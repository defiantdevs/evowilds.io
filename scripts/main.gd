extends Node2D

const Species = preload("res://scripts/species.gd")
const Creature = preload("res://scripts/creature.gd")
const Fx = preload("res://scripts/fx.gd")
const Hud = preload("res://scripts/hud.gd")

const ARENA_R := 3000.0
const FOOD_TARGET := 620
const BOT_COUNT := 28
const FOOD_XP := [1.5, 4.0, 10.0, 6.0]
const BOT_NAMES := ["Nyx", "Vorn", "Kelp", "Zephyr", "Marrow", "Skiff", "Ondine", "Brine", "Thresh", "Quill", "Mako", "Ember", "Drift", "Haze", "Rook", "Tangle", "Lumo", "Fathom", "Gale", "Pip", "Sable", "Orrin", "Riptide", "Coral", "Echo", "Murk", "Tide", "Flux", "Jinx", "Onyx"]
const VIGNETTE := "shader_type canvas_item;\nvoid fragment() {\n\tvec2 uv = UV - 0.5;\n\tfloat v = smoothstep(0.3, 0.95, length(uv * vec2(1.0, 0.85)));\n\tCOLOR = vec4(0.0, 0.05, 0.02, v * 0.42);\n}\n"

var player
var creatures: Array = []
var food_pos := PackedVector2Array()
var food_kind := PackedInt32Array()
var food_ph := PackedFloat32Array()
var decor: Array = []
var patches: Array = []
var obstacles: Array = []
var cam: Camera2D
var fx
var hud
var time := 0.0
var shake := 0.0
var respawns: Array = []
var feed: Array = []
var board: Array = []
var board_t := 0.0
var banner_text := ""
var banner_ttl := 0.0
var banner_col := Color.WHITE
var player_dead := false
var death_time := 0.0
var killer_name := ""
var best_evo := 0
var kills := 0
var final_score := 0
var shot_path := ""
var shot_gallery := false
var shot_evo := 0
var shot_time := 3.0


func _ready() -> void:
	randomize()
	for a in OS.get_cmdline_user_args():
		if a.begins_with("--shot="):
			shot_path = a.substr(7)
		elif a == "--gallery":
			shot_gallery = true
		elif a.begins_with("--evo="):
			shot_evo = int(a.substr(6))
		elif a.begins_with("--wait="):
			shot_time = float(a.substr(7))
	_build_world()
	_setup_env()
	cam = Camera2D.new()
	add_child(cam)
	fx = Fx.new()
	fx.z_index = 20
	add_child(fx)
	_spawn_player()
	if shot_gallery:
		_spawn_gallery()
	else:
		for i in range(BOT_COUNT):
			_spawn_bot(true)
	var layer := CanvasLayer.new()
	layer.layer = 5
	add_child(layer)
	var vig := ColorRect.new()
	var sh := Shader.new()
	sh.code = VIGNETTE
	var mat := ShaderMaterial.new()
	mat.shader = sh
	vig.material = mat
	vig.mouse_filter = Control.MOUSE_FILTER_IGNORE
	vig.set_anchors_preset(Control.PRESET_FULL_RECT)
	layer.add_child(vig)
	var layer2 := CanvasLayer.new()
	layer2.layer = 6
	add_child(layer2)
	hud = Hud.new()
	hud.main = self
	layer2.add_child(hud)
	cam.position = player.position
	cam.zoom = Vector2(0.9, 0.9)


func _setup_env() -> void:
	var env := Environment.new()
	env.background_mode = Environment.BG_CANVAS
	env.glow_enabled = false
	env.glow_intensity = 0.9
	env.glow_strength = 1.0
	env.glow_bloom = 0.12
	env.glow_hdr_threshold = 0.95
	env.glow_blend_mode = Environment.GLOW_BLEND_MODE_ADDITIVE
	env.adjustment_enabled = true
	env.adjustment_saturation = 1.15
	env.adjustment_contrast = 1.05
	var we := WorldEnvironment.new()
	we.environment = env
	add_child(we)


