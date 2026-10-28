extends RefCounted

const COUNT := 48
# The five newest ranks (tiers 44-48). They are part of the normal climb now;
# TOP_FROM only marks them for their extra orbs and their wide swings.
const TOP_FROM := 43
const TOTAL := COUNT
# From this level up (The Infinite, tier 43, and every newest rank above it)
# each blade of a dual pair sweeps a 200 degree cut.
const WIDE_SWING_FROM := 42
# from this evo up a body wears rings of floating orbs. They are decoration
# only and cannot hurt anything.
const ORB_FROM := 39
const NAMES := ["Caveman", "Forager", "Hunter", "Tribesman", "Peasant", "Raider", "Viking", "Soldier", "Knight", "Samurai", "Ninja", "Gladiator", "Crusader", "Paladin", "Sorcerer", "Necromancer", "Dragon Knight", "Warlord", "Emperor", "Immortal Sage", "Storm Titan", "Death Reaper", "Celestial King", "Cosmos Emperor", "Astral Sovereign", "Void Titan", "Eternal Seraph", "Omniverse God",
	"Eclipse Monarch", "Chrono Warden", "Genesis Prime", "Aether Regent", "Author of Worlds",
	"Sunforged", "Storm Herald", "Abyss Sovereign", "Crimson Colossus", "Shard Prophet", "Elder Warden", "Void Empress", "Dragon Ascendant", "Primordial", "The Infinite",
	"Sovereign of Nothing", "The Hollow Crown", "World-Eater", "Shepherd of Suns", "The Last Idea"]
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
	"Day and night fight over which one gets to be your shadow.",
	"Every second you ever wasted has been counted, and billed.",
	"The first green thing, and the last thing left standing.",
	"Reality is a rumour you started and never denied.",
	"Every world in the wilds is a line you have already written.",
	"A star fell into a forge and refused to cool.",
	"The sky answers whenever it raises a hand.",
	"Something with too many eyes has decided you float.",
	"It does not duel. It demolishes.",
	"Every possible future is a splinter in its hand.",
	"It remembers when this arena was a forest.",
	"She keeps whole civilisations in her pockets.",
	"The last thing many worlds ever saw. Twice.",
	"It was here before the word 'here'.",
	"You have finally found the edge of the map. It is holding them.",
	"Nothing is left for it to kneel to.",
	"Its crown is the hole where a world used to be.",
	"It eats planets the way you eat berries.",
	"Every sun it owns is still burning, for it.",
	"When it forgets you, you will stop having been."]
const XP_AT := [0.0, 50.0, 176.0, 364.0, 612.0, 913.0, 1267.0, 1674.0, 2128.0, 2630.0, 3181.0, 3775.0, 4415.0, 5099.0, 5827.0, 6597.0, 7411.0, 8266.0, 9160.0, 10096.0, 11077.0, 12103.0, 13183.0, 14317.0, 15498.0, 16722.0, 17982.0, 19296.0, 20664.0, 22086.0, 23562.0, 25092.0, 26676.0, 28576.0, 30626.0, 32826.0, 35176.0, 37676.0, 40326.0, 43126.0, 46076.0, 49176.0, 52426.0, 72000.0, 120000.0, 250000.0, 550000.0, 999999.0]
const COL1 := [Color("8a5a3a"), Color("7a8f3a"), Color("4f8f3a"), Color("b5532f"), Color("9a8a6a"), Color("6b5a4a"), Color("7a4a2a"), Color("3f6fa8"), Color("8d9bb0"), Color("a83232"), Color("2c2c3c"), Color("c9a06a"), Color("e8e8ee"), Color("d4b13a"), Color("6d3fb5"), Color("2f1f3f"), Color("8f1d2c"), Color("4a2a2a"), Color("e0b020"), Color("6a4fae"), Color("2f6f9e"), Color("221c2c"), Color("e8e2c8"), Color("241242"), Color("22407f"), Color("120e1c"), Color("efe6cc"), Color("f2c84a"),
	Color("141018"), Color("43301a"), Color("143a28"), Color("3a1440"), Color("f7f4ec"),
	Color("7a2a08"), Color("1b2a5a"), Color("07222a"), Color("5a0a0a"), Color("3f4a5e"), Color("2f3d18"), Color("1a0a24"), Color("6a1010"), Color("120a2e"), Color("f4eaff"), Color("2a1c33"), Color("33240a"), Color("3a1a12"), Color("1c2a3a"), Color("2e0f2e")]
const COL2 := [Color("f1e2c6"), Color("e8d27a"), Color("e4a43a"), Color("2e8bd6"), Color("7a3b2a"), Color("b0b0b8"), Color("c8b88a"), Color("e0e0e8"), Color("d94b4b"), Color("e8c15a"), Color("b04bff"), Color("c03030"), Color("d03030"), Color("5fa8ff"), Color("5de0ff"), Color("7cff8a"), Color("ff9a2a"), Color("ff6a2a"), Color("8a1010"), Color("59e0d0"), Color("ffe25a"), Color("b23a4a"), Color("ffd25a"), Color("b06aff"), Color("9fd8ff"), Color("8a4bff"), Color("ffe9a8"), Color("ffffff"),
	Color("eef2ff"), Color("6ff0dc"), Color("b6ff6a"), Color("ff9ae4"), Color("8fe4ff"),
	Color("ffc24a"), Color("7fe9ff"), Color("3affd0"), Color("ff6a3a"), Color("c9f4ff"), Color("a8f05a"), Color("d46aff"), Color("ffd25a"), Color("8affe0"), Color("ffd36a"), Color("ff7ad9"), Color("ffd166"), Color("ff8a5c"), Color("8fd0ff"), Color("f0a6ff")]
const SKIN := [Color("e0a878"), Color("f0c9a0"), Color("e8b98a"), Color("c98f62"), Color("f0c9a0"), Color("e0a878"), Color("f3d3b3"), Color("e9b890"), Color("f3d3b3"), Color("efc9a2"), Color("d9b38c"), Color("c98f62"), Color("f3d3b3"), Color("f5d9bc"), Color("f3d3b3"), Color("cfd8c8"), Color("d9a679"), Color("b98660"), Color("f0c9a0"), Color("e8c9a8"), Color("c9a27a"), Color("cfc8bc"), Color("f3d9bc"), Color("e0c9a8"), Color("e6d9f2"), Color("b8aec8"), Color("f7e9d2"), Color("f7e9d2"),
	Color("c9c2d8"), Color("d8c9a8"), Color("a8d8b0"), Color("f0d0e8"), Color("ffffff"),
	Color("e8b06a"), Color("cfd8f0"), Color("8fd8cf"), Color("d89a86"), Color("e6eef8"), Color("b8a878"), Color("c8b8e0"), Color("e0a070"), Color("9fb8d8"), Color("ffffff"), Color("f0d8ff"), Color("ffe6b0"), Color("ffc9a8"), Color("d8ecff"), Color("f4dcff")]
const HEAD := [0, 1, 2, 3, 4, 5, 6, 7, 7, 8, 9, 7, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 20, 17, 13, 22,
	23, 24, 25, 26, 27,
	28, 29, 30, 31, 32, 33, 34, 35, 36, 37,
	38, 39, 40, 41, 42]
const WEAPON := [0, 1, 2, 3, 4, 5, 5, 6, 6, 7, 7, 8, 9, 10, 11, 12, 14, 13, 15, 11, 16, 17, 18, 20, 21, 18, 23, 22,
	24, 25, 26, 27, 28,
	29, 30, 31, 32, 33, 34, 35, 36, 37, 38,
	39, 40, 41, 42, 43]
const SHIELD := [0, 0, 0, 0, 0, 1, 1, 2, 3, 0, 0, 1, 4, 3, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 2, 3, 0,
	0, 0, 0, 0, 0,
	0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
	0, 0, 0, 0, 0]
const CAPE := [0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
	1, 1, 1, 1, 1,
	1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
	1, 1, 1, 1, 1]
const PAULD := [0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 1, 1, 1, 0, 0, 2, 2, 2, 0, 2, 0, 2, 2, 2, 2, 0, 2,
	2, 2, 2, 2, 2,
	2, 2, 2, 2, 2, 2, 2, 2, 2, 2,
	2, 2, 2, 2, 2]
# 1 = feathered wings (Eternal Seraph only)
const WINGS := [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0,
	0, 0, 0, 0, 0,
	0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
	0, 0, 0, 0, 0]
# 1 = carries a blade in each hand
const DUAL := [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
	1, 1, 1, 1, 1]
