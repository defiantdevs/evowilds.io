extends Control
# The Test Range's control panel: pick any of the evolutions, and choose
# how many bots come charging at you.

const Species = preload("res://scripts/species.gd")

var main
var buttons: Array = []
var shown := -1
var shown_bots := -1
var panel: PanelContainer
var bot_label: Label
var title: Label
var min_btn: Button
var body: VBoxContainer
var minimized := false


func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	anchor_left = 0.0
	anchor_right = 0.0
	anchor_top = 0.0
	anchor_bottom = 0.0
	size = get_viewport_rect().size

	var sb := StyleBoxFlat.new()
	sb.bg_color = Color(0.02, 0.05, 0.11, 0.88)
	sb.set_corner_radius_all(12)
	sb.border_color = Color(0.35, 0.9, 0.85, 0.5)
	sb.set_border_width_all(2)
	sb.content_margin_left = 12
	sb.content_margin_right = 12
	sb.content_margin_top = 8
	sb.content_margin_bottom = 8
	panel = PanelContainer.new()
	panel.add_theme_stylebox_override("panel", sb)
	panel.anchor_left = 0.0
	panel.anchor_right = 0.0
	panel.anchor_top = 0.0
	panel.anchor_bottom = 0.0
	panel.grow_horizontal = Control.GROW_DIRECTION_END
	panel.grow_vertical = Control.GROW_DIRECTION_END
	panel.offset_left = 16.0
	panel.offset_right = 16.0
	panel.offset_top = 16.0
	panel.offset_bottom = 16.0
	add_child(panel)

	var col := VBoxContainer.new()
	col.add_theme_constant_override("separation", 6)
	panel.add_child(col)

	# --- header: title and the minimise button -------------------------
	var head := HBoxContainer.new()
	head.add_theme_constant_override("separation", 6)
	col.add_child(head)

	title = Label.new()
	title.text = "TEST RANGE  -  PICK A TIER"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	title.custom_minimum_size = Vector2(250, 0)
	title.add_theme_font_size_override("font_size", 14)
	title.add_theme_color_override("font_color", Color(0.6, 1.0, 0.9))
	head.add_child(title)

	min_btn = Button.new()
	min_btn.text = "-"
	min_btn.tooltip_text = "Minimise (M)"
	min_btn.focus_mode = Control.FOCUS_NONE
	min_btn.custom_minimum_size = Vector2(26, 22)
	min_btn.add_theme_font_size_override("font_size", 15)
	_style(min_btn, false)
	min_btn.pressed.connect(func(): set_minimized(not minimized))
	head.add_child(min_btn)

	# everything below the header can be folded away
	body = VBoxContainer.new()
	body.add_theme_constant_override("separation", 6)
	col.add_child(body)

	# --- how many bots charge you -------------------------------------
	var row := HBoxContainer.new()
	row.alignment = BoxContainer.ALIGNMENT_CENTER
	row.add_theme_constant_override("separation", 8)
	body.add_child(row)

	var bl := Label.new()
	bl.text = "BOTS"
	bl.add_theme_font_size_override("font_size", 12)
	bl.add_theme_color_override("font_color", Color(0.65, 0.85, 0.95, 0.9))
	row.add_child(bl)

	var minus := _small_button("-")
	minus.pressed.connect(func(): _bump(-1))
	row.add_child(minus)

	bot_label = Label.new()
	bot_label.text = str(GameState.test_bots)
	bot_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	bot_label.custom_minimum_size = Vector2(34, 24)
	bot_label.add_theme_font_size_override("font_size", 14)
	bot_label.add_theme_color_override("font_color", Color(1, 1, 1))
	row.add_child(bot_label)

	var plus := _small_button("+")
	plus.pressed.connect(func(): _bump(1))
	row.add_child(plus)

	var cap := Label.new()
	cap.text = "max 25"
	cap.add_theme_font_size_override("font_size", 11)
	cap.add_theme_color_override("font_color", Color(0.65, 0.8, 0.9, 0.6))
	row.add_child(cap)

	# --- every tier ---------------------------------------------------
	var grid := GridContainer.new()
	grid.columns = 5
	grid.add_theme_constant_override("h_separation", 4)
	grid.add_theme_constant_override("v_separation", 4)
	body.add_child(grid)

	for i in range(Species.COUNT):
		var b := Button.new()
		b.text = "%02d %s" % [i + 1, Species.NAMES[i]]
		b.focus_mode = Control.FOCUS_NONE
		b.custom_minimum_size = Vector2(120, 24)
		b.add_theme_font_size_override("font_size", 12)
		b.pressed.connect(func(): _pick(i))
		grid.add_child(b)
		buttons.append(b)

	var hint := Label.new()
	hint.text = "1-9 0 tier    [ ] step    - + bots    M minimise    TAB hide    ESC leave"
	hint.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	hint.add_theme_font_size_override("font_size", 11)
	hint.add_theme_color_override("font_color", Color(0.65, 0.8, 0.9, 0.8))
	body.add_child(hint)

	get_viewport().size_changed.connect(_place)
	_place()
	call_deferred("_place")
	_refresh()


