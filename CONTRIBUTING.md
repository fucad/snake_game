# Contributing

Thanks for being here. This project exists to prove that simple games can be
a public good — ad-free, forever. Every contribution, however small, moves
that forward.

---

## Before You Start

Read these two files — they take about 10 minutes and will save you hours:

- `GAME_DESIGN.md` — what the game is and how it works
- `CLAUDE.md` — where things live, why the layers exist, and contribution patterns

If you are using an AI assistant, also read:
- `CLAUDE.md` (Claude Code) or `AGENTS.md` (everything else)
- `DESIGN_SYSTEM.md` if you are touching UI

---

## Setup

**Requirements:** Flutter 3.44.1+, Dart 3.12.1+

```bash
# Clone
git clone https://github.com/fucad/snake_game.git
cd snake_game

# Install dependencies
flutter pub get

# Download fonts (required — not committed to the repo)
# Download Nunito from https://fonts.google.com/specimen/Nunito
# Place Nunito-Regular.ttf, Nunito-SemiBold.ttf, Nunito-Bold.ttf,
# Nunito-ExtraBold.ttf into assets/fonts/

# Verify everything works
flutter test
dart analyze lib/
flutter run
```

---

## Types of Contribution

### Balance Tuning — easiest entry point

If a round feels too hard, too easy, or XP feels wrong — open `lib/balance/`.
Change a constant. Run tests. Submit a PR with before/after values and why.

No game engine knowledge required. This is the best first contribution.

Relevant files: `lib/balance/*.dart`
Reference: `GAME_BALANCE.md`

---

### Bug Fix

1. Open an issue first if one doesn't exist — describe the bug and how to reproduce
2. Write a test that fails due to the bug (in `test/logic/` for logic bugs)
3. Fix the bug
4. Confirm the test passes

---

### Bot AI Improvement

Bot behaviour lives in `lib/game/bot/`. Each bot implements one interface:

```dart
Vector2 computeDirection(SnakeState bot, ArenaState state);
```

It receives world state and returns a normalised direction vector.
No Flutter, no Flame, no side effects. Pure function.

Tests for bots go in `test/logic/`.

---

### New Visual Theme or Snake Skin

1. Add image assets to `assets/images/` following the spec in
   `assets/images/CONTRIBUTING.md`
2. Follow naming conventions in that file
3. Register the new skin in the skin selector (once that screen is implemented)
4. All assets must be original work or CC0/CC BY licensed
5. Note the license in your PR description

---

### Sound Effects

Follow `assets/audio/CONTRIBUTING.md` for format, naming, and licensing rules.

---

### New Screen or UI Component

1. Use only design tokens — `AppColors.*`, `AppTextStyles.*`, `AppDimensions.*`
2. Screens receive data as constructor parameters — no game logic inside them
3. Reference `DESIGN_SYSTEM.md` for component patterns (buttons, cards, overlays)
4. Add a widget test if the component has meaningful interactive state

---

### Documentation Fix

Found something unclear, outdated, or wrong in a `.md` file? Fix it directly.
Docs PRs are always welcome and don't need an issue first.

---

## Workflow

```
1. Fork the repo and create a branch
   git checkout -b fix/round-2-goal-too-high

2. Make your change

3. Run checks
   dart analyze lib/
   flutter test

4. Commit with a clear message
   git commit -m "balance: reduce round 2 goal from 38 to 30"

5. Push and open a PR
```

PR title format: `type: short description`
Types: `fix`, `feat`, `balance`, `docs`, `asset`, `refactor`, `test`

---

## PR Description Template

```
## What
Short description of the change.

## Why
Why this change is needed or what problem it solves.

## Test
How you verified this works.

## Asset License (if applicable)
Source URL and license for any added assets.
```

---

## What We Will Not Accept

- Ads, analytics, crash reporters, or any network calls
- Multiplayer or server-side features
- In-app purchases or premium content of any kind
- Game logic inside Flame components or UI screens
- Flutter/Flame imports in `lib/game/logic/`, `lib/game/bot/`, or `lib/progression/`
- Raw color or spacing values in widget files (use design tokens)
- Assets without a clear license

---

## Using AI to Contribute

This repo is intentionally structured to make AI-assisted contributions safe.

**With Claude Code:** The `CLAUDE.md` file is automatically loaded. It contains
contribution patterns, file maps, and a PR checklist.

**With any other AI tool:** Point it at `AGENTS.md`. It covers everything needed
for a safe, correct contribution in a format all major tools understand.

**General tip:** Give your AI a narrow, specific task. "Fix the round 3 goal
value in `lib/balance/round_config.dart`" is safer and faster than "improve
the game balance." The architecture is designed so narrow tasks are also
complete tasks.

---

## Questions

Open a GitHub Discussion or file an issue with the `question` label.
We are friendly.

---

## License

Code contributions are released under the MIT License.
Asset contributions are released under CC BY.
By submitting a PR you agree to these terms.
