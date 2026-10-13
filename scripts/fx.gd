extends Node2D

var parts: Array = []
var rings: Array = []


func burst(pos: Vector2, col: Color, n: int, spd: float, life: float = 0.6) -> void:
	if parts.size() > 700:
		return
	for i in range(n):
		var a := randf() * TAU
		var s := spd * randf_range(0.35, 1.0)
		parts.append({"p": pos, "v": Vector2.from_angle(a) * s, "life": life * randf_range(0.6, 1.0), "max": life, "c": col})


func ring(pos: Vector2, col: Color, max_r: float, life: float = 0.5) -> void:
	rings.append({"p": pos, "r": max_r, "life": life, "max": life, "c": col})


func _process(delta: float) -> void:
	var i := parts.size() - 1
	while i >= 0:
		var d: Dictionary = parts[i]
		var life: float = d["life"] - delta
		if life <= 0.0:
			parts.remove_at(i)
		else:
			var v: Vector2 = d["v"]
			d["life"] = life
			d["p"] = (d["p"] as Vector2) + v * delta
			d["v"] = v * maxf(1.0 - 2.2 * delta, 0.0)
		i -= 1
	i = rings.size() - 1
	while i >= 0:
		var d: Dictionary = rings[i]
		var life: float = d["life"] - delta
		if life <= 0.0:
			rings.remove_at(i)
		else:
			d["life"] = life
		i -= 1
	queue_redraw()


func _draw() -> void:
	for d in parts:
		var life: float = d["life"]
		var mx: float = d["max"]
		var a := clampf(life / mx, 0.0, 1.0)
		var c: Color = d["c"]
		var p: Vector2 = d["p"]
		var v: Vector2 = d["v"]
		draw_line(p, p - v * 0.05, Color(c.r, c.g, c.b, a), 1.0 + 3.0 * a, true)
	for d in rings:
		var life: float = d["life"]
		var mx: float = d["max"]
		var f := 1.0 - clampf(life / mx, 0.0, 1.0)
		var c: Color = d["c"]
		var rad: float = d["r"]
		draw_arc(d["p"] as Vector2, rad * (0.2 + 0.8 * f), 0.0, TAU, 48, Color(c.r, c.g, c.b, 1.0 - f), 3.0, true)