func _small_button(txt: String) -> Button:
	var b := Button.new()
	b.text = txt
	b.focus_mode = Control.FOCUS_NONE
	b.custom_minimum_size = Vector2(30, 24)
	b.add_theme_font_size_override("font_size", 14)
	_style(b, false)
	return b


func _place() -> void:
	# this control does not get the viewport rect for free, so place the
	# panel by hand: down the left edge. Folded up it tucks into the top
	# corner, unfolded it sits centred vertically.
	size = get_viewport_rect().size
	if panel == null:
		return
	var vs: Vector2 = get_viewport_rect().size
	# folded up, tuck it away in the bottom-left corner so it covers
	# neither the score, the kill feed nor the arena's middle
	var y := (vs.y - panel.size.y - 16.0) if minimized else vs.y * 0.5 - panel.size.y * 0.5
	panel.position = Vector2(16.0, maxf(y, 96.0))


func set_minimized(on: bool) -> void:
	if on == minimized:
		return
	minimized = on
	if body != null:
		body.visible = not on
	if min_btn != null:
		min_btn.text = "+" if on else "-"
		min_btn.tooltip_text = "Expand (M)" if on else "Minimise (M)"
	_refresh()
	_fit()


func _fit() -> void:
	# the panel is not inside a container, so re-fit it by hand after folding
	if panel == null:
		return
	panel.reset_size()
	await get_tree().process_frame
	if not is_instance_valid(panel):
		return
	panel.reset_size()
	_place()


func _pick(evo: int) -> void:
	if main != null and is_instance_valid(main):
		main.set_test_tier(evo)


func _bump(d: int) -> void:
	if main != null and is_instance_valid(main):
		main.set_test_bots(GameState.test_bots + d)
	_refresh()


func _style(b: Button, on: bool) -> void:
	var s := StyleBoxFlat.new()
	s.bg_color = Color(0.1, 0.45, 0.42, 0.95) if on else Color(0.06, 0.1, 0.17, 0.9)
	s.set_corner_radius_all(6)
	s.border_color = Color(0.5, 1.0, 0.9, 0.95) if on else Color(0.25, 0.45, 0.6, 0.5)
	s.set_border_width_all(1)
	b.add_theme_stylebox_override("normal", s)
	var h: StyleBoxFlat = s.duplicate()
	h.bg_color = s.bg_color.lightened(0.18)
	b.add_theme_stylebox_override("hover", h)
	b.add_theme_stylebox_override("pressed", s)
	b.add_theme_color_override("font_color", Color(1, 1, 1) if on else Color(0.75, 0.85, 0.95))


func _refresh() -> void:
	var cur: int = GameState.test_tier
	if title != null:
		var want := ("TEST RANGE  -  %02d %s" % [cur + 1, Species.NAMES[cur]]) if minimized else "TEST RANGE  -  PICK A TIER"
		if title.text != want:
			title.text = want
	if cur != shown:
		shown = cur
		for i in range(buttons.size()):
			_style(buttons[i], i == cur)
	if GameState.test_bots != shown_bots:
		shown_bots = GameState.test_bots
		bot_label.text = str(shown_bots)


func _process(_delta: float) -> void:
	# the count can also change from the keyboard
	_refresh()
