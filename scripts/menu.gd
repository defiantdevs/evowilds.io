extends Control
# Title screen: pick a name, then press PLAY.

const Species = preload("res://scripts/species.gd")

var name_edit: LineEdit
var play_btn: Button
var buttons_box: VBoxContainer
var secret_label: Label
var code_buf := ""
var t := 0.0
var mascot_evo := 0
var shot_path := ""
var shot_time := 2.0


func _ready() -> void:
	set_anchors_preset(Control.PRESET_FULL_RECT)
	mouse_filter = Control.MOUSE_FILTER_STOP
	randomize()
	for a in OS.get_cmdline_user_args():
		if a.begins_with("--shot="):
			shot_path = a.substr(7)
		elif a.begins_with("--wait="):
			shot_time = float(a.substr(7))
		elif a.begins_with("--team="):  # dev: pretend we are mid-match on a team
			GameState.mode = "tdm"
			GameState.team = int(a.substr(7))
	_build_ui()
	# dev/test hook: jump straight into a game with a given name
	for a in OS.get_cmdline_user_args():
		if a.begins_with("--play="):
			name_edit.text = a.substr(7)
			call_deferred("_play")
			return
	name_edit.grab_focus()


func _build_ui() -> void:
	_mk_label("EVO WILDS", 64, -322, Color(1.0, 0.95, 0.55), 900)
	_mk_label("Eat. Evolve. Rule the wilds.", 20, -262, Color(0.78, 0.9, 1.0, 0.9), 900)

	# build stamp: if this does not say the newest version, the download did
	# not land and the game is still the old build.
	var ver := Label.new()
	ver.text = "BUILD " + GameState.VERSION
	ver.add_theme_font_size_override("font_size", 12)
	ver.add_theme_color_override("font_color", Color(0.72, 0.85, 0.95, 0.55))
	ver.mouse_filter = Control.MOUSE_FILTER_IGNORE
	ver.anchor_left = 1.0
	ver.anchor_top = 1.0
	ver.anchor_right = 1.0
	ver.anchor_bottom = 1.0
	ver.offset_left = -180.0
	ver.offset_top = -26.0
	ver.offset_right = -12.0
	ver.offset_bottom = -6.0
	ver.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	add_child(ver)

	_mk_label("YOUR NAME", 14, 26, Color(0.62, 0.8, 0.92, 0.9), 400)

	secret_label = _mk_label("", 20, -206, Color(0.55, 1.0, 0.85, 0.95), 900)
	secret_label.text = ""

	name_edit = LineEdit.new()
	name_edit.placeholder_text = "Enter a name"
	name_edit.max_length = 14
	name_edit.alignment = HORIZONTAL_ALIGNMENT_CENTER
	_center_node(name_edit, 340.0, 52.0, 52.0)
	name_edit.add_theme_font_size_override("font_size", 22)
	name_edit.add_theme_color_override("font_color", Color(1, 1, 1))
	name_edit.add_theme_color_override("font_placeholder_color", Color(0.62, 0.72, 0.82, 0.55))
	name_edit.add_theme_color_override("caret_color", Color(0.6, 0.95, 1.0))
	var sb := StyleBoxFlat.new()
	sb.bg_color = Color(0.02, 0.06, 0.11, 0.9)
	sb.set_corner_radius_all(9)
	sb.border_color = Color(0.3, 0.8, 1.0, 0.45)
	sb.set_border_width_all(2)
	sb.content_margin_left = 12
	sb.content_margin_right = 12
	name_edit.add_theme_stylebox_override("normal", sb)
	var sbf: StyleBoxFlat = sb.duplicate()
	sbf.border_color = Color(0.55, 0.92, 1.0, 0.95)
	name_edit.add_theme_stylebox_override("focus", sbf)
	add_child(name_edit)
	name_edit.text_submitted.connect(func(_s): _submit())
	name_edit.text_changed.connect(_on_name_changed)
	if GameState.player_name.strip_edges() != "" and GameState.player_name != "You":
		name_edit.text = GameState.player_name
		name_edit.caret_column = name_edit.text.length()

	_build_buttons()

	_mk_label("Move: WASD / arrows or mouse     Swing: SPACE / click     Sprint: SHIFT / right-click", 13, 318, Color(0.72, 0.85, 0.95, 0.7), 1000)


func _on_name_changed(t: String) -> void:
	# A secret name on this screen opens up the Test Range.
	if not GameState.secret_unlocked and GameState.is_secret(t):
		_unlock_secret()


