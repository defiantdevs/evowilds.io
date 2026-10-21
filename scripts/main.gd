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
const DM_TIME := 600.0        # Deathmatch: 10:00 countdown
const BASE_HP := 15000.0      # Team Deathmatch statue health
const UNIT_SIZES := [
	{"r": 26.0, "dmg": 1.0, "cd": 0.7, "every": 15.0},    # small
	{"r": 38.0, "dmg": 2.0, "cd": 0.9, "every": 40.0},    # medium
	{"r": 52.0, "dmg": 3.0, "cd": 1.1, "every": 60.0},    # large
	{"r": 70.0, "dmg": 5.0, "cd": 1.5, "every": 120.0},   # extra large
]

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
var leader = null  # the biggest creature alive (rank 1); wears the crown
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

# --- game modes ---------------------------------------------------------
var mode := "dm"                       # "dm" or "tdm"
var player_team := -1                  # 0 = Red, 1 = Blue, -1 = none
var stat_red: Dictionary = {}
var stat_blue: Dictionary = {}
var units: Array = []                  # neutral / captured golems & statues
var unit_timers := [3.0, 12.0, 22.0, 45.0]
var match_time := 0.0
var match_over := false
var match_msg := ""
var result_t := 0.0
var leave_t := 0.0
var leaving := false


func _ready() -> void:
	randomize()
	var dev_mode := ""
	for a in OS.get_cmdline_user_args():
		if a.begins_with("--shot="):
			shot_path = a.substr(7)
		elif a == "--gallery":
			shot_gallery = true
		elif a.begins_with("--evo="):
			shot_evo = int(a.substr(6))
		elif a.begins_with("--wait="):
			shot_time = float(a.substr(7))
		elif a.begins_with("--mode="):
			dev_mode = a.substr(7)
	mode = dev_mode if dev_mode != "" else ("dm" if shot_path != "" else GameState.mode)
	if mode == "tdm":
		player_team = GameState.team
		if player_team < 0:
			player_team = randi() % 2
			GameState.team = player_team
	_setup_mode()
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
	var pal := [Color(0.42, 0.7, 0.33), Color(0.3, 0.56, 0.27), Color(0.78, 0.7, 0.44), Color(0.5, 0.76, 0.4), Color(0.35, 0.63, 0.35), Color(0.66, 0.6, 0.4)]
	for i in range(12):
		var rad := rng.randf_range(260.0, 560.0)
		var a := rng.randf() * TAU
		var d := sqrt(rng.randf()) * (ARENA_R - rad - 60.0)
		patches.append({"pos": Vector2.from_angle(a) * d, "rad": rad, "col": pal[i % pal.size()]})
	for i in range(260):
		var a := rng.randf() * TAU
		var d := sqrt(rng.randf()) * (ARENA_R - 130.0)
		var k := rng.randi() % 12
		var kind := 0
		if k >= 4 and k < 6:
			kind = 1
		elif k >= 6 and k < 8:
			kind = 2
		elif k >= 8 and k < 10:
			kind = 3
		elif k >= 10 and k < 11:
			kind = 4
		elif k >= 11:
			kind = 5
		var sz := rng.randf_range(46.0, 86.0)
		if kind == 1:
			sz = rng.randf_range(30.0, 60.0)
		elif kind == 2:
			sz = rng.randf_range(34.0, 56.0)
		elif kind == 3:
			sz = rng.randf_range(90.0, 170.0)
		elif kind == 4:
			sz = rng.randf_range(40.0, 70.0)
		elif kind == 5:
			sz = rng.randf_range(26.0, 48.0)
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


func _spawn_creature(is_pl: bool, evo: int, pos: Vector2, nm: String, extra_xp: float = 0.0, team_: int = -1) -> Node2D:
	var c := Creature.new()
	c.main = self
	c.is_player = is_pl
	c.cname = nm
	c.team = team_
	var base: float = Species.XP_AT[evo]
	c.xp = base + extra_xp
	c.position = pos
	c.shield = 2.0
	add_child(c)
	creatures.append(c)
	return c


func _team_with_fewer() -> int:
	var r := 0
	var b := 0
	for c in creatures:
		if c.team == 0:
			r += 1
		elif c.team == 1:
			b += 1
	return 0 if r <= b else 1


