extends Node2D
# Flick checks: EvoWars movement is mouse-run, instant-facing, and the blade
# cuts everything its steel actually sweeps through when the cursor snaps.

const MainScene = preload("res://scenes/main.tscn")
const Creature = preload("res://scripts/creature.gd")
const Species = preload("res://scripts/species.gd")

var main
var checks := 0
var fails := 0


func ok(cond: bool, msg: String) -> void:
	checks += 1
	if not cond:
		fails += 1
		printerr("FAIL: ", msg)


func _ready() -> void:
	main = MainScene.instantiate()
	add_child(main)
	main.set_process(false)

	# keep only the player, and stop its own AI/input so every pose is ours
	for c in main.creatures.duplicate():
		if c != main.player:
			main.creatures.erase(c)
			c.queue_free()
	main.board.clear()
	main.leader = null
	var p = main.player
	p.set_process(false)
	p.position = Vector2.ZERO
	p.heading = 0.0
	p.alive = true
	p.frozen = false
	p.shield = 0.0
	p.swing_t = -1.0
	p.swing_cd = 0.0
	p.swing_hits.clear()
	p.trail.clear()
	p.trail2.clear()
	p.locked_tier = -1
	# a long single blade makes the angular test meaningful (short blades have
	# such a wide target tolerance that everything nearby looks hit)
	p.evo = 32
	p.xp = Species.XP_AT[32] + 1.0
	p.r = Species.radius_for(p.evo, p.xp)

	_test_face()
	_test_run_speed()
	_test_flick_mid_arc()
	_test_flick_multi_kill()
	_test_flick_reach()
	_test_dual_swing()

	print("CHECKS ", checks, " FAILS ", fails)
	get_tree().quit(0 if fails == 0 else 1)


func _target(pos: Vector2, evo: int = 0) -> Node2D:
	var c = Creature.new()
	c.main = main
	c.is_player = false
	c.cname = "Target"
	c.team = -1
	c.evo = evo
	c.xp = Species.XP_AT[evo] + 1.0
	c.position = pos
	main.add_child(c)
	c.set_process(false)
	main.creatures.append(c)
	c.shield = 0.0
	c.r = Species.radius_for(evo, c.xp)
	return c


func _clear_targets() -> void:
	for c in main.creatures.duplicate():
		if c != main.player:
			main.creatures.erase(c)
			c.queue_free()
	main.player.swing_hits.clear()
	main.player.trail.clear()
	main.player.trail2.clear()
	main.player.swing_t = -1.0
	main.player.swing_cd = 0.0


func _blade_pose(h: float, s: float, side: int = 0) -> Dictionary:
	# A point on the middle of the longest part of the drawn blade, in world
	# space for a body at heading h and swing angle s.
	var p = main.player
	var bands: Array = p._weapon_bands(s, side)
	var best: Array = bands[0]
	for b in bands:
		if float(b[2]) + float(b[4]) > float(best[2]) + float(best[4]):
			best = b
	var local: Vector2 = best[0]
	var rr := clampf(local.length(), float(best[1]), float(best[2]))
	var grip := Vector2(0.0, 0.8 * p.r) if side == 0 else Vector2(0.0, -0.8 * p.r)
	var pivot: Vector2 = p.position + grip.rotated(h)
	return {
		"pos": pivot + (Vector2.from_angle(local.angle()) * rr).rotated(h),
		"pivot": pivot,
		"angle": local.angle(),
		"far": float(best[2]) + float(best[4]),
	}


func _test_face() -> void:
	var p = main.player
	p.heading = 0.0
	p._face(Vector2(-100.0, 0.0))
	ok(absf(angle_difference(p.heading, PI)) < 0.001, "a flick faces the cursor at once")
	p._face(Vector2(3.0, 0.0))
	ok(absf(angle_difference(p.heading, PI)) < 0.001, "a cursor on the body does not spin it")


func _test_run_speed() -> void:
	var p = main.player
	var far: Vector2 = p._player_dir(Vector2(p.r * 3.0, 0.0))
	ok(absf(far.length() - 1.0) < 0.01, "the mouse run is full speed")
	var near_out: Vector2 = p._player_dir(Vector2(p.r * 0.95, 0.0))
	ok(absf(near_out.length() - 1.0) < 0.01, "the run stays full speed close to the cursor")
	var dead: Vector2 = p._player_dir(Vector2(p.r * 0.5, 0.0))
	ok(dead.length() < 0.001, "the warrior stops with the cursor on its body")
	var back: Vector2 = p._player_dir(Vector2(-p.r * 3.0, 0.0))
	ok(back.is_equal_approx(Vector2.LEFT), "the mouse run goes where the cursor is")