func _build_world() -> void:
	var rng := RandomNumberGenerator.new()
	rng.seed = 424242
	var pal := [Color(0.45, 0.74, 0.34), Color(0.3, 0.58, 0.28), Color(0.8, 0.72, 0.45), Color(0.55, 0.8, 0.42), Color(0.34, 0.62, 0.36)]
	for i in range(9):
		var rad := rng.randf_range(300.0, 520.0)
		var a := rng.randf() * TAU
		var d := sqrt(rng.randf()) * (ARENA_R - rad - 60.0)
		patches.append({"pos": Vector2.from_angle(a) * d, "rad": rad, "col": pal[i % pal.size()]})
	for i in range(230):
		var a := rng.randf() * TAU
		var d := sqrt(rng.randf()) * (ARENA_R - 130.0)
		var k := rng.randi() % 10
		var kind := 0
		if k >= 4 and k < 6:
			kind = 1
		elif k >= 6 and k < 9:
			kind = 2
		elif k >= 9:
			kind = 3
		var sz := rng.randf_range(46.0, 86.0)
		if kind == 1:
			sz = rng.randf_range(30.0, 60.0)
		elif kind == 2:
			sz = rng.randf_range(34.0, 56.0)
		elif kind == 3:
			sz = rng.randf_range(90.0, 170.0)
		var seeds: Array = []
		for j in range(rng.randi_range(5, 8)):
			seeds.append(rng.randf())
		var pos := Vector2.from_angle(a) * d
		decor.append({"pos": pos, "kind": kind, "size": sz, "seeds": seeds})
		if kind == 0:
			obstacles.append([pos, sz * 0.5])
		elif kind == 1:
			obstacles.append([pos, sz * 0.7])
	for i in range(FOOD_TARGET):
		_add_food(_random_food_pos(), _random_food_kind())


func push_out(c) -> void:
	for o in obstacles:
		var op: Vector2 = o[0]
		var orad: float = o[1]
		var cr: float = c.r
		var d: Vector2 = c.position - op
		var l := d.length()
		var minr := orad + cr * 0.7
		if l < minr and l > 0.01:
			c.position = op + d / l * minr


func _blocked(p: Vector2) -> bool:
	for o in obstacles:
		var op: Vector2 = o[0]
		var orad: float = o[1]
		if p.distance_to(op) < orad + 18.0:
			return true
	return false


func _random_food_pos() -> Vector2:
	var q := Vector2.ZERO
	for tries in range(6):
		if randf() < 0.55 and patches.size() > 0:
			var p: Dictionary = patches[randi() % patches.size()]
			var c: Vector2 = p["pos"]
			var rad: float = p["rad"]
			q = c + Vector2.from_angle(randf() * TAU) * sqrt(randf()) * rad
		else:
			q = Vector2.from_angle(randf() * TAU) * sqrt(randf()) * (ARENA_R - 60.0)
		if q.length() < ARENA_R - 50.0 and not _blocked(q):
			return q
	return q


func _random_food_kind() -> int:
	var x := randf()
	if x < 0.7:
		return 0
	if x < 0.94:
		return 1
	return 2


func _add_food(pos: Vector2, kind: int) -> void:
	food_pos.append(pos)
	food_kind.append(kind)
	food_ph.append(randf() * TAU)


func _spawn_creature(is_pl: bool, evo: int, pos: Vector2, nm: String, extra_xp: float = 0.0) -> Node2D:
	var c := Creature.new()
	c.main = self
	c.is_player = is_pl
	c.cname = nm
	var base: float = Species.XP_AT[evo]
	c.xp = base + extra_xp
	c.position = pos
	c.shield = 2.0
	add_child(c)
	creatures.append(c)
	return c


func _spawn_player() -> void:
	player_dead = false
	if player != null and is_instance_valid(player):
		player.queue_free()
	var evo := 0
	var pos := Vector2.from_angle(randf() * TAU) * randf_range(200.0, 900.0)
	if shot_path != "":
		evo = shot_evo
		pos = Vector2(0, 260) if shot_gallery else pos
	player = _spawn_creature(true, evo, pos, "You", 0.0)
	if shot_path != "":
		player.frozen = true
		player.shield = 0.0
	time = 0.0 if not shot_gallery else time


func _random_bot_evo() -> int:
	return mini(int(pow(randf(), 3.5) * float(Species.COUNT)), Species.COUNT - 1)


func _spawn_bot(initial: bool) -> void:
	var evo := _random_bot_evo() if initial else mini(int(pow(randf(), 3.0) * 6.0), 5)
	var pos := Vector2.ZERO
	for tries in range(10):
		pos = Vector2.from_angle(randf() * TAU) * sqrt(randf()) * (ARENA_R - 200.0)
		if player == null or pos.distance_to(player.position) > 700.0:
			break
	var span := 80.0
	if evo < Species.COUNT - 1:
		var a: float = Species.XP_AT[evo]
		var b: float = Species.XP_AT[evo + 1]
		span = (b - a) * 0.6
	var c := _spawn_creature(false, evo, pos, BOT_NAMES[randi() % BOT_NAMES.size()], randf() * span)
	c.shield = 3.0


