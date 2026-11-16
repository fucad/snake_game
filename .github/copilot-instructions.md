# GitHub Copilot Instructions

## Project

Open-source, ad-free arena snake game. Flutter + Flame. Slither.io-style:
smooth movement, AI bots, death particles, collectible items, XP progression.
Local only, no server. MIT License.

## Architecture Rule

`lib/game/logic/`, `lib/game/bot/`, and `lib/progression/` are **pure Dart**.
They must never import `package:flame` or `package:flutter`.
Rendering belongs in `lib/game/components/` and `lib/ui/`.

## Always Use Design Tokens

```dart
// Never
Color(0xFF1E2130), fontSize: 16, EdgeInsets.all(16)

// Always
AppColors.surface, AppTextStyles.bodyLarge, EdgeInsets.all(AppDimensions.spaceMd)
```

Tokens live in `lib/ui/theme/`.

## Balance Constants

All game numbers (speeds, bot counts, round goals, XP values, upgrade costs)
live in `lib/balance/*.dart`. Edit those files, not logic code.

## Never Add

- Ads, analytics, or network calls
- Multiplayer or server dependencies
- Raw color/spacing values in widget files
- Flutter/Flame imports in logic files

## Run Tests

```bash
flutter test
dart analyze lib/
```

Full guide: `AGENTS.md` and `CLAUDE.md`
