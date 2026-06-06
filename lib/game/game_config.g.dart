// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AgeDef _$AgeDefFromJson(Map<String, dynamic> json) => _AgeDef(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  goldThresholdToAdvance: (json['gold_threshold_to_advance'] as num?)?.toInt(),
  enemySpawnIntervalMs: (json['enemy_spawn_interval_ms'] as num).toInt(),
  enemySpawnDecay: (json['enemy_spawn_decay'] as num).toDouble(),
  enemySpawnFloorMs: (json['enemy_spawn_floor_ms'] as num).toInt(),
  bgSprite: json['bg_sprite'] as String,
  music: json['music'] as String,
);

Map<String, dynamic> _$AgeDefToJson(_AgeDef instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'gold_threshold_to_advance': instance.goldThresholdToAdvance,
  'enemy_spawn_interval_ms': instance.enemySpawnIntervalMs,
  'enemy_spawn_decay': instance.enemySpawnDecay,
  'enemy_spawn_floor_ms': instance.enemySpawnFloorMs,
  'bg_sprite': instance.bgSprite,
  'music': instance.music,
};

_GameConstants _$GameConstantsFromJson(Map<String, dynamic> json) =>
    _GameConstants(
      startingGold: (json['starting_gold'] as num).toInt(),
      playerBaseHp: (json['player_base_hp'] as num).toInt(),
      enemyBaseHp: (json['enemy_base_hp'] as num).toInt(),
      worldWidthPx: (json['world_width_px'] as num).toDouble(),
      worldHeightPx: (json['world_height_px'] as num).toDouble(),
      playerBaseX: (json['player_base_x'] as num).toDouble(),
      enemyBaseX: (json['enemy_base_x'] as num).toDouble(),
      groundY: (json['ground_y'] as num).toDouble(),
      spawnDebounceMs: (json['spawn_debounce_ms'] as num).toInt(),
      sfxThrottleMs: (json['sfx_throttle_ms'] as num).toInt(),
    );

Map<String, dynamic> _$GameConstantsToJson(_GameConstants instance) =>
    <String, dynamic>{
      'starting_gold': instance.startingGold,
      'player_base_hp': instance.playerBaseHp,
      'enemy_base_hp': instance.enemyBaseHp,
      'world_width_px': instance.worldWidthPx,
      'world_height_px': instance.worldHeightPx,
      'player_base_x': instance.playerBaseX,
      'enemy_base_x': instance.enemyBaseX,
      'ground_y': instance.groundY,
      'spawn_debounce_ms': instance.spawnDebounceMs,
      'sfx_throttle_ms': instance.sfxThrottleMs,
    };

_GameConfig _$GameConfigFromJson(Map<String, dynamic> json) => _GameConfig(
  units: (json['units'] as Map<String, dynamic>).map(
    (k, e) => MapEntry(k, UnitDef.fromJson(e as Map<String, dynamic>)),
  ),
  ages: (json['ages'] as Map<String, dynamic>).map(
    (k, e) =>
        MapEntry(int.parse(k), AgeDef.fromJson(e as Map<String, dynamic>)),
  ),
  constants: GameConstants.fromJson(json['constants'] as Map<String, dynamic>),
);

Map<String, dynamic> _$GameConfigToJson(_GameConfig instance) =>
    <String, dynamic>{
      'units': instance.units,
      'ages': instance.ages.map((k, e) => MapEntry(k.toString(), e)),
      'constants': instance.constants,
    };