func _spawn_gallery() -> void:
	for i in range(Species.COUNT):
		var col := i % 5
		var row := i / 5
		var c := _spawn_creature(false, i, Vector2(float(col - 2) * 330.0, float(row) * 300.0 - 460.0), Species.NAMES[i])
		c.frozen = true
		c.shield = 0.0
		c.heading = 0.0


func on_evolve(c, before: int) -> void:
	var col: Color = Species.COL2[c.evo]
	fx.burst(c.position, Species.glow(col, 1.8), 40, 380.0, 0.9)
	fx.ring(c.position, Species.glow(col, 1.8), 220.0 + c.r * 2.0, 0.8)
	if c.is_player:
		var nm: String = Species.NAMES[c.evo]
		banner_text = "TIER %d  -  %s" % [c.evo + 1, nm]
		banner_ttl = 3.2
		banner_col = col
		shake = 14.0
		best_evo = maxi(best_evo, c.evo)
	elif c.evo >= 3:
		var nm2: String = Species.NAMES[c.evo]
		_post(c.cname + " evolved into " + nm2, col)


func _post(text: String, col: Color) -> void:
	feed.append({"t": text, "c": col, "ttl": 6.0})
	if feed.size() > 6:
		feed.pop_front()


func nearest_food(pos: Vector2, rng_: float) -> int:
	var best := -1
	var bd := rng_ * rng_
	for i in range(food_pos.size()):
		var d := pos.distance_squared_to(food_pos[i])
		if d < bd:
			bd = d
			best = i
	return best


func eat_food_near(c) -> void:
	var rad: float = c.r * 1.15 + 16.0
	var rad2 := rad * rad
	var i := food_pos.size() - 1
	while i >= 0:
		if c.position.distance_squared_to(food_pos[i]) < rad2:
			_consume_food(c, i)
		i -= 1


func _food_color(kind: int, ph: float) -> Color:
	match kind:
		0:
			return Color(0.9, 0.2, 0.35)
		1:
			return Color(0.95, 0.35, 0.25)
		2:
			return Color(1.0, 0.8, 0.2)
		_:
			return Color(0.85, 0.6, 0.3)


func _consume_food(c, i: int) -> void:
	var kind := food_kind[i]
	var v: float = FOOD_XP[kind]
	v *= 1.0 + 0.1 * float(c.evo)
	if c.is_player:
		fx.burst(food_pos[i], Species.glow(_food_color(kind, food_ph[i]), 1.8), 6, 140.0, 0.4)
	var last := food_pos.size() - 1
	food_pos[i] = food_pos[last]
	food_kind[i] = food_kind[last]
	food_ph[i] = food_ph[last]
	food_pos.resize(last)
	food_kind.resize(last)
	food_ph.resize(last)
	c.add_xp(v)


func devour(eater, victim) -> void:
	if not victim.alive:
		return
	victim.alive = false
	var gain: float = victim.xp * 0.4 + 10.0 * float(victim.evo + 1)
	gain *= 1.0 + 0.12 * float(maxi(victim.evo - eater.evo, 0))
	var vc: Color = Species.COL2[victim.evo]
	fx.burst(victim.position, Species.glow(vc, 1.8), 36, 360.0, 0.8)
	fx.ring(victim.position, Species.glow(vc, 1.6), 160.0 + victim.r * 1.5, 0.6)
	var drops := clampi(int(victim.xp / 14.0) + 3, 3, 18)
	for k in range(drops):
		var vr: float = victim.r
		var off: Vector2 = Vector2.from_angle(randf() * TAU) * randf() * vr * 1.6
		_add_food(victim.position + off, 3 if randf() < 0.6 else 1)
	_post(eater.cname + " defeated " + victim.cname, Species.COL2[eater.evo])
	if victim.is_player:
		player_dead = true
		death_time = time
		killer_name = eater.cname
		final_score = int(victim.xp)
		shake = 20.0
	if eater.is_player:
		kills += 1
		shake = 8.0
	creatures.erase(victim)
	board.erase(victim)
	if victim.is_player:
		victim.visible = false
	else:
		victim.queue_free()
	if not victim.is_player:
		respawns.append(randf_range(3.0, 6.0))
	eater.add_xp(gain)