func _spawn_player(reset_clock: bool = true) -> void:
	player_dead = false
	leave_t = 0.0
	kills = 0
	best_evo = 0
	if player != null and is_instance_valid(player):
		player.queue_free()
	var evo := 0
	var pos := Vector2.from_angle(randf() * TAU) * randf_range(200.0, 900.0)
	if shot_path != "":
		evo = shot_evo
		pos = Vector2(0, 260) if shot_gallery else pos
	if mode == "tdm":
		pos = Vector2.from_angle(randf() * TAU) * randf_range(400.0, 1100.0)
	player = _spawn_creature(true, evo, pos, GameState.clean_name(), 0.0, player_team)
	if shot_path != "":
		player.frozen = true
		player.shield = 0.0
	if reset_clock and not shot_gallery:
		time = 0.0


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
	var c := _spawn_creature(false, evo, pos, BOT_NAMES[randi() % BOT_NAMES.size()], randf() * span, _team_with_fewer() if mode == "tdm" else -1)
	c.shield = 3.0


func _spawn_gallery() -> void:
	for i in range(Species.COUNT):
		var col := i % 5
		var row := i / 5
		var c := _spawn_creature(false, i, Vector2(float(col - 2) * 330.0, float(row) * 300.0 - 460.0), Species.NAMES[i])
		c.frozen = true
		c.shield = 0.0
		c.heading = 0.0


# --- game modes ---------------------------------------------------------

func _setup_mode() -> void:
	if mode == "tdm":
		var off := ARENA_R * 0.5
		stat_red = {"team": 0, "pos": Vector2(-off, 0.0), "r": 150.0, "hp": BASE_HP, "max_hp": BASE_HP, "flash": 0.0}
		stat_blue = {"team": 1, "pos": Vector2(off, 0.0), "r": 150.0, "hp": BASE_HP, "max_hp": BASE_HP, "flash": 0.0}
		match_time = 0.0
	else:
		match_time = DM_TIME


func team_color(t: int) -> Color:
	if t == 0:
		return Color(0.89, 0.27, 0.27)
	if t == 1:
		return Color(0.3, 0.52, 0.95)
	return Color(0.62, 0.62, 0.66)


func team_name_of(t: int) -> String:
	if t == 0:
		return "Red"
	if t == 1:
		return "Blue"
	return ""


func enemy_base(t: int) -> Dictionary:
	if t == 0:
		return stat_blue
	if t == 1:
		return stat_red
	return {}


func own_base(t: int) -> Dictionary:
	if t == 0:
		return stat_red
	if t == 1:
		return stat_blue
	return {}


func enemy_near_base(team_: int, radius: float):
	# nearest enemy creature (player or bot) hanging around this team's statue
	var b := own_base(team_)
	if b.is_empty():
		return null
	var bp: Vector2 = b["pos"]
	var best = null
	var bd := radius
	for c in creatures:
		if not c.alive or c.frozen:
			continue
		if c.team == team_ or c.team < 0:
			continue
		var d: float = c.position.distance_to(bp)
		if d < bd:
			bd = d
			best = c
	return best


func unit_to_convert(pos: Vector2, team_: int, reach: float):
	var best = null
	var bd := reach
	for u in units:
		if int(u["team"]) == team_:
			continue
		var d: float = pos.distance_to(u["pos"])
		if d < bd + float(u["r"]) * 0.5:
			bd = d
			best = u
	return best


func _statue_damage(c) -> float:
	# 1 at the smallest size up to 28 at the biggest; evolution only matters via size
	var rr: float = c.r
	var d := 1.0 + 27.0 * clampf((rr - 22.0) / (95.0 - 22.0), 0.0, 1.0)
	return clampf(roundf(d), 1.0, 28.0)


func _spawn_unit(size: int) -> void:
	var pos := Vector2.ZERO
	for tries in range(14):
		pos = Vector2.from_angle(randf() * TAU) * sqrt(randf()) * (ARENA_R - 340.0)
		if pos.distance_to(stat_red["pos"]) > 520.0 and pos.distance_to(stat_blue["pos"]) > 520.0 and not _blocked(pos):
			break
	units.append({
		"pos": pos,
		"size": size,
		"team": -1,
		"r": float(UNIT_SIZES[size]["r"]),
		"atk": 0.0,
		"flash": 0.0,
		"ph": randf() * TAU,
	})


