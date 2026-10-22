extends Control

const Species = preload("res://scripts/species.gd")

var main
var t := 0.0
var sb: StyleBoxFlat


func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	set_anchors_preset(Control.PRESET_FULL_RECT)
	sb = StyleBoxFlat.new()
	sb.bg_color = Color(0.02, 0.05, 0.1, 0.72)
	sb.set_corner_radius_all(10)
	sb.border_color = Color(0.3, 0.8, 1.0, 0.35)
	sb.set_border_width_all(1)


func _process(delta: float) -> void:
	t += delta
	position = Vector2.ZERO
	size = get_viewport_rect().size
	queue_redraw()


func _text(s: String, pos: Vector2, size_: int, col: Color, w: float = -1.0, align: int = HORIZONTAL_ALIGNMENT_LEFT) -> void:
	draw_string(ThemeDB.fallback_font, pos, s, align, w, size_, col)


func _center(s: String, y: float, size_: int, col: Color) -> void:
	var w := 900.0
	draw_string(ThemeDB.fallback_font, Vector2(size.x * 0.5 - w * 0.5, y), s, HORIZONTAL_ALIGNMENT_CENTER, w, size_, col)


func _clock(secs: float) -> String:
	var s := maxi(int(ceil(secs)), 0)
	return "%d:%02d" % [s / 60, s % 60]


func _timer_ui(S: Vector2) -> void:
	if main.mode == "test":
		draw_style_box(sb, Rect2(S.x * 0.5 - 96, 16, 192, 56))
		_center("TEST RANGE", 38.0, 20, Color(0.55, 1.0, 0.85))
		_center("%d BOTS CHARGING" % GameState.test_bots, 60.0, 13, Color(0.75, 0.92, 1.0, 0.9))
		return
	var col := Color(1, 1, 1)
	if main.mode == "dm" and main.match_time <= 10.0:
		col = Color(1.0, 0.55, 0.45)
	draw_style_box(sb, Rect2(S.x * 0.5 - 58, 16, 116, 44))
	_center(_clock(main.match_time), 47.0, 24, col)
	if main.mode == "tdm":
		var tn: String = main.team_name_of(main.player_team)
		if tn != "":
			var tcol: Color = main.team_color(main.player_team)
			_center("YOU ARE " + tn.to_upper(), 76.0, 15, tcol.lightened(0.25))
		_statue_bar(main.stat_red, S.x * 0.5 - 300.0)
		_statue_bar(main.stat_blue, S.x * 0.5 + 80.0)


func _statue_bar(st: Dictionary, x: float) -> void:
	if st.is_empty():
		return
	var y := 24.0
	var w := 220.0
	var col: Color = main.team_color(int(st["team"]))
	var frac: float = clampf(float(st["hp"]) / float(st["max_hp"]), 0.0, 1.0)
	draw_rect(Rect2(x - 3, y - 3, w + 6, 26), Color(0.02, 0.05, 0.1, 0.8))
	draw_rect(Rect2(x, y, w, 20), Color(0.1, 0.12, 0.16))
	draw_rect(Rect2(x, y, w * frac, 20), col)
	draw_rect(Rect2(x, y, w, 20), Color(1, 1, 1, 0.3), false, 1.5)
	_text("%s  %d / %d" % [main.team_name_of(int(st["team"])).to_upper(), int(st["hp"]), int(st["max_hp"])], Vector2(x, y - 6), 14, Color(1, 1, 1, 0.95), w)


func _mini_crown(p: Vector2, s: float) -> void:
	# small crown badge for the biggest creature (player or bot)
	var gold := Color(1.0, 0.86, 0.3)
	var pts := PackedVector2Array([
		p + Vector2(-s, 0.0),
		p + Vector2(-s, -s * 0.7),
		p + Vector2(-s * 0.5, -s * 0.15),
		p + Vector2(0.0, -s * 0.95),
		p + Vector2(s * 0.5, -s * 0.15),
		p + Vector2(s, -s * 0.7),
		p + Vector2(s, 0.0),
	])
	draw_colored_polygon(pts, gold)
	draw_polyline(pts, Color(0.3, 0.18, 0.02, 0.9), 1.0, true)
	draw_rect(Rect2(p + Vector2(-s, -s * 0.05), Vector2(s * 2.0, s * 0.3)), gold)


