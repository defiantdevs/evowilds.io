extends Node2D

const Species = preload("res://scripts/species.gd")
const SWING_TIME := 0.42

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
var hit_flash := 0.0
var since_hit := 99.0
var mode := 0
var mode_t := 0.0
var target = null
var wander_dir := Vector2.RIGHT
var bot_attack_t := 1.0
var bot_sprint := false
var aim_err := 0.0


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
		swing_t += delta
		var sp := swing_t / SWING_TIME
		if sp >= 0.2 and sp <= 0.72:
			var seg := _weapon_seg()
			trail.append(seg[1])
			if trail.size() > 9:
				trail.remove_at(0)


			main.weapon_hit(self, position + (seg[0] as Vector2).rotated(heading), position + (seg[1] as Vector2).rotated(heading))
		if swing_t >= SWING_TIME:
			swing_t = -1.0
			trail.clear()
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
		if xp - floor_xp > 0.4:
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
	var accel := 1500.0 - 40.0 * float(evo)
	if is_player:
		accel = 3000.0 - 50.0 * float(evo)
	if dir.length_squared() < 0.000001:
		var fric := accel
		if is_player:
			fric = 2800.0 - 40.0 * float(evo)
		vel = vel.move_toward(Vector2.ZERO, maxf(fric, 400.0) * delta)
	else:
		if is_player and vel.dot(dir) < 0.0:
			accel *= 1.7
		vel = vel.move_toward(dir * spd, accel * delta)
	position += vel * delta

	main.push_out(self)
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


func _choose_mode() -> void:
	mode_t = randf_range(0.55, 1.5)
	bot_sprint = false
	if mode == 2 and target != null and is_instance_valid(target) and target.alive:
		if position.distance_to(target.position) < 620.0 and randf() < 0.82:
			bot_sprint = randf() < 0.3
			return
	if mode == 4 and team >= 0 and main.mode == "tdm":
		# keep charging the enemy statue once committed
		if randf() < 0.85:
			bot_sprint = true
			return
	target = null
	mode = 0
	var aggro := 440.0 + r * 2.0
	var best = null
	var best_d := aggro
	# the player is always fair game, even when far bigger than this bot
	var pl = main.player
	if pl != null and is_instance_valid(pl) and pl.alive and not pl.frozen:
		var ally: bool = main.mode == "tdm" and team >= 0 and pl.team == team
		var dp: float = position.distance_to(pl.position)
		if not ally and dp < aggro + 180.0:
			best = pl
			best_d = dp
	var threat = null
	var threat_d := 210.0 + r
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
		var chance := 0.9 if best.is_player else 0.72
		if best.evo >= evo and not best.is_player:
			chance -= 0.12
		elif best.evo < evo - 2:
			chance += 0.08
		if randf() < chance:
			mode = 2
			target = best
			bot_sprint = best_d < 280.0
			bot_attack_t = randf_range(0.2, 0.7)
			return
	if threat != null and randf() < 0.55:
		mode = 3
		target = threat
		bot_sprint = randf() < 0.45
		return
	# Team Deathmatch: some bots march on the enemy statue instead of grazing
	if main.mode == "tdm" and team >= 0 and randf() < 0.42:
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
		var lead := clampf(position.distance_to(target.position) / 950.0, 0.0, 0.3)
		var aim: Vector2 = target.position + target.vel * lead - position
		var dist := aim.length()
		heading = lerp_angle(heading, aim.angle() + aim_err, minf(7.0 * delta, 1.0))
		bot_attack_t -= delta
		var reach: float = weapon_reach() + float(target.r) * 0.55
		if bot_attack_t <= 0.0 and dist < reach and absf(angle_difference(heading, aim.angle())) < 0.75:
			bot_attack_t = randf_range(0.45, 1.3)
			aim_err = randf_range(-0.32, 0.32)
			start_swing()
		if dist > reach * 0.65:
			bot_sprint = target.is_player or target.evo >= evo
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
	if mode == 4:
		var base: Dictionary = main.enemy_base(team)
		if base.is_empty():
			mode = 0
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
	# distance from the body centre to the drawn blade tip
	var pv := Vector2(0.0, 0.8 * r)
	return Species._wp(pv, 0.0, r, Species.blade_tip(evo), 0.5).length()

func _weapon_seg() -> Array:
	# the kill segment IS the drawn blade: same pivot, angle and length
	var pv := Vector2(0.0, 0.8 * r)
	var ang := _swing_angle()
	var tx: float = Species.blade_tip(evo)
	var base: Vector2 = Species._wp(pv, ang, r, 0.95, 0.5)
	var tip: Vector2 = Species._wp(pv, ang, r, tx, 0.5)
	return [base, tip]


func _swing_angle() -> float:
	var ang := 0.12 + sin(anim_t * 3.0) * 0.04
	if swing_t >= 0.0:
		var p := clampf(swing_t / SWING_TIME, 0.0, 1.0)
		if p < 0.2:
			ang = lerpf(0.12, 1.35, p / 0.2)
		elif p < 0.7:
			ang = lerpf(1.35, -1.35, (p - 0.2) / 0.5)
		else:
			ang = lerpf(-1.35, 0.12, (p - 0.7) / 0.3)
	return ang


func _draw() -> void:
	draw_set_transform(Vector2.ZERO, heading, Vector2.ONE)
	if main.mode == "tdm" and team >= 0:
		var tc: Color = main.team_color(team)
		draw_arc(Vector2.ZERO, r * 1.3, 0.0, TAU, 40, Color(tc.r, tc.g, tc.b, 0.9), 3.5, true)
	var sa := _swing_angle()
	if trail.size() > 1:
		for i in range(1, trail.size()):
			var f := float(i) / float(trail.size())
			draw_line(trail[i - 1], trail[i], Color(1, 1, 1, f * 0.7), r * (0.1 + 0.28 * f), true)
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
