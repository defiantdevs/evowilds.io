extends Node2D

const Species = preload("res://scripts/species.gd")
const SWING_TIME := 0.42
const BIG_EVO := 15   # at this evolution a Team Deathmatch bot becomes a base defender

var main
var is_player := false
var frozen := false
var team := -1     # 0 = Red, 1 = Blue, -1 = free-for-all
var cname := "Creature"
var evo := 0
var xp := 0.0
var r := 22.0
var vel := Vector2.ZERO
var heading := 0.0
var hp := 40.0
var max_hp := 40.0
var sprinting := false
var shield := 0.0
var alive := true
var anim_t := 0.0
var trail_t := 0.0
var c1 := Color.WHITE
var c2 := Color.WHITE
var swing_t := -1.0
var swing_cd := 0.0
var swing_hit := false
var swing_hits: Array = []
var trail: PackedVector2Array = PackedVector2Array()
var trail2: PackedVector2Array = PackedVector2Array()
var hit_flash := 0.0
var since_hit := 99.0
var mode := 0
var mode_t := 0.0
var target = null
var wander_dir := Vector2.RIGHT
var bot_attack_t := 1.0
var bot_sprint := false
var aim_err := 0.0
var locked_tier := -1   # Test Range: the tier is pinned, so it never drifts


func _ready() -> void:
	evo = Species.evo_for_xp(xp)
	r = Species.radius_for(evo, xp)
	max_hp = Species.max_hp_for(evo)
	hp = max_hp
	_refresh_colors()
	anim_t = randf() * 10.0
	wander_dir = Vector2.from_angle(randf() * TAU)
	heading = randf() * TAU
	mode_t = randf_range(0.2, 1.2)
	bot_attack_t = randf_range(0.8, 2.0)
	z_index = evo


func _refresh_colors() -> void:
	c1 = Species.COL1[evo]
	c2 = Species.COL2[evo]


func tier_floor() -> float:
	var f: float = Species.XP_AT[evo]
	return f


func add_xp(v: float) -> void:
	if locked_tier >= 0:
		# Test Range: the tier you picked is the tier you keep
		return
	var before := evo
	xp += v
	evo = Species.evo_for_xp(xp)
	if evo != before:
		_refresh_colors()
		z_index = evo
		shield = 2.0
		max_hp = Species.max_hp_for(evo)
		hp = max_hp
		main.on_evolve(self, before)


func take_damage(_amount: float, attacker) -> void:
	if not alive or shield > 0.0:
		return
	if is_player and main.mode == "test":
		# Test Range: you cannot be killed, so you can try the same swing
		# as many times as you like.
		return
	var away: Vector2 = (position - attacker.position).normalized()
	main.fx.burst(position - away * r * 0.3, Color(1.0, 0.92, 0.7), 8, 260.0, 0.35)
	main.devour(attacker, self)


func start_swing() -> void:
	if swing_t >= 0.0 or swing_cd > 0.0 or frozen:
		return
	swing_t = 0.0
	swing_hit = false
	swing_hits.clear()
	trail.clear()
	trail2.clear()
	swing_cd = SWING_TIME + 0.12 + 0.02 * float(evo)