func _draw() -> void:
	if main == null or main.player == null:
		return
	var S := size
	var pl = main.player
	var evo: int = pl.evo
	var c1: Color = Species.COL1[evo]
	var c2: Color = Species.COL2[evo]

	_timer_ui(S)

	draw_style_box(sb, Rect2(16, 16, 230, 74))
	_text("SCORE", Vector2(30, 38), 12, Color(0.6, 0.8, 0.9, 0.8))
	_text(str(int(pl.xp)), Vector2(30, 72), 30, Color(1, 1, 1))
	_text("KILLS", Vector2(150, 38), 12, Color(0.6, 0.8, 0.9, 0.8))
	_text(str(main.kills), Vector2(150, 72), 30, Species.glow(c2, 1.0))

	var fy := 108.0
	for f in main.feed:
		var ttl: float = f["ttl"]
		var fc: Color = f["c"]
		_text(str(f["t"]), Vector2(20, fy), 14, Color(fc.r, fc.g, fc.b, clampf(ttl, 0.0, 1.0)))
		fy += 20.0

	var rows := mini(main.board.size(), 8)
	var lb_h := 40.0 + float(rows) * 24.0 + 28.0
	draw_style_box(sb, Rect2(S.x - 246, 16, 230, lb_h))
	_text("LEADERBOARD", Vector2(S.x - 230, 38), 12, Color(0.6, 0.8, 0.9, 0.8))
	var ly := 62.0
	var in_top := false
	for i in range(rows):
		var o = main.board[i]
		var oc: Color = Species.COL2[o.evo].lightened(0.45)
		var nm: String = o.cname
		var is_me: bool = o == pl
		if is_me:
			in_top = true
			draw_rect(Rect2(S.x - 240, ly - 16, 218, 22), Color(1, 1, 1, 0.1))
		_text(str(i + 1) + ".", Vector2(S.x - 232, ly), 14, Color(0.7, 0.8, 0.9))
		_text(nm, Vector2(S.x - 208, ly), 14, oc if not is_me else Color(1, 0.95, 0.5))
		if o == main.leader:
			var nw: float = ThemeDB.fallback_font.get_string_size(nm, HORIZONTAL_ALIGNMENT_LEFT, -1, 14).x
			_mini_crown(Vector2(S.x - 208 + nw + 8.0, ly - 3.0), 4.2)
		_text(str(int(o.xp)), Vector2(S.x - 110, ly), 14, Color(0.85, 0.95, 1.0), 80.0, HORIZONTAL_ALIGNMENT_RIGHT)
		ly += 24.0
	if not in_top and pl.alive:
		var rank: int = main.board.find(pl) + 1
		_text(str(rank) + ".", Vector2(S.x - 232, ly + 6), 14, Color(1, 0.95, 0.5))
		_text(pl.cname, Vector2(S.x - 208, ly + 6), 14, Color(1, 0.95, 0.5))
		_text(str(int(pl.xp)), Vector2(S.x - 110, ly + 6), 14, Color(1, 0.95, 0.5), 80.0, HORIZONTAL_ALIGNMENT_RIGHT)

	var bw := 560.0
	var bx := (S.x - bw) * 0.5
	var by := S.y - 66.0
	var maxed: bool = evo >= Species.COUNT - 1
	var total := Species.progress(pl.xp)
	draw_rect(Rect2(bx - 3, by - 3, bw + 6, 22), Color(0.02, 0.05, 0.1, 0.8))
	draw_rect(Rect2(bx - 3, by - 3, bw + 6, 22), Color(0.3, 0.8, 1.0, 0.4), false, 1.5)
	var fw := bw * total
	if fw > 1.0:
		var cols := PackedColorArray([c1.lightened(0.1), c2, c2, c1.lightened(0.1)])
		draw_polygon(PackedVector2Array([Vector2(bx, by), Vector2(bx + fw, by), Vector2(bx + fw, by + 16), Vector2(bx, by + 16)]), cols)
		draw_rect(Rect2(bx, by, fw, 5), Color(1, 1, 1, 0.25))
	for k in range(1, 4):
		draw_line(Vector2(bx + bw * float(k) / 4.0, by), Vector2(bx + bw * float(k) / 4.0, by + 16), Color(0, 0, 0, 0.35), 2.0)
	var ia := Vector2(bx - 40.0, by + 8.0)
	draw_set_transform(ia, 0.0, Vector2(0.9, 0.9))
	Species.draw_body(self, evo, 14.0, t, c1, c2, 0.12)
	draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
	if not maxed:
		var nc1: Color = Species.COL1[evo + 1]
		var nc2: Color = Species.COL2[evo + 1]
		draw_set_transform(Vector2(bx + bw + 40.0, by + 8.0), 0.0, Vector2(0.9, 0.9))
		Species.draw_body(self, evo + 1, 14.0, t, Color(nc1.r * 0.45, nc1.g * 0.45, nc1.b * 0.5), Color(nc2.r * 0.5, nc2.g * 0.5, nc2.b * 0.55), 0.12)
		draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
	_center(Species.NAMES[evo], by - 40.0, 24, c2.lightened(0.4))
	var sub := "Tier %d of %d" % [evo + 1, Species.COUNT]
	if not maxed:
		var nxt: float = Species.XP_AT[evo + 1]
		sub += "   -   %d XP to %s" % [int(maxf(nxt - pl.xp, 0.0)), Species.NAMES[evo + 1]]
	else:
		sub += "   -   MAX TIER"
	_center(sub, by - 20.0, 13, Color(0.7, 0.85, 0.95, 0.85))
	var sw := 260.0
	var sx := (S.x - sw) * 0.5
	_text("SPACE / CLICK: swing (one hit kills!)      SHIFT / RIGHT-CLICK: sprint (costs XP)", Vector2(sx - 160, by + 34), 12, Color(0.8, 0.9, 1.0, 0.75), sw + 320.0, HORIZONTAL_ALIGNMENT_CENTER)

	var mc := Vector2(S.x - 100, S.y - 100)
	var mr := 80.0
	var msc: float = mr / main.ARENA_R
	draw_circle(mc + Vector2(3, 4), mr + 5.0, Color(0, 0, 0, 0.32))
	draw_circle(mc, mr + 5.0, Color(0.05, 0.09, 0.15, 0.92))
	draw_circle(mc, mr + 2.0, Color(0.24, 0.6, 0.8, 0.5))
	draw_circle(mc, mr, Color(0.13, 0.32, 0.24))
	for p in main.patches:
		var pp: Vector2 = p["pos"]
		var pr: float = p["rad"]
		var pc: Color = p["col"]
		draw_circle(mc + pp * msc, pr * msc, Color(pc.r * 0.55, pc.g * 0.7, pc.b * 0.55, 0.4))
	draw_arc(mc, mr * 0.5, 0.0, TAU, 32, Color(1, 1, 1, 0.08), 1.0, true)
	draw_line(mc + Vector2(-mr, 0), mc + Vector2(mr, 0), Color(1, 1, 1, 0.07), 1.0, true)
	draw_line(mc + Vector2(0, -mr), mc + Vector2(0, mr), Color(1, 1, 1, 0.07), 1.0, true)
	var step_f: int = maxi(1, int(round(float(main.food_pos.size()) / 200.0)))
	for i in range(0, main.food_pos.size(), step_f):
		draw_circle(mc + main.food_pos[i] * msc, 1.0, Color(0.95, 0.85, 0.4, 0.45))
	for o in main.creatures:
		if o == pl:
			continue
		var q: Vector2 = mc + o.position * msc
		var oc2: Color = Species.COL2[o.evo]
		var rad := clampf(1.6 + float(o.evo) * 0.5, 1.6, 6.0)
		var danger: bool = o.evo >= pl.evo + 3
		if danger:
			oc2 = Color(1.0, 0.32, 0.32)
		elif o.evo <= pl.evo - 3:
			oc2 = Color(0.55, 1.0, 0.6)
		draw_circle(q, rad + 1.0, Color(0.02, 0.04, 0.08, 0.85))
		draw_circle(q, rad, oc2)
		if danger:
			draw_arc(q, rad + 2.5, 0.0, TAU, 12, Color(1.0, 0.4, 0.4, 0.7), 1.2, true)
		if o == main.leader:
			_mini_crown(q + Vector2(0.0, -rad - 3.0), 3.4)
	if pl.alive:
		var pq: Vector2 = mc + pl.position * msc
		var hd := Vector2.from_angle(pl.heading)
		var pp2 := Vector2(-hd.y, hd.x)
		var pulse := 0.5 + 0.5 * sin(t * 3.0)
		draw_circle(pq, 4.5 + pulse * 2.5, Color(1.0, 0.95, 0.5, 0.18 + 0.18 * pulse))
		draw_circle(pq, 5.0, Color(0.04, 0.04, 0.07, 0.85))
		var tri := PackedVector2Array([pq + hd * 8.0, pq - hd * 4.5 + pp2 * 5.0, pq - hd * 4.5 - pp2 * 5.0])
		draw_colored_polygon(tri, Color(1.0, 0.95, 0.5))
		draw_polyline(PackedVector2Array([tri[2], tri[1], tri[0], tri[2]]), Color(0.25, 0.18, 0.05, 0.9), 1.0, true)
		if main.leader == pl:
			_mini_crown(pq + Vector2(0.0, -11.0), 4.0)
	draw_arc(mc, mr + 5.0, 0.0, TAU, 56, Color(0.3, 0.9, 1.0, 0.7), 2.0, true)
	draw_arc(mc, mr, 0.0, TAU, 56, Color(0.95, 0.88, 0.6, 0.5), 1.5, true)

	if main.banner_ttl > 0.0:
		var ba := clampf(main.banner_ttl, 0.0, 1.0)
		var pop := 1.0 + 0.25 * clampf(main.banner_ttl - 2.7, 0.0, 0.5) * 2.0
		var bc: Color = main.banner_col
		_center(main.banner_text, 150.0 - (1.0 - ba) * 20.0, int(44.0 * pop), Color(bc.r * 1.5, bc.g * 1.5, bc.b * 1.5, ba))
		_center(Species.BLURB[evo], 182.0, 16, Color(0.85, 0.95, 1.0, ba * 0.9))

	if main.time < 9.0 and not main.player_dead and main.shot_path == "":
		var ha := clampf((9.0 - main.time) / 2.0, 0.0, 1.0)
		_center("EVO WILDS", S.y * 0.5 - 120.0, 54, Color(0.5 * 1.5, 1.3, 1.5, ha))
		if main.mode == "test":
			_center("Test Range: bots run into you and never swing. Pick a tier and a bot count on the left.", S.y * 0.5 - 80.0, 18, Color(0.9, 0.97, 1.0, ha))
			_center("You cannot die here - try the same swing as many times as you like.", S.y * 0.5 - 52.0, 16, Color(0.7, 0.9, 1.0, ha * 0.9))
		else:
			_center("Move with WASD or the mouse   -   Swing with SPACE or click   -   Sprint with SHIFT (costs XP)", S.y * 0.5 - 80.0, 18, Color(0.9, 0.97, 1.0, ha))
			if main.mode == "tdm":
				_center("Team Deathmatch: hit a grey golem to recruit it, then smash the enemy statue!", S.y * 0.5 - 52.0, 16, Color(0.7, 0.9, 1.0, ha * 0.9))
			else:
				_center("Eat food and defeat rivals to level up. Evolve through %d tiers!" % Species.COUNT, S.y * 0.5 - 52.0, 16, Color(0.7, 0.9, 1.0, ha * 0.9))

	if main.player_dead:
		draw_rect(Rect2(Vector2.ZERO, S), Color(0.02, 0, 0.04, 0.6))
		_center("DEVOURED", S.y * 0.5 - 86.0, 64, Color(1.9, 0.35, 0.4))
		_center("by " + str(main.killer_name), S.y * 0.5 - 44.0, 22, Color(1, 0.8, 0.8))
		var reached: String = Species.NAMES[main.best_evo]
		_center("Best form: %s     Score: %d     Defeated: %d" % [reached, main.final_score, main.kills], S.y * 0.5 - 6.0, 18, Color(0.9, 0.97, 1.0))
		if main.mode == "tdm" and main.player_team >= 0:
			_center("Respawning on the " + main.team_name_of(main.player_team) + " team", S.y * 0.5 + 26.0, 16, Color(0.85, 0.92, 1.0, 0.9))
		else:
			_center("The match keeps going...", S.y * 0.5 + 26.0, 16, Color(0.85, 0.92, 1.0, 0.9))
		if main.time - main.death_time > 0.8:
			var blink := 0.6 + 0.4 * sin(t * 4.0)
			_center("Respawning...   (click or press any key to respawn now)", S.y * 0.5 + 70.0, 18, Color(1.1, 1.3, 1.5, blink))

	if main.match_over:
		draw_rect(Rect2(Vector2.ZERO, S), Color(0.02, 0.0, 0.04, 0.55))
		var mcol := Color(1.95, 1.55, 0.5)
		if main.match_msg.begins_with("BLUE"):
			mcol = Color(0.55, 0.95, 1.6)
		elif main.match_msg.begins_with("RED"):
			mcol = Color(1.6, 0.6, 0.6)
		_center(main.match_msg, S.y * 0.5 - 24.0, 56, mcol)
		_center("Returning to the menu...", S.y * 0.5 + 44.0, 18, Color(0.85, 0.92, 1.0, 0.9))