func _input(event: InputEvent) -> void:
	# The code also works if you just type it on the title screen: keep the
	# last few letters and look for it. This runs before the text box does,
	# so it still works when the name box is full and would cut the code off.
	if not (event is InputEventKey) or not event.pressed or event.echo:
		return
	var k := event as InputEventKey
	if k.ctrl_pressed or k.meta_pressed:
		return
	var ch := ""
	if k.unicode > 0:
		ch = String.chr(k.unicode).to_lower()
	if ch.length() == 1 and ch >= "a" and ch <= "z":
		code_buf = (code_buf + ch).right(24)
		if code_buf.contains(GameState.SECRET_NAME):
			code_buf = ""
			_unlock_secret()


func _unlock_secret() -> void:
	GameState.secret_unlocked = true
	_build_buttons()
	if secret_label != null and is_instance_valid(secret_label):
		secret_label.text = "TEST RANGE UNLOCKED  -  NEW BUTTON BELOW"
		secret_label.add_theme_color_override("font_color", Color(0.55, 1.0, 0.85, 1.0))


func _build_buttons() -> void:
	if buttons_box != null and is_instance_valid(buttons_box):
		buttons_box.queue_free()
	buttons_box = VBoxContainer.new()
	buttons_box.add_theme_constant_override("separation", 10)
	buttons_box.anchor_left = 0.5
	buttons_box.anchor_right = 0.5
	buttons_box.anchor_top = 0.5
	buttons_box.anchor_bottom = 0.5
	buttons_box.offset_left = -150.0
	buttons_box.offset_right = 150.0
	add_child(buttons_box)
	if GameState.mode == "tdm" and GameState.team >= 0:
		# already on a team: rejoin it, or leave with Quit match
		var tc := _team_color(GameState.team)
		var rj := _mk_button("REJOIN " + GameState.team_name().to_upper() + " TEAM", tc)
		rj.pressed.connect(_play)
		buttons_box.add_child(rj)
		var qm := _mk_button("QUIT MATCH", Color(0.3, 0.33, 0.4))
		qm.pressed.connect(_quit_match)
		buttons_box.add_child(qm)
		play_btn = rj
	else:
		var dm := _mk_button("DEATHMATCH", Color(0.17, 0.52, 0.29))
		dm.pressed.connect(func(): _start("dm"))
		buttons_box.add_child(dm)
		var tdm := _mk_button("TEAM DEATHMATCH", Color(0.2, 0.34, 0.62))
		tdm.pressed.connect(func(): _start("tdm"))
		buttons_box.add_child(tdm)
		play_btn = dm
		if GameState.secret_unlocked:
			# the secret name on the name field opens the Test Range
			var tr := _mk_button("TEST RANGE", Color(0.12, 0.5, 0.46))
			tr.pressed.connect(func(): _start("test"))
			buttons_box.add_child(tr)
	buttons_box.offset_top = 116.0
	buttons_box.offset_bottom = 116.0 + 122.0


func _mk_button(txt: String, base: Color) -> Button:
	var b := Button.new()
	b.text = txt
	b.custom_minimum_size = Vector2(300, 56)
	b.add_theme_font_size_override("font_size", 23)
	b.add_theme_color_override("font_color", Color(1, 1, 1))
	b.add_theme_color_override("font_hover_color", Color(1, 1, 1))
	b.add_theme_color_override("font_pressed_color", Color(1, 1, 1))
	var s := StyleBoxFlat.new()
	s.bg_color = base
	s.set_corner_radius_all(12)
	s.border_color = base.lightened(0.4)
	s.set_border_width_all(2)
	b.add_theme_stylebox_override("normal", s)
	var h: StyleBoxFlat = s.duplicate()
	h.bg_color = base.lightened(0.14)
	b.add_theme_stylebox_override("hover", h)
	var p: StyleBoxFlat = s.duplicate()
	p.bg_color = base.darkened(0.22)
	b.add_theme_stylebox_override("pressed", p)
	var f: StyleBoxFlat = s.duplicate()
	f.border_color = Color(1, 1, 1, 0.9)
	b.add_theme_stylebox_override("focus", f)
	return b


func _team_color(team_: int) -> Color:
	if team_ == 0:
		return Color(0.72, 0.2, 0.2)
	if team_ == 1:
		return Color(0.2, 0.36, 0.72)
	return Color(0.5, 0.5, 0.55)


func _mk_label(text: String, fs: int, top: float, col: Color, w: float) -> Label:
	var l := Label.new()
	l.text = text
	l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	l.add_theme_font_size_override("font_size", fs)
	l.add_theme_color_override("font_color", col)
	l.mouse_filter = Control.MOUSE_FILTER_IGNORE
	l.anchor_left = 0.5
	l.anchor_right = 0.5
	l.anchor_top = 0.5
	l.anchor_bottom = 0.5
	l.offset_left = -w * 0.5
	l.offset_right = w * 0.5
	l.offset_top = top
	l.offset_bottom = top + float(fs) + 14.0
	add_child(l)
	return l