func _update_units(delta: float) -> void:
	for i in range(UNIT_SIZES.size()):
		unit_timers[i] = float(unit_timers[i]) - delta
		if float(unit_timers[i]) <= 0.0:
			unit_timers[i] = float(UNIT_SIZES[i]["every"])
			_spawn_unit(i)
	for u in units:
		if float(u["flash"]) > 0.0:
			u["flash"] = maxf(float(u["flash"]) - delta, 0.0)
		var t: int = int(u["team"])
		if t < 0:
			continue
		var base: Dictionary = enemy_base(t)
		if base.is_empty():
			continue
		var to: Vector2 = base["pos"] - Vector2(u["pos"])
		var dist := to.length()
		var reach: float = float(base["r"]) + float(u["r"]) * 0.5
		if dist > reach:
			u["pos"] = Vector2(u["pos"]) + to.normalized() * (95.0 - 9.0 * float(u["size"])) * delta
		else:
			u["atk"] = float(u["atk"]) - delta
			if float(u["atk"]) <= 0.0:
				u["atk"] = float(UNIT_SIZES[int(u["size"])]["cd"])
				base["hp"] = maxf(float(base["hp"]) - float(UNIT_SIZES[int(u["size"])]["dmg"]), 0.0)
				base["flash"] = 0.25
				fx.burst(Vector2(base["pos"]), team_color(t), 6, 150.0, 0.4)
	for b in [stat_red, stat_blue]:
		if float(b["flash"]) > 0.0:
			b["flash"] = maxf(float(b["flash"]) - delta, 0.0)


func _check_match_end() -> void:
	if float(stat_red["hp"]) <= 0.0:
		_end_match("BLUE TEAM WINS")
	elif float(stat_blue["hp"]) <= 0.0:
		_end_match("RED TEAM WINS")


func _end_match(msg: String) -> void:
	if match_over:
		return
	match_over = true
	match_msg = msg
	result_t = 4.5
	shake = 16.0
	banner_text = msg
	banner_ttl = 4.0
	banner_col = Color(1.0, 0.9, 0.4)


func _leave_to_menu() -> void:
	if leaving:
		return
	leaving = true
	get_tree().change_scene_to_file("res://scenes/menu.tscn")


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
	if leader == victim:
		leader = board[0] if board.size() > 0 else null
	if victim.is_player:
		victim.visible = false
	else:
		victim.queue_free()
	if not victim.is_player:
		respawns.append(randf_range(3.0, 6.0))
	eater.add_xp(gain)


func weapon_hit_zone(attacker, bands: Array, s_lo: float, s_hi: float) -> void:
	# The killing ground is the weapon itself: the drawn blade, part by part,
	# and the slice of the arc it swept through on this frame. Nothing kills
	# outside the weapon.
	var pivot: Vector2 = attacker.position + Vector2(0.0, 0.8 * attacker.r).rotated(attacker.heading)
	for o in creatures:
		if o == attacker or not o.alive or o.frozen:
			continue
		if mode == "tdm" and attacker.team >= 0 and o.team == attacker.team:
			continue
		if attacker.swing_hits.has(o):
			continue
		if not _zone_hits(o.position, o.r, pivot, attacker.heading, bands, s_lo, s_hi):
			continue
		attacker.swing_hits.append(o)
		o.take_damage(0.0, attacker)
		if not attacker.alive:
			return
	if mode != "tdm" or not attacker.alive:
		return
	var ateam: int = attacker.team
	if ateam < 0:
		return
	# hitting a neutral (or enemy) golem flips it to your colour
	for u in units:
		if int(u["team"]) == ateam or attacker.swing_hits.has(u):
			continue
		var up: Vector2 = u["pos"]
		if _zone_hits(up, float(u["r"]), pivot, attacker.heading, bands, s_lo, s_hi):
			attacker.swing_hits.append(u)
			u["team"] = ateam
			u["atk"] = 0.0
			u["flash"] = 0.3
			fx.burst(up, team_color(ateam), 14, 220.0, 0.5)
	# hitting the enemy statue chips its health (1-28 by size)
	var eb: Dictionary = enemy_base(ateam)
	if eb.is_empty() or attacker.swing_hits.has(eb):
		return
	var ep: Vector2 = eb["pos"]
	if _zone_hits(ep, float(eb["r"]), pivot, attacker.heading, bands, s_lo, s_hi):
		attacker.swing_hits.append(eb)
		var dmg := _statue_damage(attacker)
		eb["hp"] = maxf(float(eb["hp"]) - dmg, 0.0)
		eb["flash"] = 0.3
		fx.burst(ep, team_color(ateam), 18, 260.0, 0.5)
		if attacker.is_player:
			shake = maxf(shake, 5.0)


