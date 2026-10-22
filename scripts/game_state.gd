extends Node
# Tiny global that carries settings between the menu and the game.

# Type this in as your name on the start screen to unlock the Test Range.
const SECRET_NAME := "godmode"
const VERSION := "v1.12"

var player_name := "You"
var mode := "dm"   # "dm" = Deathmatch, "tdm" = Team Deathmatch, "test" = Test Range
var team := -1     # 0 = Red, 1 = Blue, -1 = none
var secret_unlocked := false   # the Test Range stays unlocked once found
var test_tier := 0             # which evolution you are trying in the Test Range


func clean_name() -> String:
	var n := player_name.strip_edges()
	if n.length() > 14:
		n = n.substr(0, 14)
	if n == "":
		n = "You"
	return n


func is_secret(n: String) -> bool:
	# forgiving on purpose: any case, any spaces, and it still counts if the
	# code is stuck on the end of a name that was already in the box.
	var s := n.strip_edges().to_lower().replace(" ", "")
	return s == SECRET_NAME or s.begins_with(SECRET_NAME) or s.ends_with(SECRET_NAME)


func team_name() -> String:
	if team == 0:
		return "Red"
	if team == 1:
		return "Blue"
	return ""


func team_color() -> Color:
	if team == 0:
		return Color(0.89, 0.27, 0.27)
	if team == 1:
		return Color(0.28, 0.5, 0.93)
	return Color(0.62, 0.62, 0.66)
