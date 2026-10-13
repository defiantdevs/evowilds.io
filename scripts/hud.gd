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


func _draw() -> void:
	if main == null or main.player == null:
		return
	var S := size
	var pl = main.player
	var evo: int = pl.evo
	var c1: Color = Species.COL1[evo]
	var c2: Color = Species.COL2[evo]

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
		_text(str(int(o.xp)), Vector2(S.x - 110, ly), 14, Color(0.85, 0.95, 1.0), 80.0, HORIZONTAL_ALIGNMENT_RIGHT)
		ly += 24.0
	if not in_top and pl.alive:
		var rank: int = main.board.find(pl) + 1
		_text(str(rank) + ".", Vector2(S.x - 232, ly + 6), 14, Color(1, 0.95, 0.5))
		_text("You", Vector2(S.x - 208, ly + 6), 14, Color(1, 0.95, 0.5))
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

	var mc := Vector2(S.x - 96, S.y - 96)
	var mr := 76.0
	draw_circle(mc, mr, Color(0.02, 0.06, 0.12, 0.72))
	draw_arc(mc, mr, 0.0, TAU, 48, Color(0.3, 0.9, 1.2, 0.7), 2.0, true)
	for o in main.creatures:
		var q: Vector2 = mc + (o.position / main.ARENA_R) * mr
		var oc2: Color = Species.COL2[o.evo]
		draw_circle(q, 1.8 + float(o.evo) * 0.7, Species.glow(oc2, 1.3) if o != pl else Color(2, 2, 2))
	if pl.alive:
		var pq: Vector2 = mc + (pl.position / main.ARENA_R) * mr
		var hd := Vector2.from_angle(pl.heading)
		var pp := Vector2(-hd.y, hd.x)
		draw_colored_polygon(PackedVector2Array([pq + hd * 7.0, pq - hd * 4.0 + pp * 4.0, pq - hd * 4.0 - pp * 4.0]), Color(2, 2, 2))

	if main.banner_ttl > 0.0:
		var ba := clampf(main.banner_ttl, 0.0, 1.0)
		var pop := 1.0 + 0.25 * clampf(main.banner_ttl - 2.7, 0.0, 0.5) * 2.0
		var bc: Color = main.banner_col
		_center(main.banner_text, 150.0 - (1.0 - ba) * 20.0, int(44.0 * pop), Color(bc.r * 1.5, bc.g * 1.5, bc.b * 1.5, ba))
		_center(Species.BLURB[evo], 182.0, 16, Color(0.85, 0.95, 1.0, ba * 0.9))

	if main.time < 9.0 and not main.player_dead and main.shot_path == "":
		var ha := clampf((9.0 - main.time) / 2.0, 0.0, 1.0)
		_center("EVO WILDS", S.y * 0.5 - 120.0, 54, Color(0.5 * 1.5, 1.3, 1.5, ha))
		_center("Move with WASD or the mouse   -   Swing with SPACE or click   -   Sprint with SHIFT (costs XP)", S.y * 0.5 - 80.0, 18, Color(0.9, 0.97, 1.0, ha))
		_center("Eat food and defeat rivals to level up. Evolve through 24 tiers!", S.y * 0.5 - 52.0, 16, Color(0.7, 0.9, 1.0, ha * 0.9))

	if main.player_dead:
		draw_rect(Rect2(Vector2.ZERO, S), Color(0.02, 0, 0.04, 0.6))
		_center("DEVOURED", S.y * 0.5 - 70.0, 64, Color(1.9, 0.35, 0.4))
		_center("by " + str(main.killer_name), S.y * 0.5 - 28.0, 22, Color(1, 0.8, 0.8))
		var reached: String = Species.NAMES[main.best_evo]
		_center("Best form: %s     Score: %d     Defeated: %d" % [reached, main.final_score, main.kills], S.y * 0.5 + 16.0, 18, Color(0.9, 0.97, 1.0))
		if main.time - main.death_time > 1.0:
			var blink := 0.6 + 0.4 * sin(t * 4.0)
			_center("Press ENTER or click to evolve again", S.y * 0.5 + 64.0, 20, Color(0.7 * 1.5, 1.4, 1.6, blink))