func weapon_hit(attacker, a: Vector2, b: Vector2) -> void:
	for o in creatures:
		if o == attacker or not o.alive or o.frozen:
			continue
		if attacker.swing_hits.has(o):
			continue
		var closest := Geometry2D.get_closest_point_to_segment(o.position, a, b)
		if closest.distance_to(o.position) > o.r:
			continue
		attacker.swing_hits.append(o)
		o.take_damage(0.0, attacker)
		if not attacker.alive:
			return


func _process(delta: float) -> void:
	time += delta
	var spawn_budget := 6
	while food_pos.size() < FOOD_TARGET and spawn_budget > 0:
		_add_food(_random_food_pos(), _random_food_kind())
		spawn_budget -= 1
	var i := respawns.size() - 1
	while i >= 0:
		respawns[i] = float(respawns[i]) - delta
		if float(respawns[i]) <= 0.0:
			respawns.remove_at(i)
			if not shot_gallery:
				_spawn_bot(false)
		i -= 1
	i = feed.size() - 1
	while i >= 0:
		var f: Dictionary = feed[i]
		f["ttl"] = float(f["ttl"]) - delta
		if float(f["ttl"]) <= 0.0:
			feed.remove_at(i)
		i -= 1
	banner_ttl = maxf(banner_ttl - delta, 0.0)
	board_t -= delta
	if board_t <= 0.0:
		board_t = 0.4
		_update_board()
	_update_camera(delta)
	if shot_path != "" and time > shot_time:
		var img := get_viewport().get_texture().get_image()
		img.save_png(shot_path)
		get_tree().quit()
	queue_redraw()


func _update_board() -> void:
	var s := creatures.duplicate()
	s.sort_custom(func(a, b): return a.xp > b.xp)
	board = s


func _update_camera(delta: float) -> void:
	var target_zoom := 0.9
	if player != null and player.alive:
		var e: int = player.evo
		target_zoom = clampf(1.1 - 0.033 * float(e) - 0.02 * Species.progress(player.xp), 0.46, 1.1)
		cam.position = cam.position.lerp(player.position + player.vel * 0.15, minf(delta * 6.0, 1.0))
	if shot_gallery:
		target_zoom = 0.4
		cam.position = Vector2(0, -160)
	var z := lerpf(cam.zoom.x, target_zoom, minf(delta * 2.5, 1.0))
	cam.zoom = Vector2(z, z)
	shake = move_toward(shake, 0.0, 45.0 * delta)
	cam.offset = Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0)) * shake


func _unhandled_input(event: InputEvent) -> void:
	if not player_dead or time - death_time < 1.0:
		return
	var go := false
	if event is InputEventKey and event.pressed:
		go = event.physical_keycode == KEY_ENTER or event.physical_keycode == KEY_SPACE or event.physical_keycode == KEY_R
	elif event is InputEventMouseButton and event.pressed:
		go = true
	if go:
		kills = 0
		best_evo = 0
		_spawn_player()
		player.position = Vector2.from_angle(randf() * TAU) * randf_range(300.0, 1200.0)
		cam.position = player.position


func _view_rect() -> Rect2:
	var sz := get_viewport_rect().size / cam.zoom
	var c := cam.get_screen_center_position()
	return Rect2(c - sz * 0.5, sz)


func _hash(x: int, y: int) -> float:
	return fposmod(sin(float(x) * 127.1 + float(y) * 311.7) * 43758.5453, 1.0)


