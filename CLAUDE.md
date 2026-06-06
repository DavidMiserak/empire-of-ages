# Empire of Ages — Development Guide

## Design System

Always read **[DESIGN.md](./DESIGN.md)** before making any UI, layout, or visual decisions.

Key principles:

- **Color palette:** Dark navy backgrounds + gold accents + red alerts (see DESIGN.md Color Palette)
- **Fixed game world:** 1200×600px canvas with centered Flame camera — do NOT scale the world based on screen size
- **Responsive positioning:** HUD elements (spawn panel, top bar) use MediaQuery + SafeArea to adapt to different screen sizes
- **Multiplatform targets:** Mobile landscape (primary), tablet, desktop Linux (all 16:9 / 16:10 / ultrawide landscape screens)

## Responsive Design Rules

When editing UI layout (`lib/game/hud.dart`, `lib/play_session/play_session_screen.dart`):

1. **Never hardcode pixel values for positioning** unless they're button padding or fixed-size components
2. **Use responsive formulas for HUD position offsets:**
    - Spawn panel: `bottom = max(safeAreaBottom + 12, viewportHeight × 0.275)`
    - This scales spawn panel positioning across all screen heights (384dp mobile → 1200dp desktop)
3. **Always use MediaQuery.of(context).padding** to account for SafeArea (notches, status bars)
4. **Test on multiple screen sizes before committing:**
    - Mobile landscape: `make run-android` or run on device
    - Linux desktop: `make run-linux` (tests 1920×1080, 1280×720, etc.)
    - Web: `make run-web` (responsive browser resize)

## Key Files

| File                                        | Purpose                                                                       |
| ------------------------------------------- | ----------------------------------------------------------------------------- |
| `lib/game/age_of_war_game.dart`             | Flame game setup; camera/viewport configuration (gap D)                       |
| `lib/game/hud.dart`                         | HUD overlay: top bar + spawn panel positioning                                |
| `lib/play_session/play_session_screen.dart` | Full-bleed game layout + back button                                          |
| `lib/style/palette.dart`                    | Color system (dark navy, gold, red, text colors)                              |
| `lib/style/responsive_screen.dart`          | Menu screen layout (portrait/landscape adaption)                              |
| `assets/config/ages.yaml`                   | Game constants: world dimensions (1200×600), spawn intervals, age definitions |

## Multiplatform Testing Checklist

Before pushing to `develop`:

- [ ] Tested on Linux desktop (`make run-linux`) at ≥2 resolutions
- [ ] Tested on mobile landscape (Android or iOS emulator)
- [ ] Verified spawn panel doesn't overlap top bar or go off-screen
- [ ] Verified all HUD text is readable (no scaling artifacts)
- [ ] No hardcoded pixel positions for responsive elements

## Known Gaps (Pre-v2)

These are documented in `TODOS.md` and in code comments marked `gap X`:

- **Gap B (Audio):** SFX cache pre-warming (done T13)
- **Gap D (Camera):** Fixed-resolution viewport (done T7, responsive positioning in progress)
- **Gap F (Lifecycle):** App pause/resume handling for audio (not yet)
- **Gap G (Balance):** Enemy difficulty curve tuning (placeholder values)

## Questions?

Refer to code comments and commit messages (especially `feat:` commits which add new systems). The commit history is the source of truth for recent decisions.
