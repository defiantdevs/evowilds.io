extends RefCounted

const COUNT := 28
const NAMES := ["Caveman", "Forager", "Hunter", "Tribesman", "Peasant", "Raider", "Viking", "Soldier", "Knight", "Samurai", "Ninja", "Gladiator", "Crusader", "Paladin", "Sorcerer", "Necromancer", "Dragon Knight", "Warlord", "Emperor", "Immortal Sage", "Storm Titan", "Death Reaper", "Celestial King", "Cosmos Emperor", "Astral Sovereign", "Void Titan", "Eternal Seraph", "Omniverse God"]
const BLURB := [
	"Club in hand. Everyone starts somewhere.",
	"Sharpened stick, sharper instincts.",
	"Spear thrower of the plains.",
	"War paint and a stone axe.",
	"Pitchfork and a grudge.",
	"Iron axe, wooden shield.",
	"Horned helm. Loud and proud.",
	"Disciplined steel and a sturdy shield.",
	"Plume, plate and honour.",
	"One clean cut. Katana ready.",
	"Silent and swift.",
	"The arena roars your name.",
	"Cross on the shield, mace in hand.",
	"Holy hammer. Winged helm.",
	"Arcane staff and a wicked beard.",
	"Death comes with a scythe.",
	"Flames cling to the blade.",
	"Spiked crown, spiked temper.",
	"All kneel before the Emperor.",
	"A thousand battles, distilled into one calm step.",
	"The storm kneels before its master.",
	"Your scythe reaps the strong and the weak alike.",
	"Starlight forged this crown. Heaven wears it poorly.",
	"The wilds end here. All orbits lead to you.",
	"The stars bend knee to your banner.",
	"A walking absence. Even light hesitates.",
	"Six wings, one purpose: never fall.",
	"Every world, every age, every ending. Yours.",
]
const XP_AT := [0.0, 28.0, 98.0, 202.0, 340.0, 507.0, 704.0, 930.0, 1182.0, 1461.0, 1767.0, 2097.0, 2453.0, 2833.0, 3237.0, 3665.0, 4117.0, 4592.0, 5089.0, 5609.0, 6154.0, 6724.0, 7324.0, 7954.0, 8610.0, 9290.0, 9990.0, 10720.0]
const COL1 := [Color("8a5a3a"), Color("7a8f3a"), Color("4f8f3a"), Color("b5532f"), Color("9a8a6a"), Color("6b5a4a"), Color("7a4a2a"), Color("3f6fa8"), Color("8d9bb0"), Color("a83232"), Color("2c2c3c"), Color("c9a06a"), Color("e8e8ee"), Color("d4b13a"), Color("6d3fb5"), Color("2f1f3f"), Color("8f1d2c"), Color("4a2a2a"), Color("e0b020"), Color("6a4fae"), Color("2f6f9e"), Color("221c2c"), Color("e8e2c8"), Color("2a1a4a"), Color("2e1f5e"), Color("120e1c"), Color("efe6cc"), Color("f2c84a")]
const COL2 := [Color("f1e2c6"), Color("e8d27a"), Color("e4a43a"), Color("2e8bd6"), Color("7a3b2a"), Color("b0b0b8"), Color("c8b88a"), Color("e0e0e8"), Color("d94b4b"), Color("e8c15a"), Color("b04bff"), Color("c03030"), Color("d03030"), Color("5fa8ff"), Color("5de0ff"), Color("7cff8a"), Color("ff9a2a"), Color("ff6a2a"), Color("8a1010"), Color("59e0d0"), Color("ffe25a"), Color("b23a4a"), Color("ffd25a"), Color("b06aff"), Color("b58cff"), Color("8a4bff"), Color("ffe9a8"), Color("ffffff")]
const SKIN := [Color("e0a878"), Color("f0c9a0"), Color("e8b98a"), Color("c98f62"), Color("f0c9a0"), Color("e0a878"), Color("f3d3b3"), Color("e9b890"), Color("f3d3b3"), Color("efc9a2"), Color("d9b38c"), Color("c98f62"), Color("f3d3b3"), Color("f5d9bc"), Color("f3d3b3"), Color("cfd8c8"), Color("d9a679"), Color("b98660"), Color("f0c9a0"), Color("e8c9a8"), Color("c9a27a"), Color("cfc8bc"), Color("f3d9bc"), Color("e0c9a8"), Color("e6d9f2"), Color("b8aec8"), Color("f7e9d2"), Color("f7e9d2")]
const HEAD := [0, 1, 2, 3, 4, 5, 6, 7, 7, 8, 9, 7, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 20, 17, 13, 21]
const WEAPON := [0, 1, 2, 3, 4, 5, 5, 6, 6, 7, 7, 8, 9, 10, 11, 12, 14, 13, 15, 11, 16, 17, 18, 19, 19, 18, 17, 19]
const SHIELD := [0, 0, 0, 0, 0, 1, 1, 2, 3, 0, 0, 1, 4, 3, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 2, 3, 0]
const CAPE := [0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]
const PAULD := [0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 1, 1, 1, 0, 0, 2, 2, 2, 0, 2, 0, 2, 2, 2, 2, 0, 2]
# How far each drawn weapon kind reaches, in units of body radius, measured
# from the body centre to the very tip of the blade. The kill test is built
# from these so the kill area always matches the drawn blade exactly.
const WEAPON_TIP := [2.27, 2.35, 2.95, 1.95, 2.45, 2.1, 2.45, 2.65, 2.95, 2.24, 2.4, 2.85, 2.5, 3.3, 3.3, 3.55, 3.3, 3.45, 3.4, 3.7]
const OL := Color(0.12, 0.07, 0.07)
const STEEL := Color(0.8, 0.84, 0.92)


static func radius_base(i: int) -> float:
	return 22.0 + 2.6 * float(i)


static func speed_base(i: int) -> float:
	return 270.0 - 3.5 * float(i)


static func blade_tip(e: int) -> float:
	return WEAPON_TIP[WEAPON[e]]


static func max_hp_for(i: int) -> float:
	return 40.0 + 14.0 * float(i)