func _process(delta: float) -> void:
	if not alive:
		return
	anim_t += delta
	shield = maxf(shield - delta, 0.0)
	hit_flash = maxf(hit_flash - delta, 0.0)
	swing_cd = maxf(swing_cd - delta, 0.0)
	since_hit += delta
	r = lerpf(r, Species.radius_for(evo, xp), minf(delta * 4.0, 1.0))
	if swing_t >= 0.0:
		# the blade's angle last frame, so we can work out the slice of the
		# weapon's own arc that this swing just swept through
		var prev_ang: float = _swing_angle()
		swing_t += delta
		var sp := swing_t / SWING_TIME
		if sp >= 0.2 and sp <= 0.72:
			var ang: float = _swing_angle()
			trail.append(_weapon_tip(ang))
			if trail.size() > 9:
				trail.remove_at(0)
			if dual_wield():
				trail2.append(_weapon_tip(ang, 1))
				if trail2.size() > 9:
					trail2.remove_at(0)

			# The killing ground is the weapon itself: the drawn blade, and
			# the slice of the arc it swept through on this frame.
			var shift: float = prev_ang - ang
			main.weapon_hit_zone(self, _weapon_bands(ang), minf(0.0, shift), maxf(0.0, shift))
			if dual_wield():
				# the other blade turns the other way, half a circle around
				var shift2: float = -shift
				main.weapon_hit_zone(self, _weapon_bands(ang, 1), minf(0.0, shift2), maxf(0.0, shift2), Vector2(0.0, -0.8))
		if swing_t >= SWING_TIME:
			swing_t = -1.0
			trail.clear()
			trail2.clear()
	if frozen:
		queue_redraw()
		return

	var dir := Vector2.ZERO
	var want_sprint := false
	if is_player:
		dir = _player_dir()
		want_sprint = Input.is_physical_key_pressed(KEY_SHIFT) or Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT)
		if Input.is_physical_key_pressed(KEY_SPACE) or Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			start_swing()
		var to_m := get_global_mouse_position() - global_position
		if to_m.length() > 6.0:
			heading = lerp_angle(heading, to_m.angle(), minf(16.0 * delta, 1.0))
		main.eat_food_near(self)
	else:
		mode_t -= delta
		if mode_t <= 0.0:
			_choose_mode()
		dir = _bot_dir(delta)
		want_sprint = bot_sprint

	var floor_xp := tier_floor()
	sprinting = want_sprint and dir.length() > 0.1
	if sprinting and is_player:
		if main.mode == "test":
			pass   # Test Range: sprinting is free
		elif xp - floor_xp > 0.4:
			var nxt: float = Species.XP_AT[mini(evo + 1, Species.COUNT - 1)]
			var span := maxf(nxt - floor_xp, 60.0)
			xp = maxf(xp - span * 0.03 * delta, floor_xp)
		else:
			sprinting = false

	var spd := Species.speed_base(evo)
	if not is_player:
		spd *= 0.8
	if sprinting:
		spd *= 1.6
	if swing_t >= 0.0:
		spd *= 0.7
	# crisper control for the player: quick to build speed, quick to stop,
	# and extra bite when reversing so direction changes don't slide.
	# acceleration falls off as you grow, but never to zero and never
	# below it: a negative step would make big creatures accelerate
	# without limit and sail across the arena
	var accel := maxf(1500.0 - 40.0 * float(evo), 620.0)
	if is_player:
		accel = maxf(3000.0 - 50.0 * float(evo), 1200.0)
	if is_player:
		# The player runs where they point *this frame*: a turn redirects the
		# whole of the current speed instead of coasting through a wide arc,
		# and reversing drops the old speed to nothing rather than skidding on
		# backwards for a moment.
		if dir.length_squared() < 0.000001:
			# let go: plant your feet, no glide
			vel = vel.move_toward(Vector2.ZERO, 9000.0 * delta)
		else:
			var d := dir.normalized()
			var mag := clampf(dir.length(), 0.0, 1.0)
			var sp := vel.length()
			# only a genuine reversal (or a hair sharper than square) drops the
			# speed; a square turn keeps its pace and simply goes the new way
			if sp > 1.0 and vel.dot(d) < -0.05 * sp:
				sp = 0.0
			sp = minf(sp + accel * delta, spd * mag)
			vel = d * sp
	else:
		if dir.length_squared() < 0.000001:
			var fric := accel
			vel = vel.move_toward(Vector2.ZERO, maxf(fric, 400.0) * delta)
		else:
			if vel.dot(dir) < 0.0:
				accel *= 1.7
			vel = vel.move_toward(dir * spd, accel * delta)
	# nothing outruns its own legs by much, however big it gets
	var cap := spd * 2.0 + 40.0
	if vel.length() > cap:
		vel = vel.normalized() * cap
	position += vel * delta

	main.push_out(self, delta)
	var lim: float = main.ARENA_R - r * 0.8
	if position.length() > lim:
		position = position.normalized() * lim
		vel = vel.slide(position.normalized())

	if not is_player and vel.length() > 25.0 and mode != 2:
		heading = lerp_angle(heading, vel.angle(), minf(6.0 * delta, 1.0))

	if not is_player and main.mode == "tdm" and team >= 0 and swing_t < 0.0 and swing_cd <= 0.0:
		# bots flip nearby neutral/enemy golems to their side
		var u = main.unit_to_convert(position, team, weapon_reach() + r * 0.4)
		if u != null:
			heading = (Vector2(u["pos"]) - position).angle()
			start_swing()

	if sprinting:
		trail_t -= delta
		if trail_t <= 0.0:
			trail_t = 0.04
			main.fx.burst(position - Vector2.from_angle(heading) * r * 0.8, Color(0.95, 0.9, 0.7), 1, 40.0, 0.35)
	queue_redraw()


