# Game Design Document

> This is the mechanics contract. If a rule or behaviour is not described
> here, it does not exist in the game. Contributors must not add, remove,
> or change mechanics without updating this document first.
>
> Numbers (speeds, counts, XP values) are NOT defined here — they live in
> `lib/balance/` and `GAME_BALANCE.md`. This document defines structure and
> rules, not tuning.

---

## 1. Game Summary

A single-player arena snake game. The player controls one snake in a large
open arena shared with AI-controlled bot snakes. The goal each round is to
grow the snake to a target length by eating food, collecting items, and
surviving long enough to outlast or outmanoeuvre opponents.

There is no internet connection required. There are no ads. There is no
server. All progress is stored locally on the device.

---

## 2. Core Loop

```
┌─────────────────────────────────────────────┐
│              ROUND INTRO SCREEN             │
│   Shows: round number, stage, size goal     │
└──────────────────┬──────────────────────────┘
                   │ player taps "Start"
                   ▼
┌─────────────────────────────────────────────┐
│                  ARENA                      │
│  Player steers snake, eats, survives        │
│  Bots act independently                     │
│  Round ends when: player dies OR goal met   │
└──────────┬──────────────────────┬───────────┘
           │ player died          │ goal met
           ▼                      ▼
┌──────────────────┐   ┌─────────────────────┐
│  GOAL NOT MET    │   │    GOAL MET          │
│  Base XP only    │   │    Bonus XP          │
└────────┬─────────┘   └──────────┬──────────┘
         └──────────────┬─────────┘
                        ▼
           ┌────────────────────────┐
           │     GAME OVER SCREEN   │
           │  Score, XP earned,     │
           │  goal result           │
           └────────────┬───────────┘
                        │
              ┌─────────┴──────────┐
              │                    │
              ▼                    ▼
    ┌──────────────────┐  ┌─────────────────┐
    │  UPGRADE SCREEN  │  │   RETRY / NEXT  │
    │  Spend XP        │  │   ROUND INTRO   │
    └──────────────────┘  └─────────────────┘
```

---

## 3. The Arena

### Shape and size
The arena is a square flat field. Its size grows with each round up to a
maximum cap. A visual border marks the edge. There are no obstacles inside
the arena — the field is open.

### Boundary
Hitting the arena wall kills the snake instantly. There is no wrap-around.
The wall is a hard kill boundary.

### Camera
The camera always centers on the player's snake head. The player sees a
viewport window into the arena — the full arena is larger than the screen.
The camera follows the head with a smooth lerp (slight lag for feel).

### Minimap
A small minimap in the corner shows the full arena with dot indicators for
every snake. The player snake is highlighted in a distinct color. The
minimap updates in real time.

---

## 4. The Player Snake

### Appearance
The snake is a chain of rounded circular segments. The head is visually
distinct from the body (brighter, slightly larger). The player snake is
always green. The tail tapers slightly.

### Movement
Movement is **smooth and continuous** — not grid-based. The snake moves
forward at all times at a constant speed. The player cannot stop the snake.

The snake steers by rotating toward the player's touch point. The turn rate
is limited — the snake cannot reverse direction instantly. It carves arcs,
not right angles.

### Controls (mobile — primary)
**Follow-finger:** The snake always steers toward wherever the player's
finger is on the screen. Moving the finger changes the target direction.
Lifting the finger keeps the last direction.

The control area is the full screen. No dedicated joystick is required,
though a joystick mode may be offered as an accessibility option in settings.

### Controls (keyboard — development / desktop)
Arrow keys or WASD steer the snake. The snake turns toward the held key's
direction continuously.

### Growth
Each food orb or particle orb collected adds segments to the snake's tail.
The snake never shrinks during normal play (no burn-length boost mechanic).

### Starting length
The snake starts each round with a base number of segments. The Starting
Size upgrade increases this base.

---

## 5. Bot Snakes

### Count and placement
Bots are spawned at the start of each round. Their count scales with the
round number up to a maximum cap. Bots are placed at random positions
across the arena, with a minimum distance from the player's spawn point.

### No respawning
When a bot snake dies it is gone for the rest of the round. No new bots
spawn mid-round. The arena becomes progressively less crowded as bots die.

### Difficulty tiers
Each bot is assigned a difficulty tier at spawn. Three tiers exist:

