# Evo Wilds (Godot 4.7)

A top-down eat-to-grow arena. Eat food, defeat rivals with one-hit weapon swings, and evolve through 24 humanoid tiers — from Caveman to Cosmos Emperor.

## Download
Latest build: **[evo-wilds.zip](https://github.com/defiantdevs/evowilds.io/releases/latest/download/evo-wilds.zip)** — all versions on the [Releases page](https://github.com/defiantdevs/evowilds.io/releases).

Unzip it, open the folder in Godot 4.7+, and press F5.

## Start screen
Pick your name on the title screen and press **PLAY** — your name is what rivals see in the arena and on the leaderboard.

## Controls
- **Move:** WASD / arrow keys (or steer with the mouse)
- **Swing:** SPACE or left-click — the blade is the hitbox, one hit kills at any tier
- **Sprint:** SHIFT or right-click (drains XP)
- **Respawn:** ENTER or click after being defeated
- **Main menu:** ESC on the defeat screen

## Evolutions (24)
Caveman → Forager → Hunter → Tribesman → Peasant → Raider → Viking → Soldier → Knight → Samurai → Ninja → Gladiator → Crusader → Paladin → Sorcerer → Necromancer → Dragon Knight → Warlord → Emperor → Immortal Sage → Storm Titan → Death Reaper → Celestial King → Cosmos Emperor

## Features
- Title screen where you choose your name
- 28 AI bots with hunting/fleeing/wandering instincts — they notice you and gang up when you get close, but they react slowly and miss often
- Leaderboard, minimap, kill feed, tier progress bar
- Berries, apples, gold and loot drops; trees, rocks, ponds, meadows, flowers
- Camera zooms out as you grow
- Responsive movement — crisp turning and stopping, no ice-skating

## Run
Open this folder in Godot 4.7+ and press F5, or `godot --path .`

Files: `scripts/species.gd` (the 24 tier designs), `creature.gd` (movement, swing, bot AI), `main.gd` (world, food, combat), `hud.gd`, `fx.gd`.
