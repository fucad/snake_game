# Audio Asset Contributions

## What belongs here

- Sound effects (eat, death, kill, item pickup, boost, magnet hum)
- Background music tracks (optional, off by default)

## Spec

| Asset | Format | Duration | Notes |
|---|---|---|---|
| Eat sound | OGG | < 0.3s | Short, satisfying pop |
| Death sound | OGG | 0.5–1s | Crunch / dissolve |
| Kill chime | OGG | 0.3–0.5s | Rewarding, distinct from eat |
| Boost pickup | OGG | 0.3s | Electric / whoosh |
| Magnet pickup | OGG | 0.3s | Soft magnetic hum |
| Magnet loop | OGG | 1–2s looping | Plays while magnet is active |
| Background music | OGG | 2–4 min looping | Subtle, not distracting |

## Naming convention

```
sfx_eat.ogg
sfx_death.ogg
sfx_kill.ogg
sfx_boost_pickup.ogg
sfx_magnet_pickup.ogg
sfx_magnet_loop.ogg
music_arena.ogg
```

## License

All audio must be your own original work **or** sourced from a
CC0 / CC BY compatible license (e.g. freesound.org CC0).
Include the source URL and license in your PR description.

## How to submit

1. Add your `.ogg` files to this folder
2. Register the file in `lib/game/snake_game.dart` audio preload list
3. Open a PR with source and license info
