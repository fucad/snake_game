# Balance Configuration

This folder contains all the numbers that control how the game feels.
You do **not** need to understand the game engine to edit these files.

## Files

| File | What it controls |
|---|---|
| `world_config.dart` | Arena size per round, food density |
| `bot_config.dart` | Number of bots, difficulty mix per round, bot AI radius |
| `round_config.dart` | Round goals, XP rewards, stage labels |
| `upgrade_config.dart` | Upgrade tier values and XP costs |
| `item_config.dart` | Boost and Magnet item spawn rates and effects |
| `particle_config.dart` | Death particle count, lifetime, scatter |

## How to Edit

1. Open the relevant file
2. Change the constant value
3. Run `flutter test` to make sure nothing broke
4. Submit a PR with a short explanation of why you changed it

## Rules

- Every constant has a comment explaining what it affects
- Do **not** add logic or conditionals here — only plain values
- Do **not** import from game logic — these files have zero dependencies
- If a value needs a floor/ceiling, note it in a comment
- See `GAME_BALANCE.md` in the project root for the full rationale behind each value

## Good First Issues

Rebalancing is a great first contribution. Look for issues labelled `balance` on GitHub.
