# Image Asset Contributions

## What belongs here

- Snake skin sprites (`.png`)
- Arena background textures (`.png`)
- UI icons (`.png` or `.svg`)
- App icon source file

## Spec

| Asset type | Format | Size |
|---|---|---|
| Snake skin (segment) | PNG, transparent bg | 64×64 px |
| Snake skin (head) | PNG, transparent bg | 64×64 px |
| Food orb | PNG, transparent bg | 32×32 px |
| Item (Boost / Magnet) | PNG, transparent bg | 48×48 px |
| UI icons | PNG or SVG | 48×48 px |
| App icon | PNG | 1024×1024 px |

## Naming convention

```
snake_skin_<name>_segment.png
snake_skin_<name>_head.png
food_orb_default.png
item_boost.png
item_magnet.png
icon_<name>.png
```

## License

All image assets must be your own original work **or** sourced from a
CC0 / CC BY compatible license. Include the source and license in your PR
description.

## How to submit

1. Add your asset files to this folder
2. Update `pubspec.yaml` if adding a new sub-folder
3. Open a PR — mention the asset type and source license in the description