# The weapon's own shape, part by part. Each part is
# [x0, y0, x1, y1, half_width] in weapon frame units: x runs along the
# weapon, y across it, and the centre line sits at y = 0.5. The killing
# ground is built from these parts, so what kills you is the blade you can
# actually see.
const WEAPON_PARTS := [
	[[0.5, 0.5, 1.6, 0.5, 0.10], [1.43, 0.5, 2.27, 0.5, 0.30]],           # 0 club
	[[1.8, 0.5, 2.35, 0.5, 0.10]],                                         # 1 dagger
	[[1.95, 0.5, 2.05, 0.5, 0.10], [2.2, 0.5, 2.95, 0.5, 0.15]],            # 2 sword
	[[0.5, 0.5, 1.5, 0.5, 0.06], [1.3, 0.5, 1.95, 0.5, 0.45]],             # 3 axe
	[[1.72, 0.5, 1.72, 0.5, 0.35], [1.7, 0.2, 2.45, 0.2, 0.06],
		[1.7, 0.5, 2.45, 0.5, 0.06], [1.7, 0.8, 2.45, 0.8, 0.06]],         # 4 trident
	[[0.5, 0.5, 1.6, 0.5, 0.06], [1.35, 0.5, 2.1, 0.5, 0.55]],             # 5 mace
	[[0.96, 0.5, 0.96, 0.5, 0.375], [0.95, 0.5, 2.45, 0.5, 0.10]],          # 6 cleaver
	[[0.97, 0.5, 0.97, 0.5, 0.14], [0.95, 0.5, 2.65, 0.5, 0.08]],          # 7 saber
	[[0.5, 0.5, 2.1, 0.5, 0.05], [2.1, 0.1, 2.8, 0.1, 0.06],
		[2.1, 0.9, 2.8, 0.9, 0.06], [2.1, 0.1, 2.1, 0.9, 0.06],
		[2.1, 0.5, 2.95, 0.5, 0.06]],                                      # 8 pitchfork
	[[0.5, 0.5, 1.6, 0.5, 0.07], [1.4, 0.5, 2.4, 0.5, 0.50]],              # 9 mace ball
	[[0.5, 0.5, 1.9, 0.5, 0.07], [1.75, 0.5, 2.4, 0.5, 0.50]],             # 10 greatsword
	[[0.5, 0.5, 2.4, 0.5, 0.05], [2.25, 0.5, 2.85, 0.5, 0.30]],           # 11 orb staff
	[[0.5, 0.5, 2.3, 0.5, 0.05], [2.1, 0.5, 2.5, 0.1, 0.07],
		[1.55, -0.6, 2.2, -0.35, 0.07]],                                   # 12 scythe
	[[0.97, 0.5, 0.97, 0.5, 0.50], [0.95, 0.5, 3.3, 0.5, 0.16]],           # 13 big sword
	[[0.97, 0.5, 0.97, 0.5, 0.50], [0.95, 0.5, 3.3, 0.5, 0.16]],           # 14 flame sword
	[[2.59, 0.5, 2.59, 0.5, 0.31], [2.6, 0.5, 3.55, 0.5, 0.20]],           # 15 emperor blade
	[[2.4, 0.5, 2.4, 0.5, 0.33], [2.45, 0.5, 3.3, 0.5, 0.14]],            # 16 rapier
	[[0.5, 0.5, 3.0, 0.5, 0.05], [2.85, 0.5, 3.45, 0.2, 0.08],
		[2.6, -0.45, 3.1, -0.25, 0.08]],                                 # 17 warlord blade
	[[2.54, 0.5, 2.54, 0.5, 0.30], [2.6, 0.5, 3.3, 0.2, 0.08],
		[2.6, 0.5, 3.3, 0.8, 0.08]],                                      # 18 twin blade
	[[0.97, 0.5, 0.97, 0.5, 0.575], [0.95, 0.5, 3.7, 0.5, 0.20]],          # 19 god blade
	[[0.45, 0.5, 2.45, 0.5, 0.06],
		[3.17, 0.5, 3.047, 0.797, 0.05], [3.047, 0.797, 2.75, 0.92, 0.05],
		[2.75, 0.92, 2.453, 0.797, 0.05], [2.453, 0.797, 2.33, 0.5, 0.05],
		[2.33, 0.5, 2.453, 0.203, 0.05], [2.453, 0.203, 2.75, 0.08, 0.05],
		[2.75, 0.08, 3.047, 0.203, 0.05], [3.047, 0.203, 3.17, 0.5, 0.05],
		[2.75, 0.5, 2.75, 0.5, 0.22]],                                     # 20 cosmic sceptre
	[[0.45, 0.5, 2.6, 0.5, 0.05],
		[2.55, 0.18, 2.55, 0.82, 0.06],
		[2.6, 0.5, 3.5, 0.03, 0.12], [2.6, 0.5, 3.5, 0.97, 0.12]],          # 21 astral glaive
	[[0.3, 0.5, 1.0, 0.5, 0.08],
		[0.95, 0.05, 0.95, 0.95, 0.09],
		[0.95, 0.5, 2.3, 0.5, 0.18], [2.2, 0.5, 3.2, 0.5, 0.12],
		[3.1, 0.5, 3.95, 0.5, 0.07]],                                      # 22 omniverse blade
	[[0.32, 0.5, 0.95, 0.5, 0.06],
		[0.95, 0.16, 0.95, 0.84, 0.075],
		[0.98, 0.5, 3.25, 0.5, 0.175], [3.25, 0.5, 3.6, 0.5, 0.05]],        # 23 holy sword
	[[0.3, 0.5, 1.0, 0.5, 0.08],
		[0.97, 0.06, 0.97, 0.94, 0.08],
		[0.97, 0.5, 2.9, 0.5, 0.14], [2.85, 0.5, 3.9, 0.5, 0.07]],          # 24 eclipse blade
	[[0.45, 0.5, 3.0, 0.5, 0.05],
		[3.0, 0.5, 3.45, 0.5, 0.06],
		[2.55, 0.5, 3.3, 0.18, 0.13], [2.55, 0.5, 3.2, 0.8, 0.11],
		[1.9, 0.5, 1.9, 0.5, 0.16]],                                       # 25 chrono halberd
	[[0.45, 0.5, 3.1, 0.5, 0.045],
		[3.0, 0.5, 4.0, 0.5, 0.16],
		[2.55, 0.5, 3.0, 0.18, 0.09], [2.55, 0.5, 3.0, 0.82, 0.09]],        # 26 genesis spear
	[[0.35, 0.5, 0.95, 0.5, 0.07],
		[0.95, 0.5, 1.5, 0.18, 0.10], [0.95, 0.5, 1.5, 0.82, 0.10],
		[1.0, 0.5, 2.6, 0.5, 0.17], [2.5, 0.5, 3.75, 0.5, 0.10]],           # 27 aether warblade
	[[0.3, 0.5, 3.7, 0.5, 0.05],
		[1.6, 0.5, 3.5, 0.5, 0.42],
		[3.6, 0.5, 4.15, 0.5, 0.10]],                                      # 28 quill of creation
	[[0.35, 0.5, 1.0, 0.5, 0.065],
		[1.0, 0.5, 2.5, 0.5, 0.24], [2.4, 0.5, 3.55, 0.5, 0.13]],          # 29 sun cleaver
	[[0.4, 0.5, 2.2, 0.5, 0.045],
		[2.1, 0.5, 3.3, 0.5, 0.18], [3.2, 0.5, 3.75, 0.5, 0.07]],          # 30 storm glaive
	[[0.4, 0.5, 3.05, 0.5, 0.04],
		[3.0, 0.08, 3.0, 0.92, 0.06],
		[3.0, 0.08, 3.72, 0.08, 0.055], [3.0, 0.5, 3.85, 0.5, 0.055],
		[3.0, 0.92, 3.72, 0.92, 0.055]],                                    # 31 abyss trident
	[[0.35, 0.5, 2.55, 0.5, 0.05],
		[2.35, 0.5, 3.4, 0.25, 0.16], [2.35, 0.5, 3.4, 0.75, 0.16]],        # 32 colossus axe
	[[0.35, 0.5, 0.95, 0.5, 0.05],
		[0.95, 0.44, 0.95, 0.56, 0.06],
		[0.95, 0.5, 3.3, 0.5, 0.11], [2.6, 0.5, 3.45, 0.5, 0.1]],           # 33 shard blade
	[[0.35, 0.5, 2.1, 0.5, 0.045],
		[2.05, 0.5, 3.42, 0.5, 0.17],
		[1.55, 0.18, 1.95, 0.18, 0.09]],                                    # 34 bough blade
	[[0.3, 0.5, 3.1, 0.5, 0.04],
		[3.0, 0.5, 3.7, 0.34, 0.14], [3.4, 0.24, 3.85, 0.4, 0.09]],         # 35 void scythe
	[[0.35, 0.5, 1.0, 0.5, 0.06],
		[0.95, 0.18, 0.95, 0.82, 0.08],
		[0.98, 0.5, 3.35, 0.5, 0.13], [3.3, 0.5, 3.62, 0.5, 0.05]],         # 36 dragon fang
	[[0.35, 0.5, 0.9, 0.5, 0.06],
		[1.5, 0.5, 1.5, 0.5, 0.42],
		[1.9, 0.5, 3.2, 0.5, 0.12], [3.15, 0.5, 3.55, 0.5, 0.06]],          # 37 primordial blade
	[[0.35, 0.5, 0.95, 0.5, 0.05],
		[0.95, 0.14, 0.95, 0.86, 0.09],
		[0.95, 0.5, 3.5, 0.5, 0.1], [3.4, 0.5, 3.9, 0.5, 0.06]],            # 38 infinite blade

	# ---- Test Range only: the five above The Infinite ----
	[[0.3, 0.5, 3.0, 0.5, 0.035],
		[2.95, 0.2, 2.95, 0.8, 0.05],
		[2.28, 0.5, 3.0, 0.5, 0.15], [3.0, 0.5, 3.75, 0.5, 0.09]],          # 39 nothing blade
	[[0.35, 0.5, 0.98, 0.5, 0.07],
		[0.98, 0.16, 0.98, 0.84, 0.09],
		[0.5, 0.5, 1.05, 0.2, 0.10], [0.5, 0.5, 1.05, 0.8, 0.10],
		[1.0, 0.42, 2.9, 0.42, 0.11], [1.0, 0.58, 2.9, 0.58, 0.11],
		[2.95, 0.3, 3.55, 0.4, 0.07], [2.95, 0.7, 3.55, 0.6, 0.07]],         # 40 hollow crown
	[[0.4, 0.5, 3.3, 0.5, 0.13],
		[3.2, 0.5, 4.2, 0.36, 0.26], [3.2, 0.5, 4.2, 0.64, 0.26]],           # 41 world-eater
	[[0.35, 0.5, 3.1, 0.5, 0.04],
		[3.05, 0.12, 3.05, 0.88, 0.05],
		[2.05, 0.08, 2.05, 0.92, 0.05],
		[1.05, 0.16, 1.05, 0.84, 0.05],
		[0.7, 0.3, 1.6, 0.3, 0.06], [1.6, 0.5, 2.5, 0.5, 0.06], [2.5, 0.7, 3.3, 0.7, 0.06]],  # 42 sun shepherd
	[[0.3, 0.5, 2.8, 0.5, 0.045],
		[0.75, 0.5, 0.75, 0.5, 0.46],
		[1.75, 0.5, 1.75, 0.5, 0.52],
		[2.75, 0.5, 2.75, 0.5, 0.50],
		[2.8, 0.5, 3.5, 0.5, 0.14]],                                         # 43 the last idea
]
const OL := Color(0.12, 0.07, 0.07)
const STEEL := Color(0.8, 0.84, 0.92)


static func orb_body(e: int) -> bool:
	# does this body wear rings of floating orbs?
	return e >= ORB_FROM and e < TOTAL


static func orb_count(e: int) -> int:
	if not orb_body(e):
		return 0
	return 6 if is_top_rank(e) else 4


static func orb_radius(e: int) -> float:
	# how far out from the centre the orbs circle, in body radii
	return 1.9 + 0.9 * float(maxi(e - TOP_FROM, 0))


static func orb_positions(e: int, r: float, t: float) -> Array:
	# where each orb sits right now, relative to the body's centre. Purely
	# cosmetic: nothing reads these positions for damage.
	var out: Array = []
	var n := orb_count(e)
	if n == 0:
		return out
	if e == TOP_FROM - 1:
		# The Infinite already spins a second, tighter ring the other way
		for k in range(n):
			out.append(Vector2.from_angle(t * 1.4 + TAU * float(k) / float(n)) * r * 1.9)
		return out
	var spin := t * (0.9 if is_top_rank(e) else 1.4)
	var dist := orb_radius(e) * r
	for k in range(n):
		out.append(Vector2.from_angle(spin + TAU * float(k) / float(n)) * dist)
	return out


static func orb_draw_radius(e: int, r: float) -> float:
	# the drawn size of one orb, as a radius
	return r * (0.085 if is_top_rank(e) else 0.11)