func _draw() -> void:
	if cam == null:
		return
	var view := _view_rect()
	draw_rect(view.grow(200.0), Color(0.17, 0.46, 0.68))
	for i in range(6):
		var wr := ARENA_R + 150.0 + float(i) * 170.0 + sin(time * 0.8 + float(i)) * 14.0
		draw_arc(Vector2.ZERO, wr, 0.0, TAU, 200, Color(1, 1, 1, 0.07), 5.0, true)
	draw_circle(Vector2.ZERO, ARENA_R + 95.0, Color(0.3, 0.6, 0.82))
	draw_circle(Vector2.ZERO, ARENA_R + 70.0, Color(0.88, 0.8, 0.55))
	draw_circle(Vector2.ZERO, ARENA_R + 30.0, Color(0.96, 0.9, 0.68))
	draw_circle(Vector2.ZERO, ARENA_R, Color(0.38, 0.68, 0.3))
	for p in patches:
		var c: Vector2 = p["pos"]
		var rad: float = p["rad"]
		var col: Color = p["col"]
		draw_circle(c, rad, col)
		draw_circle(c + Vector2(rad * 0.45, rad * 0.2), rad * 0.7, col)
		draw_circle(c + Vector2(-rad * 0.4, -rad * 0.3), rad * 0.66, col)
	var sp := 80
	var gx0 := int(floorf(view.position.x / float(sp)))
	var gx1 := int(ceilf(view.end.x / float(sp)))
	var gy0 := int(floorf(view.position.y / float(sp)))
	var gy1 := int(ceilf(view.end.y / float(sp)))
	var tuft := Color(0.2, 0.45, 0.2, 0.55)
	for gy in range(gy0, gy1 + 1):
		for gx in range(gx0, gx1 + 1):
			var q := Vector2((float(gx) + _hash(gx, gy)) * float(sp), (float(gy) + _hash(gy + 7, gx + 3)) * float(sp))
			if q.length() < ARENA_R - 20.0:
				draw_line(q, q + Vector2(-3, -7), tuft, 1.6, true)
				draw_line(q, q + Vector2(0, -9), tuft, 1.6, true)
				draw_line(q, q + Vector2(3, -7), tuft, 1.6, true)
	var vr := view.grow(200.0)
	for d in decor:
		var dp: Vector2 = d["pos"]
		if vr.has_point(dp):
			_draw_decor(d)
	for i in range(food_pos.size()):
		if vr.has_point(food_pos[i]):
			_draw_food(i)


func _blob(p: Vector2, rad: float, seeds: Array, jitter: float, rot: float = 0.0) -> PackedVector2Array:
	var pts := PackedVector2Array()
	var n := 14
	for i in range(n):
		var a := rot + TAU * float(i) / float(n)
		var sd: float = seeds[i % seeds.size()]
		pts.append(p + Vector2.from_angle(a) * rad * (1.0 - jitter + jitter * 2.0 * sd))
	return pts


func _outlined(pts: PackedVector2Array, fill: Color, line: Color, w: float) -> void:
	draw_colored_polygon(pts, fill)
	var closed: PackedVector2Array = pts.duplicate()
	closed.append(pts[0])
	draw_polyline(closed, line, w, true)


func _draw_decor(d: Dictionary) -> void:
	var p: Vector2 = d["pos"]
	var s: float = d["size"]
	var kind: int = d["kind"]
	var seeds: Array = d["seeds"]
	match kind:
		0:
			draw_colored_polygon(_blob(p + Vector2(8, 12), s * 0.66, seeds, 0.1), Color(0, 0, 0, 0.16))
			var ol := Color(0.1, 0.28, 0.12)
			for k in range(5):
				var a := float(seeds[k]) * TAU
				draw_circle(p + Vector2.from_angle(a) * s * 0.28, s * 0.4 + 3.0, ol)
			draw_circle(p, s * 0.5 + 3.0, ol)
			for k in range(5):
				var a2 := float(seeds[k]) * TAU
				draw_circle(p + Vector2.from_angle(a2) * s * 0.28, s * 0.4, Color(0.2, 0.52, 0.24))
			draw_circle(p, s * 0.5, Color(0.22, 0.56, 0.26))
			for k in range(4):
				var a3 := float(seeds[k]) * TAU
				draw_circle(p + Vector2.from_angle(a3) * s * 0.22 + Vector2(-s * 0.08, -s * 0.1), s * 0.2, Color(0.34, 0.68, 0.34))
		1:
			draw_colored_polygon(_blob(p + Vector2(6, 9), s * 0.75, seeds, 0.12), Color(0, 0, 0, 0.16))
			_outlined(_blob(p, s * 0.72, seeds, 0.14), Color(0.62, 0.64, 0.68), Color(0.28, 0.29, 0.33), 3.0)
			draw_colored_polygon(_blob(p + Vector2(-s * 0.1, -s * 0.12), s * 0.4, seeds, 0.15), Color(0.78, 0.8, 0.84))
		2:
			draw_colored_polygon(_blob(p + Vector2(5, 8), s * 0.62, seeds, 0.1), Color(0, 0, 0, 0.14))
			for k in range(4):
				var a := float(seeds[k]) * TAU
				draw_circle(p + Vector2.from_angle(a) * s * 0.25, s * 0.38 + 2.5, Color(0.12, 0.34, 0.14))
			for k in range(4):
				var a2 := float(seeds[k]) * TAU
				draw_circle(p + Vector2.from_angle(a2) * s * 0.25, s * 0.38, Color(0.3, 0.64, 0.28))
			for k in range(5):
				var a3 := float(seeds[(k + 1) % seeds.size()]) * TAU
				var bp := p + Vector2.from_angle(a3) * s * 0.3
				draw_circle(bp, 4.0, Color(0.6, 0.1, 0.18))
				draw_circle(bp, 3.0, Color(0.92, 0.2, 0.3))
		_:
			_outlined(_blob(p, s * 0.62, seeds, 0.12), Color(0.94, 0.88, 0.66), Color(0.8, 0.7, 0.45), 3.0)
			draw_colored_polygon(_blob(p, s * 0.55, seeds, 0.12), Color(0.3, 0.62, 0.86))
			draw_colored_polygon(_blob(p + Vector2(s * 0.05, -s * 0.05), s * 0.38, seeds, 0.14), Color(0.4, 0.72, 0.92))
			for k in range(2):
				var rr := s * (0.22 + 0.12 * float(k)) + sin(time * 1.2 + float(k)) * 3.0
				draw_arc(p, rr, 0.3 + float(k), 1.5 + float(k), 12, Color(1, 1, 1, 0.55), 2.0, true)


