# Design System

> Version: 1.0
> All code tokens live in `lib/ui/theme/`. Never use raw color, font, or
> spacing values in widget code — always reference a named token.

---

## Design Philosophy

The visual language is **clean, minimal, and premium casual**.

The game is the content. The UI exists to get out of its way. Every screen
should feel like it took effort to simplify, not effort to decorate. Rounded
shapes, generous whitespace, one strong accent color, and smooth motion are
the four pillars.

**Four rules that define the feel:**

1. **Round everything.** No hard corners. Cards, buttons, avatars, orbs — all
   use rounded shapes. Hard edges feel cold and dated.

2. **Dark but not harsh.** The background is deep navy-black, not pure black.
   Surfaces float above it in layers of slightly lighter dark tones. It reads
   as polished, not gothic.

3. **One accent, used sparingly.** Coral (`#FF6B6B`) is the single call-to-action
   color. It appears on primary buttons, highlights, and goal indicators. When
   everything is coral, nothing is. Use it only where the eye needs to go.

4. **Motion is smooth, not snappy.** Animations ease in and out with cubic
   curves. Nothing pops abruptly. State changes feel like a breath, not a click.

---

## Color

All tokens are in `lib/ui/theme/app_colors.dart`.

### Background layers

The UI uses a three-layer depth system. Each layer is slightly lighter than
the one below.

| Token | Hex | Use |
|---|---|---|
| `AppColors.arenaBg` | `#0D1117` | The game arena floor |
| `AppColors.screenBg` | `#13151F` | Menu and screen backgrounds |
| `AppColors.surface` | `#1E2130` | Cards, panels, bottom sheets |
| `AppColors.surfaceElevated` | `#262A3D` | Dialogs, dropdowns, tooltips |

**Rule:** Never place content directly on `arenaBg` in menus. Use `screenBg`
or higher.

### Accent

| Token | Hex | Use |
|---|---|---|
| `AppColors.primary` | `#FF6B6B` | Primary buttons, CTAs, goal indicators, highlights |
| `AppColors.primaryLight` | `#FF8E8E` | Pressed state, hover tint |
| `AppColors.secondary` | `#64FFDA` | Secondary actions, success states, mint accents |

**Rule:** `primary` appears on at most one element per screen — the single most
important action. If two things feel equally important, one of them is wrong.

### Text

| Token | Use |
|---|---|
| `AppColors.textPrimary` | Headings, active values, anything the user must read |
| `AppColors.textSecondary` | Labels, descriptions, supporting info |
| `AppColors.textDisabled` | Inactive states, placeholder text |

**Rule:** Never use raw `Colors.white` or `Colors.grey`. Always use a text token.

### Borders and dividers

| Token | Use |
|---|---|
| `AppColors.border` | Card outlines, input borders |
| `AppColors.divider` | List separators, section breaks |

Borders should be subtle — they define structure, not decoration.

### Game entities

Each entity has its own named color. These are tuned for visibility against
the dark arena background.

| Token | Entity |
|---|---|
| `AppColors.playerSnake` | Player snake body segments |
| `AppColors.playerSnakeHead` | Player snake head (brighter green) |
| `AppColors.foodOrb` | Food orbs (warm yellow) |
| `AppColors.deathParticle` | Particles left by dead snakes (orange) |
| `AppColors.boostItem` | Boost pickup item (electric blue) |
| `AppColors.magnetItem` | Magnet pickup item (soft purple) |
| `AppColors.botSnakeColors` | List of 12 distinct colors for bot snakes |

**Rule:** Bot snake colors are assigned from `botSnakeColors` in order. Do not
hand-pick bot colors — use the list so they stay distinct from each other and
from the player.

### Feedback and state

| Token | Use |
|---|---|
| `AppColors.success` | Goal met, positive result |
| `AppColors.warning` | Caution states, low XP |
| `AppColors.error` | Death, failure, destructive actions |
| `AppColors.xpBar` | XP progress fill (purple) |
| `AppColors.scrim` | Overlay behind modals and pause screen |

