extends Node
# Tiny global that carries settings between the menu and the game.

var player_name := "You"
var mode := "dm"   # "dm" = Deathmatch, "tdm" = Team Deathmatch
var team := -1     # 0 = Red, 1 = Blue, -1 = none


func clean_name() -> String:
	var n := player_name.strip_edges()
	if n.length() > 14:
		n = n.substr(0, 14)
	if n == "":
		n = "You"
	return n


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
