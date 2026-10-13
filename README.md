# Evo Wilds (Godot 4.7)

A top-down eat-to-grow arena. Eat food, defeat rivals with one-hit weapon swings, and evolve through 19 humanoid tiers — from Caveman to Emperor.

## Controls
- **Move:** WASD / arrow keys (or steer with the mouse)
- **Swing:** SPACE or left-click — the blade is the hitbox, one hit kills at any tier
- **Sprint:** SHIFT or right-click (drains XP)
- **Respawn:** ENTER or click after being defeated

## Evolutions (19)
Caveman → Forager → Hunter → Tribesman → Peasant → Raider → Viking → Soldier → Knight → Samurai → Ninja → Gladiator → Crusader → Paladin → Sorcerer → Necromancer → Dragon Knight → Warlord → Emperor

## Features
- 28 AI bots with simple hunting/fleeing/wandering instincts — they gang up on the player when nearby
- Leaderboard, minimap, kill feed, tier progress bar
- Berries, apples, gold and loot drops; rocks, trees, ponds and meadows
- Camera zooms out as you grow

## Run
Open this folder in Godot 4.7+ and press F5, or `godot --path .`

Files: `scripts/species.gd` (the 19 tier designs), `creature.gd` (movement, swing, bot AI), `main.gd` (world, food, combat), `hud.gd`, `fx.gd`.