---

## Typography

All tokens are in `lib/ui/theme/app_text_styles.dart`.

Font: **Nunito** — rounded terminals, friendly weight range, excellent
legibility at small sizes on mobile.

### Scale

| Token | Size | Weight | Use |
|---|---|---|---|
| `displayLarge` | 64 / 800 | Score on game-over screen |
| `displayMedium` | 48 / 800 | App name on home screen |
| `headingLarge` | 28 / 700 | Screen titles |
| `headingMedium` | 22 / 700 | Section headers |
| `headingSmall` | 18 / 600 | Card titles, sub-headers |
| `bodyLarge` | 16 / 400 | Primary body text |
| `bodyMedium` | 14 / 400 | Secondary descriptions |
| `bodySmall` | 12 / 400 | Fine print, timestamps |
| `labelLarge` | 16 / 700 | Button text, tabs |
| `labelMedium` | 13 / 600 | Tags, chips, captions |
| `hudScore` | 32 / 800 | In-game score display |
| `hudLabel` | 11 / 600 | In-game label under score |
| `stageLabel` | 13 / 700 | Stage name (coral color, spaced caps) |

### Rules

- **Never hard-code font size or weight.** Use a named style.
- `displayLarge` and `displayMedium` are for numbers and single words only —
  not sentences.
- `stageLabel` always renders in `AppColors.primary` with letter spacing.
- HUD styles have a built-in text shadow for legibility over the arena.
- If a style doesn't fit your use case, discuss before creating a new one.
  Most cases are covered.

---

## Spacing

All tokens are in `lib/ui/theme/app_dimensions.dart`.

Built on an **8px grid**. All spacing values are multiples of 4 or 8.

| Token | Value | Use |
|---|---|---|
| `spaceXs` | 4 | Tight internal gaps (icon + label) |
| `spaceSm` | 8 | Between closely related items |
| `spaceMd` | 16 | Standard internal padding, between items |
| `spaceLg` | 24 | Section separation |
| `spaceXl` | 32 | Major section breaks |
| `spaceXxl` | 48 | Hero areas, splash spacing |

Screen edges use `screenPaddingH: 24` and `screenPaddingV: 20`.

**Rule:** Never use an arbitrary number like `SizedBox(height: 13)`. Pick the
nearest token. If nothing fits, use the next size up — err toward more space.

---

## Border Radius

| Token | Value | Use |
|---|---|---|
| `radiusSm` | 8 | Small chips, tags, badges |
| `radiusMd` | 12 | Input fields, small cards |
| `radiusLg` | 20 | Standard cards, panels, buttons |
| `radiusXl` | 28 | Large modals, bottom sheets |
| `radiusFull` | 999 | Pills, avatar circles, orbs |

**Rule:** The default card and button shape is `radiusLg`. Smaller elements use
`radiusMd`. Circles and orbs use `radiusFull`. Never use `radiusSm` for
anything the user taps.

---

## Elevation & Shadow

This design is **flat**. Cards have `elevation: 0`. Depth is expressed through
background color layering (see Background layers above), not shadows.

The single exception is the HUD score text, which uses a soft drop shadow
(`app_text_styles.dart`) for legibility against the arena.

**Rule:** Do not add `BoxShadow` to cards or buttons. If something feels like
it needs a shadow to stand out, reconsider the background color instead.

---

## Animation

All tokens are in `lib/ui/theme/app_animations.dart`.

### Durations

| Token | Duration | Use |
|---|---|---|
| `micro` | 120ms | Instant tap feedback (color change on press) |
| `fast` | 200ms | Button press, icon swap |
| `normal` | 300ms | State transitions, panel expand/collapse |
| `slow` | 450ms | Screen transitions |
| `crawl` | 600ms | Intro reveals, first-load animations |

### Curves

| Token | Curve | Use |
|---|---|---|
| `standard` | `easeInOutCubic` | Default for everything |
| `enter` | `easeOutCubic` | Elements entering the screen |
| `exit` | `easeInCubic` | Elements leaving the screen |
| `spring` | `elasticOut` | Score pop, XP gain, rewarding moments |
| `decelerate` | `decelerate` | Scroll physics, settling motion |