static func dmg_for(i: int) -> float:
	return 7.0 + 2.4 * float(i)


static func evo_for_xp(xp: float) -> int:
	var e := 0
	for i in range(COUNT):
		var need: float = XP_AT[i]
		if xp >= need:
			e = i
	return e


static func progress(xp: float) -> float:
	var e := evo_for_xp(xp)
	var base: float = XP_AT[e]
	if e >= COUNT - 1:
		return minf((xp - base) / 1500.0, 1.0)
	var nxt: float = XP_AT[e + 1]
	return clampf((xp - base) / (nxt - base), 0.0, 1.0)


static func radius_for(evo: int, xp: float) -> float:
	return radius_base(evo) * (1.0 + 0.16 * progress(xp))


static func glow(c: Color, k: float) -> Color:
	return c.lightened(clampf((k - 1.0) * 0.25, 0.0, 0.5))


static func _ellipse(cx: float, cy: float, rx: float, ry: float, rot: float = 0.0, n: int = 24) -> PackedVector2Array:
	var pts := PackedVector2Array()
	var cr := cos(rot)
	var sr := sin(rot)
	for i in range(n):
		var a := TAU * float(i) / float(n)
		var x := cos(a) * rx
		var y := sin(a) * ry
		pts.append(Vector2(cx + x * cr - y * sr, cy + x * sr + y * cr))
	return pts


static func _fill(ci: CanvasItem, pts: PackedVector2Array, fill: Color, line: Color, w: float = 2.0) -> void:
	ci.draw_colored_polygon(pts, fill)
	var closed: PackedVector2Array = pts.duplicate()
	closed.append(pts[0])
	ci.draw_polyline(closed, line, w, true)


static func _wp(pv: Vector2, ang: float, r: float, x: float, y: float) -> Vector2:
	return pv + (Vector2(x * r, y * r) - pv).rotated(ang)


static func _wpoly(pv: Vector2, ang: float, r: float, units: PackedVector2Array) -> PackedVector2Array:
	var out := PackedVector2Array()
	for uv in units:
		out.append(pv + (uv * r - pv).rotated(ang))
	return out


static func _bar(ci: CanvasItem, r: float, pv: Vector2, ang: float, x0: float, x1: float, y: float, w: float, col: Color, lw: float) -> void:
	var a := _wp(pv, ang, r, x0, y)
	var b := _wp(pv, ang, r, x1, y)
	ci.draw_line(a, b, OL, w * r + lw * 1.6, true)
	ci.draw_line(a, b, col, w * r, true)


static func _feet(ci: CanvasItem, r: float, t: float, col: Color, lw: float) -> void:
	var st := sin(t * 10.0) * r * 0.22
	_fill(ci, _ellipse(0.25 * r + st, -0.38 * r, 0.3 * r, 0.18 * r, 0.0, 10), col, OL, lw * 0.7)
	_fill(ci, _ellipse(0.25 * r - st, 0.38 * r, 0.3 * r, 0.18 * r, 0.0, 10), col, OL, lw * 0.7)


static func _arm(ci: CanvasItem, r: float, from: Vector2, to: Vector2, sleeve: Color, skin: Color, lw: float) -> void:
	ci.draw_line(from, to, OL, r * 0.26 + lw * 1.6, true)
	ci.draw_line(from, to, sleeve, r * 0.26, true)
	ci.draw_circle(to, r * 0.17 + lw * 0.6, OL)
	ci.draw_circle(to, r * 0.17, skin)


static func _head(ci: CanvasItem, r: float, skin: Color, hair: Color, lw: float) -> void:
	var hx := 0.12 * r
	for s in range(2):
		var side := -1.0 + float(s) * 2.0
		ci.draw_circle(Vector2(hx, side * 0.5 * r), r * 0.12, OL)
		ci.draw_circle(Vector2(hx, side * 0.5 * r), r * 0.09, skin)
	_fill(ci, _ellipse(hx, 0, 0.5 * r, 0.46 * r, 0.0, 22), skin, OL, lw)
	_fill(ci, _ellipse(hx - 0.1 * r, 0, 0.44 * r, 0.43 * r, 0.0, 22), hair, OL, lw * 0.6)
	ci.draw_circle(Vector2(hx + 0.52 * r, 0), r * 0.09, skin.darkened(0.15))


static func _helmet(ci: CanvasItem, r: float, col: Color, lw: float) -> void:
	var hx := 0.12 * r
	_fill(ci, _ellipse(hx, 0, 0.54 * r, 0.52 * r, 0.0, 24), col, OL, lw)
	ci.draw_line(Vector2(hx + 0.36 * r, -0.3 * r), Vector2(hx + 0.36 * r, 0.3 * r), Color(0.05, 0.05, 0.08), r * 0.1, true)
	ci.draw_line(Vector2(hx + 0.5 * r, 0), Vector2(hx - 0.1 * r, 0), col.darkened(0.3), r * 0.07, true)


