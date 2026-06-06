# Design System — Empire of Ages

## Product Context

- **What this is:** A side-scrolling auto-battler in the Age of War
  tradition. Players spawn units from their base, earn gold from
  kills, advance through ages, and destroy the enemy base before
  theirs falls.
- **Who it's for:** Casual game players seeking quick, engaging
  skirmishes
- **Space/industry:** Casual real-time strategy games, browser-era
  auto-battlers
- **Project type:** Mobile-first game (Android primary), with web and
  desktop (Linux) support

## Aesthetic Direction

- **Direction:** Retro pixel-art with Medieval aesthetic
- **Decoration level:** Intentional — pixel art sprites (Tiny Swords),
  minimal UI chrome
- **Mood:** Approachable chaos. Nostalgic (Age of War DNA), energetic
  (units spawning), strategic (upgrade decisions). Dark battle palette
  creates focus on the action.
- **Reference assets:** Tiny Swords sprite pack (Medieval roster,
  terrain tiles, castle bases)

## Color Palette

- **Approach:** Restrained — dark neutrals with strategic accent
  colors
- **Primary accent:** Gold `#FFCA28` — currency, buttons, achievements
  (matches Tiny Swords coin sprite)
- **Secondary accent:** Purple `#7E57C2` — age-up button, progress
  readiness
- **Alert/Damage:** Red `#EF5350` — defeat, enemy HP, warnings
- **Backgrounds:**
    - Main menu / level select: `#141E2D` (charcoal)
    - Battle arena: `#0F1722` (earth/night)
    - UI surfaces: `#1A2638` (dusk sky) — matches world background
    - Text on dark: `#E6ECF5` (off-white, 98% opacity)
- **Semantic:**
    - Success: `#66BB6A` (green) — player HP, friendly units
    - Error: `#EF5350` (red) — enemy HP, base under attack
    - Muted: `#B39DDB` (light purple) — disabled age-up, progress incomplete

## Typography

- **Display/Hero:** Material Symbols or platform system (titles, age
  names)
- **Body:** Flutter default sans-serif (labels, HUD stats)
- **Numeric:** Tabular figures enabled on all numbers (gold, HP,
  damage) so values don't jitter when they change
- **Scale:** No custom type ramp — use Material defaults (headline,
  body, label sizes)
- **UI Density:** Compact — buttons and labels are small to maximize
  play area

## Layout — Responsive Multiplatform Spec

### Fixed Game World

The battlefield is a fixed-resolution canvas: **1200px wide × 600px
tall**. This world does NOT scale based on screen size — instead, the
camera viewport adapts to fit the screen, maintaining a centered view
of the battle.

**Why:** Fixed world means consistent unit positions, camera behavior,
and hit detection across all devices. The camera handles the
responsive part, not the game engine.

### Viewport & Camera Rules

#### Rule 1: Fixed Viewfinder Size

Set the Flame camera viewfinder to the world dimensions:

```dart
camera.viewfinder.visibleGameSize = Vector2(1200, 600)
camera.viewfinder.anchor = Anchor.center
camera.viewfinder.position = Vector2(600, 300)
```

This ensures the camera always shows the full 1200×600 world, no
cropping.

#### Rule 2: Aspect Ratio Adaptation

The viewport will scale proportionally to fit the device screen while
maintaining the 2:1 aspect ratio. This creates letterboxing on non-2:1
screens:

- **Mobile landscape (2:1 to 2.2:1):** Near-perfect fit, minimal letterboxing
- **Desktop landscape (16:10, 16:9, ultrawide):** Black bars on left/right (world is narrower than screen)
- **Mobile portrait (1:1.3 to 1:1.5):** Black bars on top/bottom (world is wider than screen)
- **Desktop portrait (3:4, 4:5):** Letterboxed both axes — game area becomes smaller

**Why:** A fixed 2:1 world with centered viewport is simpler than
responsive scaling and preserves gameplay feel across devices. The
game IS a horizontal battle — portrait orientations are secondary.

#### Rule 3: Viewport Safe Margins

Leave padding around the game viewport to account for OS UI and prevent content creep:

- **Mobile:** SafeArea (notches, status bar) — Flutter's SafeArea widget handles this
- **Desktop:** No system notches; use 8-16px margin from window edges for visual breathing room

### HUD Positioning Rules

The HUD consists of two layers: **top bar** (fixed) and **spawn panel** (floated).

#### Top Bar (Stats & Age Controls)

- **Position:** Fixed to top of screen, full width
- **Content:** Gold, progress, age chip, age-up button, player HP, enemy HP
- **Rules:**
    - Always visible, never covered by game world
    - Stretches full-width with horizontal padding (8-12px)
    - Vertical padding: 2-4px for compact mobile feel
    - Use Row with Spacer to push player HP and enemy HP to right edge
    - Text size fixed at 16px (bold gold stat) to prevent reflow

