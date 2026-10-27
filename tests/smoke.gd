extends Node
# Runs a real match for a few seconds in each mode, with the player live.

const MainScene = preload("res://scenes/main.tscn")

var main
var frames := 0
var mode := "dm"


func _ready() -> void:
	for a in OS.get_cmdline_user_args():
		if a.begins_with("--mode="):
			mode = a.substr(7)
	GameState.mode = mode
	if mode == "test":
		GameState.test_tier = 12
		GameState.test_bots = 8
	Engine.time_scale = 3.0
	main = MainScene.instantiate()
	add_child(main)


func _process(_delta: float) -> void:
	frames += 1
	if frames < 240:
		return
	Engine.time_scale = 1.0
	var bad := 0
	for c in main.creatures:
		if c == null or not is_instance_valid(c):
			bad += 1
	print("SMOKE mode=", mode, " game_time=", snappedf(main.time, 0.1), " creatures=", main.creatures.size(), " bad=", bad, " player=", main.player != null and is_instance_valid(main.player), " kills=", main.kills)
	get_tree().quit(0 if bad == 0 and main.creatures.size() > 1 else 1)
