# CLAUDE.md — Claude Code Project Guide

This file is read by Claude Code at the start of every session.
It contains everything you need to contribute safely and correctly.

---

## What This Project Is

An open-source, ad-free arena snake game built with Flutter and Flame.
**Slither.io-style** — smooth continuous movement, large scrolling arena,
player vs AI bots, death particles, collectible items, round-based progression
with XP and upgrades. Local only, no server, no internet required.

This is part of the **fucad** initiative: free casual games as a public good.
Zero ads, zero monetization, zero data collection. MIT License.

---

## Stack

- **Flutter 3.44.1** — UI framework, target platforms: Android + iOS
- **Flame 1.37.0** — game engine (rendering, game loop, components)
- **Dart 3.12.1**
- **shared_preferences** — local persistence only
- **Nunito** — typography, bundled in `assets/fonts/` (OFL; no runtime fetching)
- **vector_math** — `Vector2` for the logic layer (the same type Flame re-exports)
- **flame_audio** — sound effects

---

## Architecture — Read This Before Touching Any File

The codebase has three strict layers. The rule between them is a hard wall.

```
lib/
├── balance/        LAYER 0 — Plain constants. No imports, no logic.
├── game/
│   ├── logic/      LAYER 1 — Pure Dart game logic. No Flutter, no Flame.
│   └── bot/        LAYER 1 — AI bot strategies. No Flutter, no Flame.
│   └── components/ LAYER 2 — Flame rendering. Reads logic state, never writes it.
│   └── snake_game.dart  LAYER 2 — Main FlameGame. Owns the game loop.
├── progression/    LAYER 1 — XP, upgrades, persistence. No Flutter, no Flame.
└── ui/
    ├── theme/      LAYER 0 — Design tokens. No logic.
    └── screens/    LAYER 3 — Flutter UI. Wraps Flame, shows overlays.
    └── widgets/    LAYER 3 — Reusable Flutter widgets.
```

### The one rule that matters most

**`lib/game/logic/` and `lib/progression/` must never import Flutter or Flame.**

If you are in `lib/game/logic/` and feel the urge to write
`import 'package:flame/...'` — stop. You are in the wrong layer.
Move rendering concerns to `lib/game/components/`.

This separation exists so:
- Logic is fully unit-testable without a simulator
- AI contributors can fix game rules without understanding Flame
- Rendering can be replaced without touching game rules

---

## Where Things Live

| What you want to change | File(s) to touch |
|---|---|
| A game number (speed, XP, bot count) | `lib/balance/*.dart` only |
| Round goals or stage labels | `lib/balance/round_config.dart` |
| How the snake moves | `lib/game/logic/movement_logic.dart` |
| Collision detection | `lib/game/logic/collision_logic.dart` |
| What happens when a snake dies | `lib/game/logic/death_logic.dart` |
| How food/items spawn | `lib/game/logic/spawn_logic.dart` |
| How XP is calculated | `lib/game/logic/xp_logic.dart` |
| Bot AI behaviour | `lib/game/bot/easy_bot.dart` / `normal_bot.dart` / `hard_bot.dart` |
| How the snake looks | `lib/game/components/snake_component.dart` |
| How the arena looks | `lib/game/components/arena_component.dart` |
| Colors | `lib/ui/theme/app_colors.dart` |
| Typography | `lib/ui/theme/app_text_styles.dart` |
| Spacing / sizing | `lib/ui/theme/app_dimensions.dart` |
| Any screen UI | `lib/ui/screens/*.dart` |
| Upgrade logic | `lib/progression/upgrade_logic.dart` |
| Save / load player data | `lib/progression/persistence_service.dart` |

---

## Balance Folder — Special Rules

`lib/balance/` contains **only plain Dart constants**. No methods, no logic,
no conditionals, no imports. Every file exports a single class with a private
constructor.

When tuning game feel, edit `lib/balance/` **first**. Only touch game logic
code if the constant-based approach genuinely cannot express what you need.

---

## How to Run

```bash
# Install dependencies
flutter pub get

# Run tests
flutter test

# Analyse for errors
dart analyze lib/

# Run on a device
flutter run

# Dev: open straight into a round-1 arena (simulator screenshots)
flutter run --dart-define=AUTOSTART=true
```

`test/logic/game_tick_test.dart` simulates whole rounds headlessly through
`RoundSetup.build` + `GameTick.advance` — extend it when changing rules.