func _center_node(c: Control, w: float, top: float, h: float) -> void:
	c.anchor_left = 0.5
	c.anchor_right = 0.5
	c.anchor_top = 0.5
	c.anchor_bottom = 0.5
	c.offset_left = -w * 0.5
	c.offset_right = w * 0.5
	c.offset_top = top
	c.offset_bottom = top + h


func _process(delta: float) -> void:
	t += delta
	mascot_evo = int(t / 2.2) % Species.COUNT
	queue_redraw()
	if shot_path != "" and t > shot_time:
		var img := get_viewport().get_texture().get_image()
		img.save_png(shot_path)
		get_tree().quit()


func _set_name() -> void:
	var nm := name_edit.text.strip_edges()
	if GameState.is_secret(nm):
		_unlock_secret()
	GameState.player_name = nm if nm != "" else "You"


func _submit() -> void:
	if GameState.mode == "tdm" and GameState.team >= 0:
		_play()
		return
	if not GameState.secret_unlocked and GameState.is_secret(name_edit.text):
		# the code opens the Test Range instead of starting a match
		_unlock_secret()
		return
	_start("dm")


func _start(m: String) -> void:
	_set_name()
	GameState.mode = m
	if m == "tdm":
		if GameState.team < 0:
			GameState.team = randi() % 2
	else:
		GameState.team = -1
	get_tree().change_scene_to_file("res://scenes/main.tscn")


func _quit_match() -> void:
	GameState.team = -1
	GameState.mode = "dm"
	get_tree().reload_current_scene()


func _play() -> void:
	_set_name()
	if GameState.mode == "tdm" and GameState.team >= 0:
		# rejoin the match on the same team
		pass
	else:
		GameState.mode = "dm"
		GameState.team = -1
	get_tree().change_scene_to_file("res://scenes/main.tscn")


func _draw() -> void:
	var S := size
	var top := Color(0.07, 0.13, 0.24)
	var bot := Color(0.05, 0.11, 0.12)
	var bands := 32
	for i in range(bands):
		var f := (float(i) + 0.5) / float(bands)
		draw_rect(Rect2(0, S.y * float(i) / float(bands), S.x, S.y / float(bands) + 1.0), top.lerp(bot, f))
	draw_circle(Vector2(S.x * 0.5, S.y * 0.28), 320.0, Color(0.35, 0.62, 0.45, 0.08))
	draw_circle(Vector2(S.x * 0.5, S.y * 0.28), 190.0, Color(0.4, 0.72, 0.5, 0.07))
	var gy := S.y * 0.66
	draw_rect(Rect2(0, gy, S.x, S.y - gy), Color(0.14, 0.3, 0.2))
	draw_rect(Rect2(0, gy, S.x, 5.0), Color(0.3, 0.55, 0.34))
	for i in range(28):
		var ph := float(i) * 1.7
		var x := fposmod(float(i) * 197.0 + sin(t * 0.6 + ph) * 24.0, S.x)
		var y := 30.0 + fposmod(float(i) * 71.0 + t * (10.0 + float(i % 5) * 5.0), gy - 30.0)
		var n: int = i % 4
		var fc := Color(0.9, 0.2, 0.35) if n == 0 else (Color(0.95, 0.35, 0.25) if n == 1 else (Color(1.0, 0.8, 0.2) if n == 2 else Color(0.85, 0.6, 0.3)))
		draw_circle(Vector2(x, y), 3.4, fc)
	var mcx := S.x * 0.5
	var mcy := S.y * 0.34
	var evo := mascot_evo
	var bob := sin(t * 2.0) * 4.0
	draw_set_transform(Vector2(mcx, mcy + 96.0), 0.0, Vector2(1.0, 0.3))
	draw_circle(Vector2.ZERO, 74.0, Color(0, 0, 0, 0.22))
	draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
	draw_set_transform(Vector2(mcx, mcy + bob), -0.12, Vector2(58.0, 58.0))
	Species.draw_body(self, evo, 1.0, t, Species.COL1[evo], Species.COL2[evo], 0.12 + 0.5 * (0.5 + 0.5 * sin(t * 1.1)))
	draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
	draw_string(ThemeDB.fallback_font, Vector2(mcx - 300.0, mcy + 108.0), Species.NAMES[evo], HORIZONTAL_ALIGNMENT_CENTER, 600.0, 21, Species.COL2[evo].lightened(0.35))
	draw_string(ThemeDB.fallback_font, Vector2(mcx - 300.0, mcy + 130.0), "Tier %d of %d" % [evo + 1, Species.COUNT], HORIZONTAL_ALIGNMENT_CENTER, 600.0, 13, Color(0.7, 0.85, 0.95, 0.75))