static func draw_body(ci: CanvasItem, evo: int, r: float, t: float, c1: Color, c2: Color, swing: float = 0.12) -> void:
	var skin: Color = SKIN[evo]
	var lw := maxf(r * 0.09, 2.0)
	var pv := Vector2(0, 0.8 * r)
	var big: float = 1.0 + float(evo) * 0.03
	ci.draw_colored_polygon(_ellipse(0.1 * r, 0.2 * r, 1.0 * r * big, 1.1 * r * big, 0.0, 24), Color(0, 0, 0, 0.17))
	if evo >= 16:
		var pu := 0.5 + 0.5 * sin(t * 3.0)
		var ac: Color = c2
		ci.draw_circle(Vector2.ZERO, r * (1.5 + 0.1 * pu), Color(ac.r, ac.g, ac.b, 0.12))
		ci.draw_arc(Vector2.ZERO, r * (1.5 + 0.1 * pu), 0.0, TAU, 40, Color(ac.r, ac.g, ac.b, 0.5), 2.5, true)
		if evo >= 21:
			ci.draw_arc(Vector2.ZERO, r * (1.15 + 0.08 * pu), 0.0, TAU, 36, Color(ac.r, ac.g, ac.b, 0.35), 1.5, true)
		if evo >= COUNT - 4:
			for k in range(4):
				var oa := t * 1.4 + TAU * float(k) / 4.0
				var op := Vector2.from_angle(oa) * r * 1.9
				ci.draw_circle(op, r * 0.11, Color(ac.r, ac.g, ac.b, 0.8))
				ci.draw_circle(op, r * 0.05, Color(1, 1, 1, 0.9))
	var cape: int = CAPE[evo]
	if cape == 1:
		var w := sin(t * 4.0) * r * 0.2
		var cc := c2.darkened(0.35)
		var pts := PackedVector2Array([Vector2(-0.1 * r, -0.8 * r), Vector2(-1.6 * r, -1.0 * r + w), Vector2(-2.0 * r, w * 0.6), Vector2(-1.6 * r, 1.0 * r + w), Vector2(-0.1 * r, 0.8 * r)])
		_fill(ci, pts, cc, OL, lw)
		ci.draw_polyline(pts, c2, lw, true)
	_feet(ci, r, t, Color(0.32, 0.22, 0.16), lw)
	var armored := evo >= 5
	var sh: int = SHIELD[evo]
	var two_hand: bool = WEAPON[evo] >= 13
	var lh := Vector2(0.7 * r, -0.55 * r)
	if two_hand:
		lh = _wp(pv, swing, r, 1.0, 0.2)
	_arm(ci, r, Vector2(0, -0.8 * r), lh, c1, skin if not armored else Color(0.55, 0.58, 0.65), lw)
	if sh > 0:
		_shield(ci, r, sh, c1, c2, lw)
	_fill(ci, _ellipse(0, 0, 0.52 * r, 0.92 * r, 0.0, 22), c1, OL, lw)
	if armored:
		ci.draw_colored_polygon(_ellipse(0.05 * r, 0, 0.3 * r, 0.6 * r, 0.0, 16), c1.lightened(0.18))
	ci.draw_line(Vector2(0.18 * r, -0.8 * r), Vector2(0.18 * r, 0.8 * r), c2, r * 0.1, true)
	var pd: int = PAULD[evo]
	if pd > 0:
		for s in range(2):
			var side := -1.0 + float(s) * 2.0
			var c := Vector2(0.0, side * 0.85 * r)
			if pd == 2:
				for k in range(3):
					var a := (float(k) - 1.0) * 0.7 + PI * 0.5 * side
					var d := Vector2.from_angle(a)
					var pp := Vector2(-d.y, d.x)
					var b := c + d * 0.36 * r
					_fill(ci, PackedVector2Array([b + pp * 0.1 * r, c + d * 0.9 * r, b - pp * 0.1 * r]), c2, OL, lw * 0.8)
			_fill(ci, _ellipse(c.x, c.y, 0.4 * r, 0.36 * r, 0.0, 16), c1.lightened(0.1), OL, lw)
	_headgear(ci, r, HEAD[evo], t, skin, c1, c2, lw)
	var hand := _wp(pv, swing, r, 0.8, 0.5)
	_arm(ci, r, pv, hand, c1, skin if not armored else Color(0.55, 0.58, 0.65), lw)
	_weapon(ci, r, WEAPON[evo], pv, swing, t, c1, c2, lw)
	ci.draw_circle(hand, r * 0.17 + lw * 0.6, OL)
	ci.draw_circle(hand, r * 0.17, skin if not armored else Color(0.55, 0.58, 0.65))


static func _shield(ci: CanvasItem, r: float, kind: int, c1: Color, c2: Color, lw: float) -> void:
	var sc := Vector2(0.95 * r, -1.0 * r)
	match kind:
		1:
			ci.draw_circle(sc, 0.58 * r + lw, OL)
			ci.draw_circle(sc, 0.58 * r, Color(0.55, 0.38, 0.2))
			ci.draw_arc(sc, 0.45 * r, 0.0, TAU, 20, Color(0.4, 0.26, 0.12), lw, true)
			ci.draw_circle(sc, 0.16 * r, STEEL)
		2:
			var pts := PackedVector2Array([sc + Vector2(-0.4 * r, -0.5 * r), sc + Vector2(0.55 * r, -0.5 * r), sc + Vector2(0.55 * r, 0.5 * r), sc + Vector2(-0.4 * r, 0.5 * r)])
			_fill(ci, pts, Color(0.7, 0.74, 0.82), OL, lw)
			ci.draw_rect(Rect2(sc + Vector2(-0.3 * r, -0.4 * r), Vector2(0.75 * r, 0.8 * r)), c2, true)
		3:
			var kite := PackedVector2Array([sc + Vector2(-0.35 * r, -0.45 * r), sc + Vector2(0.55 * r, -0.45 * r), sc + Vector2(0.85 * r, 0.0), sc + Vector2(0.55 * r, 0.45 * r), sc + Vector2(-0.35 * r, 0.45 * r)])
			_fill(ci, kite, c2, OL, lw)
			ci.draw_line(sc + Vector2(-0.3 * r, 0), sc + Vector2(0.75 * r, 0), Color(1, 1, 1, 0.9), r * 0.12, true)
			ci.draw_line(sc + Vector2(0.2 * r, -0.4 * r), sc + Vector2(0.2 * r, 0.4 * r), Color(1, 1, 1, 0.9), r * 0.12, true)
		_:
			var cs := PackedVector2Array([sc + Vector2(-0.4 * r, -0.5 * r), sc + Vector2(0.6 * r, -0.5 * r), sc + Vector2(0.8 * r, 0.0), sc + Vector2(0.6 * r, 0.5 * r), sc + Vector2(-0.4 * r, 0.5 * r)])
			_fill(ci, cs, Color(0.95, 0.95, 0.98), OL, lw)
			ci.draw_line(sc + Vector2(-0.3 * r, 0), sc + Vector2(0.7 * r, 0), c2, r * 0.16, true)
			ci.draw_line(sc + Vector2(0.15 * r, -0.4 * r), sc + Vector2(0.15 * r, 0.4 * r), c2, r * 0.16, true)