**Easy** — Wanders semi-randomly. Avoids walls. Has no awareness of other
snakes. Poses low threat to an attentive player.

**Normal** — Seeks the nearest food orb. Steers away from other snake
bodies within a detection radius. Avoids walls reliably. A consistent
mid-level threat.

**Hard** — Seeks food and also chases death particle clusters after kills.
Strong body avoidance. Harder to trap and harder to avoid. Poses real
threat to the player at all times.

The mix of difficulty tiers shifts toward harder bots in later rounds.

### Bot appearance
Each bot snake has a unique color from a fixed palette, distinct from the
player snake and from other bots. Color is assigned at spawn in order from
the palette.

---

## 6. Food Orbs

Small glowing orbs scattered across the arena. There is always a target
number of food orbs present. When one is eaten a replacement spawns
immediately at a random empty location.

Eating a food orb grows the snake by one segment (value of 1).

Food orbs do not move and do not expire.

---

## 7. Collectible Items

Two item types spawn randomly in the arena. Items are visually distinct
from food orbs — larger, different shape and color, with a glow animation.

At most one instance of each item type exists on the field at a time.
Items despawn automatically after a fixed duration if not collected.
A new item of the same type spawns after a cooldown following pickup or
despawn.

Items activate immediately on collection — no button press required.
Only the collecting snake benefits.

### Boost Item (blue)
**Effect:** The collecting snake's speed multiplies for a short duration.
The multiplier applies on top of the snake's current upgrade-based speed.
Visually: a speed trail appears behind the snake while active.

Boost does not change the snake's length. It only affects speed.
Collecting a second Boost while one is already active resets the timer.

### Magnet Item (purple)
**Effect:** Food orbs within the snake's detection range are pulled
toward the snake head for a short duration. The pull is a smooth arc —
orbs accelerate toward the head, not teleport.
Visually: a soft pulsing ring around the snake head while active.

The detection range for the magnet is the same value as the player's
Detection Range upgrade stat.

---

## 8. Collision Rules

### Head hits body
When a snake's head overlaps any segment of another snake's body, the
attacking snake dies. The attacked snake is unaffected.

A small "safe zone" of segments nearest the snake's own head are excluded
from self-collision — a snake cannot die by curling into itself within
the first few segments.

### Head-to-head
When two snakes' heads collide simultaneously, the **shorter snake dies**.
If both snakes are exactly the same length, both die.

### Wall collision
Any snake whose head crosses the arena boundary dies immediately.
This applies to bots and the player equally.

### Kill credit
If the player caused the death (their body was the obstacle), the player
receives kill credit and bonus XP. Bot-on-bot kills award no XP.

---

## 9. Death and Particles

### When a snake dies
1. A brief visual flash plays on the dead snake (white dissolve).
2. The snake's body converts to particle orbs distributed along the
   body's position at the moment of death.
3. Particles scatter outward from each segment with a small random
   velocity then drift slowly.
4. Particles are immediately collectible by any living snake.
5. Particles expire after a fixed duration if not collected.

### Particle economy
Particles are worth less per-unit than food orbs — it takes several
particles to gain one segment. Killing a large snake creates a feast
that is substantially rewarding.