func _player_dir() -> Vector2:
	var d := Vector2.ZERO
	if Input.is_physical_key_pressed(KEY_A) or Input.is_physical_key_pressed(KEY_LEFT):
		d.x -= 1.0
	if Input.is_physical_key_pressed(KEY_D) or Input.is_physical_key_pressed(KEY_RIGHT):
		d.x += 1.0
	if Input.is_physical_key_pressed(KEY_W) or Input.is_physical_key_pressed(KEY_UP):
		d.y -= 1.0
	if Input.is_physical_key_pressed(KEY_S) or Input.is_physical_key_pressed(KEY_DOWN):
		d.y += 1.0
	if d != Vector2.ZERO:
		return d.normalized()
	var to_m := get_global_mouse_position() - global_position
	var dist := to_m.length()
	if dist < r * 0.9:
		return Vector2.ZERO
	return to_m.normalized() * clampf(dist / (r * 3.0), 0.3, 1.0)


func is_big() -> bool:
	return evo >= BIG_EVO


func _choose_mode() -> void:
	mode_t = randf_range(0.85, 2.2)
	bot_sprint = false
	if main.mode == "test":
		# Test Range: every bot runs straight at you and never swings, so you
		# can walk them into your own blade and see exactly what it kills.
		var tp = main.player
		if tp != null and is_instance_valid(tp) and tp.alive:
			mode = 5
			target = tp
			bot_sprint = false
			return
		mode = 0
		target = null
		return
	if mode == 2 and target != null and is_instance_valid(target) and target.alive:
		if position.distance_to(target.position) < 500.0 and randf() < 0.62:
			bot_sprint = randf() < 0.22
			return
	if mode == 4 and team >= 0 and main.mode == "tdm" and not is_big():
		# keep charging the enemy statue once committed
		if randf() < 0.85:
			bot_sprint = true
			return
	target = null
	mode = 0
	# Team Deathmatch: big bots roam and guard their own statue instead of
	# marching on the enemy one. If an enemy turns up at their statue, attack.
	if main.mode == "tdm" and team >= 0 and is_big():
		var intruder = main.enemy_near_base(team, 620.0)
		if intruder != null:
			mode = 2
			target = intruder
			bot_sprint = randf() < 0.7
			bot_attack_t = randf_range(0.25, 0.7)
			return
	var aggro := 300.0 + r * 1.5
	var best = null
	var best_d := aggro
	# the player is always fair game, even when far bigger than this bot
	var pl = main.player
	if pl != null and is_instance_valid(pl) and pl.alive and not pl.frozen:
		var ally: bool = main.mode == "tdm" and team >= 0 and pl.team == team
		var dp: float = position.distance_to(pl.position)
		if not ally and dp < aggro + 110.0:
			best = pl
			best_d = dp
	var threat = null
	var threat_d := 165.0 + r * 0.8
	for o in main.creatures:
		if o == self or o.is_player or not o.alive or o.frozen:
			continue
		if main.mode == "tdm" and team >= 0 and o.team == team:
			continue
		var d: float = position.distance_to(o.position)
		if o.evo > evo + 1:
			if d < threat_d:
				threat_d = d
				threat = o
		elif d < best_d:
			best_d = d
			best = o
	if best != null:
		var chance := 0.82 if best.is_player else 0.6
		if best.evo >= evo and not best.is_player:
			chance -= 0.16
		elif best.evo < evo - 2:
			chance += 0.05
		if randf() < chance:
			mode = 2
			target = best
			bot_sprint = best_d < 380.0 and randf() < 0.4
			bot_attack_t = randf_range(0.4, 1.1)
			return
	if threat != null and randf() < 0.4:
		mode = 3
		target = threat
		bot_sprint = randf() < 0.3
		return
	# Team Deathmatch: some bots march on the enemy statue instead of grazing
	if main.mode == "tdm" and team >= 0 and not is_big() and randf() < 0.42:
		mode = 4
		target = null
		bot_sprint = true
		return
	if randf() < 0.7:
		var fi: int = main.nearest_food(position, 320.0 + r)
		if fi >= 0:
			mode = 1
			wander_dir = (main.food_pos[fi] - position).normalized()
			return
	wander_dir = Vector2.from_angle(randf() * TAU) if randf() < 0.8 else Vector2.ZERO


