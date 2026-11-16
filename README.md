# Snake Game

An open-source, ad-free arena snake game for Android and iOS. Part of the [fucad](https://github.com/fucad) initiative — free casual games as a public good.

Zero ads. Zero monetization. Zero data collection. MIT License.

---

## What It Is

A smooth, continuous-movement arena snake game where you grow by eating food orbs and absorbing death particles from eliminated snakes. Survive the arena, outlast AI bots, and meet the segment-count goal each round to earn XP and upgrade your snake.

**Key mechanics:**
- Eat food orbs to grow one segment at a time
- Kill bot snakes by making their head collide with your body — smaller snake always loses head-to-head
- Dead snakes scatter particles; collect 3 to gain 1 segment
- Boost item temporarily doubles your speed; Magnet item pulls nearby food to you
- Rounds end when the goal length is met or your snake dies
- XP earned each round funds permanent speed, size, and detection-range upgrades
- Bot count and difficulty scale with round number — no bot respawning

---

## Stack

| Layer | Technology |
|---|---|
| UI framework | Flutter 3.44.1 |
| Game engine | Flame 1.37.0 |
| Language | Dart 3.12.1 |
| Fonts | Nunito via google_fonts |
| Sound | flame_audio |
| Persistence | shared_preferences (local only) |

---

## Getting Started

```bash
# Install dependencies
flutter pub get

# Run on a connected device or simulator
flutter run

# Run all tests
flutter test

# Static analysis
dart analyze lib/
```

Requires Flutter 3.44.1+. No server, no backend, no internet required at runtime.

---

## Architecture

The codebase is split into four strict layers. Dependencies only flow downward — upper layers must never reach into lower layers to mutate state.

```
lib/
├── balance/          Layer 0 — Plain constants only. No logic, no imports.
├── game/
│   ├── logic/        Layer 1 — Pure Dart game rules. No Flutter, no Flame.
│   ├── bot/          Layer 1 — AI bot strategies. No Flutter, no Flame.
│   └── components/   Layer 2 — Flame rendering. Reads logic state, never writes it.
│   └── snake_game.dart   Layer 2 — Main FlameGame, owns the game loop.
├── progression/      Layer 1 — XP, upgrades, local persistence.
├── settings/         Layer 1 — Settings model and SharedPreferences persistence.
└── ui/
    ├── theme/        Layer 0 — Design tokens (colors, typography, spacing).
    ├── screens/      Layer 3 — Flutter screens and overlays.
    └── widgets/      Layer 3 — Reusable Flutter widgets.
```

**The one rule that matters most:** `lib/game/logic/`, `lib/game/bot/`, and `lib/progression/` must never import Flutter or Flame. Logic is unit-testable without a device.

For full architecture details, see [CLAUDE.md](CLAUDE.md).  
For balance values and rationale, see [GAME_BALANCE.md](GAME_BALANCE.md).  
For mechanic specifications, see [GAME_DESIGN.md](GAME_DESIGN.md).  
For the design system, see [DESIGN_SYSTEM.md](DESIGN_SYSTEM.md).

---

## Contributing

All contributions are welcome. Please read [CONTRIBUTING.md](CONTRIBUTING.md) first.

Before opening a PR:
- `dart analyze lib/` must return no errors
- `flutter test` must pass
- No raw `Color(...)`, font sizes, or magic spacing values in widget files
- Logic files (`lib/game/logic/`, `lib/game/bot/`, `lib/progression/`) must not import Flutter or Flame
- Balance changes go in `lib/balance/`, not hardcoded into logic

Bug reports, feature requests, and AI-ready task briefs can be filed via GitHub Issues using the provided templates.

---

## License

Code: [MIT](LICENSE)  
Assets: CC BY (see individual asset files for attribution)
