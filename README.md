# Empire of Ages

Side-scrolling auto-battler in the Age of War tradition, built with the [Flutter Casual Games Toolkit](https://github.com/flutter/games) and [Flame](https://flame-engine.org/).

Spawn units from your base, earn gold from kills, advance through ages, and destroy the enemy base before yours falls.

## Current state

The game is a playable v1 prototype with two ages (Stone and Medieval), a full combat loop, HUD overlay, and game-over flow with Play Again.

| Area                                 | Status                                                    |
| ------------------------------------ | --------------------------------------------------------- |
| Main menu, settings, level selection | From Casual Games Toolkit scaffold                        |
| YAML-driven game config              | Units, ages, balance constants in `assets/config/`        |
| Combat                               | Unit walk/attack FSM, melee and ranged, enemy AI spawning |
| HUD                                  | Gold, age, HP, spawn buttons, age-up                      |
| Game over                            | Victory/defeat overlay + reset                            |
| Platforms                            | Android (primary), web, Linux (dev)                       |

Planned v2 work (ages 3–5, tech tree, turrets, distribution) is tracked in [`TODOS.md`](TODOS.md).

## Requirements

- [FVM](https://fvm.app/) — Flutter SDK is pinned to `stable` (see [`.fvmrc`](.fvmrc))
- For Android builds: Android SDK + a device or emulator
- For web: Chrome
- Optional: [pre-commit](https://pre-commit.com/) for git hooks

## Quick start

```bash
# Install the pinned Flutter SDK
fvm install

# Resolve dependencies
make pub-get

# Run on the first available device
make run

# Or target a specific platform
make run-linux      # Linux desktop (good for local dev)
make run-web        # Chrome with hot reload
make run-android    # Connected or emulated Android device
```

## Development

```bash
make help              # List all Makefile targets
make doctor            # Verify Flutter SDK and toolchains
make test              # Unit + widget tests (includes smoke test)
make analyze           # flutter analyze
make format            # dart format lib/ test/
make build-apk         # Release APK
make build-web         # Release web bundle → build/web/
make serve-web         # Build web + serve at http://localhost:8000
make pre-commit-setup  # Install git hooks
```

### Code generation

Config models use [freezed](https://pub.dev/packages/freezed). After editing `lib/game/unit_def.dart` or `lib/game/game_config.dart`:

```bash
fvm dart run build_runner build --delete-conflicting-outputs
```

### Game balance

Balance and unit stats live in YAML, not Dart:

- [`assets/config/units.yaml`](assets/config/units.yaml) — unit HP, damage, speed, cost, rewards
- [`assets/config/ages.yaml`](assets/config/ages.yaml) — age thresholds, enemy spawn curves, world dimensions

`GameConfig.load()` reads both files once at startup.

## Project structure

```
lib/
├── main.dart                 # App entry, providers, lifecycle
├── router.dart               # go_router routes
├── main_menu/                # Main menu screen
├── level_selection/          # Level picker
├── play_session/             # Game screen + Flame GameWidget
├── game/
│   ├── age_of_war_game.dart  # FlameGame: world, notifiers, match flow
│   ├── base.dart             # Player/enemy bases, spawning, enemy AI
│   ├── unit.dart             # Unit FSM: walk, attack, death
│   ├── hud.dart              # In-game HUD overlay
│   ├── game_over_overlay.dart
│   ├── game_config.dart      # YAML loader + AgeDef/GameConstants
│   └── unit_def.dart         # Freezed unit model
├── audio/                    # Music + SFX controller
├── settings/                 # Audio/name persistence
└── player_progress/          # Level unlock persistence

assets/
├── config/                   # Game balance (YAML)
├── images/                   # Sprites
├── music/                    # Background tracks
└── sfx/                      # Sound effects

test/
└── smoke_test.dart           # Menu → play → game mounts
```

## How it works

1. **Economy** — Gold comes from kills only. Cumulative gold earned gates age advancement.
2. **Spawning** — Tap unit buttons in the HUD to spawn from your base (cost deducted from gold).
3. **Combat** — Units walk toward the nearest enemy, attack in range, and credit their base with gold on kills.
4. **Enemy AI** — The enemy base spawns units on a decaying interval (tuned per age in `ages.yaml`).
5. **Win/lose** — When a base reaches 0 HP, the match ends, simulation freezes, and the game-over overlay appears. Play Again resets the battlefield.

## Commit history (high level)

| Commit    | Summary                                                      |
| --------- | ------------------------------------------------------------ |
| Bootstrap | Casual Games Toolkit template, renamed to `empire_of_ages`   |
| Tooling   | FVM pin, Makefile targets for run/test/build                 |
| Config    | Typed YAML layer (`units.yaml`, `ages.yaml`, freezed models) |
| Game core | `AgeOfWarGame` Flame skeleton, fixed-resolution camera       |
| Combat    | Bases, units, enemy AI, HUD overlay                          |
| Fixes     | Camera/world wiring, full-bleed play session layout          |
| Polish    | Game-over overlay, Play Again reset, first balance pass      |

## Credits

Game design by Edmund Alexander Peterson.

## License

Source files retain the Flutter project's BSD-style license headers where applicable. Font assets include their own licenses under `assets/fonts/`.