func _bot_dir(delta: float) -> Vector2:
	if mode == 1:
		main.eat_food_near(self)
		return wander_dir
	if mode == 2:
		if target == null or not is_instance_valid(target) or not target.alive:
			mode = 0
			target = null
			return wander_dir * 0.5
		var lead := clampf(position.distance_to(target.position) / 1400.0, 0.0, 0.15)
		var aim: Vector2 = target.position + target.vel * lead - position
		var dist := aim.length()
		heading = lerp_angle(heading, aim.angle() + aim_err, minf(4.0 * delta, 1.0))
		bot_attack_t -= delta
		var reach: float = weapon_reach() + float(target.r)
		if bot_attack_t <= 0.0 and dist < reach and absf(angle_difference(heading, aim.angle())) < 0.65:
			bot_attack_t = randf_range(0.75, 1.7)
			aim_err = randf_range(-0.5, 0.5)
			start_swing()
		if dist > reach * 0.65:
			bot_sprint = bot_sprint and dist > 260.0
			return aim.normalized()
		if dist < (r + float(target.r)) * 0.6:
			bot_sprint = false
			return -aim.normalized()
		bot_sprint = false
		return Vector2.ZERO
	if mode == 3:
		if target == null or not is_instance_valid(target) or not target.alive:
			mode = 0
			target = null
			return wander_dir * 0.6
		bot_sprint = true
		return (position - target.position).normalized()
	if mode == 5:
		# Test Range: run at the player, swing never
		if target == null or not is_instance_valid(target) or not target.alive:
			mode = 0
			target = null
			return wander_dir * 0.6
		var tp: Vector2 = target.position - position
		heading = lerp_angle(heading, tp.angle(), minf(6.0 * delta, 1.0))
		bot_sprint = false
		return tp.normalized()
	if mode == 4:
		var base: Dictionary = main.enemy_base(team)
		if base.is_empty() or is_big():
			mode = 0
			target = null
			return wander_dir * 0.5
		var bp: Vector2 = base["pos"]
		var to := bp - position
		var dist := to.length()
		heading = lerp_angle(heading, to.angle(), minf(7.0 * delta, 1.0))
		bot_attack_t -= delta
		var reach: float = weapon_reach() + float(base["r"]) * 0.6
		if bot_attack_t <= 0.0 and dist < reach:
			bot_attack_t = randf_range(0.5, 1.1)
			start_swing()
		if dist > reach * 0.7:
			bot_sprint = true
			return to.normalized()
		bot_sprint = false
		return Vector2.ZERO
	return wander_dir * 0.6


func weapon_reach() -> float:
	# how far the drawn weapon reaches out from the body
	var best := 0.0
	for p in Species.weapon_parts(evo):
		var e0 := Vector2(float(p[0]), float(p[1]))
		var e1 := Vector2(float(p[2]), float(p[3]))
		best = maxf(best, maxf(e0.length(), e1.length()) + float(p[4]))
	return best * r


func dual_wield() -> bool:
	return Species.is_dual(evo)


func _weapon_tip(ang: float, side: int = 0) -> Vector2:
	# the far end of the drawn weapon, for the swing trail
	var pv := Vector2(0.0, 0.8 * r)
	if side == 1:
		pv = -pv
		ang += PI
	var best_x := -999.0
	var best := Vector2.ZERO
	for p in Species.weapon_parts(evo):
		var e0 := Vector2(float(p[0]) * r, float(p[1]) * r)
		var e1 := Vector2(float(p[2]) * r, float(p[3]) * r)
		if e0.x > best_x:
			best_x = e0.x
			best = e0
		if e1.x > best_x:
			best_x = e1.x
			best = e1
	return pv + (best - pv).rotated(ang)


func _weapon_bands(ang: float, side: int = 0) -> Array:
	# The weapon's parts, measured from the pivot it swings around. Each band
	# is [middle, near_radius, far_radius, half_spread, half_width].
	var pv := Vector2(0.0, 0.8 * r)
	if side == 1:
		pv = -pv
		ang += PI
	var bands: Array = []
	for p in Species.weapon_parts(evo):
		var a := Vector2(float(p[0]) * r, float(p[1]) * r) - pv
		var b := Vector2(float(p[2]) * r, float(p[3]) * r) - pv
		var ra := a.length()
		var rb := b.length()
		var h: float = absf(angle_difference(a.angle(), b.angle())) * 0.5
		bands.append([
			((a + b) * 0.5).rotated(ang),
			minf(ra, rb),
			maxf(ra, rb),
			h,
			float(p[4]) * r,
		])
	return bands


func _swing_angle() -> float:
	var rest := 0.12
	var wind := 1.35
	var end := -1.35
	if dual_wield():
		# two blades, one each side: they rest out at the sides and the pair
		# turns a full 160 degrees through the swing
		rest = 1.30
		wind = 1.48
		end = -1.32
	var ang := rest + sin(anim_t * 3.0) * 0.04
	if swing_t >= 0.0:
		var p := clampf(swing_t / SWING_TIME, 0.0, 1.0)
		if p < 0.2:
			ang = lerpf(rest, wind, p / 0.2)
		elif p < 0.72:
			var k := (p - 0.2) / 0.52
			if dual_wield():
				# ease in, then a hard 160 degree cut, then a slow-out
				k = k * k * (3.0 - 2.0 * k)
			ang = lerpf(wind, end, k)
		else:
			ang = lerpf(end, rest, (p - 0.72) / 0.28)
	return ang