### Kill feedback
When the player kills a bot:
- Screen shake (brief, proportional to the killed snake's size)
- A kill chime sound plays
- A brief haptic pulse fires (if haptics are enabled)

---

## 10. Round System

### Round intro
Before each round, the player sees:
- Round number
- Stage label (Hatchling / Crawler / Predator / Apex / Endless)
- The size goal for this round ("Reach length 56")
- A start button

### Round goal
The goal is a target snake length in segments. If the player reaches or
exceeds this length at any point during the round, the goal is immediately
marked as met. The round does not end at this point — the player may
continue playing to earn more kills and a higher score.

The round ends only when the player's snake dies.

### Passing a round
If the goal was met before death:
- "Goal met" shown on game over screen
- Full bonus XP awarded
- The current round number advances by one
- The next round intro screen shows the new round

### Failing a round
If the player dies before meeting the goal:
- "Goal not met" shown on game over screen
- Partial XP awarded proportional to how close they got
- The round number does not advance
- The same round can be retried immediately

The player is never locked out of a round. There are no lives.

### Endless mode
After round 20 all arena and bot variables are capped at their maximum
values. Goals continue to increase linearly forever. This is the endgame
for experienced players.

---

## 11. Scoring

The in-game score equals the player snake's current length in segments.
The score shown on game over is the maximum length reached during the round.

A persistent local high score records the best score across all sessions.
No account or network required.

---

## 12. XP and Upgrades

### Earning XP
XP is awarded at the end of every round regardless of goal outcome.
Sources:
- **Base XP** — scales with round number and whether the goal was met
- **Kill XP** — flat bonus per bot snake killed
- **Partial credit** — if the goal was not met, base XP is proportional
  to how far the player got (always at least a minimum floor)

XP is cumulative and persistent across all rounds and sessions.

### Spending XP
Between rounds (on the Upgrade screen), the player spends XP to
permanently upgrade their snake's stats. Upgrades persist forever — they
are never reset.

Three upgradeable stats, each with five tiers above base:

**Speed** — increases the snake's base movement speed. Higher tiers make
the snake faster to steer and harder for bots to catch.

**Detection Range** — increases the radius of the Magnet item effect and
the range at which the player receives proximity warnings. Does not affect
vision or the camera.

**Starting Size** — increases the number of segments the snake begins
each round with. A larger start means less grinding for early-round goals.

Each tier has a fixed XP cost. Costs increase with each tier. Upgrades
must be purchased in order — tier 3 requires tier 2.

### Upgrade screen
Shown after game over. Displays current XP balance, all three stats with
current tier, tier dots (filled = owned, empty = available), cost of next
tier, and an upgrade button (greyed out if unaffordable).

The player may skip upgrades and go directly to the next round.

---

## 13. Settings

The following can be toggled or adjusted in the Settings screen.
All settings persist across sessions.

| Setting | Type | Default |
|---|---|---|
| Sound effects | On / Off | On |
| Music | On / Off | Off |
| Haptic feedback | On / Off | On |
| Bot count | Slider (min–max) | Default per round |
| Bot difficulty | Easy / Normal / Hard / Mixed | Mixed |
| Show minimap | On / Off | On |
| Controls | Follow-finger / Joystick | Follow-finger |

Bot count and difficulty in settings override the round-based scaling
when set manually. This is intended for players who want a custom experience
or for accessibility purposes.

---

## 14. Screens

| Screen | When shown |
|---|---|
| Home | App launch. Shows high score, current round, start and settings buttons. |
| Round Intro | Before each round. Shows round number, stage, goal. |
| Game (arena) | During play. Shows arena, HUD, minimap. |
| Pause overlay | When player pauses mid-game. Semi-transparent over arena. |
| Game Over | After player snake dies. Shows score, XP earned, goal result. |
| Upgrade | After game over, before next round. Optional — player can skip. |
| Settings | Accessible from Home and Pause. |
| How to Play | Accessible from Home. One-screen explanation of controls and items. |

---

## 15. HUD (In-Game Overlay)

Displayed over the arena during play. Kept minimal — the arena is the content.

| Element | Position | Content |
|---|---|---|
| Score | Top center | Current snake length (updates live) |
| Stage / round label | Below score | Small, secondary |
| Active item indicator | Top right | Icon + countdown bar when Boost or Magnet is active |
| Minimap | Bottom right corner | Arena overview with snake positions |

No in-game buttons during play other than a pause tap gesture (double-tap or
system back gesture). This keeps the play area unobstructed.

---

## 16. What This Game Is Not

These are not design oversights — they are explicit constraints.

- **Not multiplayer.** No real-time opponents, no server, no leaderboard sync.
- **Not monetized.** No ads, no IAP, no premium content, no subscriptions.
- **Not grid-based.** Movement is smooth and continuous, not tile-by-tile.
- **Not endless survival without structure.** There are rounds with goals.
- **Not a gacha or loot system.** Upgrades are deterministic and permanent.
- **Not data-collecting.** No analytics, no crash reporting, no user accounts.

Any PR that adds any of the above will not be merged.

---

## 17. Out of Scope for v1

The following are valid future additions but are explicitly not in v1:

- Additional game modes (e.g. survival, time attack, last-snake-standing)
- Multiple arena themes / backgrounds
- Snake skin customization
- Global leaderboard (local only in v1)
- Replay system
- Dynamic difficulty adjustment
- Accessibility themes (high contrast, reduced motion)
- Localization / multi-language

These should be filed as GitHub issues, not added to v1 PRs.
