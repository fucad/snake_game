# Game Balance Design

> Version: draft-01 · Status: awaiting feedback
>
> This document defines all numbers that govern gameplay — round goals, world
> size, bot counts, upgrade values, XP rewards, and item rates. It is the
> single source of truth for game feel.
>
> **Where this lives in the repo:**
> All values defined here will be implemented as editable config files under
> `balance/` — plain Dart/JSON constants that any contributor can tune without
> touching game logic. See [Balance Folder](#balance-folder-structure) at the
> bottom.

---

## Design Principles

1. **Every variable has a floor and a ceiling.** The game must never become
   impossible (too fast, too many bots, world too large to navigate) or trivial
   (world too small, no bots, infinite upgrades).

2. **Round difficulty scales smoothly.** No single round should feel like a
   brick wall. Increments are small and predictable.

3. **Upgrades help, not carry.** A fully upgraded snake should feel noticeably
   better — but a player who understands the game should be able to clear early
   rounds without any upgrades.

4. **Balance is a living document.** All values here are tunable by contributors.
   If a round feels wrong, the fix is in `balance/` — not in game logic code.

---

## Core Variable Summary

These are every number that affects gameplay. All have explicit min/max limits.

| Variable | Controls | Floor | Ceiling |
|---|---|---|---|
| Arena width/height | How much space exists | 2 000 units | 5 000 units |
| Bot count | How many opponents | 3 | 12 |
| Bot difficulty | How smart opponents are | Easy | Hard |
| Food orb count | How much food is available | 20 | 80 |
| Item spawn interval | How often Boost/Magnet appear | 12 s | 35 s |
| Max items on field | Simultaneous pickups | 1 | 3 |
| Player base speed | Movement speed | 120 u/s | — (upgrade capped) |
| Player speed (with max upgrade) | — | — | 204 u/s |
| Player starting size | Segments at round start | 10 | — (upgrade capped) |
| Player starting size (max upgrade) | — | — | 35 segments |
| Detection range | Magnet + awareness radius | 100 units | 300 units |
| Round goal | Target size to win round | 20 segments | uncapped (scales linearly) |

---

## World Scaling

The arena grows as rounds advance so the game never feels claustrophobic, but
stops growing at a limit so navigation remains meaningful.

### Formula
```
arena_size = BASE_SIZE + (round_number - 1) × SIZE_STEP
arena_size = clamp(arena_size, MIN_ARENA, MAX_ARENA)
```

### Values
| Constant | Value |
|---|---|
| `BASE_SIZE` | 2 000 × 2 000 units |
| `SIZE_STEP` | +150 units per side per round |
| `MIN_ARENA` | 2 000 × 2 000 units |
| `MAX_ARENA` | 5 000 × 5 000 units (reached at round ~21) |

### Size Progression Table
| Round | Arena Size | Notes |
|---|---|---|
| 1 | 2 000 × 2 000 | Tight — early rounds feel dense |
| 3 | 2 300 × 2 300 | |
| 5 | 2 600 × 2 600 | |
| 8 | 3 050 × 3 050 | |
| 10 | 3 350 × 3 350 | |
| 15 | 4 100 × 4 100 | |
| 20 | 4 850 × 4 850 | |
| 21+ | 5 000 × 5 000 | **Capped** — no further growth |

### Why these limits?
- **2 000 floor:** below this the arena is too small to navigate with multiple
  snakes. Collisions feel unfair rather than skillful.
- **5 000 ceiling:** beyond this the minimap loses meaning, bots and player
  rarely interact, and the game loses tension.

---

## Bot Count Scaling

No bots respawn mid-round. The round ends when the player dies or meets the
goal. Bot count is set at round start and stays fixed.

### Formula
```
bot_count = BASE_BOTS + floor((round_number - 1) / BOT_STEP)
bot_count = clamp(bot_count, MIN_BOTS, MAX_BOTS)
```

### Values
| Constant | Value |
|---|---|
| `BASE_BOTS` | 3 |
| `BOT_STEP` | +1 bot every 2 rounds |
| `MIN_BOTS` | 3 |
| `MAX_BOTS` | 12 (reached at round ~21) |

### Bot Count Table
| Round | Bot Count |
|---|---|
| 1 | 3 |
| 3 | 4 |
| 5 | 5 |
| 7 | 6 |
| 9 | 7 |
| 11 | 8 |
| 13 | 9 |
| 15 | 10 |
| 17 | 11 |
| 19 | 12 |
| 21+ | **12 (capped)** |

### Why 12 bots max?
With the 5 000-unit capped arena and a max snake length of ~290 segments by
round 16, 12 snakes fill the space densely enough to feel dangerous without
making collision unavoidable regardless of player skill.

---

## Bot Difficulty Progression

Each bot is assigned a difficulty tier at spawn. The mix shifts toward harder
bots as rounds advance.

### Difficulty Tiers
| Tier | Behavior |
|---|---|
| Easy | Wanders randomly, avoids walls, no threat awareness |
| Normal | Seeks nearest food, avoids nearby snake bodies |
| Hard | Food-seeking, snake-avoidance, opportunistically chases death particles |

### Mix Per Round
| Round | Easy | Normal | Hard |
|---|---|---|---|
| 1 | 3 | 0 | 0 |
| 2 | 3 | 0 | 0 |
| 3 | 3 | 1 | 0 |
| 4 | 2 | 2 | 0 |
| 5 | 1 | 3 | 1 |
| 6 | 1 | 2 | 2 |
| 7 | 0 | 4 | 2 |
| 8 | 0 | 3 | 3 |
| 9 | 0 | 2 | 5 |
| 10 | 0 | 1 | 6 |
| 11 | 0 | 0 | 8 |
| 12+ | 0 | 0 | all |

---

## Food Orb Density

Food count scales proportionally to arena size so density stays consistent.

### Formula
```
food_count = round(arena_area / FOOD_AREA_PER_ORB)
food_count = clamp(food_count, MIN_FOOD, MAX_FOOD)
```

### Values
| Constant | Value |
|---|---|
| `FOOD_AREA_PER_ORB` | 200 000 sq units (1 orb per 200k sq units) |
| `MIN_FOOD` | 20 orbs |
| `MAX_FOOD` | 80 orbs |

### Resulting Food Counts
| Arena Size | Raw Count | Clamped |
|---|---|---|
| 2 000 × 2 000 (4M sq) | 20 | 20 |
| 3 000 × 3 000 (9M sq) | 45 | 45 |
| 4 000 × 4 000 (16M sq) | 80 | 80 |
| 5 000 × 5 000 (25M sq) | 125 | **80 (capped)** |

New food spawns immediately when an orb is eaten, maintaining the target count.

---

## Item Spawning (Boost & Magnet)

Items spawn randomly in the arena. Only one of each type can exist at a time.
Items despawn after 20 seconds if not collected.

### Spawn Rules
| Constant | Value |
|---|---|
| Boost spawn interval | 18 seconds (after previous pickup or despawn) |
| Magnet spawn interval | 24 seconds |
| Max Boost items on field | 1 |
| Max Magnet items on field | 1 |
| Item lifetime (uncollected) | 20 seconds |
| Minimum spawn distance from player | 300 units |

### Item Effects
| Item | Effect | Duration |
|---|---|---|
| **Boost** | Speed ×1.8 for the collecting snake | 5 seconds |
| **Magnet** | Pulls food orbs within detection range toward head | 7 seconds |

Items do not stack. Collecting a second Boost while one is active resets the timer.

### Scaling with rounds?
Item spawn rates do **not** scale with rounds. They remain constant. Items are
the player's relief valve — keeping their rate predictable means skilled players
can learn to time them.

---

## Round Goal Progression

Each round has a target snake size (in segments) the player must reach to pass.
Failing the goal still ends the session and awards base XP — it does not lock
the player out.

### Formula
```
round_goal = BASE_GOAL + (round_number - 1) × GOAL_STEP
```
Goal grows linearly. No cap — rounds can always be harder.

### Values
| Constant | Value |
|---|---|
| `BASE_GOAL` | 20 segments (round 1) |
| `GOAL_STEP` | +18 segments per round |

### Round Table (first 20 rounds)
| Round | Goal | Arena | Bots | Bot Mix | XP (goal met) | XP (base) |
|---|---|---|---|---|---|---|
| 1 | 20 | 2 000 | 3 | 3E | 25 XP | 10 XP |
| 2 | 38 | 2 150 | 3 | 3E | 30 XP | 12 XP |
| 3 | 56 | 2 300 | 4 | 3E+1N | 36 XP | 14 XP |
| 4 | 74 | 2 450 | 4 | 2E+2N | 43 XP | 17 XP |
| 5 | 92 | 2 600 | 5 | 1E+3N+1H | 52 XP | 20 XP |
| 6 | 110 | 2 750 | 5 | 1E+2N+2H | 62 XP | 24 XP |
| 7 | 128 | 2 900 | 6 | 4N+2H | 74 XP | 29 XP |
| 8 | 146 | 3 050 | 6 | 3N+3H | 89 XP | 35 XP |
| 9 | 164 | 3 200 | 7 | 2N+5H | 107 XP | 42 XP |
| 10 | 182 | 3 350 | 7 | 1N+6H | 128 XP | 50 XP |
| 11 | 200 | 3 500 | 8 | 8H | 154 XP | 60 XP |
| 12 | 218 | 3 650 | 8 | 8H | 185 XP | 72 XP |
| 13 | 236 | 3 800 | 9 | 9H | 222 XP | 86 XP |
| 14 | 254 | 3 950 | 9 | 9H | 266 XP | 103 XP |
| 15 | 272 | 4 100 | 10 | 10H | 319 XP | 124 XP |
| 16 | 290 | 4 250 | 10 | 10H | 383 XP | 149 XP |
| 17 | 308 | 4 400 | 11 | 11H | 460 XP | 179 XP |
| 18 | 326 | 4 550 | 11 | 11H | 552 XP | 215 XP |
| 19 | 344 | 4 700 | 12 | 12H | 662 XP | 258 XP |
| 20 | 362 | 4 850 | 12 | 12H | 794 XP | 310 XP |
| 21+ | +18/round | 5 000 (cap) | 12 (cap) | 12H | ×1.2/round | ×1.2/round |

### Bonus XP for kills during a round
- +8 XP per bot killed (awarded at round end, regardless of goal)

### XP for size reached (partial credit)
Even if the goal is not met, the player gets partial XP proportional to
how close they got:

```
partial_xp = base_xp × (size_reached / round_goal)
partial_xp = max(partial_xp, MIN_PARTIAL_XP)
MIN_PARTIAL_XP = 5 XP
```

---

## Player Upgrade System

Three permanent stats. Each has **5 upgrade tiers** beyond the base.
Upgrades are purchased with XP between rounds on the Upgrade screen.

### Speed Upgrade
Base speed: **120 units/second**

| Tier | Speed | Multiplier | XP Cost | Cumulative Cost |
|---|---|---|---|---|
| 0 (base) | 120 u/s | ×1.00 | — | — |
| 1 | 132 u/s | ×1.10 | 20 XP | 20 XP |
| 2 | 148 u/s | ×1.23 | 35 XP | 55 XP |
| 3 | 166 u/s | ×1.38 | 55 XP | 110 XP |
| 4 | 186 u/s | ×1.55 | 80 XP | 190 XP |
| 5 | 204 u/s | ×1.70 | 110 XP | 300 XP |

**Cap rationale:** ×1.70 feels noticeably faster without making the game
uncontrollable on a small phone screen. Beyond ×2.0 the game becomes a
reaction test rather than a strategy game.

---

### Detection Range Upgrade
Controls: magnet pull radius + how close bots get before the player notices
them approaching (used for visual warning system in the HUD).

Base range: **100 units**

| Tier | Range | XP Cost | Cumulative Cost |
|---|---|---|---|
| 0 (base) | 100 u | — | — |
| 1 | 130 u | 20 XP | 20 XP |
| 2 | 165 u | 35 XP | 55 XP |
| 3 | 205 u | 55 XP | 110 XP |
| 4 | 250 u | 80 XP | 190 XP |
| 5 | 300 u | 110 XP | 300 XP |

**Cap rationale:** At 300 units the magnet picks up food from roughly ⅙ of the
smallest arena's width. Beyond this the player passively vacuums food without
steering, removing the skill element.

---

### Starting Size Upgrade
Segments the player's snake starts with at the beginning of each round.

| Tier | Starting Segments | XP Cost | Cumulative Cost |
|---|---|---|---|
| 0 (base) | 10 | — | — |
| 1 | 14 | 25 XP | 25 XP |
| 2 | 19 | 40 XP | 65 XP |
| 3 | 25 | 65 XP | 130 XP |
| 4 | 31 | 95 XP | 225 XP |
| 5 | 38 | 130 XP | 355 XP |

**Cap rationale:** At 38 segments the player starts with roughly 20% of the
round 1 goal already met. Starting larger than ~40 segments would make early
rounds feel trivial and undermine the round goal mechanic.

---

### Max Upgrade Cost Summary
Fully upgrading all three stats costs **955 XP** total.

A player completing rounds with average performance (no kills, goal met ~50%
of the time) would reach this at roughly round 25–30. Faster if skilled.
This ensures upgrades feel earned, not rushed.

---

## Progression Stages

Rounds are grouped into stages for UI framing (shown on the Round Intro screen).
Stages are cosmetic — they don't change the underlying formulas.

| Stage | Rounds | Label | Description |
|---|---|---|---|
| 1 | 1–3 | **Hatchling** | Gentle introduction. All Easy bots. Small arena. |
| 2 | 4–7 | **Crawler** | First Normal bots. Slightly larger goals. |
| 3 | 8–12 | **Predator** | Hard bots appear. Tension increases. |
| 4 | 13–20 | **Apex** | Full Hard bots. Arena approaching max size. |
| 5 | 21+ | **Endless** | All variables capped. Goals scale forever. True endgame. |

---

## Snake Speed During Boost Item

When the Boost item is active, speed is multiplied on top of the player's
current upgrade level.

```
active_speed = (base_speed × upgrade_multiplier) × BOOST_MULTIPLIER
```

| Constant | Value |
|---|---|
| `BOOST_MULTIPLIER` | ×1.8 |
| Boost duration | 5 seconds |

**Example:** A player at Speed Tier 3 (166 u/s) with Boost active:
`166 × 1.8 = 299 u/s` — noticeably fast but not uncontrollable.

**Hard cap:** Even with max upgrade + boost, speed is:
`204 × 1.8 = 367 u/s` — the absolute ceiling. This is intentional.

---

## Death Particle Economy

When a snake dies its body converts to collectible particles.

| Constant | Value |
|---|---|
| Particles per segment | 1 orb |
| Particle value (segments gained) | 1 per 3 particles eaten |
| Particle lifetime | 25 seconds |
| Particle scatter radius | ±50 units from segment position |

**Example:** A 60-segment bot snake dies → spawns 60 particles. Eating all 60
gives the player 20 additional segments. This creates meaningful "feast"
moments after large kills.

---

## Balance Folder Structure

All values above will live in a dedicated `balance/` folder as Dart constant
files. This means:

- Anyone can tune a value without understanding the game engine
- AI contributors can open one file and make a targeted change
- Each file maps 1:1 to a section of this document

```
balance/
├── README.md               ← How to edit safely, what each file controls
├── world_config.dart       ← Arena size, food density
├── bot_config.dart         ← Bot count, difficulty mix per round
├── round_config.dart       ← Round goals, XP rewards, stage labels
├── upgrade_config.dart     ← Upgrade tiers, costs, effects
├── item_config.dart        ← Item spawn rates, effects, durations
└── particle_config.dart    ← Death particle count, value, lifetime
```

Each file exports a single constant class. Example:

```dart
// balance/world_config.dart
class WorldConfig {
  static const double baseArenaSize   = 2000;
  static const double sizeStepPerRound = 150;
  static const double minArenaSize    = 2000;
  static const double maxArenaSize    = 5000;

  static const int    minFood         = 20;
  static const int    maxFood         = 80;
  static const double foodAreaPerOrb  = 200000;
}
```

The game logic layer imports only from `balance/`. To rebalance anything,
open the relevant file, change the constant, and submit a PR.

---

## Open Balance Questions

These require further playtesting before locking in. Mark resolved after feedback.

| # | Question | Current assumption | Status |
|---|---|---|---|
| B1 | Is GOAL_STEP of +18 segments the right pacing? | +18/round | Open |
| B2 | Is 5 upgrade tiers the right depth? | 5 tiers each | Open |
| B3 | Is 300 XP per stat (955 total) the right grind? | ~25–30 rounds | Open |
| B4 | Should bots scale in base speed by round? | No — fixed speed | Open |
| B5 | Should Boost item give same multiplier at all upgrade tiers? | Yes — flat ×1.8 | Open |
| B6 | Should there be a 4th upgrade stat? (e.g., XP multiplier, shield) | Not in v1 | Open |
| B7 | Should Easy bots exist past round 5? | No (see mix table) | Open |
| B8 | Is ×1.2/round XP scaling for round 21+ sustainable? | Needs testing | Open |
