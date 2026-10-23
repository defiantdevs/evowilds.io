# Evo Wilds (Godot 4.7)

A top-down eat-to-grow arena. Eat food, defeat rivals with one-hit weapon swings, and evolve through 43 humanoid tiers — from Caveman to The Infinite.

## Download
Current build: **v1.21** — [evo-wilds.zip (direct link)](https://github.com/defiantdevs/evowilds.io/releases/download/v1.21/evo-wilds.zip) · [always-latest link](https://github.com/defiantdevs/evowilds.io/releases/latest/download/evo-wilds.zip) · all versions on the [Releases page](https://github.com/defiantdevs/evowilds.io/releases).

Unzip it, open the folder in Godot 4.7+, and press F5. The start screen shows the build number in the bottom-right corner — if it does not say **BUILD v1.21**, you are still running an older download.

## What's new in v1.21

- **Orbs are decorative again.** The floating orbs just look pretty now, they don't kill anything.
- **Zoomed out at the top.** The camera pulls back a little more when you reach tier 46.

## What's new in v1.20
- **Five new Test Range only levels.** Tiers 44–48 live entirely in the Test Range (not in Deathmatch or Team Deathmatch). Each is bigger than The Infinite and gets its own weapon and headgear.
- The Test Range picker now lists all 48, with the five secret ranks tinted pink.

## What's new in v1.19
- **Fixed: the tier 42 and 43 giants no longer fly around the map.** A body that size cannot fit between the trees, and whenever one of them overlapped a trunk the game shoved it out to the far side of the trunk in a single frame — up to a hundred pixels at once. That snap was the "flying": the bot was not moving fast, it was being teleported from one side of a tree to the other, over and over. Big bodies are now eased out of a trunk at a walking pace, and any speed pointed into it is turned into a slide along its side, so titans step around trees instead of being flung across the arena.
- **Big bots no longer hatch inside a tree.** Spawn spots were chosen without knowing how wide the creature would be, so a giant could start its life buried in a trunk and be flung out on its first frame. Spawns now search outwards for the first gap the body actually fits in.
- Measured in the Test Range with 25 bots all pinned to tiers 42 and 43: the worst single-frame jump is now under 3 px, down from 93 px, and no creature anywhere on the map exceeds a normal running step.

## What's new in v1.18
- **Fixed: the biggest bots no longer fly around the arena.** Above tier 38 the run-acceleration curve went negative, so instead of building up to their walking speed they gained speed every single frame — by tier 43 a bot could hit a thousand pixels a second and would rocket across the map until it slammed into the arena edge. Acceleration now bottoms out at a sane value, so the titans move at their proper slow, heavy pace.
- Added a hard ceiling on how fast anything can travel, so no future tier can ever outrun its own legs again.
- The README's download header now points at the current build (it had been left on v1.16).

## What's new in v1.17
- **Ten new tiers above Author of Worlds: the game now has 43.** Every one is bigger than the last, and every one fights with **a weapon in each hand**:
  - **34 Sunforged** — a burning sun disc for a face, twin **sun cleavers**: wide molten blades on short hafts.
  - **35 Storm Herald** — lightning-bolt horns, twin **storm glaives**: jagged lightning blades on silver shafts.
  - **36 Abyss Sovereign** — a mask with too many eyes, twin **abyss tridents**, three glowing prongs on each.
  - **37 Crimson Colossus** — a horned brute helm, twin **colossus axes** with a heavy bit on both sides.
  - **38 Shard Prophet** — crystals orbiting its head, twin **shard blades** with split crystal tips.
  - **39 Elder Warden** — antlers and leaves, twin **bough blades**: living branches ending in a great leaf.
  - **40 Void Empress** — a dark orb where the face should be, twin **void scythes** with hooked crescents.
  - **41 Dragon Ascendant** — a dragon skull helm, twin **dragon fangs**: serrated greatswords with fanged guards.
  - **42 Primordial** — one great eye, twin **primordial blades** with a void orb floating inside each.
  - **43 The Infinite** — two interlocking rings of light over a blank face, twin **infinite blades** with double crescents and a split tip.
- **A blade on each side.** From tier 34 up the second weapon is a real second weapon: its own arm, its own swing trail, and its own killing ground built from the same drawn parts. It is not a wider hitbox bolted onto the first one.
- **The pair turns a full 160°.** At rest the blades sit out on your left and right. Swing and the pair rotates through 160 degrees — one blade sweeping down one side, the other down the other — so a single swing now covers both sides of you at once.
- **Levelling is properly hard now.** Every evolution costs more than it did (tier 2 goes from 28 XP to 50, Author of Worlds from 14,820 to 26,676), ten more gates sit above that up to **52,426** for The Infinite, and a kill now feeds you a quarter of the victim's XP instead of two-fifths. Climbing the whole ladder is a long fight again.
- The Test Range picker lists all 43 tiers, five to a row, and still fits on one screen — and it still folds away with **M**.
- Every new weapon's kill zone is still exactly the weapon: the cleaver's wide blade, the trident's prongs, the axe's bits, the scythe's hook and the void orb in the primordial blade are what kills, and nothing behind the blades is.

## What's new in v1.16
- **The Test Range box folds away.** Click the **–** in its top-right corner (or press **M**) and the whole tier list collapses into a slim title bar in the bottom-left corner that still shows the tier you are playing. Click **+** (or press **M** again) and the full picker comes back exactly where it was, centred down the left edge.
- Everything keeps working while it is folded: **1-9** / **0** pick a tier, **[** and **]** step through them, **- / +** change the bot count, **TAB** hides the bar outright, **ESC** leaves.
- It folds out of the way of the score, the kill feed and the middle of the arena, so nothing important is covered while you test.

## What's new in v1.15
- **Five new tiers above Omniverse God: the game now has 33.** Each has its own body, colours, face and weapon, so none of them is a recolour of the one before:
  - **29 Eclipse Monarch** — a black sun for a face, rimmed in white, carrying the **eclipse blade**: a black greatsword edged in white light.
  - **30 Chrono Warden** — a brass clock ring around its head with the hands still turning, carrying the **chrono halberd**: long brass shaft, axe head, spike, and a ticking dial on the haft.
  - **31 Genesis Prime** — a crown of leaves around a seed of light, carrying the **genesis spear**: a living shaft crowned with a great leaf.
  - **32 Aether Regent** — a smooth pale mask trailing ribbons of light, carrying the **aether warblade** between two fins of light.
  - **33 Author of Worlds** — an open book hangs behind a luminous face, and it carries the longest weapon in the game, the **quill of creation**, with a feather fan and a golden nib.
- The Test Range picker now lists all 33 tiers, five to a row; it still fits on one screen.
- Bigger statues hit harder: Team Deathmatch statue damage now runs from 1 to 33 by size.
- Every new weapon's kill zone is still built from its own drawn parts, so the quill's feather and nib, the spear's leaf, the halberd's axe head, the warblade's fins and the eclipse blade's edge are exactly what kills.

## What's new in v1.14
- **Movement turns on a coin, with no slide.** Your run now goes exactly where you point it each frame: a 90° turn keeps its full speed and simply goes the new way, and turning right around does not carry you a single extra pixel forward. No more skating through corners.
- **Levels 24 and 25 are now two different creatures.** Cosmos Emperor (24) is a violet figure carrying a **cosmic sceptre** — a dark rod with a ring of orbiting starlight. Astral Sovereign (25) is an **ice-blue** figure with a **double crescent astral glaive**. Different colours, different silhouette, different weapon.
- **Level 27 — Eternal Seraph — now has wings and a holy sword.** Three feathered wings per side, beating slowly, and a white-gold blade with a cross guard and a line of light down its middle.
- **Level 28 — Omniverse God — is rebuilt, not a recoloured 24.** It wears a **crown of light** (twin halo rings and ten rays), carries the white-gold **omniverse blade** with a star guard, and is ringed by two counter-rotating circles of light instead of one.
- Every new weapon's kill zone is built from its own drawn parts, exactly like the others: the ring of the sceptre, both crescents of the glaive, the cross guard of the holy sword and the whole omniverse blade are the killing ground, and nothing behind you is.

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
  - A picker on the left lists all **33 evolutions** — click one, or press **1-9** / **0** / **[** / **]** to become that tier instantly.
  - The tier you pick is pinned: you do not outgrow it while you test.
  - Every bot in the arena **runs straight at you and never swings**, so you can walk them into your own blade and see exactly what your weapon kills.
  - **You cannot die in here** — try the same swing as many times as you like.
  - No clock, no scoreboard rules: the Test Range runs until you press **ESC** (or **TAB** to hide the picker, **M** to fold it away).

## What's new in v1.10
- **The killing ground is the weapon itself.** Every weapon carries a table of its own drawn parts — blade, guard, head, tines — and the swing's hit test is built from those parts, so a swing kills exactly what the visible blade touches. No reach bonus, no graze padding, and nothing behind you.
- The Emperor finally has a visible broadsword (it had no weapon art at all before).

## Start screen
Pick your name on the title screen, then choose a mode:

- **DEATHMATCH** — free-for-all. A 10:00 timer counts down; when it hits zero the match ends.
- **TEAM DEATHMATCH** — Red vs Blue. A timer counts **up** from 0:00 and there is no time limit.
- **TEST RANGE** — the secret one. Type `godmode` anywhere on this screen to unlock it. Pick any of the 43 tiers, set the number of charging bots from 1 to **25**, and swing away: no clock, no food, no loot orbs, and you cannot die.

When you are defeated the match **keeps running** — the clock ticks on, golems keep marching and the statues keep the health they had. You respawn into the same match after a couple of seconds (or immediately with a click / key press), starting small again while the battle carries on around you. Only when the match itself ends (timer out, or a statue destroyed) do you return to the start screen. ESC still takes you back to the start screen whenever you want to leave.

## Controls
- **Move:** WASD / arrow keys (or steer with the mouse). Direction changes are instant — a turn goes where you point it, with no sliding.
- **Swing:** SPACE or left-click — the killing ground is the weapon itself: the drawn blade, and the whole arc it sweeps through. One hit kills at any tier.
- **Sprint:** SHIFT or right-click (drains XP)
- **Back to start screen:** ESC (or click / any key on the match-over screen)

## Team Deathmatch rules
- Two base statues — one **Red**, one **Blue** — each with **15,000 HP**.
- Grey golems spawn around the arena and stand still: **small** every 15s, **medium** every 40s, **large** every minute, **extra-large** every 2 minutes.
- Hit a golem or statue and it joins **your** team, turns your colour, and marches off to chip the enemy statue (small 1, medium 2, large 3, extra-large 5 damage on a size-based cooldown).
- You can hit the enemy statue directly: damage scales with your size from **1** (smallest) to **43** (biggest).
- First statue destroyed wins. Smaller bots charge the enemy statue; **big bots instead roam the arena and guard their own statue**, attacking anyone who comes near it.
- No friendly fire — team-mates can't hurt each other.

## Evolutions (43)
Caveman → Forager → Hunter → Tribesman → Peasant → Raider → Viking → Soldier → Knight → Samurai → Ninja → Gladiator → Crusader → Paladin → Sorcerer → Necromancer → Dragon Knight → Warlord → Emperor → Immortal Sage → Storm Titan → Death Reaper → Celestial King → Cosmos Emperor → Astral Sovereign → Void Titan → Eternal Seraph → Omniverse God → Eclipse Monarch → Chrono Warden → Genesis Prime → Aether Regent → Author of Worlds → Sunforged → Storm Herald → Abyss Sovereign → Crimson Colossus → Shard Prophet → Elder Warden → Void Empress → Dragon Ascendant → Primordial → The Infinite

## Features
- Title screen where you choose your name and pick a mode (Deathmatch, Team Deathmatch, or the secret Test Range)
- A hidden Test Range for testing any of the 43 tiers: pick a tier, and the bots come running at you without ever swinging
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

Files: `scripts/species.gd` (the 43 tier designs), `creature.gd` (movement, swing, bot AI, team logic), `main.gd` (world, food, combat, game modes), `menu.gd` + `game_state.gd` (start screen and mode/team memory), `hud.gd`, `fx.gd`, `test_panel.gd` (the Test Range tier picker).