### Rules

- Screen transitions use `slow` + `standard`.
- Rewarding game events (kill, goal met, level up) use `spring` — this is the
  only place elastic motion is appropriate.
- Never animate layout changes that happen during gameplay — the arena updates
  at 60fps and overlay animations will conflict.
- Prefer implicit animations (`AnimatedContainer`, `AnimatedOpacity`) over
  explicit `AnimationController` for simple UI transitions.

---

## Components

### Primary Button

```
Height:          AppDimensions.buttonHeightLarge (56px)
Radius:          AppDimensions.radiusLg (20px)
Background:      AppColors.primary
Text style:      AppTextStyles.labelLarge
Elevation:       0 (flat)
Full width:      always (no narrow buttons on mobile)
```

Use for: the main action on any screen. One per screen maximum.

### Secondary / Text Button

```
Text style:      AppTextStyles.labelMedium
Color:           AppColors.textSecondary
No background, no border
```

Use for: "cancel", "skip", "later" — low-emphasis actions.

### Card / Panel

```
Background:      AppColors.surface
Radius:          AppDimensions.radiusLg (20px)
Padding:         AppDimensions.cardPaddingH (20) × AppDimensions.cardPaddingV (16)
Elevation:       0
Border:          none (background contrast provides the separation)
```

Use for: upgrade cards, settings rows, stat displays.

### Upgrade Card

Three columns: icon + label, tier dots, upgrade button.
Tier dots show filled/empty circles — `AppColors.primary` for filled,
`AppColors.border` for empty. Max 5 dots.

### XP Bar

```
Height:          AppDimensions.xpBarHeight (8px)
Radius:          AppDimensions.xpBarRadius (4px)
Fill color:      AppColors.xpBar (purple)
Track color:     AppColors.xpBarBg
Animation:       AppAnimations.xpBarFill (800ms, standard curve)
```

### HUD (in-game overlay)

- Score: top-center, `AppTextStyles.hudScore`, with built-in shadow
- Label under score: `AppTextStyles.hudLabel` in `AppColors.textSecondary`
- Minimap: bottom-right corner, `AppDimensions.minimapSize` (100px),
  `AppDimensions.minimapPadding` (12px) from edges
- All HUD elements use `AppColors.scrim` as a subtle backing pill when
  overlaying the arena

### Overlays (Pause, Game Over)

- Scrim: `AppColors.scrim` — covers the arena behind the overlay
- Panel: `AppColors.surfaceElevated`, `radiusXl`
- Do not slide in from an edge — fade in with `AppAnimations.normal`

---

## Do / Don't

| Do | Don't |
|---|---|
| Use `AppColors.*` tokens everywhere | Use raw `Color(0xFF...)` in widget files |
| Use `AppTextStyles.*` for all text | Set `fontSize` directly on `Text` |
| Use `AppDimensions.*` for all spacing | Use magic numbers like `SizedBox(height: 13)` |
| Keep one primary CTA per screen | Use `primary` color on multiple elements |
| Animate with `AppAnimations.*` curves | Use `Curves.bounceIn` or other jarring curves |
| Let background layering create depth | Add `BoxShadow` to cards |
| Use `radiusFull` for all game orbs | Mix radius values inconsistently |
| Default to more whitespace | Pack elements tightly to fit more on screen |

---

## Fonts Setup

Nunito font files must be present in `assets/fonts/`. See `assets/fonts/README.md`
for the required files and download instructions.

If the font files are missing the app will fall back to the system font, which
will not match the design. Font files are not committed to the repo (size) —
contributors must download them before running locally.

---

## Adding to the Design System

Before creating a new color, style, or dimension value:

1. Check if an existing token is close enough.
2. If not, add it to the appropriate `app_*.dart` file with a comment.
3. Update this document — the code and the doc must stay in sync.
4. Never add a token that is only used once. If it's used once it's a local
   value, not a system token.
