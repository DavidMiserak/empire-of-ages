// Empire of Ages — Game configuration loader
// Loads units.yaml + ages.yaml exactly once at AgeOfWarGame.onLoad() (design D5).
//
// Architecture:
//   - Three freezed data classes: AgeDef, GameConstants, GameConfig (this file).
//     UnitDef lives in unit_def.dart (per eng-review T4).
//   - GameConfig.load() is async, called once during onLoad(), cached on the
//     FlameGame instance, and never re-parsed.
//   - YAML → typed model conversion handles the YamlMap quirk: package:yaml
//     returns YamlMap (a SplayTreeMap subclass) and YamlList, not the
//     Map<String, dynamic>/List<dynamic> that json_serializable expects.
//     _convertYaml() walks the tree once to convert (outside-voice gap A).
//
// Run after editing this file:  fvm dart run build_runner build

import 'package:flutter/services.dart' show rootBundle;
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:yaml/yaml.dart';

import 'unit_def.dart';

part 'game_config.freezed.dart';
part 'game_config.g.dart';

/// Per-age definition: progression threshold, enemy AI spawn behaviour, art.
@freezed
abstract class AgeDef with _$AgeDef {
  const factory AgeDef({
    required int id,
    required String name,

    /// Cumulative gold earned required to advance INTO this age.
    /// null for age 1 (the starting age).
    @JsonKey(name: 'gold_threshold_to_advance') int? goldThresholdToAdvance,

    /// Initial enemy spawn interval (ms) when enemy reaches this age.
    @JsonKey(name: 'enemy_spawn_interval_ms') required int enemySpawnIntervalMs,

    /// Per-30s decay multiplier on the spawn interval (e.g. 0.10 = 10% faster).
    @JsonKey(name: 'enemy_spawn_decay') required double enemySpawnDecay,

    /// Floor on the spawn interval after decay (ms).
    @JsonKey(name: 'enemy_spawn_floor_ms') required int enemySpawnFloorMs,

    /// Background sprite for this age (placeholder until T2 picks assets).
    @JsonKey(name: 'bg_sprite') required String bgSprite,

    /// Background music for this age.
    required String music,
  }) = _AgeDef;

  factory AgeDef.fromJson(Map<String, dynamic> json) => _$AgeDefFromJson(json);
}

/// Game-wide constants. Magic numbers live here, not in code.
@freezed
abstract class GameConstants with _$GameConstants {
  const factory GameConstants({
    @JsonKey(name: 'starting_gold') required int startingGold,
    @JsonKey(name: 'player_base_hp') required int playerBaseHp,
    @JsonKey(name: 'enemy_base_hp') required int enemyBaseHp,
    @JsonKey(name: 'world_width_px') required double worldWidthPx,
    @JsonKey(name: 'world_height_px') required double worldHeightPx,
    @JsonKey(name: 'player_base_x') required double playerBaseX,
    @JsonKey(name: 'enemy_base_x') required double enemyBaseX,
    @JsonKey(name: 'ground_y') required double groundY,
    @JsonKey(name: 'spawn_debounce_ms') required int spawnDebounceMs,
    @JsonKey(name: 'sfx_throttle_ms') required int sfxThrottleMs,
  }) = _GameConstants;

  factory GameConstants.fromJson(Map<String, dynamic> json) =>
      _$GameConstantsFromJson(json);
}

/// Top-level configuration loaded at game startup.
/// units = id -> UnitDef.
/// ages  = age id -> AgeDef.
@freezed
abstract class GameConfig with _$GameConfig {
  const factory GameConfig({
    required Map<String, UnitDef> units,
    required Map<int, AgeDef> ages,
    required GameConstants constants,
  }) = _GameConfig;

  /// Load and parse units.yaml + ages.yaml from the asset bundle.
  ///
  /// Throws [ConfigLoadError] with a clear message if either file is missing,
  /// malformed, or has a schema mismatch — fail-loud at startup beats silent
  /// mid-battle failures (eng-review code-quality #1).
  static Future<GameConfig> load() async {
    final unitsRaw = await _loadString('assets/config/units.yaml');
    final agesRaw = await _loadString('assets/config/ages.yaml');

    final unitsYaml = loadYaml(unitsRaw);
    final agesYaml = loadYaml(agesRaw);

    if (unitsYaml is! YamlMap || unitsYaml['units'] is! YamlList) {
      throw const ConfigLoadError(
        'assets/config/units.yaml',
        "Expected top-level 'units:' list",
      );
    }
    if (agesYaml is! YamlMap ||
        agesYaml['ages'] is! YamlList ||
        agesYaml['game'] is! YamlMap) {
      throw const ConfigLoadError(
        'assets/config/ages.yaml',
        "Expected top-level 'ages:' list and 'game:' map",
      );
    }

    final units = <String, UnitDef>{};
    for (final entry in (unitsYaml['units'] as YamlList)) {
      final json = _convertYaml(entry) as Map<String, dynamic>;
      final def = _safeParse(
        'units.yaml',
        json['id']?.toString() ?? '<unknown>',
        () => UnitDef.fromJson(json),
      );
      units[def.id] = def;
    }

    final ages = <int, AgeDef>{};
    for (final entry in (agesYaml['ages'] as YamlList)) {
      final json = _convertYaml(entry) as Map<String, dynamic>;
      final def = _safeParse(
        'ages.yaml',
        json['id']?.toString() ?? '<unknown>',
        () => AgeDef.fromJson(json),
      );
      ages[def.id] = def;
    }

    final constants = _safeParse(
      'ages.yaml',
      'game',
      () => GameConstants.fromJson(
        _convertYaml(agesYaml['game']) as Map<String, dynamic>,
      ),
    );

    return GameConfig(units: units, ages: ages, constants: constants);
  }

  factory GameConfig.fromJson(Map<String, dynamic> json) =>
      _$GameConfigFromJson(json);
}

// ---------------------------------------------------------------------------
// Internal helpers
// ---------------------------------------------------------------------------

/// Read a string asset, mapping FlutterError ("Unable to load asset: ...") into
/// a typed [ConfigLoadError] so the call site can give a clean error message.
Future<String> _loadString(String path) async {
  try {
    return await rootBundle.loadString(path);
  } catch (e) {
    throw ConfigLoadError(path, 'asset not found: $e');
  }
}

/// Walk a YamlMap/YamlList tree and return a json-serializable equivalent
/// (`Map<String, dynamic>` + `List<dynamic>` + scalars). package:yaml's
/// YamlMap is a `Map<dynamic, dynamic>`, which freezed/json_serializable
/// refuse to parse. This is the convert step called out in outside-voice gap A.
Object? _convertYaml(Object? node) {
  if (node is YamlMap) {
    return {
      for (final entry in node.entries) entry.key.toString(): _convertYaml(entry.value),
    };
  }
  if (node is YamlList) {
    return [for (final item in node) _convertYaml(item)];
  }
  return node;
}

/// Wrap fromJson() so a typo in YAML produces a [ConfigLoadError] naming the
/// file, the offending entry id, and the underlying error — rather than a raw
/// CheckedFromJsonException with no project context.
T _safeParse<T>(String file, String entryId, T Function() parse) {
  try {
    return parse();
  } catch (e) {
    throw ConfigLoadError(file, "entry '$entryId': $e");
  }
}

/// Thrown when a config file is missing, malformed, or schema-incompatible.
class ConfigLoadError implements Exception {
  final String file;
  final String message;
  const ConfigLoadError(this.file, this.message);

  @override
  String toString() => 'ConfigLoadError($file): $message';
}