func _zone_hits(p: Vector2, target_r: float, pivot: Vector2, heading: float, bands: Array, s_lo: float, s_hi: float) -> bool:
	# Does a body of that size at p overlap the weapon? Each part of the
	# weapon owns a band of radii and a slice of the arc it just swept.
	var v: Vector2 = (p - pivot).rotated(-heading)
	var d := v.length()
	if d < 0.001:
		return true
	var va := v.angle()
	for b in bands:
		var tol: float = target_r + float(b[4])
		if d < float(b[1]) - tol or d > float(b[2]) + tol:
			continue
		var rel: float = angle_difference(va, (b[0] as Vector2).angle())
		var eps := asin(clampf(tol / d, 0.0, 1.0))
		var h: float = float(b[3])
		if rel >= s_lo - h - eps and rel <= s_hi + h + eps:
			return true
	return false


func _process(delta: float) -> void:
	time += delta
	if match_over:
		result_t = maxf(result_t - delta, 0.0)
		if result_t <= 0.0:
			_leave_to_menu()
	else:
		# The match keeps running while the player is dead: the clock ticks,
		# golems march and statues keep taking damage.
		if mode == "tdm":
			match_time += delta
			_update_units(delta)
			_check_match_end()
		else:
			match_time = maxf(match_time - delta, 0.0)
			if match_time <= 0.0:
				_end_match("TIME UP")
		if not match_over and player_dead:
			leave_t += delta
			if leave_t > 2.2:
				_spawn_player(false)
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
	leader = board[0] if board.size() > 0 else null


