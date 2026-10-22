extends Node2D

const Species = preload("res://scripts/species.gd")


func _ready() -> void:
	Engine.max_fps = 60
	GameState.mode = "test"
	GameState.test_bots = 12
	GameState.player_name = "Tester"
	var main = load("res://scenes/main.tscn").instantiate()
	add_child(main)
	await get_tree().process_frame

	# --- Which tiers do orbs kill at? -------------------------------------
	print("orb_body: tier 39 %s | 40 %s | 43 %s | 44 %s | 48 %s" % [
		str(Species.orb_body(38)), str(Species.orb_body(39)),
		str(Species.orb_body(42)), str(Species.orb_body(43)),
		str(Species.orb_body(47))])

	# --- Normal play must cap at 43 ---------------------------------------
	print("cap dm  : %d %d" % [Species.capped_for_mode(Species.evo_for_xp(9.9e9), "dm"),
		Species.capped_for_mode(Species.evo_for_xp(9.9e9), "tdm")])
	print("cap test: %d" % Species.capped_for_mode(Species.evo_for_xp(9.9e9), "test"))

	# --- The Test Range orb kill, at each tier ----------------------------
	for tier in [39, 42, 43, 45, 47]:
		await _orb_kill(main, tier)
	get_tree().quit()


func _orb_kill(main, tier: int) -> void:
	main.set_test_tier(tier)
	await get_tree().process_frame
	await get_tree().process_frame
	var player = main.player
	# park players and bots still
	for c in main.creatures:
		c.frozen = true
	# pick a body, shrink it, and let it come at us: it has to walk into the ring
	var victim = null
	for c in main.creatures:
		if c != player:
			victim = c
			break
	if victim == null:
		print("tier %d: no bot" % (tier + 1))
		return
	victim.evo = 10
	victim.xp = Species.XP_AT[10]
	victim.r = Species.radius_base(10)
	victim.locked_tier = 10
	victim._refresh_colors()
	victim.frozen = false
	victim.position = player.position + Vector2.from_angle(randf() * TAU) * (Species.orb_radius(player.evo) * player.r + 260.0)
	var alive_before: bool = victim.alive
	var ring: float = Species.orb_radius(player.evo) * player.r
	var closest := 9.9e9
	var died := false
	for f in range(240):
		await get_tree().process_frame
		if not is_instance_valid(victim) or not victim.alive:
			died = true
			break
		closest = minf(closest, victim.position.distance_to(player.position))
	print("tier %-2d orbs %d ring %5.0f | bot closes to %5.0f | killed in 4 s: %s (was alive %s)" % [
		tier + 1, Species.orb_count(player.evo), ring, closest, str(died), str(alive_before)])