static func draw_orbs(ci: CanvasItem, e: int, r: float, t: float, ac: Color) -> void:
	# purely decorative: nothing here can hurt anyone
	if not orb_body(e):
		return
	if e >= 30:
		var hr := orb_draw_radius(e, r) * 0.7
		var ops := orb_positions(e, r, t)
		var limit := mini(ops.size(), 6)
		for i in range(limit):
			var op := ops[i]
			ci.draw_circle(op, hr, Color(ac.r, ac.g, ac.b, 0.7))
			ci.draw_circle(op, hr * 0.4, Color(1, 1, 1, 0.8))
		return
	var hr := orb_draw_radius(e, r)
	for op in orb_positions(e, r, t):
		ci.draw_circle(op, hr, Color(ac.r, ac.g, ac.b, 0.8))
		ci.draw_circle(op, hr * 0.45, Color(1, 1, 1, 0.9))


static func radius_base(i: int) -> float:
	if i >= TOP_FROM:
		# the five newest ranks: each one a real step up again
		return 200.0 + 40.0 * float(i - TOP_FROM)
	var base := 22.0 + 2.6 * float(i)
	if i > 32:
		# the last ten grow faster than the rest: every one is a step up
		base += 0.9 * float(i - 32)
	return base


static func speed_base(i: int) -> float:
	if i >= TOP_FROM:
		return 88.0 - 6.0 * float(i - TOP_FROM)
	if i > 32:
		return 158.0 - 1.1 * float(i - 32)
	return 270.0 - 3.5 * float(i)


static func is_dual(e: int) -> bool:
	return DUAL[clampi(e, 0, TOTAL - 1)] > 0


static func is_top_rank(e: int) -> bool:
	# the five newest ranks, 44 to 48
	return e >= TOP_FROM and e < TOTAL


static func weapon_parts(e: int) -> Array:
	# the drawn shape of this weapon, part by part
	return WEAPON_PARTS[WEAPON[e]]


static func max_hp_for(i: int) -> float:
	return 40.0 + 14.0 * float(i)


static func dmg_for(i: int) -> float:
	return 7.0 + 2.4 * float(i)


static func evo_for_xp(xp: float) -> int:
	var e := 0
	for i in range(TOTAL):
		var need: float = XP_AT[i]
		if xp >= need:
			e = i
	return e


static func capped_for_mode(e: int, _mode: String) -> int:
	# every tier is part of the normal climb now
	return clampi(e, 0, TOTAL - 1)


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


