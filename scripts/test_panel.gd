extends Control
# The Test Range's tier picker: click any of the 28 evolutions to try it.

const Species = preload("res://scripts/species.gd")

var main
var buttons: Array = []
var shown := -1
var panel: PanelContainer


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

	var title := Label.new()
	title.text = "TEST RANGE  -  PICK A TIER"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 14)
	title.add_theme_color_override("font_color", Color(0.6, 1.0, 0.9))
	col.add_child(title)

	var grid := GridContainer.new()
	grid.columns = 4
	grid.add_theme_constant_override("h_separation", 4)
	grid.add_theme_constant_override("v_separation", 4)
	col.add_child(grid)

	for i in range(Species.COUNT):
		var b := Button.new()
		b.text = "%02d %s" % [i + 1, Species.NAMES[i]]
		b.focus_mode = Control.FOCUS_NONE
		b.custom_minimum_size = Vector2(118, 24)
		b.add_theme_font_size_override("font_size", 12)
		b.pressed.connect(func(): _pick(i))
		grid.add_child(b)
		buttons.append(b)

	var hint := Label.new()
	hint.text = "1-9 / 0 pick a tier    [ ] step    TAB hide    ESC leave"
	hint.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	hint.add_theme_font_size_override("font_size", 11)
	hint.add_theme_color_override("font_color", Color(0.65, 0.8, 0.9, 0.8))
	col.add_child(hint)

	get_viewport().size_changed.connect(_place)
	_place()
	call_deferred("_place")
	_refresh()


func _place() -> void:
	# this control does not get the viewport rect for free, so place the
	# picker by hand: down the left edge, centred vertically.
	size = get_viewport_rect().size
	if panel == null:
		return
	var vs: Vector2 = get_viewport_rect().size
	panel.position = Vector2(16.0, maxf(vs.y * 0.5 - panel.size.y * 0.5, 96.0))


func _pick(evo: int) -> void:
	if main != null and is_instance_valid(main):
		main.set_test_tier(evo)


func _refresh() -> void:
	var cur: int = GameState.test_tier
	if cur == shown:
		return
	shown = cur
	for i in range(buttons.size()):
		var b: Button = buttons[i]
		var on: bool = i == cur
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
