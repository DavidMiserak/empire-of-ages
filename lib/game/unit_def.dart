// Empire of Ages — UnitDef
// Typed data model for a single unit definition loaded from assets/config/units.yaml.
// Generated parts are produced by build_runner (json_serializable + freezed).
// Run after editing this file:  `make pub-get && fvm dart run build_runner build`

import 'package:freezed_annotation/freezed_annotation.dart';

part 'unit_def.freezed.dart';
part 'unit_def.g.dart';

@freezed
abstract class UnitDef with _$UnitDef {
  const factory UnitDef({
    /// Stable identifier; serves as the `Map<String, UnitDef>` key.
    required String id,

    /// Which age unlocks this unit (1 or 2 for v1).
    required int age,

    /// Display name for the HUD.
    required String name,

    /// Starting hit points.
    required int hp,

    /// Damage dealt per attack tick.
    required int dmg,

    /// Walking speed in pixels per second.
    required double speed,

    /// Gold cost to spawn this unit.
    required int cost,

    /// Gold granted to the killing Base when this unit dies (decision H).
    @JsonKey(name: 'gold_reward') required int goldReward,

    /// Asset path under assets/ (relative to project root).
    required String sprite,

    /// Optional attack range in pixels. null/absent = melee (attacks on contact).
    int? range,
  }) = _UnitDef;

  factory UnitDef.fromJson(Map<String, dynamic> json) => _$UnitDefFromJson(json);
}