static func _wings(ci: CanvasItem, r: float, t: float, lw: float) -> void:
	# a pair of feathered wings, sweeping back and beating slowly
	var flap := sin(t * 2.1) * 0.1
	var lit := Color(0.99, 0.97, 0.9)
	var shade := Color(0.85, 0.89, 0.98)
	for s in range(2):
		var side := -1.0 + float(s) * 2.0
		for k in range(3):
			var f := float(k)
			var spread := 0.5 + 0.32 * f + flap * (1.0 + 0.3 * f)
			var reach := 1.15 + 0.4 * f
			var root := Vector2(-0.15 * r, side * (0.28 + 0.2 * f) * r)
			var b1 := Vector2(-0.62 * r, side * (0.16 + 0.22 * f) * r)
			var b2 := Vector2(-1.05 * r, side * (spread * 0.55) * r)
			var tip := Vector2(-reach * r, side * spread * r)
			_fill(ci, PackedVector2Array([root, b1, b2, tip]), lit if k == 0 else shade, OL, lw * 0.8)
			ci.draw_line(b1, tip, Color(0.72, 0.77, 0.92, 0.7), lw * 0.5, true)


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
	var simple := evo >= 24
	var skin: Color = SKIN[evo]
	var lw := maxf(r * 0.09, 2.0) if not simple else maxf(r * 0.06, 1.4)
	var pv := Vector2(0, 0.8 * r)
	var big: float = 1.0 + float(evo) * 0.03
	ci.draw_colored_polygon(_ellipse(0.1 * r, 0.2 * r, 1.0 * r * big, 1.1 * r * big, 0.0, 12 if simple else 18), Color(0, 0, 0, 0.17))
	if evo >= 16 and not simple:
		var pu := 0.5 + 0.5 * sin(t * 3.0)
		var ac: Color = c2
		ci.draw_circle(Vector2.ZERO, r * (1.5 + 0.1 * pu), Color(ac.r, ac.g, ac.b, 0.12))
		ci.draw_arc(Vector2.ZERO, r * (1.5 + 0.1 * pu), 0.0, TAU, 18, Color(ac.r, ac.g, ac.b, 0.4), 1.5, true)
		if evo >= 21:
			ci.draw_arc(Vector2.ZERO, r * (1.15 + 0.08 * pu), 0.0, TAU, 14, Color(ac.r, ac.g, ac.b, 0.25), 0.9, true)
		draw_orbs(ci, evo, r, t, ac)
	elif evo >= 16 and simple:
		var pu := 0.5 + 0.5 * sin(t * 3.0)
		var ac: Color = c2
		ci.draw_arc(Vector2.ZERO, r * (1.3 + 0.05 * pu), 0.0, TAU, 10, Color(ac.r, ac.g, ac.b, 0.25), 1.2, true)
		draw_orbs(ci, evo, r, t, ac)
		if evo == COUNT - 1:
			ci.draw_arc(Vector2.ZERO, r * (1.7 + 0.08 * pu), 0.0, TAU, 14, Color(ac.r, ac.g, ac.b, 0.35), 1.4, true)
			for k in range(3):
				var oa2 := -t * 1.9 + TAU * float(k) / 3.0
				var op2 := Vector2.from_angle(oa2) * r * 1.95
				ci.draw_circle(op2, r * 0.07, Color(1, 1, 1, 0.85))
				ci.draw_circle(op2, r * 0.035, Color(ac.r, ac.g, ac.b))
	if WINGS[evo] > 0:
		_wings(ci, r, t, lw)
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
	var dual: bool = DUAL[evo] > 0
	var two_hand: bool = WEAPON[evo] >= 13 and not dual
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
	if dual:
		# the second blade: the same weapon, turned half a circle around the
		# body, so the pair covers both sides at once
		var pv2 := -pv
		var hand2 := _wp(pv2, swing + PI, r, 0.8, 0.5)
		_arm(ci, r, pv2, hand2, c1, skin if not armored else Color(0.55, 0.58, 0.65), lw)
		_weapon(ci, r, WEAPON[evo], pv2, swing + PI, t, c1, c2, lw)
		ci.draw_circle(hand2, r * 0.17 + lw * 0.6, OL)
		ci.draw_circle(hand2, r * 0.17, skin if not armored else Color(0.55, 0.58, 0.65))


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
		22:
			# the last face in the game: a crown of pure light, not a mask
			_fill(ci, _ellipse(hx, 0, 0.6 * r, 0.58 * r, 0.0, 24), Color(1.0, 0.98, 0.9), OL, lw)
			ci.draw_arc(Vector2(hx, 0), 0.92 * r, 0.0, TAU, 40, Color(1.0, 0.94, 0.6, 0.9), r * 0.1, true)
			ci.draw_arc(Vector2(hx, 0), 1.16 * r, 0.0, TAU, 44, Color(1.0, 0.86, 0.36, 0.35), r * 0.05, true)
			for k in range(10):
				var a7 := TAU * float(k) / 10.0 + t * 0.35
				var d7 := Vector2.from_angle(a7)
				var q7 := Vector2(hx, 0) + d7 * 0.92 * r
				var pq7 := Vector2(-d7.y, d7.x)
				_fill(ci, PackedVector2Array([q7 + pq7 * 0.07 * r, q7 + d7 * 0.32 * r, q7 - pq7 * 0.07 * r]), Color(1.0, 0.9, 0.45), OL, lw * 0.5)
			ci.draw_circle(Vector2(hx + 0.3 * r, 0), r * 0.15, Color(1, 1, 0.92))
			ci.draw_circle(Vector2(hx + 0.34 * r, 0), r * 0.08, Color(1.0, 0.84, 0.2))
		23:
			# eclipse: a black sun with a white rim, and a pale face inside it
			_fill(ci, _ellipse(hx, 0, 0.68 * r, 0.66 * r, 0.0, 26), Color(0.05, 0.04, 0.08), OL, lw)
			ci.draw_arc(Vector2(hx, 0), 0.72 * r, 0.0, TAU, 44, Color(0.95, 0.97, 1.0, 0.95), r * 0.09, true)
			ci.draw_arc(Vector2(hx, 0), 0.96 * r, 0.0, TAU, 48, Color(1, 1, 1, 0.32), r * 0.05, true)
			for k in range(8):
				var a9 := t * 0.5 + TAU * float(k) / 8.0
				var d9 := Vector2.from_angle(a9)
				var q9 := Vector2(hx, 0) + d9 * 1.02 * r
				var pq9 := Vector2(-d9.y, d9.x)
				_fill(ci, PackedVector2Array([q9 + pq9 * 0.05 * r, q9 + d9 * 0.22 * r, q9 - pq9 * 0.05 * r]), Color(0.95, 0.97, 1.0), OL, lw * 0.4)
			ci.draw_circle(Vector2(hx + 0.24 * r, 0), r * 0.2, Color(0.9, 0.92, 1.0))
			ci.draw_line(Vector2(hx + 0.14 * r, -0.12 * r), Vector2(hx + 0.42 * r, -0.06 * r), Color(0.05, 0.04, 0.08), r * 0.06, true)
			ci.draw_line(Vector2(hx + 0.14 * r, 0.12 * r), Vector2(hx + 0.42 * r, 0.06 * r), Color(0.05, 0.04, 0.08), r * 0.06, true)
		24:
			# chrono: a brass clock ring around the head, hands still turning
			_head(ci, r, skin, hair, lw)
			ci.draw_arc(Vector2(hx, 0), 0.95 * r, 0.0, TAU, 46, Color(0.85, 0.7, 0.35), r * 0.12, true)
			for k in range(12):
				var a10 := TAU * float(k) / 12.0
				var d10 := Vector2.from_angle(a10)
				ci.draw_circle(Vector2(hx, 0) + d10 * 0.95 * r, r * 0.05, Color(0.98, 0.9, 0.6))
			ci.draw_line(Vector2(hx, 0), Vector2(hx, 0) + Vector2.from_angle(-t * 0.9) * 0.7 * r, Color(0.92, 1.0, 0.99), r * 0.08, true)
			ci.draw_line(Vector2(hx, 0), Vector2(hx, 0) + Vector2.from_angle(-t * 2.4) * 0.95 * r, c2, r * 0.05, true)
			ci.draw_circle(Vector2(hx, 0), r * 0.1, Color(1, 1, 1))
			ci.draw_circle(Vector2(hx, 0), r * 0.05, Color(0.4, 0.3, 0.15))
		25:
			# genesis: a crown of leaves around a seed of light
			_head(ci, r, skin, hair, lw)
			for s in range(2):
				var side := -1.0 + float(s) * 2.0
				for k in range(4):
					var a11 := -1.4 + float(k) * 0.42
					var d11 := Vector2(cos(a11), sin(a11) * side)
					var q11 := Vector2(hx - 0.1 * r, 0) + d11 * 0.62 * r
					_fill(ci, _ellipse(q11.x, q11.y, 0.17 * r, 0.075 * r, a11, 10), Color(0.45, 0.85, 0.35), OL, lw * 0.6)
			ci.draw_circle(Vector2(hx + 0.1 * r, 0), r * 0.17, Color(0.55, 1.0, 0.5))
			ci.draw_circle(Vector2(hx + 0.1 * r, 0), r * 0.09, Color(1, 1, 1, 0.92))
		26:
			# aether: a smooth pale mask trailing ribbons of light
			_fill(ci, _ellipse(hx, 0, 0.56 * r, 0.54 * r, 0.0, 24), Color(0.98, 0.95, 1.0), OL, lw)
			ci.draw_line(Vector2(hx + 0.18 * r, -0.15 * r), Vector2(hx + 0.46 * r, -0.08 * r), c1.darkened(0.05), r * 0.09, true)
			ci.draw_line(Vector2(hx + 0.18 * r, 0.15 * r), Vector2(hx + 0.46 * r, 0.08 * r), c1.darkened(0.05), r * 0.09, true)
			ci.draw_circle(Vector2(hx + 0.3 * r, 0), r * 0.05, c2)
			for s in range(2):
				var side := -1.0 + float(s) * 2.0
				_fill(ci, PackedVector2Array([
					Vector2(hx - 0.3 * r, side * 0.32 * r),
					Vector2(hx - 1.05 * r, side * 0.5 * r + wv),
					Vector2(hx - 1.45 * r, side * 0.95 * r + wv * 1.4),
					Vector2(hx - 1.15 * r, side * 0.82 * r + wv * 0.8),
					Vector2(hx - 0.5 * r, side * 0.52 * r)]), c2, OL, lw * 0.6)
		27:
			# the author: an open book hangs behind a luminous face
			for s in range(2):
				var side := -1.0 + float(s) * 2.0
				_fill(ci, PackedVector2Array([
					Vector2(hx - 0.05 * r, 0),
					Vector2(hx - 0.6 * r, side * 0.95 * r),
					Vector2(hx + 0.02 * r, side * 0.84 * r),
					Vector2(hx + 0.55 * r, side * 0.76 * r)]), Color(1.0, 0.99, 0.93), OL, lw * 0.8)
				ci.draw_line(Vector2(hx - 0.05 * r, 0), Vector2(hx + 0.05 * r, side * 0.86 * r), Color(0.7, 0.76, 0.9), lw * 0.5, true)
			_fill(ci, _ellipse(hx, 0, 0.54 * r, 0.52 * r, 0.0, 24), Color(1.0, 1.0, 0.98), OL, lw)
			ci.draw_circle(Vector2(hx + 0.2 * r, -0.16 * r), r * 0.07, Color(0.3, 0.72, 0.9))
			ci.draw_circle(Vector2(hx + 0.2 * r, 0.16 * r), r * 0.07, Color(0.3, 0.72, 0.9))
			ci.draw_arc(Vector2(hx, 0), 0.7 * r, 0.0, TAU, 40, Color(1.0, 0.9, 0.5, 0.9), r * 0.07, true)
			ci.draw_arc(Vector2(hx, 0), 0.88 * r, 0.0, TAU, 44, Color(0.6, 0.9, 1.0, 0.5), r * 0.04, true)

		28:
			# sunforged: a burning sun disc behind the face
			var sf := 0.5 + 0.5 * sin(t * 2.4)
			_head(ci, r, skin, hair, lw)
			ci.draw_circle(Vector2(hx, 0), r * (1.02 + 0.05 * sf), Color(1.0, 0.72, 0.2, 0.32))
			for k in range(12):
				var a12 := TAU * float(k) / 12.0 + t * 0.25
				var d12 := Vector2.from_angle(a12)
				var q12 := Vector2(hx, 0) + d12 * 0.95 * r
				var pq12 := Vector2(-d12.y, d12.x)
				_fill(ci, PackedVector2Array([q12 + pq12 * 0.09 * r, q12 + d12 * 0.44 * r, q12 - pq12 * 0.09 * r]), Color(1.0, 0.78 + 0.2 * sf, 0.25), OL, lw * 0.5)
			_fill(ci, _ellipse(hx, 0, 0.52 * r, 0.5 * r, 0.0, 24), Color(1.0, 0.93, 0.7), OL, lw)
			ci.draw_line(Vector2(hx + 0.12 * r, -0.16 * r), Vector2(hx + 0.44 * r, -0.1 * r), Color(0.55, 0.16, 0.03), r * 0.08, true)
			ci.draw_line(Vector2(hx + 0.12 * r, 0.16 * r), Vector2(hx + 0.44 * r, 0.1 * r), Color(0.55, 0.16, 0.03), r * 0.08, true)
		29:
			# storm: twin lightning bolts for horns
			_head(ci, r, skin, hair, lw)
			for s in range(2):
				var side := -1.0 + float(s) * 2.0
				_fill(ci, PackedVector2Array([
					Vector2(hx - 0.35 * r, side * 0.35 * r),
					Vector2(hx - 0.62 * r, side * 1.05 * r),
					Vector2(hx - 0.42 * r, side * 0.95 * r),
					Vector2(hx - 0.78 * r, side * 1.62 * r),
					Vector2(hx - 0.2 * r, side * 0.95 * r),
					Vector2(hx - 0.4 * r, side * 0.85 * r)]), Color(0.75, 0.95, 1.0), OL, lw * 0.7)
			ci.draw_arc(Vector2(hx, 0), 0.62 * r, -0.9, 0.9, 16, c2, r * 0.09, true)
			ci.draw_circle(Vector2(hx + 0.28 * r, -0.14 * r), r * 0.07, Color(0.85, 1.0, 1.0))
			ci.draw_circle(Vector2(hx + 0.28 * r, 0.14 * r), r * 0.07, Color(0.85, 1.0, 1.0))
		30:
			# abyss: a mask with too many eyes and trailing tendrils
			_fill(ci, _ellipse(hx, 0, 0.58 * r, 0.56 * r, 0.0, 24), Color(0.05, 0.18, 0.2), OL, lw)
			for k in range(3):
				var ey := (float(k) - 1.0) * 0.24 * r
				ci.draw_circle(Vector2(hx + 0.3 * r, ey), r * 0.075, Color(0.4, 1.0, 0.85))
				ci.draw_circle(Vector2(hx + 0.32 * r, ey), r * 0.035, Color(1, 1, 1))
			for k in range(4):
				var tx := hx - 0.5 * r + float(k) * 0.12 * r
				var wob := sin(t * 3.0 + float(k)) * 0.12 * r
				ci.draw_line(Vector2(tx, 0.42 * r), Vector2(tx - 0.15 * r, (1.1 + 0.1 * float(k)) * r + wob), Color(0.3, 0.95, 0.8, 0.85), r * 0.06, true)
		31:
			# colossus: a brute helm with two swept horns and a slit visor
			_fill(ci, _ellipse(hx, 0, 0.58 * r, 0.56 * r, 0.0, 24), Color(0.35, 0.08, 0.08), OL, lw)
			for s in range(2):
				var side := -1.0 + float(s) * 2.0
				_fill(ci, PackedVector2Array([
					Vector2(hx + 0.0, side * 0.42 * r),
					Vector2(hx - 0.45 * r, side * 0.9 * r),
					Vector2(hx - 1.15 * r, side * 1.02 * r),
					Vector2(hx - 0.72 * r, side * 0.6 * r),
					Vector2(hx - 0.1 * r, side * 0.24 * r)]), Color(0.92, 0.86, 0.7), OL, lw * 0.8)
			ci.draw_rect(Rect2(hx + 0.1 * r, -0.1 * r, 0.44 * r, 0.2 * r), Color(0.05, 0.02, 0.02))
			ci.draw_rect(Rect2(hx + 0.14 * r, -0.05 * r, 0.36 * r, 0.1 * r), Color(1.0, 0.35, 0.15))
		32:
			# shard: crystals orbiting a calm face
			_head(ci, r, skin, hair, lw)
			for k in range(6):
				var a13 := t * 0.6 + TAU * float(k) / 6.0
				var d13 := Vector2.from_angle(a13)
				var q13 := Vector2(hx, 0) + d13 * 0.95 * r
				var pq13 := Vector2(-d13.y, d13.x)
				_fill(ci, PackedVector2Array([q13 + d13 * 0.26 * r, q13 + pq13 * 0.11 * r, q13 - d13 * 0.12 * r, q13 - pq13 * 0.11 * r]), Color(0.85, 0.97, 1.0, 0.95), OL, lw * 0.6)
			ci.draw_line(Vector2(hx + 0.15 * r, -0.12 * r), Vector2(hx + 0.45 * r, -0.08 * r), Color(0.25, 0.5, 0.7), r * 0.07, true)
			ci.draw_line(Vector2(hx + 0.15 * r, 0.12 * r), Vector2(hx + 0.45 * r, 0.08 * r), Color(0.25, 0.5, 0.7), r * 0.07, true)
		33:
			# elder: antlers grown out of the crown of the head
			_head(ci, r, skin, hair, lw)
			for s in range(2):
				var side := -1.0 + float(s) * 2.0
				var root := Vector2(hx - 0.1 * r, side * 0.35 * r)
				var tip := Vector2(hx - 0.55 * r, side * 1.15 * r)
				ci.draw_line(root, tip, Color(0.45, 0.33, 0.18), r * 0.09, true)
				for k in range(3):
					var f3 := 0.35 + 0.28 * float(k)
					var base := root.lerp(tip, f3)
					ci.draw_line(base, base + Vector2(-0.3 * r, side * 0.3 * r), Color(0.5, 0.37, 0.2), r * 0.055, true)
					_fill(ci, _ellipse(base.x - 0.34 * r, base.y + side * 0.34 * r, 0.12 * r, 0.06 * r, side * 0.6, 8), Color(0.45, 0.8, 0.3), OL, lw * 0.4)
		34:
			# void: spikes around a dark orb where the face should be
			_head(ci, r, skin, hair, lw)
			ci.draw_circle(Vector2(hx, 0), r * 0.3, Color(0.06, 0.02, 0.1))
			ci.draw_arc(Vector2(hx, 0), r * 0.3, 0.0, TAU, 24, c2, r * 0.06, true)
			ci.draw_circle(Vector2(hx - 0.1 * r, -0.1 * r), r * 0.06, Color(1, 1, 1, 0.85))
			for k in range(7):
				var a14 := PI + (float(k) - 3.0) * 0.42
				var d14 := Vector2.from_angle(a14)
				var q14 := Vector2(hx, 0) + d14 * 0.55 * r
				var pq14 := Vector2(-d14.y, d14.x)
				_fill(ci, PackedVector2Array([q14 + pq14 * 0.06 * r, q14 + d14 * 0.42 * r, q14 - pq14 * 0.06 * r]), c2, OL, lw * 0.5)
		35:
			# dragon: a skull helm with a snout, fangs and swept horns
			_fill(ci, _ellipse(hx, 0, 0.56 * r, 0.54 * r, 0.0, 24), Color(0.88, 0.84, 0.72), OL, lw)
			_fill(ci, PackedVector2Array([
				Vector2(hx + 0.3 * r, -0.34 * r), Vector2(hx + 0.95 * r, -0.16 * r),
				Vector2(hx + 1.0 * r, 0.02 * r), Vector2(hx + 0.3 * r, 0.3 * r)]), Color(0.8, 0.76, 0.64), OL, lw * 0.8)
			for k in range(3):
				var fy := (float(k) - 1.0) * 0.16 * r
				_fill(ci, PackedVector2Array([Vector2(hx + 0.78 * r, fy - 0.05 * r), Vector2(hx + 0.9 * r, fy), Vector2(hx + 0.78 * r, fy + 0.05 * r)]), Color(1, 1, 0.95), OL, lw * 0.4)
			ci.draw_circle(Vector2(hx + 0.45 * r, -0.14 * r), r * 0.07, Color(1.0, 0.35, 0.1))
			ci.draw_circle(Vector2(hx + 0.45 * r, 0.14 * r), r * 0.07, Color(1.0, 0.35, 0.1))
			for s in range(2):
				var side := -1.0 + float(s) * 2.0
				_fill(ci, PackedVector2Array([
					Vector2(hx + 0.1 * r, side * 0.4 * r), Vector2(hx - 0.3 * r, side * 0.95 * r),
					Vector2(hx - 0.95 * r, side * 1.1 * r), Vector2(hx - 0.5 * r, side * 0.7 * r),
					Vector2(hx - 0.05 * r, side * 0.3 * r)]), Color(0.95, 0.9, 0.78), OL, lw * 0.7)
		36:
			# primordial: one great eye above the head, ringed in light
			_head(ci, r, skin, hair, lw)
			var ga := Vector2(hx - 0.05 * r, 0)
			ci.draw_circle(ga, r * 0.62, Color(0.05, 0.02, 0.12, 0.8))
			ci.draw_arc(ga, r * 0.62, 0.0, TAU, 32, c2, r * 0.07, true)
			_fill(ci, _ellipse(ga.x, ga.y, r * 0.44, r * 0.26, 0.0, 20), Color(0.9, 1.0, 0.95), OL, lw * 0.7)
			ci.draw_circle(ga + Vector2(0.06 * r, 0), r * 0.17, c1.darkened(0.2))
			ci.draw_circle(ga + Vector2(0.06 * r, 0), r * 0.1, Color(0.02, 0.02, 0.05))
			ci.draw_circle(ga + Vector2(0.12 * r, -0.06 * r), r * 0.04, Color(1, 1, 1, 0.9))
		38:
			# sovereign of nothing: a hole in the air where a face should be
			_head(ci, r, skin, hair, lw)
			_fill(ci, _ellipse(hx, 0, 0.6 * r, 0.58 * r, 0.0, 24), Color(0.03, 0.02, 0.05), OL, lw)
			ci.draw_arc(Vector2(hx, 0), 0.6 * r, 0.0, TAU, 32, c2, r * 0.07, true)
			ci.draw_arc(Vector2(hx, 0), 0.44 * r, t * 1.2, t * 1.2 + 4.4, 20, Color(c2.r, c2.g, c2.b, 0.6), r * 0.04, true)
			for k in range(5):
				var a38 := -t * 0.9 + TAU * float(k) / 5.0
				ci.draw_circle(Vector2(hx, 0) + Vector2.from_angle(a38) * 0.76 * r, r * 0.045, Color(1, 1, 1, 0.85))
		39:
			# the hollow crown: a crown of gold spikes around a masked face
			_fill(ci, _ellipse(hx, 0, 0.54 * r, 0.52 * r, 0.0, 24), Color(0.95, 0.9, 0.7), OL, lw)
			for s39 in range(2):
				var side39 := -1.0 + float(s39) * 2.0
				ci.draw_line(Vector2(hx + 0.16 * r, side39 * 0.1 * r), Vector2(hx + 0.44 * r, side39 * 0.07 * r), Color(0.2, 0.16, 0.1), r * 0.06, true)
			for k in range(6):
				var a39 := PI + (float(k) - 2.5) * 0.42
				var d39 := Vector2.from_angle(a39)
				var q39 := Vector2(hx, 0) + d39 * 0.62 * r
				var pq39 := Vector2(-d39.y, d39.x)
				var tip39 := q39 + d39 * 0.34 * r
				_fill(ci, PackedVector2Array([
					q39 - pq39 * 0.09 * r, tip39,
					q39 + pq39 * 0.09 * r]), Color(1.0, 0.78, 0.2), OL, lw * 0.6)
			ci.draw_line(Vector2(hx, -0.5 * r), Vector2(hx, 0.5 * r), Color(0.3, 0.22, 0.1), r * 0.05, true)
		40:
			# world-eater: a maw of teeth under three hunting eyes
			_fill(ci, _ellipse(hx, 0, 0.6 * r, 0.56 * r, 0.0, 26), Color(0.12, 0.06, 0.06), OL, lw)
			ci.draw_circle(Vector2(hx + 0.2 * r, -0.3 * r), r * 0.13, Color(1.0, 0.35, 0.1))
			ci.draw_circle(Vector2(hx + 0.36 * r, -0.3 * r), r * 0.06, Color(0.05, 0.02, 0.02))
			ci.draw_circle(Vector2(hx + 0.2 * r, 0.3 * r), r * 0.13, Color(1.0, 0.35, 0.1))
			ci.draw_circle(Vector2(hx + 0.36 * r, 0.3 * r), r * 0.06, Color(0.05, 0.02, 0.02))
			ci.draw_circle(Vector2(hx + 0.14 * r, 0.0), r * 0.17, Color(1.0, 0.55, 0.15))
			ci.draw_circle(Vector2(hx + 0.34 * r, 0.0), r * 0.07, Color(0.05, 0.02, 0.02))
			for k in range(5):
				var ty40 := (float(k) - 2.0) * 0.16 * r
				_fill(ci, PackedVector2Array([Vector2(hx + 0.6 * r, ty40 - 0.06 * r), Vector2(hx + 0.78 * r, ty40), Vector2(hx + 0.6 * r, ty40 + 0.06 * r)]), Color(1, 1, 0.95), OL, lw * 0.4)
		41:
			# shepherd of suns: a sun for a face, red giants hanging in orbit
			_head(ci, r, skin, hair, lw)
			var sc41 := Vector2(hx - 0.02 * r, 0)
			ci.draw_circle(sc41, r * (0.56 + 0.04 * sin(t * 2.4)), Color(1.0, 0.72, 0.2, 0.35))
			ci.draw_circle(sc41, r * 0.44, Color(1.0, 0.86, 0.35))
			ci.draw_circle(sc41, r * 0.3, Color(1.0, 0.97, 0.8))
			for k in range(6):
				var a41 := t * 0.8 + TAU * float(k) / 6.0
				var rp41 := Vector2.from_angle(a41) * 0.8 * r
				ci.draw_circle(sc41 + rp41, r * 0.09, Color(1.0, 0.35, 0.12))
				ci.draw_circle(sc41 + rp41, r * 0.045, Color(1.0, 0.9, 0.6))
		42:
			# the last idea: a blank white mask, a thought already fading
			_fill(ci, _ellipse(hx, 0, 0.56 * r, 0.54 * r, 0.0, 26), Color(1, 1, 1), OL, lw)
			ci.draw_arc(Vector2(hx, 0), 0.56 * r, -0.9, 0.9, 18, Color(c2.r, c2.g, c2.b, 0.5), r * 0.05, true)
			for s42 in range(2):
				var side42 := -1.0 + float(s42) * 2.0
				ci.draw_line(Vector2(hx + 0.18 * r, side42 * 0.22 * r), Vector2(hx + 0.44 * r, side42 * 0.16 * r), Color(0.35, 0.25, 0.45), r * 0.05, true)
			ci.draw_arc(Vector2(hx + 0.14 * r, 0), 0.24 * r, 0.5, 2.64, 16, Color(0.35, 0.25, 0.45), r * 0.04, true)
		37:
			# the infinite: two interlocking rings over a calm, blank face
			_fill(ci, _ellipse(hx, 0, 0.54 * r, 0.52 * r, 0.0, 24), Color(1, 1, 1), OL, lw)
			ci.draw_line(Vector2(hx + 0.16 * r, -0.1 * r), Vector2(hx + 0.42 * r, -0.06 * r), Color(0.25, 0.3, 0.45), r * 0.06, true)
			ci.draw_line(Vector2(hx + 0.16 * r, 0.1 * r), Vector2(hx + 0.42 * r, 0.06 * r), Color(0.25, 0.3, 0.45), r * 0.06, true)
			for k in range(2):
				var cy0 := (float(k) - 0.5) * 0.46 * r
				var spin := t * 0.5 * (1.0 if k == 0 else -1.0)
				ci.draw_arc(Vector2(hx, cy0), r * 0.4, 0.0, TAU, 26, c2, r * 0.07, true)
				for j in range(3):
					var a15 := spin + TAU * float(j) / 3.0
					ci.draw_circle(Vector2(hx, cy0) + Vector2.from_angle(a15) * r * 0.4, r * 0.05, Color(1, 1, 1, 0.9))
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
		15:
			_bar(ci, r, pv, ang, -0.5, 2.6, 0.5, 0.11, Color(0.24, 0.18, 0.16), lw)
			_fill(ci, _wpoly(pv, ang, r, PackedVector2Array([Vector2(2.6, 0.3), Vector2(3.25, 0.32), Vector2(3.55, 0.5), Vector2(3.25, 0.68), Vector2(2.6, 0.7)])), Color(0.72, 0.78, 0.9), OL, lw)
			_bar(ci, r, pv, ang, 2.55, 2.63, 0.5, 0.62, c2, lw * 0.4)
			ci.draw_circle(_wp(pv, ang, r, 2.62, 0.5), r * 0.11, gold)
			ci.draw_line(_wp(pv, ang, r, 2.72, 0.5), _wp(pv, ang, r, 3.4, 0.5), Color(1.0, 0.92, 0.6), lw * 0.8, true)
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
		20:
			# cosmic sceptre: a dark rod carrying a ring of starlight
			_bar(ci, r, pv, ang, 0.45, 2.45, 0.5, 0.12, Color(0.2, 0.11, 0.36), lw)
			_bar(ci, r, pv, ang, 0.45, 0.55, 0.5, 0.3, Color(0.7, 0.5, 1.0), lw * 0.4)
			var rc := _wp(pv, ang, r, 2.75, 0.5)
			var pu4 := 0.5 + 0.5 * sin(t * 3.4)
			ci.draw_arc(rc, r * (0.42 + 0.015 * pu4), 0.0, TAU, 26, Color(0.8, 0.52, 1.0, 0.95), r * 0.09, true)
			for k in range(4):
				var a8 := t * 1.1 + TAU * float(k) / 4.0
				var sp4 := rc + Vector2.from_angle(a8) * r * 0.42
				ci.draw_circle(sp4, r * 0.07, Color(1.0, 0.96, 0.8))
			ci.draw_circle(rc, r * 0.23, Color(0.72, 0.42, 1.0))
			ci.draw_circle(rc, r * 0.15, Color(1, 1, 1, 0.95))
		21:
			# astral glaive: one shaft, two ice-blue crescent blades
			_bar(ci, r, pv, ang, 0.45, 2.6, 0.5, 0.1, Color(0.24, 0.34, 0.5), lw)
			_fill(ci, _wpoly(pv, ang, r, PackedVector2Array([
				Vector2(2.55, 0.5), Vector2(2.82, 0.32), Vector2(3.22, 0.1),
				Vector2(3.5, 0.02), Vector2(3.32, 0.28), Vector2(2.92, 0.44)])),
				Color(0.83, 0.95, 1.0), OL, lw * 0.8)
			_fill(ci, _wpoly(pv, ang, r, PackedVector2Array([
				Vector2(2.55, 0.5), Vector2(2.82, 0.68), Vector2(3.22, 0.9),
				Vector2(3.5, 0.98), Vector2(3.32, 0.72), Vector2(2.92, 0.56)])),
				Color(0.83, 0.95, 1.0), OL, lw * 0.8)
			var b0 := _wp(pv, ang, r, 2.55, 0.18)
			var b1 := _wp(pv, ang, r, 2.55, 0.82)
			ci.draw_line(b0, b1, OL, r * 0.14 + lw, true)
			ci.draw_line(b0, b1, Color(0.55, 0.8, 1.0), r * 0.14, true)
			ci.draw_circle(_wp(pv, ang, r, 2.62, 0.5), r * 0.11, Color(0.92, 0.99, 1.0))
		22:
			# omniverse blade: the biggest blade in the game, white gold
			var pu5 := 0.5 + 0.5 * sin(t * 2.6)
			ci.draw_colored_polygon(_wpoly(pv, ang, r, _ellipse(2.5, 0.5, 1.7, 0.62, 0.0, 22)), Color(1.0, 0.9, 0.5, 0.15 + 0.08 * pu5))
			_bar(ci, r, pv, ang, 0.3, 1.0, 0.5, 0.16, Color(0.55, 0.36, 0.12), lw)
			_fill(ci, _wpoly(pv, ang, r, PackedVector2Array([
				Vector2(0.95, 0.02), Vector2(1.07, 0.5), Vector2(0.95, 0.98), Vector2(0.83, 0.5)])),
				Color(1.0, 0.88, 0.4), OL, lw)
			_fill(ci, _wpoly(pv, ang, r, PackedVector2Array([
				Vector2(0.95, 0.34), Vector2(2.7, 0.4), Vector2(3.95, 0.5),
				Vector2(2.7, 0.6), Vector2(0.95, 0.66)])),
				Color(1.0, 0.97, 0.86), OL, lw)
			ci.draw_line(_wp(pv, ang, r, 1.1, 0.5), _wp(pv, ang, r, 3.75, 0.5), Color(1.0, 0.86, 0.34), lw * 1.4, true)
			for k in range(5):
				ci.draw_circle(_wp(pv, ang, r, 1.35 + float(k) * 0.5, 0.5 + (-0.07 + 0.14 * float(k % 2))), r * 0.05, Color(1.0, 0.84, 0.3, 0.9))
		23:
			# holy sword: a white blade with a cross guard and a line of light
			var pu6 := 0.5 + 0.5 * sin(t * 4.6)
			ci.draw_colored_polygon(_wpoly(pv, ang, r, _ellipse(2.2, 0.5, 1.4, 0.4, 0.0, 20)), Color(1.0, 0.95, 0.66, 0.13 + 0.07 * pu6))
			_bar(ci, r, pv, ang, 0.32, 0.95, 0.5, 0.12, Color(0.85, 0.7, 0.3), lw)
			ci.draw_circle(_wp(pv, ang, r, 0.3, 0.5), r * 0.16, Color(1.0, 0.91, 0.52))
			var h0 := _wp(pv, ang, r, 0.95, 0.16)
			var h1 := _wp(pv, ang, r, 0.95, 0.84)
			ci.draw_line(h0, h1, OL, r * 0.16 + lw, true)
			ci.draw_line(h0, h1, Color(1.0, 0.88, 0.45), r * 0.16, true)
			_fill(ci, _wpoly(pv, ang, r, PackedVector2Array([
				Vector2(0.98, 0.32), Vector2(3.0, 0.36), Vector2(3.6, 0.5),
				Vector2(3.0, 0.64), Vector2(0.98, 0.68)])),
				Color(1.0, 0.99, 0.94), OL, lw)
			ci.draw_line(_wp(pv, ang, r, 1.1, 0.5), _wp(pv, ang, r, 3.45, 0.5), Color(1.0, 0.92, 0.55), lw * 1.3, true)
			_fill(ci, _wpoly(pv, ang, r, PackedVector2Array([
				Vector2(1.85, 0.34), Vector2(2.05, 0.34), Vector2(2.05, 0.5),
				Vector2(2.25, 0.5), Vector2(2.25, 0.66), Vector2(1.85, 0.66)])),
				Color(1.0, 0.93, 0.66), OL, lw * 0.4)
		24:
			# eclipse blade: a black greatsword with a white edge
			var pu7 := 0.5 + 0.5 * sin(t * 3.2)
			ci.draw_colored_polygon(_wpoly(pv, ang, r, _ellipse(2.5, 0.5, 1.7, 0.5, 0.0, 22)), Color(0.85, 0.9, 1.0, 0.11 + 0.07 * pu7))
			_bar(ci, r, pv, ang, 0.3, 1.0, 0.5, 0.16, Color(0.2, 0.18, 0.26), lw)
			var e0 := _wp(pv, ang, r, 0.97, 0.06)
			var e1 := _wp(pv, ang, r, 0.97, 0.94)
			ci.draw_line(e0, e1, OL, r * 0.18 + lw, true)
			ci.draw_line(e0, e1, Color(0.9, 0.94, 1.0), r * 0.18, true)
			_fill(ci, _wpoly(pv, ang, r, PackedVector2Array([
				Vector2(0.97, 0.36), Vector2(2.9, 0.38), Vector2(3.9, 0.5),
				Vector2(2.9, 0.62), Vector2(0.97, 0.64)])), Color(0.07, 0.06, 0.1), OL, lw)
			ci.draw_line(_wp(pv, ang, r, 1.0, 0.39), _wp(pv, ang, r, 3.72, 0.49), Color(0.95, 0.97, 1.0), lw * 1.2, true)
			ci.draw_line(_wp(pv, ang, r, 1.0, 0.61), _wp(pv, ang, r, 3.72, 0.51), Color(0.95, 0.97, 1.0), lw * 1.2, true)
			ci.draw_circle(_wp(pv, ang, r, 0.4, 0.5), r * 0.14, Color(0.95, 0.97, 1.0))
		25:
			# chrono halberd: a long brass shaft with an axe head and a spike
			_bar(ci, r, pv, ang, 0.45, 3.0, 0.5, 0.1, Color(0.45, 0.33, 0.16), lw)
			_bar(ci, r, pv, ang, 3.0, 3.45, 0.5, 0.09, Color(0.9, 0.94, 1.0), lw)
			_fill(ci, _wpoly(pv, ang, r, PackedVector2Array([
				Vector2(2.5, 0.5), Vector2(3.05, 0.1), Vector2(3.34, 0.28),
				Vector2(3.05, 0.5), Vector2(2.9, 0.62)])), Color(0.92, 0.94, 1.0), OL, lw * 0.8)
			_fill(ci, _wpoly(pv, ang, r, PackedVector2Array([
				Vector2(2.5, 0.5), Vector2(2.95, 0.84), Vector2(3.2, 0.68),
				Vector2(3.0, 0.5)])), Color(0.85, 0.88, 0.96), OL, lw * 0.8)
			ci.draw_line(_wp(pv, ang, r, 2.55, 0.5), _wp(pv, ang, r, 3.15, 0.29), c2, lw * 0.7, true)
			ci.draw_arc(_wp(pv, ang, r, 1.9, 0.5), r * 0.17, 0.0, TAU, 20, c2, r * 0.07, true)
			ci.draw_line(_wp(pv, ang, r, 1.9, 0.5), _wp(pv, ang, r, 2.0, 0.4), c2, r * 0.06, true)
			ci.draw_line(_wp(pv, ang, r, 1.9, 0.5), _wp(pv, ang, r, 1.98, 0.62), c2, r * 0.06, true)
		26:
			# genesis spear: a living shaft crowned with a great leaf
			_bar(ci, r, pv, ang, 0.45, 3.1, 0.5, 0.09, Color(0.24, 0.36, 0.2), lw)
			_fill(ci, _wpoly(pv, ang, r, PackedVector2Array([
				Vector2(3.0, 0.5), Vector2(3.24, 0.2), Vector2(3.78, 0.34),
				Vector2(4.0, 0.5), Vector2(3.78, 0.66), Vector2(3.24, 0.8)])), Color(0.62, 0.95, 0.45), OL, lw * 0.8)
			_fill(ci, _wpoly(pv, ang, r, PackedVector2Array([
				Vector2(2.55, 0.5), Vector2(2.82, 0.26), Vector2(3.05, 0.4),
				Vector2(2.86, 0.5)])), Color(0.5, 0.85, 0.36), OL, lw * 0.6)
			_fill(ci, _wpoly(pv, ang, r, PackedVector2Array([
				Vector2(2.55, 0.5), Vector2(2.82, 0.74), Vector2(3.05, 0.6),
				Vector2(2.86, 0.5)])), Color(0.5, 0.85, 0.36), OL, lw * 0.6)
			ci.draw_line(_wp(pv, ang, r, 3.1, 0.5), _wp(pv, ang, r, 3.88, 0.5), Color(0.95, 1.0, 0.75), lw, true)
			ci.draw_circle(_wp(pv, ang, r, 3.9, 0.5), r * 0.11, Color(0.85, 1.0, 0.7))
		27:
			# aether warblade: a curved blade between two fins of light
			_bar(ci, r, pv, ang, 0.35, 0.95, 0.5, 0.14, Color(0.32, 0.16, 0.4), lw)
			_fill(ci, _wpoly(pv, ang, r, PackedVector2Array([
				Vector2(0.95, 0.5), Vector2(1.35, 0.12), Vector2(1.62, 0.24),
				Vector2(1.18, 0.5)])), c2, OL, lw * 0.7)
			_fill(ci, _wpoly(pv, ang, r, PackedVector2Array([
				Vector2(0.95, 0.5), Vector2(1.35, 0.88), Vector2(1.62, 0.76),
				Vector2(1.18, 0.5)])), c2, OL, lw * 0.7)
			_fill(ci, _wpoly(pv, ang, r, PackedVector2Array([
				Vector2(0.95, 0.42), Vector2(2.2, 0.3), Vector2(3.1, 0.4),
				Vector2(3.75, 0.5), Vector2(3.0, 0.62), Vector2(2.0, 0.62),
				Vector2(0.95, 0.58)])), Color(0.99, 0.82, 0.95), OL, lw)
			ci.draw_polyline(_wpoly(pv, ang, r, PackedVector2Array([
				Vector2(1.05, 0.47), Vector2(2.3, 0.4), Vector2(3.2, 0.45),
				Vector2(3.6, 0.5)])), Color(1.0, 0.95, 1.0), lw * 1.2, true)
		28:
			# quill of creation: a feather fan on a shaft with a golden nib
			var pu8 := 0.5 + 0.5 * sin(t * 3.6)
			ci.draw_colored_polygon(_wpoly(pv, ang, r, _ellipse(2.55, 0.5, 1.15, 0.5, 0.0, 22)), Color(0.55, 0.85, 1.0, 0.10 + 0.06 * pu8))
			_bar(ci, r, pv, ang, 0.3, 3.7, 0.5, 0.06, Color(0.98, 0.96, 0.88), lw)
			_fill(ci, _wpoly(pv, ang, r, _ellipse(2.55, 0.5, 1.12, 0.44, -0.06, 24)), Color(0.86, 0.97, 1.0), OL, lw * 0.9)
			for k in range(6):
				var f8 := -0.34 + float(k) * 0.136
				ci.draw_line(_wp(pv, ang, r, 1.55, 0.5 + f8 * 0.5), _wp(pv, ang, r, 1.65 + 0.95 * (1.0 - absf(f8) * 1.6), 0.5 + f8), Color(0.55, 0.85, 1.0, 0.8), lw * 0.5, true)
			_fill(ci, _wpoly(pv, ang, r, PackedVector2Array([
				Vector2(3.58, 0.5), Vector2(3.76, 0.38), Vector2(4.16, 0.5),
				Vector2(3.76, 0.62)])), Color(1.0, 0.86, 0.42), OL, lw * 0.7)
			ci.draw_circle(_wp(pv, ang, r, 3.72, 0.5), r * 0.09, Color(1.0, 0.97, 0.8))
			ci.draw_circle(_wp(pv, ang, r, 0.34, 0.5), r * 0.13, Color(0.75, 0.95, 1.0))
			ci.draw_circle(_wp(pv, ang, r, 0.34, 0.5), r * 0.07, Color(1, 1, 1))

		29:
			# sun cleaver: a wide molten blade on a short haft
			var sf9 := 0.5 + 0.5 * sin(t * 4.0)
			ci.draw_colored_polygon(_wpoly(pv, ang, r, _ellipse(2.3, 0.5, 1.35, 0.55, 0.0, 20)), Color(1.0, 0.6, 0.1, 0.11 + 0.06 * sf9))
			_bar(ci, r, pv, ang, 0.35, 1.0, 0.5, 0.13, Color(0.5, 0.3, 0.12), lw)
			_fill(ci, _wpoly(pv, ang, r, PackedVector2Array([
				Vector2(1.0, 0.5), Vector2(1.35, 0.14), Vector2(2.6, 0.18),
				Vector2(3.55, 0.5), Vector2(2.55, 0.66), Vector2(1.35, 0.86)])), Color(1.0, 0.62, 0.16), OL, lw)
			ci.draw_line(_wp(pv, ang, r, 1.1, 0.5), _wp(pv, ang, r, 3.3, 0.5), Color(1.0, 0.93, 0.6), lw, true)
		30:
			# storm glaive: a jagged lightning blade on a silver shaft
			_bar(ci, r, pv, ang, 0.4, 2.2, 0.5, 0.085, Color(0.55, 0.62, 0.75), lw)
			_fill(ci, _wpoly(pv, ang, r, PackedVector2Array([
				Vector2(2.1, 0.5), Vector2(2.45, 0.16), Vector2(2.75, 0.36),
				Vector2(3.1, 0.1), Vector2(3.42, 0.38), Vector2(3.78, 0.5),
				Vector2(3.2, 0.6), Vector2(2.8, 0.8), Vector2(2.1, 0.5)])), Color(0.78, 0.95, 1.0), OL, lw)
			ci.draw_polyline(_wpoly(pv, ang, r, PackedVector2Array([
				Vector2(2.3, 0.5), Vector2(2.75, 0.44), Vector2(3.1, 0.52), Vector2(3.55, 0.5)])), c2, lw * 0.8, true)
		31:
			# abyss trident: three prongs on a dark haft
			_bar(ci, r, pv, ang, 0.4, 3.05, 0.5, 0.075, Color(0.1, 0.3, 0.32), lw)
			var t0 := _wp(pv, ang, r, 3.0, 0.08)
			var t1 := _wp(pv, ang, r, 3.0, 0.92)
			ci.draw_line(t0, t1, OL, r * 0.12 + lw, true)
			ci.draw_line(t0, t1, c2, r * 0.12, true)
			for k in range(3):
				var py := 0.08 + 0.42 * float(k)
				_bar(ci, r, pv, ang, 2.95, 3.72, py, 0.055, Color(0.6, 0.95, 0.9), lw)
				_fill(ci, _wpoly(pv, ang, r, PackedVector2Array([
					Vector2(3.68, py - 0.07), Vector2(3.98, py), Vector2(3.68, py + 0.07)])), Color(0.8, 1.0, 0.95), OL, lw * 0.4)
		32:
			# colossus axe: a double-bit axe head on a thick haft
			_bar(ci, r, pv, ang, 0.35, 2.55, 0.5, 0.1, Color(0.3, 0.12, 0.1), lw)
			for s in range(2):
				var side := -1.0 + float(s) * 2.0
				_fill(ci, _wpoly(pv, ang, r, PackedVector2Array([
					Vector2(2.35, 0.5), Vector2(2.72, 0.5 + side * 0.42), Vector2(3.45, 0.5 + side * 0.32),
					Vector2(3.18, 0.5)])), Color(0.85, 0.82, 0.8), OL, lw * 0.9)
				ci.draw_line(_wp(pv, ang, r, 2.7, 0.5 + side * 0.36), _wp(pv, ang, r, 3.35, 0.5 + side * 0.3), Color(1.0, 0.35, 0.15), lw * 0.9, true)
			ci.draw_circle(_wp(pv, ang, r, 2.5, 0.5), r * 0.13, c2)
		33:
			# shard blade: a split crystal greatsword
			_bar(ci, r, pv, ang, 0.35, 0.95, 0.5, 0.1, Color(0.25, 0.32, 0.42), lw)
			var g0 := _wp(pv, ang, r, 0.95, 0.36)
			var g1 := _wp(pv, ang, r, 0.95, 0.64)
			var g2 := _wp(pv, ang, r, 1.2, 0.5)
			_fill(ci, PackedVector2Array([g0, g2, g1]), c2.darkened(0.2), OL, lw * 0.7)
			_fill(ci, _wpoly(pv, ang, r, PackedVector2Array([
				Vector2(0.95, 0.44), Vector2(1.9, 0.3), Vector2(2.9, 0.4),
				Vector2(3.3, 0.5), Vector2(2.85, 0.58), Vector2(1.9, 0.64), Vector2(0.95, 0.56)])), Color(0.82, 0.95, 1.0), OL, lw)
			_fill(ci, _wpoly(pv, ang, r, PackedVector2Array([
				Vector2(2.6, 0.5), Vector2(3.05, 0.34), Vector2(3.45, 0.5), Vector2(3.05, 0.66)])), Color(0.95, 1.0, 1.0), OL, lw * 0.8)
			ci.draw_line(_wp(pv, ang, r, 1.05, 0.46), _wp(pv, ang, r, 3.2, 0.47), Color(1, 1, 1, 0.95), lw * 0.9, true)
		34:
			# bough blade: a living branch with a leaf-shaped blade
			_bar(ci, r, pv, ang, 0.35, 2.1, 0.5, 0.09, Color(0.4, 0.28, 0.16), lw)
			_fill(ci, _wpoly(pv, ang, r, _ellipse(1.75, 0.18, 0.24, 0.08, -0.5, 10)), Color(0.5, 0.85, 0.35), OL, lw * 0.6)
			_fill(ci, _wpoly(pv, ang, r, PackedVector2Array([
				Vector2(2.05, 0.5), Vector2(2.45, 0.2), Vector2(3.1, 0.26),
				Vector2(3.55, 0.5), Vector2(3.1, 0.74), Vector2(2.45, 0.8)])), Color(0.55, 0.9, 0.4), OL, lw)
			ci.draw_line(_wp(pv, ang, r, 2.15, 0.5), _wp(pv, ang, r, 3.42, 0.5), Color(0.9, 1.0, 0.7), lw, true)
		35:
			# void scythe: a long dark haft ending in a hooked crescent
			_bar(ci, r, pv, ang, 0.3, 3.1, 0.5, 0.06, Color(0.16, 0.1, 0.2), lw)
			_fill(ci, _wpoly(pv, ang, r, PackedVector2Array([
				Vector2(3.0, 0.5), Vector2(3.3, 0.18), Vector2(3.72, 0.16),
				Vector2(3.88, 0.38), Vector2(3.45, 0.58), Vector2(3.1, 0.62)])), Color(0.35, 0.15, 0.45), OL, lw)
			ci.draw_arc(_wp(pv, ang, r, 3.45, 0.38), r * 0.38, 2.2, 5.2, 18, c2, lw * 0.9, true)
			ci.draw_circle(_wp(pv, ang, r, 3.55, 0.36), r * 0.07, Color(1, 1, 1, 0.85))
		36:
			# dragon fang: a serrated greatsword with fanged guards
			_bar(ci, r, pv, ang, 0.35, 1.0, 0.5, 0.11, Color(0.35, 0.1, 0.08), lw)
			for s in range(2):
				var side := -1.0 + float(s) * 2.0
				_fill(ci, _wpoly(pv, ang, r, PackedVector2Array([
					Vector2(0.95, 0.5), Vector2(1.25, 0.5 + side * 0.34), Vector2(1.45, 0.5 + side * 0.16),
					Vector2(1.15, 0.5)])), Color(0.95, 0.88, 0.7), OL, lw * 0.6)
			_fill(ci, _wpoly(pv, ang, r, PackedVector2Array([
				Vector2(0.98, 0.44), Vector2(2.2, 0.34), Vector2(3.3, 0.44),
				Vector2(3.62, 0.5), Vector2(3.25, 0.58), Vector2(2.2, 0.66), Vector2(0.98, 0.56)])), Color(0.85, 0.2, 0.15), OL, lw)
			for k in range(4):
				var sx := 1.5 + float(k) * 0.5
				_fill(ci, _wpoly(pv, ang, r, PackedVector2Array([
					Vector2(sx, 0.38), Vector2(sx + 0.16, 0.28), Vector2(sx + 0.18, 0.4)])), Color(1.0, 0.75, 0.2), OL, lw * 0.4)
			ci.draw_line(_wp(pv, ang, r, 1.05, 0.5), _wp(pv, ang, r, 3.5, 0.5), Color(1.0, 0.55, 0.2, 0.9), lw, true)
		37:
			# primordial blade: a void orb floats inside the blade
			var pf9 := 0.5 + 0.5 * sin(t * 2.6)
			_bar(ci, r, pv, ang, 0.35, 0.9, 0.5, 0.1, Color(0.18, 0.14, 0.3), lw)
			_fill(ci, _wpoly(pv, ang, r, _ellipse(1.5, 0.5, 0.42, 0.42, 0.0, 20)), Color(0.05, 0.02, 0.12), OL, lw)
			ci.draw_arc(_wp(pv, ang, r, 1.5, 0.5), r * 0.34, 0.0, TAU, 22, c2, lw * 0.8, true)
			ci.draw_circle(_wp(pv, ang, r, 1.5, 0.5), r * (0.12 + 0.03 * pf9), Color(0.7, 1.0, 0.9, 0.9))
			_fill(ci, _wpoly(pv, ang, r, PackedVector2Array([
				Vector2(1.9, 0.44), Vector2(2.9, 0.36), Vector2(3.55, 0.5),
				Vector2(2.9, 0.62), Vector2(1.9, 0.56)])), Color(0.35, 0.3, 0.6), OL, lw)
			ci.draw_line(_wp(pv, ang, r, 1.95, 0.5), _wp(pv, ang, r, 3.42, 0.5), Color(0.6, 1.0, 0.9), lw * 0.8, true)
		39:
			# nothing blade: a black blade with its centre missing
			var pb39 := 0.5 + 0.5 * sin(t * 2.2)
			_bar(ci, r, pv, ang, 0.3, 0.98, 0.5, 0.07, Color(0.14, 0.1, 0.22), lw)
			_fill(ci, _wpoly(pv, ang, r, PackedVector2Array([
				Vector2(0.98, 0.34), Vector2(2.24, 0.4), Vector2(3.02, 0.5),
				Vector2(2.24, 0.6), Vector2(0.98, 0.66)])), Color(0.16, 0.12, 0.28), OL, lw)
			_fill(ci, _wpoly(pv, ang, r, PackedVector2Array([
				Vector2(2.3, 0.42), Vector2(3.78, 0.5), Vector2(2.3, 0.58)])), Color(0.03, 0.02, 0.05), OL, lw * 0.8)
			ci.draw_arc(_wp(pv, ang, r, 2.62, 0.5), r * 0.32, 0.0, TAU, 22, c2, lw * 0.9, true)
			ci.draw_line(_wp(pv, ang, r, 1.05, 0.38), _wp(pv, ang, r, 2.2, 0.42), Color(c2.r, c2.g, c2.b, 0.7 + 0.3 * pb39), lw, true)
		40:
			# hollow crown: curved gold prongs reaching round from the haft
			_bar(ci, r, pv, ang, 0.35, 2.55, 0.5, 0.09, Color(0.12, 0.09, 0.16), lw)
			for s40 in range(2):
				var side40 := -1.0 + float(s40) * 2.0
				for k in range(2):
					var rc := 2.0 + float(k) * 0.6
					var rr40 := 0.52 - float(k) * 0.08
					var bow := 0.72 + float(k) * 0.1
					ci.draw_arc(_wp(pv, ang, r, rc, 0.5 + side40 * 0.16), r * rr40, ang - bow * side40 - 0.7, ang - bow * side40 + 0.7, 14, Color(1.0, 0.8 - 0.25 * float(k), 0.25), lw * 1.1, true)
			_bar(ci, r, pv, ang, 0.93, 1.03, 0.5, 0.62, c2, lw * 0.5)
			ci.draw_circle(_wp(pv, ang, r, 0.98, 0.5), r * 0.12, Color(1.0, 0.9, 0.4))
		41:
			# world-eater: a long dark haft ending in a jaw of teeth
			_bar(ci, r, pv, ang, 0.4, 3.25, 0.5, 0.13, Color(0.2, 0.06, 0.06), lw)
			var jb41 := _wp(pv, ang, r, 3.2, 0.5)
			for s41 in range(2):
				var side41 := -1.0 + float(s41) * 2.0
				_fill(ci, _wpoly(pv, ang, r, PackedVector2Array([
					Vector2(3.05, 0.5), Vector2(3.5, 0.5 + side41 * 0.3),
					Vector2(4.2, 0.5 + side41 * 0.3), Vector2(4.05, 0.5)])), Color(0.55, 0.15, 0.1), OL, lw)
				for k in range(3):
					var tx41 := 3.5 + float(k) * 0.28
					_fill(ci, _wpoly(pv, ang, r, PackedVector2Array([
						Vector2(tx41, 0.5 + side41 * 0.26), Vector2(tx41 + 0.14, 0.5 + side41 * 0.34),
						Vector2(tx41 + 0.28, 0.5 + side41 * 0.24)])), Color(1, 1, 0.95), OL, lw * 0.4)
			ci.draw_circle(jb41, r * 0.18, Color(1.0, 0.4, 0.12))
			ci.draw_circle(jb41, r * 0.09, Color(0.1, 0.02, 0.02))
			_bar(ci, r, pv, ang, 0.94, 1.06, 0.5, 0.9, c2, lw * 0.5)
		42:
			# shepherd of suns: a dark shaft hung with burning suns
			_bar(ci, r, pv, ang, 0.35, 3.1, 0.5, 0.05, Color(0.14, 0.11, 0.06), lw)
			for k in range(4):
				var sx42 := 0.9 + float(k) * 0.72
				var pc42 := _wp(pv, ang, r, sx42, 0.5)
				ci.draw_arc(pc42, r * 0.36, 0.0, TAU, 22, Color(1.0, 0.75, 0.25, 0.55), lw * 0.8, true)
				ci.draw_circle(pc42, r * (0.16 + 0.03 * sin(t * 3.0 + float(k))), Color(1.0, 0.9, 0.45))
			ci.draw_line(_wp(pv, ang, r, 1.0, 0.32), _wp(pv, ang, r, 3.1, 0.32), c2, lw * 0.6, true)
			ci.draw_line(_wp(pv, ang, r, 1.0, 0.68), _wp(pv, ang, r, 3.1, 0.68), c2, lw * 0.6, true)
		43:
			# the last idea: one long whisper, with rings floating along it
			_bar(ci, r, pv, ang, 0.3, 2.85, 0.5, 0.05, Color(0.9, 0.88, 0.8), lw)
			ci.draw_line(_wp(pv, ang, r, 0.4, 0.5), _wp(pv, ang, r, 3.1, 0.5), Color(1, 1, 1, 0.95), lw * 1.2, true)
			for k in range(3):
				var rc43 := _wp(pv, ang, r, 0.75 + float(k) * 1.0, 0.5)
				ci.draw_arc(rc43, r * (0.44 + 0.05 * sin(t * 2.0 + float(k) * 1.3)), ang + PI * 0.5 - 1.2, ang + PI * 0.5 + 1.2, 18, c2, lw * 0.9, true)
			_fill(ci, _wpoly(pv, ang, r, PackedVector2Array([
				Vector2(2.8, 0.4), Vector2(3.5, 0.5), Vector2(2.8, 0.6)])), Color(1, 1, 1), OL, lw * 0.7)
		38:
			# the infinite blade: twin crescents and a split tip
			var pi9 := 0.5 + 0.5 * sin(t * 3.0)
			_bar(ci, r, pv, ang, 0.35, 0.95, 0.5, 0.09, Color(0.9, 0.85, 0.6), lw)
			for s in range(2):
				var side := -1.0 + float(s) * 2.0
				_fill(ci, _wpoly(pv, ang, r, PackedVector2Array([
					Vector2(0.95, 0.5), Vector2(1.25, 0.5 + side * 0.36), Vector2(1.72, 0.5 + side * 0.22),
					Vector2(1.4, 0.5)])), Color(1.0, 0.95, 0.8), OL, lw * 0.6)
			_fill(ci, _wpoly(pv, ang, r, PackedVector2Array([
				Vector2(0.95, 0.44), Vector2(2.2, 0.4), Vector2(3.15, 0.44),
				Vector2(3.6, 0.36), Vector2(3.95, 0.5), Vector2(3.6, 0.64),
				Vector2(3.15, 0.56), Vector2(2.2, 0.6), Vector2(0.95, 0.56)])), Color(1.0, 0.99, 0.94), OL, lw)
			ci.draw_line(_wp(pv, ang, r, 1.05, 0.5), _wp(pv, ang, r, 3.85, 0.5), Color(1.0, 0.84, 0.35, 0.75 + 0.25 * pi9), lw * 1.1, true)
		_:
			_bar(ci, r, pv, ang, 0.3, 0.95, 0.5, 0.16, Color(0.5, 0.1, 0.1), lw)
			var blade := _wpoly(pv, ang, r, PackedVector2Array([Vector2(0.95, 0.34), Vector2(3.0, 0.3), Vector2(3.55, 0.5), Vector2(3.0, 0.7), Vector2(0.95, 0.66)]))
			var pu2 := 0.5 + 0.5 * sin(t * 4.0)
			ci.draw_colored_polygon(_wpoly(pv, ang, r, _ellipse(2.2, 0.5, 1.5, 0.45, 0.0, 20)), Color(1.0, 0.85, 0.3, 0.12 + 0.08 * pu2))
			_fill(ci, blade, Color(1.0, 0.9, 0.45), OL, lw)
			ci.draw_line(_wp(pv, ang, r, 1.1, 0.5), _wp(pv, ang, r, 3.2, 0.5), Color(1, 1, 0.85), lw, true)
			_bar(ci, r, pv, ang, 0.93, 1.01, 0.5, 1.15, c2, lw * 0.5)