func _test_flick_mid_arc() -> void:
	_clear_targets()
	var p = main.player
	var h0 := 0.0
	var h1 := deg_to_rad(150.0)
	var hm := deg_to_rad(75.0)
	var s := 0.12
	var pose := _blade_pose(hm, s)
	var body = _target(pose["pos"])
	# sanity: the final blade pose is nowhere near the target, so only the
	# swept path can kill it
	var bands: Array = p._weapon_bands(s)
	var final_pose := _blade_pose(h1, s)
	ok(not main._zone_hits(body.position, body.r, final_pose["pivot"], h1, bands, 0.0, 0.0), "the target sits outside the final blade pose")
	p.heading = h1
	p._sweep_blade(h0, s, h1, s)
	ok(not body.alive, "a 150 degree flick cuts an opponent mid-turn")
	ok(p.swing_hits.has(body), "the mid-turn cut counts as this swing's hit")


func _test_flick_multi_kill() -> void:
	_clear_targets()
	var p = main.player
	p.heading = deg_to_rad(150.0)
	var s := 0.12
	var a = _target(_blade_pose(deg_to_rad(50.0), s)["pos"])
	var b = _target(_blade_pose(deg_to_rad(100.0), s)["pos"])
	p._sweep_blade(0.0, s, deg_to_rad(150.0), s)
	ok(not a.alive and not b.alive, "one flick kills everyone the blade sweeps through")
	ok(p.swing_hits.size() == 2, "each swept body is recorded once")


func _test_flick_reach() -> void:
	# Radial exactness is measured on a pure swing (pivot fixed): a flick's
	# grip orbits the body, so a fixed world point can legitimately move in and
	# out of the blade's radius as the whole warrior turns.
	_clear_targets()
	var p = main.player
	var hm := 0.0
	var s0 := 1.35      # wind-up
	var s1 := -1.35     # follow-through
	var smid := 0.0     # a blade pose the swing passes through
	p.heading = hm
	var pose := _blade_pose(hm, smid)
	var local_angle: float = pose["angle"]
	# just past the steel's real envelope (blade far edge + its width + the
	# target's own radius): must survive, no invisible reach
	var beyond: float = float(pose["far"]) + 22.0 + 5.0
	var far_pos: Vector2 = pose["pivot"] + (Vector2.from_angle(local_angle) * beyond).rotated(hm)
	var far_body = _target(far_pos)
	p._sweep_blade(hm, s0, hm, s1)
	ok(far_body.alive, "a swing has no reach beyond the steel")
	# and a body touching the steel does die
	_clear_targets()
	p.heading = hm
	var edge: float = maxf(float(pose["far"]) - 1.0, 1.0)
	var edge_pos: Vector2 = pose["pivot"] + (Vector2.from_angle(local_angle) * edge).rotated(hm)
	var edge_body = _target(edge_pos)
	p._sweep_blade(hm, s0, hm, s1)
	ok(not edge_body.alive, "a body on the blade's edge still dies")
	# and a body beyond the start of the swing is not touched by the slice
	_clear_targets()
	p.heading = hm
	var past := _blade_pose(hm, s0 + 0.5)
	var past_pos: Vector2 = past["pivot"] + (Vector2.from_angle(past["angle"]) * (float(past["far"]) - 1.0)).rotated(hm)
	var past_body = _target(past_pos)
	p._sweep_blade(hm, s0, hm, s1)
	ok(past_body.alive, "the swing does not reach behind its start")


func _test_dual_swing() -> void:
	_clear_targets()
	var p = main.player
	p.evo = 33
	p.xp = Species.XP_AT[33] + 1.0
	p.r = Species.radius_for(p.evo, p.xp)
	p.heading = 0.0
	ok(Species.is_dual(p.evo), "the dual test is on a two-blade tier")
	var s0 := 1.35
	var s1 := -1.35
	var left = _target(_blade_pose(0.0, 0.0, 0)["pos"])
	var right = _target(_blade_pose(0.0, 0.0, 1)["pos"])
	p._sweep_blade(0.0, s0, 0.0, s1)
	ok(not left.alive, "the near blade cuts its half of the circle")
	ok(not right.alive, "the far blade cuts the other half of the circle")