static func _headgear(ci: CanvasItem, r: float, kind: int, t: float, skin: Color, c1: Color, c2: Color, lw: float) -> void:
	var hx := 0.12 * r
	var hair := Color(0.25, 0.16, 0.1)
	var wv := sin(t * 5.0) * r * 0.1
	match kind:
		0:
			_head(ci, r, skin, Color(0.22, 0.13, 0.08), lw)
			for k in range(5):
				var a := PI + (float(k) - 2.0) * 0.5
				ci.draw_circle(Vector2(hx - 0.08 * r + cos(a) * 0.45 * r, sin(a) * 0.45 * r), r * 0.1, Color(0.22, 0.13, 0.08))
		1:
			_head(ci, r, skin, Color(0.45, 0.3, 0.15), lw)
			ci.draw_line(Vector2(hx + 0.28 * r, -0.44 * r), Vector2(hx + 0.28 * r, 0.44 * r), c2, r * 0.12, true)
			_fill(ci, PackedVector2Array([Vector2(hx - 0.2 * r, 0.3 * r), Vector2(hx - 0.9 * r, 0.6 * r), Vector2(hx - 0.3 * r, 0.5 * r)]), c2, OL, lw * 0.6)
		2:
			_head(ci, r, skin, hair, lw)
			_fill(ci, _ellipse(hx - 0.06 * r, 0, 0.58 * r, 0.56 * r, 0.0, 22), c1.darkened(0.15), OL, lw)
			ci.draw_colored_polygon(_ellipse(hx + 0.38 * r, 0, 0.2 * r, 0.26 * r, 0.0, 12), skin)
			ci.draw_circle(Vector2(hx + 0.5 * r, 0), r * 0.07, skin.darkened(0.15))
		3:
			_head(ci, r, skin, Color(0.1, 0.08, 0.08), lw)
			var fc := [Color(0.9, 0.2, 0.2), Color(0.95, 0.8, 0.2), Color(0.2, 0.6, 0.9), c2]
			for k in range(7):
				var a2 := PI + (float(k) - 3.0) * 0.42
				var d := Vector2.from_angle(a2)
				var pp := Vector2(-d.y, d.x)
				var b := Vector2(hx, 0) + d * 0.35 * r
				var fcol: Color = fc[k % 4]
				_fill(ci, PackedVector2Array([b + pp * 0.1 * r, b + d * 0.9 * r, b - pp * 0.1 * r]), fcol, OL, lw * 0.6)
		4:
			_head(ci, r, skin, hair, lw)
			_fill(ci, _ellipse(hx - 0.05 * r, 0, 0.52 * r, 0.48 * r, 0.0, 22), c1.darkened(0.2), OL, lw)
			_fill(ci, _ellipse(hx + 0.38 * r, 0, 0.18 * r, 0.36 * r, 0.0, 12), c1.darkened(0.35), OL, lw * 0.7)
		5:
			_head(ci, r, skin, hair, lw)
			_helmet(ci, r, Color(0.62, 0.64, 0.7), lw)
		6:
			_head(ci, r, skin, hair, lw)
			for s in range(2):
				var side := -1.0 + float(s) * 2.0
				_fill(ci, PackedVector2Array([Vector2(hx, side * 0.42 * r), Vector2(hx - 0.3 * r, side * 1.15 * r), Vector2(hx + 0.2 * r, side * 0.55 * r)]), Color(0.95, 0.92, 0.8), OL, lw)
			_helmet(ci, r, Color(0.6, 0.62, 0.68), lw)
		7:
			_head(ci, r, skin, hair, lw)
			_helmet(ci, r, Color(0.72, 0.76, 0.84), lw)
			ci.draw_line(Vector2(hx - 0.5 * r, 0), Vector2(hx + 0.3 * r, 0), c2, r * 0.18, true)
			_fill(ci, PackedVector2Array([Vector2(hx - 0.5 * r, -0.08 * r), Vector2(hx - 1.0 * r, -0.15 * r + wv), Vector2(hx - 0.95 * r, 0.15 * r + wv), Vector2(hx - 0.5 * r, 0.08 * r)]), c2, OL, lw * 0.6)
		8:
			_head(ci, r, skin, hair, lw)
			_fill(ci, PackedVector2Array([Vector2(hx - 0.2 * r, -0.5 * r), Vector2(hx - 0.9 * r, -0.85 * r), Vector2(hx - 1.0 * r, 0), Vector2(hx - 0.9 * r, 0.85 * r), Vector2(hx - 0.2 * r, 0.5 * r)]), c1.darkened(0.2), OL, lw)
			_helmet(ci, r, Color(0.3, 0.3, 0.36), lw)
			ci.draw_arc(Vector2(hx + 0.45 * r, 0), 0.38 * r, -1.2, 1.2, 12, c2, r * 0.1, true)
		9:
			_fill(ci, _ellipse(hx, 0, 0.54 * r, 0.52 * r, 0.0, 22), Color(0.12, 0.12, 0.18), OL, lw)
			ci.draw_rect(Rect2(Vector2(hx + 0.32 * r, -0.2 * r), Vector2(0.14 * r, 0.4 * r)), skin, true)
			ci.draw_circle(Vector2(hx + 0.4 * r, -0.08 * r), r * 0.03, Color(0, 0, 0))
			ci.draw_circle(Vector2(hx + 0.4 * r, 0.08 * r), r * 0.03, Color(0, 0, 0))
			for s in range(2):
				var side := -1.0 + float(s) * 2.0
				_fill(ci, PackedVector2Array([Vector2(hx - 0.3 * r, side * 0.1 * r), Vector2(hx - 1.1 * r, side * 0.3 * r + wv), Vector2(hx - 0.5 * r, side * 0.25 * r)]), c2, OL, lw * 0.6)
		10:
			_head(ci, r, skin, hair, lw)
			_fill(ci, _ellipse(hx, 0, 0.56 * r, 0.54 * r, 0.0, 24), Color(0.78, 0.8, 0.86), OL, lw)
			ci.draw_line(Vector2(hx + 0.4 * r, -0.28 * r), Vector2(hx + 0.4 * r, 0.28 * r), Color(0.05, 0.05, 0.08), r * 0.08, true)
			ci.draw_line(Vector2(hx - 0.5 * r, 0), Vector2(hx + 0.45 * r, 0), c2, r * 0.14, true)
			ci.draw_line(Vector2(hx, -0.5 * r), Vector2(hx, 0.5 * r), c2, r * 0.14, true)
		11:
			_head(ci, r, skin, hair, lw)
			for s in range(2):
				var side := -1.0 + float(s) * 2.0
				_fill(ci, PackedVector2Array([Vector2(hx, side * 0.4 * r), Vector2(hx - 0.5 * r, side * 1.3 * r), Vector2(hx + 0.2 * r, side * 0.6 * r)]), Color(0.98, 0.98, 1.0), OL, lw * 0.8)
			_helmet(ci, r, Color(0.95, 0.85, 0.45), lw)
			ci.draw_arc(Vector2(hx, 0), 0.72 * r, 0.0, TAU, 28, Color(1.0, 0.88, 0.35, 0.9), r * 0.08, true)
		12:
			_head(ci, r, skin, hair, lw)
			_fill(ci, PackedVector2Array([Vector2(hx + 0.7 * r, -0.2 * r), Vector2(hx + 1.4 * r, 0.0), Vector2(hx + 0.7 * r, 0.2 * r)]), Color(0.95, 0.95, 0.98), OL, lw * 0.7)
			_fill(ci, _ellipse(hx, 0, 0.9 * r, 0.9 * r, 0.0, 28), c1.darkened(0.25), OL, lw)
			_fill(ci, _ellipse(hx, 0, 0.5 * r, 0.5 * r, 0.0, 22), c1.lightened(0.05), OL, lw)
			ci.draw_arc(Vector2(hx, 0), 0.6 * r, 0.0, TAU, 30, c2, r * 0.1, true)
		13:
			_head(ci, r, skin, hair, lw)
			_fill(ci, _ellipse(hx - 0.06 * r, 0, 0.6 * r, 0.58 * r, 0.0, 22), c1.darkened(0.1), OL, lw)
			ci.draw_circle(Vector2(hx + 0.28 * r, 0), r * 0.26, Color(0.95, 0.96, 0.92))
			ci.draw_circle(Vector2(hx + 0.38 * r, -0.1 * r), r * 0.06, c2)
			ci.draw_circle(Vector2(hx + 0.38 * r, 0.1 * r), r * 0.06, c2)
		14:
			_head(ci, r, skin, hair, lw)
			for s in range(2):
				var side := -1.0 + float(s) * 2.0
				_fill(ci, PackedVector2Array([Vector2(hx, side * 0.35 * r), Vector2(hx - 0.7 * r, side * 1.2 * r), Vector2(hx + 0.1 * r, side * 0.55 * r)]), Color(0.95, 0.9, 0.75), OL, lw)
			_helmet(ci, r, c1.lightened(0.1), lw)
			for k in range(4):
				_fill(ci, PackedVector2Array([Vector2(hx - 0.35 * r + float(k) * 0.2 * r, -0.08 * r), Vector2(hx - 0.25 * r + float(k) * 0.2 * r, 0.0), Vector2(hx - 0.35 * r + float(k) * 0.2 * r, 0.08 * r)]), c2, OL, 1.0)
		15:
			_head(ci, r, skin, hair, lw)
			_helmet(ci, r, Color(0.3, 0.26, 0.28), lw)
			for k in range(7):
				var a3 := PI + (float(k) - 3.0) * 0.45
				var d3 := Vector2.from_angle(a3)
				var q := Vector2(hx, 0) + d3 * 0.5 * r
				var pq := Vector2(-d3.y, d3.x)
				ci.draw_colored_polygon(PackedVector2Array([q + pq * 0.08 * r, q + d3 * 0.4 * r, q - pq * 0.08 * r]), c2)
			ci.draw_circle(Vector2(hx + 0.4 * r, -0.12 * r), r * 0.05, Color(1.0, 0.25, 0.15))
			ci.draw_circle(Vector2(hx + 0.4 * r, 0.12 * r), r * 0.05, Color(1.0, 0.25, 0.15))
		17:
			_head(ci, r, skin, hair, lw)
			_fill(ci, PackedVector2Array([Vector2(hx + 0.34 * r, -0.26 * r), Vector2(hx - 0.5 * r, -0.16 * r), Vector2(hx - 0.78 * r, 0.0), Vector2(hx - 0.5 * r, 0.16 * r), Vector2(hx + 0.34 * r, 0.26 * r)]), Color(0.92, 0.9, 0.85), OL, lw * 0.6)
			_fill(ci, _ellipse(hx, 0, 0.74 * r, 0.72 * r, 0.0, 22), c1.darkened(0.18), OL, lw)
			_fill(ci, _ellipse(hx - 0.02 * r, 0, 0.4 * r, 0.4 * r, 0.0, 20), c1, OL, lw)
			ci.draw_circle(Vector2(hx + 0.06 * r, 0), r * 0.1, c2)
		18:
			_head(ci, r, skin, hair, lw)
			_helmet(ci, r, Color(0.44, 0.58, 0.78), lw)
			for s in range(2):
				var side := -1.0 + float(s) * 2.0
				_fill(ci, PackedVector2Array([Vector2(hx, side * 0.4 * r), Vector2(hx - 0.45 * r, side * 1.1 * r), Vector2(hx + 0.15 * r, side * 0.6 * r)]), Color(0.9, 0.95, 1.0), OL, lw * 0.7)
			for k in range(3):
				var aa := -1.1 + float(k) * 1.1
				var q := Vector2(hx + 0.62 * r, 0).rotated(aa)
				ci.draw_line(q, q + Vector2.from_angle(aa) * r * 0.2, c2, r * 0.06, true)
		19:
			_fill(ci, _ellipse(hx - 0.06 * r, 0, 0.66 * r, 0.64 * r, 0.0, 22), Color(0.14, 0.12, 0.18), OL, lw)
			_fill(ci, _ellipse(hx + 0.14 * r, 0, 0.4 * r, 0.42 * r, 0.0, 18), Color(0.06, 0.05, 0.08), OL, lw * 0.6)
			ci.draw_circle(Vector2(hx + 0.3 * r, -0.12 * r), r * 0.05, c2)
			ci.draw_circle(Vector2(hx + 0.3 * r, 0.12 * r), r * 0.05, c2)
		20:
			_head(ci, r, skin, hair, lw)
			ci.draw_arc(Vector2(hx - 0.05 * r, 0), 0.68 * r, 0.0, TAU, 26, Color(1.0, 0.88, 0.4, 0.85), r * 0.09, true)
			for k in range(6):
				var a5 := PI + (float(k) - 2.5) * 0.5
				var d5 := Vector2.from_angle(a5)
				var q5 := Vector2(hx, 0) + d5 * 0.5 * r
				var pq5 := Vector2(-d5.y, d5.x)
				_fill(ci, PackedVector2Array([q5 + pq5 * 0.1 * r, q5 + d5 * 0.55 * r, q5 - pq5 * 0.1 * r]), Color(1.0, 0.84, 0.3), OL, lw * 0.6)
			ci.draw_circle(Vector2(hx + 0.02 * r, 0), r * 0.09, Color(0.95, 0.95, 1.0))
			ci.draw_circle(Vector2(hx + 0.42 * r, 0), r * 0.07, Color(0.4, 0.75, 1.0))
		21:
			_head(ci, r, skin, hair, lw)
			_fill(ci, _ellipse(hx, 0, 0.58 * r, 0.56 * r, 0.0, 24), Color(0.1, 0.07, 0.18), OL, lw)
			for k in range(5):
				var a6 := t * 1.2 + float(k) * TAU / 5.0
				ci.draw_circle(Vector2(hx, 0) + Vector2.from_angle(a6) * 0.62 * r, r * 0.05, Color(0.75, 0.5, 1.0, 0.9))
			ci.draw_arc(Vector2(hx, 0), 0.62 * r, 0.0, TAU, 30, Color(0.65, 0.35, 1.0, 0.5), r * 0.05, true)
			_fill(ci, PackedVector2Array([Vector2(hx - 0.2 * r, -0.3 * r), Vector2(hx + 0.15 * r, -0.45 * r), Vector2(hx + 0.5 * r, -0.25 * r)]), Color(0.85, 0.7, 1.0), OL, lw * 0.5)
		_:
			_head(ci, r, skin, hair, lw)
			_fill(ci, _ellipse(hx, 0, 0.54 * r, 0.5 * r, 0.0, 22), c1.lightened(0.1), OL, lw)
			for k in range(6):
				var a4 := PI + (float(k) - 2.5) * 0.5
				var d4 := Vector2.from_angle(a4)
				var q2 := Vector2(hx, 0) + d4 * 0.48 * r
				var pq2 := Vector2(-d4.y, d4.x)
				_fill(ci, PackedVector2Array([q2 + pq2 * 0.1 * r, q2 + d4 * 0.55 * r, q2 - pq2 * 0.1 * r]), Color(1.0, 0.85, 0.25), OL, lw * 0.6)
			ci.draw_circle(Vector2(hx + 0.05 * r, 0), r * 0.09, Color(0.9, 0.1, 0.2))
			ci.draw_circle(Vector2(hx + 0.4 * r, 0), r * 0.07, Color(0.2, 0.7, 1.0))


