// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'unit_def.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UnitDef {

/// Stable identifier; serves as the Map<String, UnitDef> key.
 String get id;/// Which age unlocks this unit (1 or 2 for v1).
 int get age;/// Display name for the HUD.
 String get name;/// Starting hit points.
 int get hp;/// Damage dealt per attack tick.
 int get dmg;/// Walking speed in pixels per second.
 double get speed;/// Gold cost to spawn this unit.
 int get cost;/// Gold granted to the killing Base when this unit dies (decision H).
@JsonKey(name: 'gold_reward') int get goldReward;/// Asset path under assets/ (relative to project root).
 String get sprite;/// Optional attack range in pixels. null/absent = melee (attacks on contact).
 int? get range;
/// Create a copy of UnitDef
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UnitDefCopyWith<UnitDef> get copyWith => _$UnitDefCopyWithImpl<UnitDef>(this as UnitDef, _$identity);

  /// Serializes this UnitDef to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UnitDef&&(identical(other.id, id) || other.id == id)&&(identical(other.age, age) || other.age == age)&&(identical(other.name, name) || other.name == name)&&(identical(other.hp, hp) || other.hp == hp)&&(identical(other.dmg, dmg) || other.dmg == dmg)&&(identical(other.speed, speed) || other.speed == speed)&&(identical(other.cost, cost) || other.cost == cost)&&(identical(other.goldReward, goldReward) || other.goldReward == goldReward)&&(identical(other.sprite, sprite) || other.sprite == sprite)&&(identical(other.range, range) || other.range == range));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,age,name,hp,dmg,speed,cost,goldReward,sprite,range);

@override
String toString() {
  return 'UnitDef(id: $id, age: $age, name: $name, hp: $hp, dmg: $dmg, speed: $speed, cost: $cost, goldReward: $goldReward, sprite: $sprite, range: $range)';
}


}

