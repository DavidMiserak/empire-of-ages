// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'unit_def.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UnitDef _$UnitDefFromJson(Map<String, dynamic> json) => _UnitDef(
  id: json['id'] as String,
  age: (json['age'] as num).toInt(),
  name: json['name'] as String,
  hp: (json['hp'] as num).toInt(),
  dmg: (json['dmg'] as num).toInt(),
  speed: (json['speed'] as num).toDouble(),
  cost: (json['cost'] as num).toInt(),
  goldReward: (json['gold_reward'] as num).toInt(),
  sprite: json['sprite'] as String,
  range: (json['range'] as num?)?.toInt(),
);

Map<String, dynamic> _$UnitDefToJson(_UnitDef instance) => <String, dynamic>{
  'id': instance.id,
  'age': instance.age,
  'name': instance.name,
  'hp': instance.hp,
  'dmg': instance.dmg,
  'speed': instance.speed,
  'cost': instance.cost,
  'gold_reward': instance.goldReward,
  'sprite': instance.sprite,
  'range': instance.range,
};
