extends Node
# Tiny global that carries settings between the menu and the game.

var player_name := "You"


func clean_name() -> String:
	var n := player_name.strip_edges()
	if n.length() > 14:
		n = n.substr(0, 14)
	if n == "":
		n = "You"
	return n