func _draw_food(i: int) -> void:
	var ph := food_ph[i]
	var kind := food_kind[i]
	var pos := food_pos[i] + Vector2(0, sin(time * 2.0 + ph) * 2.5)
	var ol := Color(0.15, 0.08, 0.06)
	match kind:
		0:
			draw_circle(pos + Vector2(2, 5), 9.0, Color(0, 0, 0, 0.14))
			for k in range(3):
				var bp := pos + Vector2.from_angle(float(k) * TAU / 3.0 + 0.5) * 4.5
				draw_circle(bp, 5.2, ol)
				draw_circle(bp, 4.0, Color(0.88, 0.16, 0.3))
				draw_circle(bp + Vector2(-1.2, -1.4), 1.3, Color(1, 0.8, 0.85))
			draw_colored_polygon(PackedVector2Array([pos + Vector2(0, -2), pos + Vector2(6, -9), pos + Vector2(2, -1)]), Color(0.25, 0.65, 0.25))
		1:
			draw_circle(pos + Vector2(2, 6), 11.0, Color(0, 0, 0, 0.14))
			draw_circle(pos, 10.5, ol)
			draw_circle(pos, 9.0, Color(0.9, 0.22, 0.2))
			draw_circle(pos + Vector2(-3, -3), 3.0, Color(1, 0.7, 0.65))
			draw_line(pos + Vector2(0, -8), pos + Vector2(2, -14), Color(0.4, 0.25, 0.12), 2.0, true)
			draw_colored_polygon(PackedVector2Array([pos + Vector2(2, -11), pos + Vector2(10, -14), pos + Vector2(6, -8)]), Color(0.3, 0.7, 0.28))
		2:
			var pulse := 1.0 + 0.1 * sin(time * 4.0 + ph)
			draw_circle(pos, 22.0 * pulse, Color(1.0, 0.85, 0.3, 0.2))
			draw_circle(pos, 12.5, Color(0.55, 0.35, 0.05))
			draw_circle(pos, 11.0, Color(1.0, 0.8, 0.2))
			draw_circle(pos, 7.5, Color(1.0, 0.92, 0.5))
			draw_line(pos + Vector2(-3, 0), pos + Vector2(3, 0), Color(0.75, 0.5, 0.1), 2.0, true)
			draw_line(pos + Vector2(0, -3), pos + Vector2(0, 3), Color(0.75, 0.5, 0.1), 2.0, true)
		_:
			draw_circle(pos + Vector2(2, 7), 13.0, Color(0, 0, 0, 0.14))
			var sack := PackedVector2Array()
			for k in range(16):
				var a := TAU * float(k) / 16.0
				sack.append(pos + Vector2(cos(a) * 11.0, sin(a) * 10.0))
			_outlined(sack, Color(0.72, 0.5, 0.28), ol, 2.5)
			draw_line(pos + Vector2(-5, -8), pos + Vector2(5, -8), Color(0.45, 0.28, 0.12), 3.0, true)
			draw_circle(pos + Vector2(0, 1), 3.5, Color(1.0, 0.82, 0.25))