#### Spawn Panel (Unit Spawner)

**Problem:** Currently hardcoded at `bottom: 165`, which assumes a ~384dp tall mobile screen.

**Solution:** Use responsive positioning based on screen height and viewport geometry.

**Responsive Positioning Algorithm:**

1. **Get the safe viewport height** (screen height minus safe areas)
2. **Calculate spawn panel vertical position** using this formula:

    ```text
    spawnPanelBottom = max(
      safeAreaBottom + 12,              // Minimum: 12px above safe area
      viewportHeight × 0.40              // Or: 40% up from viewport bottom
    )
    ```

    This ensures:
    - On a 384dp tall screen: ~154dp
    - On a 600dp tall screen: ~240dp
    - On a 800dp tall screen: ~320dp
    - Scales proportionally, never crashes into safe area keyboard

3. **Constrain left positioning** to prevent off-screen:

    ```text
    spawnPanelLeft = max(
      safeAreaLeft + 12,      // Minimum 12px from screen edge
      12                       // Default: 12px from left
    )
    ```

4. **Prevent spawn panel from overlapping top bar:**
    - Top bar height ≈ 40-48px (Material AppBar/stat row)
    - Spawn panel top position must be > (topBarHeight + 8px gap)

**Implementation in Flutter:**

```dart
Positioned(
  bottom: MediaQuery.of(context).size.height * 0.275,
  left: 12,
  child: _SpawnPanel(game: game),
)
```

Or, for explicit pixel control:

```dart
final viewportHeight = MediaQuery.of(context).size.height -
                       MediaQuery.of(context).padding.top -
                       MediaQuery.of(context).padding.bottom;
final spawnPanelBottom = max(
  MediaQuery.of(context).padding.bottom + 12,
  viewportHeight * 0.275
);

Positioned(
  bottom: spawnPanelBottom,
  left: 12,
  child: _SpawnPanel(game: game),
)
```

### Screen-Type Breakpoints

Define explicit behavior per device class:

| Screen Type           | Width       | Height      | Aspect     | Rules                                                                                                                                                                                |
| --------------------- | ----------- | ----------- | ---------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| **Mobile Landscape**  | 320–768dp   | 200–384dp   | 1.5–2.2:1  | Primary target. Top bar + spawn panel. Game world centered with minimal letterboxing.                                                                                                |
| **Mobile Portrait**   | 320–480dp   | 600–900dp   | 0.5–0.8:1  | Secondary. Game world letterboxed top/bottom. Consider showing spawn panel in bottom-right overlay instead of left side.                                                             |
| **Tablet Landscape**  | 768–1024dp  | 512–768dp   | 1.3–2:1    | Game world fits well. Use same spawn panel positioning as mobile landscape.                                                                                                          |
| **Tablet Portrait**   | 600–900dp   | 960–1280dp  | 0.6–0.7:1  | Game heavily letterboxed. Consider stacking top bar vertically on left side (sidebar).                                                                                               |
| **Desktop Landscape** | 1024–1920dp | 600–1200dp  | 1.5–3.2:1  | Common on Linux. Game world letterboxed left/right. Spawn panel positioning uses % of viewport height.                                                                               |
| **Desktop Portrait**  | 1200–1440dp | 1600–2560dp | 0.6–0.75:1 | Rare but possible (portrait monitor). Game heavily letterboxed both axes. Layout breaks — recommend showing help overlay: "This game is designed for landscape. Rotate your device." |

### Responsive Behavior Per Screen Type

#### Mobile Landscape (Primary Target)

- Spawn panel: `bottom: 165` (fixed, as currently implemented)
- Top bar: Responsive Row, all stats visible
- Game world: Centered, minimal letterboxing
- Portrait rotation: Show a "rotate your device" banner

#### Mobile Portrait

- **Option A (Recommended):** Show alert overlay: "Rotate to landscape
  for the best experience"
- **Option B:** Allow portrait but reposition spawn panel to right
  side of screen (vertical column instead of horizontal row)

#### Tablet Landscape

- Spawn panel: Use the responsive formula (27.5% of viewport height)
- Top bar: Same as mobile
- Game world: Centered
- Comfortable to play with extra screen real estate

#### Tablet Portrait

- Spawn panel: Right-side column, `top: 48px`, `right: 12px`
- Top bar: Full-width (or convert to left-side sidebar if space is critical)
- Game world: Centered, significant letterboxing
- Usable but not ideal

#### Desktop Landscape (Linux, Web)

- Spawn panel: Responsive formula (27.5% of viewport height)
- Top bar: Full-width, responsive Row
- Game world: Centered, black letterboxing on left/right
- All UI readable, no overflow

#### Desktop Portrait (Rare)

- Show orientation hint: "This game is best in landscape"
- Optional: Collapse UI to minimal (hide stats, show only spawn buttons)
- Game world: Centered but tiny due to letterboxing

