# Evo Wilds (Godot 4.7)

A top-down eat-to-grow arena. Eat food, defeat rivals with one-hit weapon swings, and evolve through 28 humanoid tiers — from Caveman to Omniverse God.

## Download
Current build: **v1.13** — [evo-wilds.zip (direct link)](https://github.com/defiantdevs/evowilds.io/releases/download/v1.13/evo-wilds.zip) · [always-latest link](https://github.com/defiantdevs/evowilds.io/releases/latest/download/evo-wilds.zip) · all versions on the [Releases page](https://github.com/defiantdevs/evowilds.io/releases).

Unzip it, open the folder in Godot 4.7+, and press F5. The start screen shows the build number in the bottom-right corner — if it does not say **BUILD v1.13**, you are still running an older download.

## What's new in v1.13
- **Test Range: choose how many bots you want.** A `BOTS` row at the top of the picker with **−** / **+** buttons, from 1 up to **25**. It also works from the keyboard: `-` and `=` (or `+`).
- **No more orbs in the Test Range.** Kills no longer drop loot orbs, and no food spawns at all — the arena starts clean and stays clean, which removes the biggest drawing cost in that mode.
- The badge on screen now reads `TEST RANGE` with `N BOTS CHARGING` underneath.
- Deathmatch and Team Deathmatch are untouched: 620 food items, 28 bots, orbs still drop on kills.

## What's new in v1.12
- The secret code is much easier to trigger: type `godmode` anywhere on the start screen — name box focused or not, any capitalisation, with spaces (`God Mode`), or even appended to a name that was already in the box.
- The start screen shows its build number, so you can confirm which version you are running.

## What's new in v1.11
- **Secret Test Range.** Type the code name **`godmode`** on the start screen and a third button appears: **TEST RANGE**.
  - A picker on the left lists all **28 evolutions** — click one, or press **1-9** / **0** / **[** / **]** to become that tier instantly.
  - The tier you pick is pinned: you do not outgrow it while you test.
  - Every bot in the arena **runs straight at you and never swings**, so you can walk them into your own blade and see exactly what your weapon kills.
  - **You cannot die in here** — try the same swing as many times as you like.
  - No clock, no scoreboard rules: the Test Range runs until you press **ESC** (or **TAB** to hide the picker).

## What's new in v1.10
- **The killing ground is the weapon itself.** Every weapon carries a table of its own drawn parts — blade, guard, head, tines — and the swing's hit test is built from those parts, so a swing kills exactly what the visible blade touches. No reach bonus, no graze padding, and nothing behind you.
- The Emperor finally has a visible broadsword (it had no weapon art at all before).

## Start screen
Pick your name on the title screen, then choose a mode:

- **DEATHMATCH** — free-for-all. A 10:00 timer counts down; when it hits zero the match ends.
- **TEAM DEATHMATCH** — Red vs Blue. A timer counts **up** from 0:00 and there is no time limit.
- **TEST RANGE** — the secret one. Type `godmode` anywhere on this screen to unlock it. Pick any of the 28 tiers, set the number of charging bots from 1 to **25**, and swing away: no clock, no food, no loot orbs, and you cannot die.

When you are defeated the match **keeps running** — the clock ticks on, golems keep marching and the statues keep the health they had. You respawn into the same match after a couple of seconds (or immediately with a click / key press), starting small again while the battle carries on around you. Only when the match itself ends (timer out, or a statue destroyed) do you return to the start screen. ESC still takes you back to the start screen whenever you want to leave.

## Controls
- **Move:** WASD / arrow keys (or steer with the mouse)
- **Swing:** SPACE or left-click — the killing ground is the weapon itself: the drawn blade, and the whole arc it sweeps through. One hit kills at any tier.
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
- Title screen where you choose your name and pick a mode (Deathmatch, Team Deathmatch, or the secret Test Range)
- A hidden Test Range for testing any of the 28 tiers: pick a tier, and the bots come running at you without ever swinging
- Deathmatch: 10-minute countdown; Team Deathmatch: count-up timer, Red vs Blue statues
- Captureable grey golems that switch sides when hit and march on the enemy statue
- 28 AI bots with hunting/fleeing/wandering instincts — they notice you and gang up when you get close, but they react slowly and miss often
- Leaderboard, minimap, kill feed, tier progress bar
- One-hit swings where the kill zone is the drawn weapon — every tier's blade, guard and head is modelled, so the arc you see is the arc that kills
- Berries, apples, gold and loot drops; trees, rocks, ponds, meadows, flowers
- Camera zooms out as you grow
- Responsive movement — crisp turning and stopping, no ice-skating

## Run
Open this folder in Godot 4.7+ and press F5, or `godot --path .`

Files: `scripts/species.gd` (the 28 tier designs), `creature.gd` (movement, swing, bot AI, team logic), `main.gd` (world, food, combat, game modes), `menu.gd` + `game_state.gd` (start screen and mode/team memory), `hud.gd`, `fx.gd`, `test_panel.gd` (the Test Range tier picker).