func _update_camera(delta: float) -> void:
	var target_zoom := 0.9
	if player != null and player.alive:
		var e: int = player.evo
		target_zoom = clampf(1.1 - 0.033 * float(e) - 0.02 * Species.progress(player.xp), 0.46, 1.1)
		cam.position = cam.position.lerp(player.position + player.vel * 0.15, minf(delta * 6.0, 1.0))
	if shot_gallery:
		target_zoom = 0.4
		cam.position = Vector2(0, -160)
	elif shot_path != "" and mode == "tdm":
		target_zoom = 0.8
		cam.position = stat_red["pos"] + Vector2(180, -60)
	var z := lerpf(cam.zoom.x, target_zoom, minf(delta * 2.5, 1.0))
	cam.zoom = Vector2(z, z)
	shake = move_toward(shake, 0.0, 45.0 * delta)
	cam.offset = Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0)) * shake


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and event.physical_keycode == KEY_ESCAPE:
		_leave_to_menu()
		return
	if match_over:
		if result_t > 3.7:
			return
		var go2 := false
		if event is InputEventKey and event.pressed:
			go2 = true
		elif event is InputEventMouseButton and event.pressed:
			go2 = true
		if go2:
			_leave_to_menu()
		return
	if not player_dead:
		return
	if time - death_time < 0.8:
		return
	var go := false
	if event is InputEventKey and event.pressed:
		go = true
	elif event is InputEventMouseButton and event.pressed:
		go = true
	if go:
		_spawn_player(false)


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
	var vr := view.grow(220.0)
	draw_rect(view.grow(200.0), Color(0.17, 0.46, 0.68))
	for i in range(6):
		var wr := ARENA_R + 150.0 + float(i) * 170.0 + sin(time * 0.8 + float(i)) * 14.0
		draw_arc(Vector2.ZERO, wr, 0.0, TAU, 200, Color(1, 1, 1, 0.07), 5.0, true)
	draw_circle(Vector2.ZERO, ARENA_R + 95.0, Color(0.3, 0.6, 0.82))
	draw_circle(Vector2.ZERO, ARENA_R + 70.0, Color(0.88, 0.8, 0.55))
	draw_circle(Vector2.ZERO, ARENA_R + 30.0, Color(0.96, 0.9, 0.68))
	draw_circle(Vector2.ZERO, ARENA_R, Color(0.38, 0.68, 0.3))
	var pvw := view.grow(640.0)
	for p in patches:
		var c: Vector2 = p["pos"]
		var rad: float = p["rad"]
		if not pvw.has_point(c):
			continue
		var col: Color = p["col"]
		draw_circle(c, rad * 1.07, col.darkened(0.14))
		draw_circle(c, rad, col)
		draw_circle(c + Vector2(rad * 0.4, rad * 0.25), rad * 0.62, col.lightened(0.06))
		draw_circle(c + Vector2(-rad * 0.42, -rad * 0.3), rad * 0.5, col)
	var sp := 80
	var gx0 := int(floorf(view.position.x / float(sp)))
	var gx1 := int(ceilf(view.end.x / float(sp)))
	var gy0 := int(floorf(view.position.y / float(sp)))
	var gy1 := int(ceilf(view.end.y / float(sp)))
	var tuft := Color(0.2, 0.45, 0.2, 0.55)
	var tuft2 := Color(0.48, 0.7, 0.32, 0.5)
	for gy in range(gy0, gy1 + 1):
		for gx in range(gx0, gx1 + 1):
			var h := _hash(gx + 11, gy + 5)
			var q := Vector2((float(gx) + _hash(gx, gy)) * float(sp), (float(gy) + _hash(gy + 7, gx + 3)) * float(sp))
			if q.length() < ARENA_R - 20.0:
				var hh := 6.0 + h * 5.0
				draw_line(q, q + Vector2(-3, -hh * 0.8), tuft, 1.6, true)
				draw_line(q, q + Vector2(0, -hh), tuft2, 1.5, true)
				draw_line(q, q + Vector2(3, -hh * 0.8), tuft, 1.6, true)
				if h > 0.88:
					var fc: Color = Color(0.95, 0.85, 0.35) if h > 0.95 else Color(0.88, 0.45, 0.6)
					draw_circle(q + Vector2(0, -hh), 1.8, fc)
				elif h < 0.06:
					draw_circle(q + Vector2(1.0, -1.0), 2.2, Color(0.6, 0.58, 0.52, 0.6))
	for d in decor:
		var dp: Vector2 = d["pos"]
		if vr.has_point(dp):
			_draw_decor(d)
	for i in range(food_pos.size()):
		if vr.has_point(food_pos[i]):
			_draw_food(i)
	if mode == "tdm":
		_draw_units(view)
		if not stat_red.is_empty():
			_draw_base(stat_red)
		if not stat_blue.is_empty():
			_draw_base(stat_blue)


