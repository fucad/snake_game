# AGENTS.md — AI Agent Guide

This file is read by AI coding agents (Copilot, Cursor, Windsurf, Codex,
Aider, Devin, Zed, Warp, and others). It contains everything an agent needs
to contribute to this project safely.

---

## Project Summary

An open-source, ad-free arena snake game built with Flutter + Flame.
Slither.io-style: smooth movement, large arena, player vs AI bots,
death particles, collectible items (Boost/Magnet), round-based campaign
with XP and upgrades. Local only, no server.

Part of the **fucad** initiative — free casual games as a digital public good.
MIT License. No ads. No monetization. No data collection. Ever.

---

## Stack

| Tool | Version |
|---|---|
| Flutter | 3.44.1 |
| Flame | 1.37.0 |
| Dart | 3.12.1 |
| shared_preferences | 2.5.5 |
| flame_audio | 2.12.1 |
| google_fonts | 8.1.0 |

Target platforms: **Android and iOS only.**

---

## Essential Commands

```bash
flutter pub get          # install dependencies
flutter test             # run all tests
dart analyze lib/        # static analysis
flutter run              # run on connected device
flutter test test/logic/ # run only logic tests (fast, no device needed)
```

---

## Folder Structure

```
lib/
├── balance/        Constants only — tune game numbers here, no logic
├── game/
│   ├── logic/      Pure Dart game rules — NO Flutter/Flame imports allowed
│   ├── bot/        AI bot strategies — NO Flutter/Flame imports allowed
│   └── components/ Flame rendering components — reads logic state, never writes
│   └── snake_game.dart  Main FlameGame
├── progression/    XP, upgrades, persistence — NO Flutter/Flame imports
└── ui/
    ├── theme/      Design tokens (colors, fonts, spacing, animations)
    ├── screens/    Flutter screens
    └── widgets/    Reusable Flutter widgets

assets/
├── images/         Sprites and icons — see CONTRIBUTING.md inside
├── audio/          Sound effects — see CONTRIBUTING.md inside
└── fonts/          Nunito font files

test/
└── logic/          Unit tests for lib/game/logic/ and lib/progression/
```

---

## The One Rule That Defines This Codebase

**`lib/game/logic/`, `lib/game/bot/`, and `lib/progression/` must never
import Flutter or Flame.**

These layers contain pure Dart. They are fully testable without a simulator.
Rendering concerns belong in `lib/game/components/` or `lib/ui/`.

If you're editing a logic file and reach for `import 'package:flame/...'`
or `import 'package:flutter/...'` — stop and reconsider the approach.

---

## What to Touch for Common Tasks

| Task | Files |
|---|---|
| Change a game number | `lib/balance/*.dart` |
| Change round goals or XP | `lib/balance/round_config.dart` |
| Change snake movement | `lib/game/logic/movement_logic.dart` |
| Change collision rules | `lib/game/logic/collision_logic.dart` |
| Change death/particles | `lib/game/logic/death_logic.dart` |
| Change bot behaviour | `lib/game/bot/easy_bot.dart` / `normal_bot.dart` / `hard_bot.dart` |
| Change snake visuals | `lib/game/components/snake_component.dart` |
| Change arena visuals | `lib/game/components/arena_component.dart` |
| Change a color | `lib/ui/theme/app_colors.dart` |
| Change a screen | `lib/ui/screens/*.dart` |
| Change upgrade values | `lib/balance/upgrade_config.dart` |
| Change persistence | `lib/progression/persistence_service.dart` |

---

## Design Tokens — Always Use Named Constants

Never use raw values in widget code:

```dart
// Wrong
color: Color(0xFF1E2130)
fontSize: 16
padding: EdgeInsets.all(16)

// Right
color: AppColors.surface
style: AppTextStyles.bodyLarge
padding: EdgeInsets.all(AppDimensions.spaceMd)
```

Tokens: `AppColors`, `AppTextStyles`, `AppDimensions`, `AppAnimations`
All in `lib/ui/theme/`.

---

## Hard Constraints

- No ads, analytics, or network calls of any kind
- No multiplayer (local only, no server)
- Balance constants belong in `lib/balance/`, never hardcoded in logic
- All logic files must pass `dart analyze lib/` with zero errors
- Every logic change needs a test in `test/logic/`
- Asset licenses must be CC0 or CC BY — note source in PR

---

## PR Checklist

- [ ] `dart analyze lib/` — zero errors
- [ ] `flutter test` — all passing
- [ ] No raw color/font/spacing in widget files
- [ ] No Flutter/Flame imports in `lib/game/logic/`, `lib/game/bot/`, `lib/progression/`
- [ ] Balance changes in `lib/balance/`, not hardcoded
- [ ] New assets have license noted in PR description

---

## Further Reading

| File | Contents |
|---|---|
| `CLAUDE.md` | Detailed guide for Claude Code with contribution patterns |
| `GAME_DESIGN.md` | Full mechanics specification |
| `GAME_BALANCE.md` | All balance values with rationale |
| `DESIGN_SYSTEM.md` | Color, typography, spacing rules |
| `CONTRIBUTING.md` | Human contributor workflow and setup |