static func _weapon(ci: CanvasItem, r: float, kind: int, pv: Vector2, ang: float, t: float, c1: Color, c2: Color, lw: float) -> void:
	var wood := Color(0.55, 0.38, 0.2)
	var gold := Color(1.0, 0.82, 0.25)
	match kind:
		0:
			_bar(ci, r, pv, ang, 0.5, 1.6, 0.5, 0.2, wood, lw)
			_fill(ci, _wpoly(pv, ang, r, _ellipse(1.85, 0.5, 0.42, 0.3, 0.0, 14)), Color(0.42, 0.28, 0.16), OL, lw)
			for k in range(3):
				ci.draw_circle(_wp(pv, ang, r, 1.8 + float(k) * 0.12 - 0.12, 0.42 + float(k % 2) * 0.16), r * 0.05, c2)
		1:
			_bar(ci, r, pv, ang, -0.2, 1.8, 0.5, 0.1, wood, lw)
			_fill(ci, _wpoly(pv, ang, r, PackedVector2Array([Vector2(1.8, 0.4), Vector2(2.35, 0.5), Vector2(1.8, 0.6)])), Color(0.6, 0.6, 0.55), OL, lw * 0.7)
		2:
			_bar(ci, r, pv, ang, -0.5, 2.2, 0.5, 0.1, wood, lw)
			_fill(ci, _wpoly(pv, ang, r, PackedVector2Array([Vector2(2.2, 0.35), Vector2(2.95, 0.5), Vector2(2.2, 0.65)])), STEEL, OL, lw * 0.7)
			_bar(ci, r, pv, ang, 1.95, 2.05, 0.5, 0.2, c2, lw * 0.4)
		3:
			_bar(ci, r, pv, ang, 0.3, 1.5, 0.5, 0.12, wood, lw)
			_fill(ci, _wpoly(pv, ang, r, PackedVector2Array([Vector2(1.3, 0.5), Vector2(1.55, 0.05), Vector2(1.95, 0.12), Vector2(1.95, 0.88), Vector2(1.55, 0.95)])), Color(0.55, 0.55, 0.58), OL, lw)
			_bar(ci, r, pv, ang, 1.28, 1.34, 0.5, 0.2, c2, lw * 0.4)
		4:
			_bar(ci, r, pv, ang, -0.3, 1.7, 0.5, 0.1, wood, lw)
			for y in [0.2, 0.5, 0.8]:
				var yy: float = y
				var a := _wp(pv, ang, r, 1.7, yy)
				var b := _wp(pv, ang, r, 2.45, yy)
				ci.draw_line(a, b, OL, r * 0.1 + lw * 1.2, true)
				ci.draw_line(a, b, STEEL, r * 0.1, true)
			_bar(ci, r, pv, ang, 1.7, 1.75, 0.5, 0.7, STEEL, lw * 0.4)
		5:
			_bar(ci, r, pv, ang, 0.3, 1.6, 0.5, 0.12, wood, lw)
			_fill(ci, _wpoly(pv, ang, r, PackedVector2Array([Vector2(1.45, 0.5), Vector2(1.35, -0.05), Vector2(1.85, 0.0), Vector2(2.1, 0.5), Vector2(1.85, 1.0), Vector2(1.35, 1.05)])), STEEL, OL, lw)
		6:
			_bar(ci, r, pv, ang, 0.55, 0.95, 0.5, 0.14, Color(0.4, 0.26, 0.14), lw)
			_fill(ci, _wpoly(pv, ang, r, PackedVector2Array([Vector2(0.95, 0.4), Vector2(2.15, 0.4), Vector2(2.45, 0.5), Vector2(2.15, 0.6), Vector2(0.95, 0.6)])), Color(0.9, 0.93, 0.98), OL, lw)
			_bar(ci, r, pv, ang, 0.93, 0.99, 0.5, 0.75, gold, lw * 0.5)
		7:
			_bar(ci, r, pv, ang, 0.5, 0.95, 0.5, 0.13, c2, lw)
			_fill(ci, _wpoly(pv, ang, r, PackedVector2Array([Vector2(0.95, 0.45), Vector2(1.8, 0.4), Vector2(2.5, 0.42), Vector2(2.65, 0.5), Vector2(1.8, 0.55), Vector2(0.95, 0.55)])), Color(0.92, 0.95, 1.0), OL, lw)
			ci.draw_circle(_wp(pv, ang, r, 0.97, 0.5), r * 0.14, gold)
		8:
			_bar(ci, r, pv, ang, -0.4, 2.2, 0.5, 0.1, wood, lw)
			for y in [0.1, 0.9]:
				var yy2: float = y
				var q0 := _wp(pv, ang, r, 2.1, 0.5)
				var q1 := _wp(pv, ang, r, 2.1, yy2)
				var q2 := _wp(pv, ang, r, 2.8, yy2)
				ci.draw_polyline(PackedVector2Array([q0, q1, q2]), OL, r * 0.1 + lw * 1.2, true)
				ci.draw_polyline(PackedVector2Array([q0, q1, q2]), STEEL, r * 0.1, true)
			var m0 := _wp(pv, ang, r, 2.1, 0.5)
			var m1 := _wp(pv, ang, r, 2.95, 0.5)
			ci.draw_line(m0, m1, OL, r * 0.1 + lw * 1.2, true)
			ci.draw_line(m0, m1, STEEL, r * 0.1, true)
		9:
			_bar(ci, r, pv, ang, 0.4, 1.6, 0.5, 0.14, wood, lw)
			var mc := _wp(pv, ang, r, 1.9, 0.5)
			for k in range(8):
				var a2 := TAU * float(k) / 8.0 + ang
				ci.draw_line(mc, mc + Vector2.from_angle(a2) * r * 0.5, OL, r * 0.12, true)
			ci.draw_circle(mc, r * 0.34 + lw, OL)
			ci.draw_circle(mc, r * 0.34, Color(0.6, 0.62, 0.68))
		10:
			_bar(ci, r, pv, ang, 0.4, 1.9, 0.5, 0.14, wood, lw)
			_fill(ci, _wpoly(pv, ang, r, PackedVector2Array([Vector2(1.75, 0.0), Vector2(2.4, 0.0), Vector2(2.4, 1.0), Vector2(1.75, 1.0)])), STEEL, OL, lw)
			_bar(ci, r, pv, ang, 1.78, 1.86, 0.5, 0.95, gold, lw * 0.4)
			_bar(ci, r, pv, ang, 2.28, 2.36, 0.5, 0.95, gold, lw * 0.4)
		11:
			_bar(ci, r, pv, ang, -0.6, 2.4, 0.5, 0.1, wood, lw)
			var oc := _wp(pv, ang, r, 2.55, 0.5)
			var pu := 0.5 + 0.5 * sin(t * 4.0)
			ci.draw_circle(oc, r * (0.5 + 0.12 * pu), Color(c2.r, c2.g, c2.b, 0.2))
			ci.draw_circle(oc, r * 0.3, OL)
			ci.draw_circle(oc, r * 0.25, c2)
			ci.draw_circle(oc + Vector2(-0.07 * r, -0.07 * r), r * 0.08, Color(1, 1, 1, 0.9))
		12:
			_bar(ci, r, pv, ang, -0.5, 2.3, 0.5, 0.1, Color(0.3, 0.24, 0.2), lw)
			_fill(ci, _wpoly(pv, ang, r, PackedVector2Array([Vector2(2.3, 0.5), Vector2(2.5, 0.1), Vector2(2.2, -0.35), Vector2(1.5, -0.65), Vector2(1.75, -0.3), Vector2(2.05, 0.05), Vector2(2.1, 0.5)])), Color(0.85, 0.9, 0.95), OL, lw)
		13:
			_bar(ci, r, pv, ang, 0.3, 0.95, 0.5, 0.14, Color(0.3, 0.24, 0.2), lw)
			_fill(ci, _wpoly(pv, ang, r, PackedVector2Array([Vector2(0.95, 0.36), Vector2(2.9, 0.34), Vector2(3.3, 0.5), Vector2(2.9, 0.66), Vector2(0.95, 0.64)])), Color(0.9, 0.93, 0.98), OL, lw)
			_bar(ci, r, pv, ang, 0.93, 1.01, 0.5, 1.0, c2, lw * 0.5)
		14:
			_bar(ci, r, pv, ang, 0.3, 0.95, 0.5, 0.14, Color(0.3, 0.24, 0.2), lw)
			_fill(ci, _wpoly(pv, ang, r, PackedVector2Array([Vector2(0.95, 0.36), Vector2(2.9, 0.34), Vector2(3.3, 0.5), Vector2(2.9, 0.66), Vector2(0.95, 0.64)])), Color(0.95, 0.85, 0.75), OL, lw)
			for k in range(5):
				var fx0 := 1.2 + float(k) * 0.4
				var hh := 0.28 + 0.12 * sin(t * 12.0 + float(k) * 1.7)
				ci.draw_colored_polygon(_wpoly(pv, ang, r, PackedVector2Array([Vector2(fx0, 0.34), Vector2(fx0 + 0.18, 0.34 - hh), Vector2(fx0 + 0.36, 0.34)])), Color(1.0, 0.55, 0.15, 0.9))
				ci.draw_colored_polygon(_wpoly(pv, ang, r, PackedVector2Array([Vector2(fx0 + 0.07, 0.34), Vector2(fx0 + 0.18, 0.34 - hh * 0.55), Vector2(fx0 + 0.29, 0.34)])), Color(1.0, 0.9, 0.4, 0.95))
			_bar(ci, r, pv, ang, 0.93, 1.01, 0.5, 1.0, c2, lw * 0.5)
		16:
			_bar(ci, r, pv, ang, -0.4, 2.5, 0.5, 0.11, Color(0.34, 0.3, 0.32), lw)
			_fill(ci, _wpoly(pv, ang, r, PackedVector2Array([Vector2(2.45, 0.5), Vector2(3.3, 0.36), Vector2(3.0, 0.5), Vector2(3.3, 0.64)])), Color(0.88, 0.94, 1.0), OL, lw * 0.7)
			for k in range(4):
				var za := 0.5 + (-0.16 + float(k) * 0.11)
				var z0 := _wp(pv, ang, r, 2.0 + float(k) * 0.2, za)
				var z1 := _wp(pv, ang, r, 2.28 + float(k) * 0.2, za + 0.08)
				ci.draw_line(z0, z1, Color(1.0, 0.92, 0.45, 0.85), r * 0.05, true)
			_bar(ci, r, pv, ang, 2.35, 2.44, 0.5, 0.66, c2, lw * 0.4)
		17:
			_bar(ci, r, pv, ang, -0.6, 3.0, 0.5, 0.1, Color(0.28, 0.22, 0.2), lw)
			_fill(ci, _wpoly(pv, ang, r, PackedVector2Array([Vector2(3.0, 0.5), Vector2(3.45, 0.2), Vector2(3.1, -0.25), Vector2(2.5, -0.5), Vector2(2.7, -0.15), Vector2(2.85, 0.5)])), Color(0.8, 0.85, 0.92), OL, lw)
			ci.draw_circle(_wp(pv, ang, r, 2.95, 0.5), r * 0.1, c2)
		18:
			_bar(ci, r, pv, ang, -0.5, 2.6, 0.5, 0.11, Color(0.4, 0.3, 0.22), lw)
			_fill(ci, _wpoly(pv, ang, r, PackedVector2Array([Vector2(2.55, 0.5), Vector2(2.75, 0.16), Vector2(3.35, 0.2), Vector2(3.4, 0.5), Vector2(3.0, 0.5)])), Color(0.95, 0.9, 0.6), OL, lw)
			_fill(ci, _wpoly(pv, ang, r, PackedVector2Array([Vector2(2.6, 0.5), Vector2(2.75, 0.84), Vector2(3.35, 0.8), Vector2(3.4, 0.5), Vector2(3.0, 0.5)])), Color(0.95, 0.9, 0.6), OL, lw)
			_bar(ci, r, pv, ang, 2.5, 2.58, 0.5, 0.6, c2, lw * 0.4)
		19:
			_bar(ci, r, pv, ang, 0.3, 0.95, 0.5, 0.15, Color(0.2, 0.1, 0.3), lw)
			var gblade := _wpoly(pv, ang, r, PackedVector2Array([Vector2(0.95, 0.34), Vector2(3.1, 0.3), Vector2(3.7, 0.5), Vector2(3.1, 0.7), Vector2(0.95, 0.66)]))
			var pu3 := 0.5 + 0.5 * sin(t * 3.0)
			ci.draw_colored_polygon(_wpoly(pv, ang, r, _ellipse(2.3, 0.5, 1.6, 0.5, 0.0, 20)), Color(0.6, 0.3, 1.0, 0.14 + 0.08 * pu3))
			_fill(ci, gblade, Color(0.35, 0.2, 0.55), OL, lw)
			ci.draw_line(_wp(pv, ang, r, 1.1, 0.5), _wp(pv, ang, r, 3.5, 0.5), Color(0.8, 0.6, 1.0), lw, true)
			for k in range(4):
				var sx := 1.4 + float(k) * 0.5
				ci.draw_circle(_wp(pv, ang, r, sx, 0.5 + (-0.1 + 0.2 * float(k % 2))), r * 0.045, Color(0.85, 0.75, 1.0, 0.9))
			_bar(ci, r, pv, ang, 0.93, 1.01, 0.5, 1.15, c2, lw * 0.5)
		_:
			_bar(ci, r, pv, ang, 0.3, 0.95, 0.5, 0.16, Color(0.5, 0.1, 0.1), lw)
			var blade := _wpoly(pv, ang, r, PackedVector2Array([Vector2(0.95, 0.34), Vector2(3.0, 0.3), Vector2(3.55, 0.5), Vector2(3.0, 0.7), Vector2(0.95, 0.66)]))
			var pu2 := 0.5 + 0.5 * sin(t * 4.0)
			ci.draw_colored_polygon(_wpoly(pv, ang, r, _ellipse(2.2, 0.5, 1.5, 0.45, 0.0, 20)), Color(1.0, 0.85, 0.3, 0.12 + 0.08 * pu2))
			_fill(ci, blade, Color(1.0, 0.9, 0.45), OL, lw)
			ci.draw_line(_wp(pv, ang, r, 1.1, 0.5), _wp(pv, ang, r, 3.2, 0.5), Color(1, 1, 0.85), lw, true)
			_bar(ci, r, pv, ang, 0.93, 1.01, 0.5, 1.15, c2, lw * 0.5)