All tests live in `test/`. Logic layer tests (`test/logic/`) do not require a
device and run in milliseconds. Run them after every logic change.

---

## Design System

Every color, font, spacing value, and animation duration has a named token.
**Never use raw values in widget code.**

```dart
// Wrong
Container(color: Color(0xFF1E2130), padding: EdgeInsets.all(16))

// Right
Container(color: AppColors.surface, padding: EdgeInsets.all(AppDimensions.spaceMd))
```

Full reference: `DESIGN_SYSTEM.md`
Token files: `lib/ui/theme/app_colors.dart`, `app_text_styles.dart`,
`app_dimensions.dart`, `app_animations.dart`

---

## Contribution Patterns

### Pattern 1 — Balance Tuning (safest)
Touch only `lib/balance/*.dart`. No logic changes. Always include before/after
values in the PR description.

```
Files touched: lib/balance/round_config.dart
Change: baseGoal 20 → 15 (round 1 was too hard for new players)
Tests: flutter test test/logic/round_logic_test.dart
```

### Pattern 2 — Bot AI Improvement
Touch only `lib/game/bot/*.dart`. The bot contract:
- Takes `SnakeState` and `ArenaState`, returns a normalised `Vector2` direction
- Must not mutate state
- Must not import Flutter or Flame

```dart
// Bot interface (never change this)
Vector2 computeDirection(SnakeState bot, ArenaState state);
```

### Pattern 3 — Visual / UI
Touch only `lib/game/components/*.dart` or `lib/ui/screens/*.dart`.
Never reach back into `lib/game/logic/` from a component to change state.
Components read state; logic writes state.

### Pattern 4 — New Screen
1. Create the screen in `lib/ui/screens/`
2. Use only `AppColors`, `AppTextStyles`, `AppDimensions`, `AppAnimations`
3. No game logic in screen files — pass data in as constructor parameters
4. Add navigation to it from the appropriate parent screen

### Pattern 5 — New Sound Effect
1. Add the `.ogg` file to `assets/audio/`
2. Register it in the audio preload list in `lib/game/snake_game.dart`
3. See `assets/audio/CONTRIBUTING.md` for format and licensing rules

---

## What NOT to Do

- Do not put game rules inside Flame components
- Do not import `package:flame` or `package:flutter` in `lib/game/logic/`
- Do not use raw `Color(...)`, `TextStyle(fontSize: ...)`, or magic spacing numbers in widget files
- Do not add `print()` statements to logic files
- Do not skip tests — every logic change needs test coverage
- Do not add ads, analytics, or network calls of any kind
- Do not add `shared_preferences` keys outside `lib/progression/persistence_service.dart`
- Do not create new balance constants inside logic files — they belong in `lib/balance/`

---

## Writing Tests

Logic layer tests go in `test/logic/`. They must not import Flame or Flutter test widgets.

```dart
// test/logic/round_logic_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:snake_game/game/logic/round_logic.dart';

void main() {
  test('round 1 goal is 20 segments', () {
    expect(RoundLogic.goalForRound(1), 20);
  });

  test('arena size is capped at 5000', () {
    expect(RoundLogic.arenaSizeForRound(999), 5000);
  });
}
```

---

## Key Decisions (Don't Relitigate)

| Decision | Value |
|---|---|
| Game type | Slither.io-style arena, smooth movement, not grid-based |
| Multiplayer | Never — local only, no server |
| Head-vs-head collision | Smaller snake dies |
| Boost mechanic | Item pickup (Boost item), not burn-length |
| Monetization | None, ever |
| Analytics | None, ever |
| Bot respawn | No respawning — count fixed at round start |
| Font | Nunito |
| App ID | com.fucad.snake_game |

---

## File Checklist for a PR

- [ ] `dart analyze lib/` returns no errors
- [ ] `flutter test` passes
- [ ] No raw color/font/spacing values in widget files
- [ ] Logic files have no Flutter/Flame imports
- [ ] Balance changes are in `lib/balance/`, not hardcoded
- [ ] New public functions/classes have a brief doc comment
- [ ] Asset files include license source in PR description

---

## Sources

- `GAME_DESIGN.md` — full mechanics specification
- `GAME_BALANCE.md` — all balance values with rationale
- `DESIGN_SYSTEM.md` — color, typography, spacing rules
- `CONTRIBUTING.md` — human contributor workflow