### Responsive UI Patterns

#### Pattern 1: Top Bar (Stats & Controls)

```text
[🪙 gold] [📈 progress] [STONE AGE] [▲ Medieval] -------- [🏰 player-hp] [☠ enemy-hp]
<8px> <4px> <12px> <4px> <6px> <12px>                           <12px> <8px>
```

- Uses Row with Spacer to left-justify stats and right-justify HP
- All text sizes fixed (16px for values, 13px for labels)
- Responsive width: stretches to screen width
- Responsive height: 40-48px depending on icon size

**When to collapse (only on tiny screens <320dp wide):**

- Hide progress stat temporarily (show on tap)
- Show only "Age" chip, hide "Medieval" preview
- Result: [🪙 G] [Age] [▲] --------- [🏰] [☠]

#### Pattern 2: Spawn Panel (Unit Buttons)

```text
[unit-1-btn] [unit-2-btn] [unit-3-btn]
<6px gap between buttons>
```

- Row of buttons, mainAxisSize: MainAxisSize.min
- Each button: fixed width, flexible height
- Responsive behavior:
    - **Mobile:** Horizontal row (current)
    - **Portrait or constrained width (<300dp):** Wrap to 2 rows if buttons overflow
    - **Tall screens:** Increase bottom offset using responsive formula

**Layout logic:**

```dart
if (availableWidth < buttonRowWidth) {
  // Use Wrap instead of Row to allow line-wrapping
  return Wrap(
    spacing: 6,
    runSpacing: 6,
    children: [/* spawn buttons */],
  );
} else {
  return Row(mainAxisSize: MainAxisSize.min, children: [/* buttons */]);
}
```

#### Pattern 3: Safe Area Insets

Always use MediaQuery and SafeArea together:

```dart
final safePadding = MediaQuery.of(context).padding;
final safeViewHeight = MediaQuery.of(context).size.height -
                       safePadding.top - safePadding.bottom;
```

- **Mobile:** SafeArea handles notches and OS UI
- **Desktop:** SafeArea.all = EdgeInsets.zero (no special padding), but enforce 8-16px custom margins
- **Tablet:** SafeArea handles status bar; add 8px margin for breathing room

### Testing & Validation

Before shipping, test on:

1. **Mobile Landscape (384×640 logical)**
    - Spawn panel visible above castle
    - Top bar fully readable
    - No text clipping

2. **Mobile Landscape (600×360 logical)**
    - Spawn panel adjusts (27.5% algorithm)
    - Top bar doesn't overflow

3. **Desktop Linux (1920×1080 physical)**
    - Game world letterboxed left/right
    - Spawn panel positions correctly (27.5% of 1080 ≈ 297px)
    - All UI readable (no scaling needed)

4. **Desktop Linux (1280×720 physical)**
    - Spawn panel at responsive height
    - No overlap with top bar

5. **Tablet Portrait (600×900 logical)**
    - Game heavily letterboxed top/bottom
    - Spawn panel right-aligned or shown as overlay
    - All buttons accessible

## Decisions Log

| Date       | Decision                                                    | Rationale                                                                                         |
| ---------- | ----------------------------------------------------------- | ------------------------------------------------------------------------------------------------- |
| 2026-06-06 | Fixed 1200×600 world with adaptive camera viewport          | Preserves consistent gameplay across devices; camera handles responsive scaling, not game engine. |
| 2026-06-06 | Spawn panel positioned at 27.5% of viewport height          | Scales proportionally across all screen sizes; original 165px was ~27.5% of 384dp mobile screen.  |
| 2026-06-06 | Dark palette unified across all screens (navy + gold + red) | Consistent mood across menus and battle; reduces player disorientation on navigation.             |
| 2026-06-06 | Top bar responsive Row with Spacer separator                | Flexes to any width; keeps stats left-aligned, HP right-aligned without hardcoded positions.      |
| 2026-06-06 | Letterboxing on non-2:1 screens (no world scaling)          | Maintains 2:1 battle aspect ratio; letterboxing is cleaner than stretched/cropped gameplay.       |
| 2026-06-06 | Mobile landscape as primary target, portrait as secondary   | Age of War is inherently horizontal; portrait play is supported but with layout compromises.      |

## Implementation Checklist

- [ ] Update `hud.dart` spawn panel positioning to use responsive formula
- [ ] Test on Linux desktop at multiple resolutions (1920×1080, 1280×720, 1024×768)
- [ ] Test on mobile landscape (384dp, 600dp)
- [ ] Test on tablet landscape and portrait
- [ ] Validate spawn panel doesn't overlap top bar on any screen size
- [ ] Validate all HUD text is readable without scaling
- [ ] Document breakpoints in code comments so future dev changes don't break responsive behavior
- [ ] Add orientation lock hints (portrait shows "rotate for landscape" overlay)