func _draw_base(b: Dictionary) -> void:
	var p: Vector2 = b["pos"]
	var rr: float = b["r"]
	var col := team_color(int(b["team"]))
	var flash: float = b["flash"]
	if flash > 0.0:
		col = col.lerp(Color(1, 1, 1), clampf(flash * 2.0, 0.0, 0.55))
	draw_set_transform(p + Vector2(20, 34), 0.0, Vector2(1.0, 0.34))
	draw_circle(Vector2.ZERO, rr * 1.05, Color(0, 0, 0, 0.24))
	draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
	# pedestal
	draw_rect(Rect2(p + Vector2(-rr * 0.8, rr * 0.28), Vector2(rr * 1.6, rr * 0.72)), col.darkened(0.4))
	draw_rect(Rect2(p + Vector2(-rr * 0.9, rr * 0.28), Vector2(rr * 1.8, rr * 0.18)), col.darkened(0.15))
	# torso
	draw_rect(Rect2(p + Vector2(-rr * 0.52, -rr * 0.72), Vector2(rr * 1.04, rr * 1.1)), col)
	draw_rect(Rect2(p + Vector2(-rr * 0.52, -rr * 0.72), Vector2(rr * 1.04, rr * 1.1)), col.darkened(0.32), false, 4.0)
	# shoulders / arms
	draw_circle(p + Vector2(-rr * 0.62, -rr * 0.4), rr * 0.24, col.darkened(0.08))
	draw_circle(p + Vector2(rr * 0.62, -rr * 0.4), rr * 0.24, col.darkened(0.08))
	draw_rect(Rect2(p + Vector2(-rr * 0.78, -rr * 0.44), Vector2(rr * 0.22, rr * 0.95)), col.darkened(0.18))
	draw_rect(Rect2(p + Vector2(rr * 0.56, -rr * 0.44), Vector2(rr * 0.22, rr * 0.95)), col.darkened(0.18))
	# head
	draw_circle(p + Vector2(0, -rr * 0.95), rr * 0.36, col.lightened(0.14))
	draw_circle(p + Vector2(0, -rr * 0.95), rr * 0.36, col.darkened(0.34), false, 4.0)
	draw_circle(p + Vector2(-rr * 0.13, -rr * 1.0), rr * 0.075, Color(0.05, 0.05, 0.09))
	draw_circle(p + Vector2(rr * 0.13, -rr * 1.0), rr * 0.075, Color(0.05, 0.05, 0.09))
	# health bar
	var bw := rr * 1.9
	var bx := p.x - bw * 0.5
	var by := p.y - rr * 1.6
	draw_rect(Rect2(bx - 3, by - 3, bw + 6, 20), Color(0.02, 0.03, 0.06, 0.85))
	draw_rect(Rect2(bx, by, bw, 14), Color(0.1, 0.12, 0.16))
	var frac: float = clampf(float(b["hp"]) / float(b["max_hp"]), 0.0, 1.0)
	draw_rect(Rect2(bx, by, bw * frac, 14), col)
	draw_rect(Rect2(bx, by, bw, 14), Color(1, 1, 1, 0.3), false, 1.5)
	draw_string(ThemeDB.fallback_font, Vector2(bx, by - 8), "%s  %d" % [team_name_of(int(b["team"])).to_upper(), int(b["hp"])], HORIZONTAL_ALIGNMENT_CENTER, bw, 18, Color(1, 1, 1, 0.95))


