# Evo Wilds (Godot 4.7)

A top-down eat-to-grow arena. Eat food, defeat rivals with one-hit weapon swings, and evolve through 28 humanoid tiers — from Caveman to Omniverse God.

## Download
Latest build: **[evo-wilds.zip](https://github.com/defiantdevs/evowilds.io/releases/latest/download/evo-wilds.zip)** — all versions on the [Releases page](https://github.com/defiantdevs/evowilds.io/releases).

Unzip it, open the folder in Godot 4.7+, and press F5.

## Start screen
Pick your name on the title screen, then choose a mode:

- **DEATHMATCH** — free-for-all. A 10:00 timer counts down; when it hits zero the match ends.
- **TEAM DEATHMATCH** — Red vs Blue. A timer counts **up** from 0:00 and there is no time limit.

When you are defeated the match **keeps running** — the clock ticks on, golems keep marching and the statues keep the health they had. You respawn into the same match after a couple of seconds (or immediately with a click / key press), starting small again while the battle carries on around you. Only when the match itself ends (timer out, or a statue destroyed) do you return to the start screen. ESC still takes you back to the start screen whenever you want to leave.

## Controls
- **Move:** WASD / arrow keys (or steer with the mouse)
- **Swing:** SPACE or left-click — the blade is the hitbox, one hit kills at any tier
- **Sprint:** SHIFT or right-click (drains XP)
- **Back to start screen:** ESC (or click / any key on the match-over screen)

## Team Deathmatch rules
- Two base statues — one **Red**, one **Blue** — each with **15,000 HP**.
- Grey golems spawn around the arena and stand still: **small** every 15s, **medium** every 40s, **large** every minute, **extra-large** every 2 minutes.
- Hit a golem or statue and it joins **your** team, turns your colour, and marches off to chip the enemy statue (small 1, medium 2, large 3, extra-large 5 damage on a size-based cooldown).
- You can hit the enemy statue directly: damage scales with your size from **1** (smallest) to **28** (biggest).
- First statue destroyed wins. Smaller bots charge the enemy statue; **big bots instead roam the arena and guard their own statue**, attacking anyone who comes near it.
- No friendly fire — team-mates can't hurt each other.

## Evolutions (28)
Caveman → Forager → Hunter → Tribesman → Peasant → Raider → Viking → Soldier → Knight → Samurai → Ninja → Gladiator → Crusader → Paladin → Sorcerer → Necromancer → Dragon Knight → Warlord → Emperor → Immortal Sage → Storm Titan → Death Reaper → Celestial King → Cosmos Emperor → Astral Sovereign → Void Titan → Eternal Seraph → Omniverse God

## Features
- Title screen where you choose your name and pick a mode (Deathmatch or Team Deathmatch)
- Deathmatch: 10-minute countdown; Team Deathmatch: count-up timer, Red vs Blue statues
- Captureable grey golems that switch sides when hit and march on the enemy statue
- 28 AI bots with hunting/fleeing/wandering instincts — they notice you and gang up when you get close, but they react slowly and miss often
- Leaderboard, minimap, kill feed, tier progress bar
- Berries, apples, gold and loot drops; trees, rocks, ponds, meadows, flowers
- Camera zooms out as you grow
- Responsive movement — crisp turning and stopping, no ice-skating

## Run
Open this folder in Godot 4.7+ and press F5, or `godot --path .`

Files: `scripts/species.gd` (the 28 tier designs), `creature.gd` (movement, swing, bot AI, team logic), `main.gd` (world, food, combat, game modes), `menu.gd` + `game_state.gd` (start screen and mode/team memory), `hud.gd`, `fx.gd`.