func _draw() -> void:
	draw_set_transform(Vector2.ZERO, heading, Vector2.ONE)
	if main.mode == "tdm" and team >= 0:
		var tc: Color = main.team_color(team)
		draw_arc(Vector2.ZERO, r * 1.3, 0.0, TAU, 40, Color(tc.r, tc.g, tc.b, 0.9), 3.5, true)
	var sa := _swing_angle()
	for tr in [trail, trail2]:
		if tr.size() > 1:
			for i in range(1, tr.size()):
				var f := float(i) / float(tr.size())
				draw_line(tr[i - 1], tr[i], Color(1, 1, 1, f * 0.7), r * (0.1 + 0.28 * f), true)
	if sprinting:
		for i in range(3):
			var y := float(i - 1) * r * 0.55
			draw_line(Vector2(-r * (1.3 + float(i) * 0.4), y), Vector2(-r * (2.4 + float(i) * 0.7), y), Color(1, 1, 1, 0.45), 2.0, true)
	Species.draw_body(self, evo, r, anim_t, c1, c2, sa)
	if hit_flash > 0.0:
		draw_circle(Vector2.ZERO, r * 1.0, Color(1, 1, 1, hit_flash * 2.2))
	draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
	if shield > 0.0:
		var a := 0.45 + 0.25 * sin(anim_t * 10.0)
		draw_arc(Vector2.ZERO, r * 1.6, 0.0, TAU, 48, Color(0.6, 0.9, 1.0, a), 3.0, true)
	var font := ThemeDB.fallback_font
	var label_y := -r * 1.35 - 12.0
	var col := Color(1, 1, 1, 0.9)
	var pl = main.player
	if not is_player and pl != null and pl.alive:
		if evo > pl.evo:
			col = Color(1.0, 0.5, 0.5, 0.95)
		elif evo < pl.evo:
			col = Color(0.6, 1.0, 0.65, 0.95)
	if is_player:
		col = Color(1.0, 0.95, 0.5, 1.0)
	draw_string(font, Vector2(-60, label_y), cname, HORIZONTAL_ALIGNMENT_CENTER, 120, 14, Color(0, 0, 0, 0.6))
	draw_string(font, Vector2(-60, label_y - 1.0), cname, HORIZONTAL_ALIGNMENT_CENTER, 120, 14, col)
	if is_player:
		draw_colored_polygon(PackedVector2Array([Vector2(-6, label_y - 24), Vector2(6, label_y - 24), Vector2(0, label_y - 14)]), Color(1.0, 0.95, 0.5))
	if alive and main.leader == self:
		var bob := sin(anim_t * 4.0) * 1.5
		var hw := clampf(r * 0.34, 9.0, 30.0)
		_crown(Vector2(0.0, label_y - (34.0 if is_player else 18.0) + bob), hw)


func _crown(origin: Vector2, hw: float) -> void:
	# gold crown for the biggest creature alive
	var hh := hw * 1.1
	var gold := Color(1.0, 0.84, 0.25)
	var edge := Color(0.34, 0.2, 0.02, 0.95)
	var pts := PackedVector2Array([
		origin + Vector2(-hw, 0.0),
		origin + Vector2(-hw, -hh * 0.3),
		origin + Vector2(-hw * 0.6, -hh),
		origin + Vector2(-hw * 0.3, -hh * 0.25),
		origin + Vector2(0.0, -hh * 1.1),
		origin + Vector2(hw * 0.3, -hh * 0.25),
		origin + Vector2(hw * 0.6, -hh),
		origin + Vector2(hw, -hh * 0.3),
		origin + Vector2(hw, 0.0),
	])
	draw_colored_polygon(pts, gold)
	draw_polyline(pts, edge, 1.6, true)
	var band := Rect2(origin + Vector2(-hw, 0.0), Vector2(hw * 2.0, hh * 0.34))
	draw_rect(band, gold)
	draw_rect(band, edge, false, 1.6)
	draw_circle(origin + Vector2(-hw * 0.6, -hh), hw * 0.16, Color(0.95, 0.32, 0.36))
	draw_circle(origin + Vector2(hw * 0.6, -hh), hw * 0.16, Color(0.36, 0.62, 0.95))
	draw_circle(origin + Vector2(0.0, -hh * 1.1), hw * 0.18, Color(0.6, 0.92, 0.5))