func _draw_units(view: Rect2) -> void:
	var vr := view.grow(200.0)
	for u in units:
		var p: Vector2 = u["pos"]
		if not vr.has_point(p):
			continue
		var rr: float = u["r"]
		var t: int = int(u["team"])
		var col := team_color(t)
		if t < 0:
			col = Color(0.6, 0.6, 0.64)
		var flash: float = u["flash"]
		if flash > 0.0:
			col = col.lerp(Color(1, 1, 1), clampf(flash * 2.0, 0.0, 0.55))
		var bob := sin(time * 2.0 + float(u["ph"])) * 2.0
		draw_set_transform(p + Vector2(6, rr * 0.78), 0.0, Vector2(1.0, 0.38))
		draw_circle(Vector2.ZERO, rr * 0.95, Color(0, 0, 0, 0.2))
		draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
		var c := p + Vector2(0, bob)
		draw_rect(Rect2(c + Vector2(-rr * 0.46, rr * 0.06), Vector2(rr * 0.34, rr * 0.72)), col.darkened(0.32))
		draw_rect(Rect2(c + Vector2(rr * 0.12, rr * 0.06), Vector2(rr * 0.34, rr * 0.72)), col.darkened(0.32))
		draw_rect(Rect2(c + Vector2(-rr * 0.6, -rr * 0.55), Vector2(rr * 1.2, rr * 0.85)), col)
		draw_rect(Rect2(c + Vector2(-rr * 0.6, -rr * 0.55), Vector2(rr * 1.2, rr * 0.85)), col.darkened(0.32), false, 3.0)
		draw_rect(Rect2(c + Vector2(-rr * 0.92, -rr * 0.46), Vector2(rr * 0.32, rr * 0.72)), col.darkened(0.16))
		draw_rect(Rect2(c + Vector2(rr * 0.6, -rr * 0.46), Vector2(rr * 0.32, rr * 0.72)), col.darkened(0.16))
		draw_circle(c + Vector2(0, -rr * 0.82), rr * 0.37, col.lightened(0.16))
		draw_circle(c + Vector2(0, -rr * 0.82), rr * 0.37, col.darkened(0.34), false, 3.0)
		if t < 0:
			draw_circle(c + Vector2(-rr * 0.14, -rr * 0.86), rr * 0.075, Color(0.12, 0.12, 0.15))
			draw_circle(c + Vector2(rr * 0.14, -rr * 0.86), rr * 0.075, Color(0.12, 0.12, 0.15))


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
			draw_colored_polygon(_blob(p + Vector2(10, 14), s * 0.68, seeds, 0.1), Color(0, 0, 0, 0.18))
			var ol := Color(0.1, 0.28, 0.12)
			for k in range(5):
				var a := float(seeds[k]) * TAU
				draw_circle(p + Vector2.from_angle(a) * s * 0.3, s * 0.42 + 3.0, ol)
			draw_circle(p, s * 0.52 + 3.0, ol)
			for k in range(5):
				var a2 := float(seeds[k]) * TAU
				draw_circle(p + Vector2.from_angle(a2) * s * 0.3, s * 0.4, Color(0.2, 0.52, 0.24))
			draw_circle(p, s * 0.5, Color(0.22, 0.56, 0.26))
			for k in range(4):
				var a3 := float(seeds[k]) * TAU
				draw_circle(p + Vector2.from_angle(a3) * s * 0.22 + Vector2(-s * 0.1, -s * 0.12), s * 0.2, Color(0.36, 0.7, 0.35))
			draw_circle(p + Vector2(-s * 0.16, -s * 0.18), s * 0.16, Color(0.44, 0.78, 0.4))
		1:
			draw_colored_polygon(_blob(p + Vector2(6, 9), s * 0.75, seeds, 0.12), Color(0, 0, 0, 0.16))
			_outlined(_blob(p, s * 0.72, seeds, 0.14), Color(0.62, 0.64, 0.68), Color(0.28, 0.29, 0.33), 3.0)
			draw_colored_polygon(_blob(p + Vector2(-s * 0.1, -s * 0.12), s * 0.4, seeds, 0.15), Color(0.78, 0.8, 0.84))
			draw_colored_polygon(_blob(p + Vector2(-s * 0.2, -s * 0.22), s * 0.16, seeds, 0.18), Color(0.2, 0.34, 0.2, 0.85))
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
		3:
			_outlined(_blob(p, s * 0.78, seeds, 0.12), Color(0.94, 0.88, 0.66), Color(0.85, 0.78, 0.55), 3.0)
			_outlined(_blob(p, s * 0.62, seeds, 0.12), Color(0.94, 0.88, 0.66), Color(0.8, 0.7, 0.45), 2.0)
			draw_colored_polygon(_blob(p, s * 0.55, seeds, 0.12), Color(0.3, 0.62, 0.86))
			draw_colored_polygon(_blob(p + Vector2(s * 0.05, -s * 0.05), s * 0.38, seeds, 0.14), Color(0.4, 0.72, 0.92))
			for k in range(2):
				var rr := s * (0.22 + 0.12 * float(k)) + sin(time * 1.2 + float(k)) * 3.0
				draw_arc(p, rr, 0.3 + float(k), 1.5 + float(k), 12, Color(1, 1, 1, 0.55), 2.0, true)
			for k in range(3):
				var la := float(seeds[k]) * TAU
				var lp := p + Vector2.from_angle(la) * s * 0.3
				draw_circle(lp, s * 0.09, Color(0.25, 0.55, 0.25))
				draw_circle(lp + Vector2(s * 0.03, -s * 0.02), s * 0.05, Color(0.35, 0.65, 0.3))
		4:
			for k in range(6):
				var fa := float(seeds[k % seeds.size()]) * TAU
				var q := p + Vector2.from_angle(fa) * s * 0.42
				draw_line(q, q + Vector2(0, -s * 0.32), Color(0.25, 0.5, 0.24, 0.8), 1.5, true)
				var fc: Color = [Color(0.95, 0.85, 0.35), Color(0.9, 0.45, 0.6), Color(0.6, 0.65, 0.95)][k % 3]
				draw_circle(q + Vector2(0, -s * 0.32), s * 0.09, fc)
				draw_circle(q + Vector2(0, -s * 0.32), s * 0.045, Color(1, 1, 0.9))
		_:
			for k in range(4):
				var pa2 := float(seeds[k % seeds.size()]) * TAU
				var q2 := p + Vector2.from_angle(pa2) * s * 0.3
				draw_circle(q2 + Vector2(1.5, 2.5), s * 0.16, Color(0, 0, 0, 0.15))
				draw_circle(q2, s * 0.16, Color(0.62, 0.6, 0.55))
				draw_circle(q2 + Vector2(-1.5, -2.0), s * 0.08, Color(0.8, 0.78, 0.72))


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