/// @nodoc
abstract mixin class $UnitDefCopyWith<$Res>  {
  factory $UnitDefCopyWith(UnitDef value, $Res Function(UnitDef) _then) = _$UnitDefCopyWithImpl;
@useResult
$Res call({
 String id, int age, String name, int hp, int dmg, double speed, int cost,@JsonKey(name: 'gold_reward') int goldReward, String sprite, int? range
});




}
/// @nodoc
class _$UnitDefCopyWithImpl<$Res>
    implements $UnitDefCopyWith<$Res> {
  _$UnitDefCopyWithImpl(this._self, this._then);

  final UnitDef _self;
  final $Res Function(UnitDef) _then;

/// Create a copy of UnitDef
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? age = null,Object? name = null,Object? hp = null,Object? dmg = null,Object? speed = null,Object? cost = null,Object? goldReward = null,Object? sprite = null,Object? range = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,age: null == age ? _self.age : age // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,hp: null == hp ? _self.hp : hp // ignore: cast_nullable_to_non_nullable
as int,dmg: null == dmg ? _self.dmg : dmg // ignore: cast_nullable_to_non_nullable
as int,speed: null == speed ? _self.speed : speed // ignore: cast_nullable_to_non_nullable
as double,cost: null == cost ? _self.cost : cost // ignore: cast_nullable_to_non_nullable
as int,goldReward: null == goldReward ? _self.goldReward : goldReward // ignore: cast_nullable_to_non_nullable
as int,sprite: null == sprite ? _self.sprite : sprite // ignore: cast_nullable_to_non_nullable
as String,range: freezed == range ? _self.range : range // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [UnitDef].
extension UnitDefPatterns on UnitDef {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UnitDef value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UnitDef() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UnitDef value)  $default,){
final _that = this;
switch (_that) {
case _UnitDef():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UnitDef value)?  $default,){
final _that = this;
switch (_that) {
case _UnitDef() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  int age,  String name,  int hp,  int dmg,  double speed,  int cost, @JsonKey(name: 'gold_reward')  int goldReward,  String sprite,  int? range)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UnitDef() when $default != null:
return $default(_that.id,_that.age,_that.name,_that.hp,_that.dmg,_that.speed,_that.cost,_that.goldReward,_that.sprite,_that.range);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  int age,  String name,  int hp,  int dmg,  double speed,  int cost, @JsonKey(name: 'gold_reward')  int goldReward,  String sprite,  int? range)  $default,) {final _that = this;
switch (_that) {
case _UnitDef():
return $default(_that.id,_that.age,_that.name,_that.hp,_that.dmg,_that.speed,_that.cost,_that.goldReward,_that.sprite,_that.range);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  int age,  String name,  int hp,  int dmg,  double speed,  int cost, @JsonKey(name: 'gold_reward')  int goldReward,  String sprite,  int? range)?  $default,) {final _that = this;
switch (_that) {
case _UnitDef() when $default != null:
return $default(_that.id,_that.age,_that.name,_that.hp,_that.dmg,_that.speed,_that.cost,_that.goldReward,_that.sprite,_that.range);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UnitDef implements UnitDef {
  const _UnitDef({required this.id, required this.age, required this.name, required this.hp, required this.dmg, required this.speed, required this.cost, @JsonKey(name: 'gold_reward') required this.goldReward, required this.sprite, this.range});
  factory _UnitDef.fromJson(Map<String, dynamic> json) => _$UnitDefFromJson(json);

/// Stable identifier; serves as the Map<String, UnitDef> key.
@override final  String id;
/// Which age unlocks this unit (1 or 2 for v1).
@override final  int age;
/// Display name for the HUD.
@override final  String name;
/// Starting hit points.
@override final  int hp;
/// Damage dealt per attack tick.
@override final  int dmg;
/// Walking speed in pixels per second.
@override final  double speed;
/// Gold cost to spawn this unit.
@override final  int cost;
/// Gold granted to the killing Base when this unit dies (decision H).
@override@JsonKey(name: 'gold_reward') final  int goldReward;
/// Asset path under assets/ (relative to project root).
@override final  String sprite;
/// Optional attack range in pixels. null/absent = melee (attacks on contact).
@override final  int? range;

/// Create a copy of UnitDef
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UnitDefCopyWith<_UnitDef> get copyWith => __$UnitDefCopyWithImpl<_UnitDef>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UnitDefToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UnitDef&&(identical(other.id, id) || other.id == id)&&(identical(other.age, age) || other.age == age)&&(identical(other.name, name) || other.name == name)&&(identical(other.hp, hp) || other.hp == hp)&&(identical(other.dmg, dmg) || other.dmg == dmg)&&(identical(other.speed, speed) || other.speed == speed)&&(identical(other.cost, cost) || other.cost == cost)&&(identical(other.goldReward, goldReward) || other.goldReward == goldReward)&&(identical(other.sprite, sprite) || other.sprite == sprite)&&(identical(other.range, range) || other.range == range));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,age,name,hp,dmg,speed,cost,goldReward,sprite,range);

@override
String toString() {
  return 'UnitDef(id: $id, age: $age, name: $name, hp: $hp, dmg: $dmg, speed: $speed, cost: $cost, goldReward: $goldReward, sprite: $sprite, range: $range)';
}


}

/// @nodoc
abstract mixin class _$UnitDefCopyWith<$Res> implements $UnitDefCopyWith<$Res> {
  factory _$UnitDefCopyWith(_UnitDef value, $Res Function(_UnitDef) _then) = __$UnitDefCopyWithImpl;
@override @useResult
$Res call({
 String id, int age, String name, int hp, int dmg, double speed, int cost,@JsonKey(name: 'gold_reward') int goldReward, String sprite, int? range
});




}
/// @nodoc
class __$UnitDefCopyWithImpl<$Res>
    implements _$UnitDefCopyWith<$Res> {
  __$UnitDefCopyWithImpl(this._self, this._then);

  final _UnitDef _self;
  final $Res Function(_UnitDef) _then;

/// Create a copy of UnitDef
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? age = null,Object? name = null,Object? hp = null,Object? dmg = null,Object? speed = null,Object? cost = null,Object? goldReward = null,Object? sprite = null,Object? range = freezed,}) {
  return _then(_UnitDef(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,age: null == age ? _self.age : age // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,hp: null == hp ? _self.hp : hp // ignore: cast_nullable_to_non_nullable
as int,dmg: null == dmg ? _self.dmg : dmg // ignore: cast_nullable_to_non_nullable
as int,speed: null == speed ? _self.speed : speed // ignore: cast_nullable_to_non_nullable
as double,cost: null == cost ? _self.cost : cost // ignore: cast_nullable_to_non_nullable
as int,goldReward: null == goldReward ? _self.goldReward : goldReward // ignore: cast_nullable_to_non_nullable
as int,sprite: null == sprite ? _self.sprite : sprite // ignore: cast_nullable_to_non_nullable
as String,range: freezed == range ? _self.range : range // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
