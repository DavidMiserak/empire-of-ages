// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'game_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AgeDef {

 int get id; String get name;/// Cumulative gold earned required to advance INTO this age.
/// null for age 1 (the starting age).
@JsonKey(name: 'gold_threshold_to_advance') int? get goldThresholdToAdvance;/// Initial enemy spawn interval (ms) when enemy reaches this age.
@JsonKey(name: 'enemy_spawn_interval_ms') int get enemySpawnIntervalMs;/// Per-30s decay multiplier on the spawn interval (e.g. 0.10 = 10% faster).
@JsonKey(name: 'enemy_spawn_decay') double get enemySpawnDecay;/// Floor on the spawn interval after decay (ms).
@JsonKey(name: 'enemy_spawn_floor_ms') int get enemySpawnFloorMs;/// Background sprite for this age (placeholder until T2 picks assets).
@JsonKey(name: 'bg_sprite') String get bgSprite;/// Background music for this age.
 String get music;
/// Create a copy of AgeDef
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AgeDefCopyWith<AgeDef> get copyWith => _$AgeDefCopyWithImpl<AgeDef>(this as AgeDef, _$identity);

  /// Serializes this AgeDef to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AgeDef&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.goldThresholdToAdvance, goldThresholdToAdvance) || other.goldThresholdToAdvance == goldThresholdToAdvance)&&(identical(other.enemySpawnIntervalMs, enemySpawnIntervalMs) || other.enemySpawnIntervalMs == enemySpawnIntervalMs)&&(identical(other.enemySpawnDecay, enemySpawnDecay) || other.enemySpawnDecay == enemySpawnDecay)&&(identical(other.enemySpawnFloorMs, enemySpawnFloorMs) || other.enemySpawnFloorMs == enemySpawnFloorMs)&&(identical(other.bgSprite, bgSprite) || other.bgSprite == bgSprite)&&(identical(other.music, music) || other.music == music));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,goldThresholdToAdvance,enemySpawnIntervalMs,enemySpawnDecay,enemySpawnFloorMs,bgSprite,music);

@override
String toString() {
  return 'AgeDef(id: $id, name: $name, goldThresholdToAdvance: $goldThresholdToAdvance, enemySpawnIntervalMs: $enemySpawnIntervalMs, enemySpawnDecay: $enemySpawnDecay, enemySpawnFloorMs: $enemySpawnFloorMs, bgSprite: $bgSprite, music: $music)';
}


}

/// @nodoc
abstract mixin class $AgeDefCopyWith<$Res>  {
  factory $AgeDefCopyWith(AgeDef value, $Res Function(AgeDef) _then) = _$AgeDefCopyWithImpl;
@useResult
$Res call({
 int id, String name,@JsonKey(name: 'gold_threshold_to_advance') int? goldThresholdToAdvance,@JsonKey(name: 'enemy_spawn_interval_ms') int enemySpawnIntervalMs,@JsonKey(name: 'enemy_spawn_decay') double enemySpawnDecay,@JsonKey(name: 'enemy_spawn_floor_ms') int enemySpawnFloorMs,@JsonKey(name: 'bg_sprite') String bgSprite, String music
});




}
/// @nodoc
class _$AgeDefCopyWithImpl<$Res>
    implements $AgeDefCopyWith<$Res> {
  _$AgeDefCopyWithImpl(this._self, this._then);

  final AgeDef _self;
  final $Res Function(AgeDef) _then;

/// Create a copy of AgeDef
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? goldThresholdToAdvance = freezed,Object? enemySpawnIntervalMs = null,Object? enemySpawnDecay = null,Object? enemySpawnFloorMs = null,Object? bgSprite = null,Object? music = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,goldThresholdToAdvance: freezed == goldThresholdToAdvance ? _self.goldThresholdToAdvance : goldThresholdToAdvance // ignore: cast_nullable_to_non_nullable
as int?,enemySpawnIntervalMs: null == enemySpawnIntervalMs ? _self.enemySpawnIntervalMs : enemySpawnIntervalMs // ignore: cast_nullable_to_non_nullable
as int,enemySpawnDecay: null == enemySpawnDecay ? _self.enemySpawnDecay : enemySpawnDecay // ignore: cast_nullable_to_non_nullable
as double,enemySpawnFloorMs: null == enemySpawnFloorMs ? _self.enemySpawnFloorMs : enemySpawnFloorMs // ignore: cast_nullable_to_non_nullable
as int,bgSprite: null == bgSprite ? _self.bgSprite : bgSprite // ignore: cast_nullable_to_non_nullable
as String,music: null == music ? _self.music : music // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [AgeDef].
extension AgeDefPatterns on AgeDef {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AgeDef value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AgeDef() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AgeDef value)  $default,){
final _that = this;
switch (_that) {
case _AgeDef():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AgeDef value)?  $default,){
final _that = this;
switch (_that) {
case _AgeDef() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name, @JsonKey(name: 'gold_threshold_to_advance')  int? goldThresholdToAdvance, @JsonKey(name: 'enemy_spawn_interval_ms')  int enemySpawnIntervalMs, @JsonKey(name: 'enemy_spawn_decay')  double enemySpawnDecay, @JsonKey(name: 'enemy_spawn_floor_ms')  int enemySpawnFloorMs, @JsonKey(name: 'bg_sprite')  String bgSprite,  String music)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AgeDef() when $default != null:
return $default(_that.id,_that.name,_that.goldThresholdToAdvance,_that.enemySpawnIntervalMs,_that.enemySpawnDecay,_that.enemySpawnFloorMs,_that.bgSprite,_that.music);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name, @JsonKey(name: 'gold_threshold_to_advance')  int? goldThresholdToAdvance, @JsonKey(name: 'enemy_spawn_interval_ms')  int enemySpawnIntervalMs, @JsonKey(name: 'enemy_spawn_decay')  double enemySpawnDecay, @JsonKey(name: 'enemy_spawn_floor_ms')  int enemySpawnFloorMs, @JsonKey(name: 'bg_sprite')  String bgSprite,  String music)  $default,) {final _that = this;
switch (_that) {
case _AgeDef():
return $default(_that.id,_that.name,_that.goldThresholdToAdvance,_that.enemySpawnIntervalMs,_that.enemySpawnDecay,_that.enemySpawnFloorMs,_that.bgSprite,_that.music);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name, @JsonKey(name: 'gold_threshold_to_advance')  int? goldThresholdToAdvance, @JsonKey(name: 'enemy_spawn_interval_ms')  int enemySpawnIntervalMs, @JsonKey(name: 'enemy_spawn_decay')  double enemySpawnDecay, @JsonKey(name: 'enemy_spawn_floor_ms')  int enemySpawnFloorMs, @JsonKey(name: 'bg_sprite')  String bgSprite,  String music)?  $default,) {final _that = this;
switch (_that) {
case _AgeDef() when $default != null:
return $default(_that.id,_that.name,_that.goldThresholdToAdvance,_that.enemySpawnIntervalMs,_that.enemySpawnDecay,_that.enemySpawnFloorMs,_that.bgSprite,_that.music);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AgeDef implements AgeDef {
  const _AgeDef({required this.id, required this.name, @JsonKey(name: 'gold_threshold_to_advance') this.goldThresholdToAdvance, @JsonKey(name: 'enemy_spawn_interval_ms') required this.enemySpawnIntervalMs, @JsonKey(name: 'enemy_spawn_decay') required this.enemySpawnDecay, @JsonKey(name: 'enemy_spawn_floor_ms') required this.enemySpawnFloorMs, @JsonKey(name: 'bg_sprite') required this.bgSprite, required this.music});
  factory _AgeDef.fromJson(Map<String, dynamic> json) => _$AgeDefFromJson(json);

@override final  int id;
@override final  String name;
/// Cumulative gold earned required to advance INTO this age.
/// null for age 1 (the starting age).
@override@JsonKey(name: 'gold_threshold_to_advance') final  int? goldThresholdToAdvance;
/// Initial enemy spawn interval (ms) when enemy reaches this age.
@override@JsonKey(name: 'enemy_spawn_interval_ms') final  int enemySpawnIntervalMs;
/// Per-30s decay multiplier on the spawn interval (e.g. 0.10 = 10% faster).
@override@JsonKey(name: 'enemy_spawn_decay') final  double enemySpawnDecay;
/// Floor on the spawn interval after decay (ms).
@override@JsonKey(name: 'enemy_spawn_floor_ms') final  int enemySpawnFloorMs;
/// Background sprite for this age (placeholder until T2 picks assets).
@override@JsonKey(name: 'bg_sprite') final  String bgSprite;
/// Background music for this age.
@override final  String music;

/// Create a copy of AgeDef
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AgeDefCopyWith<_AgeDef> get copyWith => __$AgeDefCopyWithImpl<_AgeDef>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AgeDefToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AgeDef&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.goldThresholdToAdvance, goldThresholdToAdvance) || other.goldThresholdToAdvance == goldThresholdToAdvance)&&(identical(other.enemySpawnIntervalMs, enemySpawnIntervalMs) || other.enemySpawnIntervalMs == enemySpawnIntervalMs)&&(identical(other.enemySpawnDecay, enemySpawnDecay) || other.enemySpawnDecay == enemySpawnDecay)&&(identical(other.enemySpawnFloorMs, enemySpawnFloorMs) || other.enemySpawnFloorMs == enemySpawnFloorMs)&&(identical(other.bgSprite, bgSprite) || other.bgSprite == bgSprite)&&(identical(other.music, music) || other.music == music));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,goldThresholdToAdvance,enemySpawnIntervalMs,enemySpawnDecay,enemySpawnFloorMs,bgSprite,music);

@override
String toString() {
  return 'AgeDef(id: $id, name: $name, goldThresholdToAdvance: $goldThresholdToAdvance, enemySpawnIntervalMs: $enemySpawnIntervalMs, enemySpawnDecay: $enemySpawnDecay, enemySpawnFloorMs: $enemySpawnFloorMs, bgSprite: $bgSprite, music: $music)';
}


}

/// @nodoc
abstract mixin class _$AgeDefCopyWith<$Res> implements $AgeDefCopyWith<$Res> {
  factory _$AgeDefCopyWith(_AgeDef value, $Res Function(_AgeDef) _then) = __$AgeDefCopyWithImpl;
@override @useResult
$Res call({
 int id, String name,@JsonKey(name: 'gold_threshold_to_advance') int? goldThresholdToAdvance,@JsonKey(name: 'enemy_spawn_interval_ms') int enemySpawnIntervalMs,@JsonKey(name: 'enemy_spawn_decay') double enemySpawnDecay,@JsonKey(name: 'enemy_spawn_floor_ms') int enemySpawnFloorMs,@JsonKey(name: 'bg_sprite') String bgSprite, String music
});




}
/// @nodoc
class __$AgeDefCopyWithImpl<$Res>
    implements _$AgeDefCopyWith<$Res> {
  __$AgeDefCopyWithImpl(this._self, this._then);

  final _AgeDef _self;
  final $Res Function(_AgeDef) _then;

/// Create a copy of AgeDef
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? goldThresholdToAdvance = freezed,Object? enemySpawnIntervalMs = null,Object? enemySpawnDecay = null,Object? enemySpawnFloorMs = null,Object? bgSprite = null,Object? music = null,}) {
  return _then(_AgeDef(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,goldThresholdToAdvance: freezed == goldThresholdToAdvance ? _self.goldThresholdToAdvance : goldThresholdToAdvance // ignore: cast_nullable_to_non_nullable
as int?,enemySpawnIntervalMs: null == enemySpawnIntervalMs ? _self.enemySpawnIntervalMs : enemySpawnIntervalMs // ignore: cast_nullable_to_non_nullable
as int,enemySpawnDecay: null == enemySpawnDecay ? _self.enemySpawnDecay : enemySpawnDecay // ignore: cast_nullable_to_non_nullable
as double,enemySpawnFloorMs: null == enemySpawnFloorMs ? _self.enemySpawnFloorMs : enemySpawnFloorMs // ignore: cast_nullable_to_non_nullable
as int,bgSprite: null == bgSprite ? _self.bgSprite : bgSprite // ignore: cast_nullable_to_non_nullable
as String,music: null == music ? _self.music : music // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$GameConstants {

@JsonKey(name: 'starting_gold') int get startingGold;@JsonKey(name: 'player_base_hp') int get playerBaseHp;@JsonKey(name: 'enemy_base_hp') int get enemyBaseHp;@JsonKey(name: 'world_width_px') double get worldWidthPx;@JsonKey(name: 'world_height_px') double get worldHeightPx;@JsonKey(name: 'player_base_x') double get playerBaseX;@JsonKey(name: 'enemy_base_x') double get enemyBaseX;@JsonKey(name: 'ground_y') double get groundY;@JsonKey(name: 'spawn_debounce_ms') int get spawnDebounceMs;@JsonKey(name: 'sfx_throttle_ms') int get sfxThrottleMs;
/// Create a copy of GameConstants
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GameConstantsCopyWith<GameConstants> get copyWith => _$GameConstantsCopyWithImpl<GameConstants>(this as GameConstants, _$identity);

  /// Serializes this GameConstants to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GameConstants&&(identical(other.startingGold, startingGold) || other.startingGold == startingGold)&&(identical(other.playerBaseHp, playerBaseHp) || other.playerBaseHp == playerBaseHp)&&(identical(other.enemyBaseHp, enemyBaseHp) || other.enemyBaseHp == enemyBaseHp)&&(identical(other.worldWidthPx, worldWidthPx) || other.worldWidthPx == worldWidthPx)&&(identical(other.worldHeightPx, worldHeightPx) || other.worldHeightPx == worldHeightPx)&&(identical(other.playerBaseX, playerBaseX) || other.playerBaseX == playerBaseX)&&(identical(other.enemyBaseX, enemyBaseX) || other.enemyBaseX == enemyBaseX)&&(identical(other.groundY, groundY) || other.groundY == groundY)&&(identical(other.spawnDebounceMs, spawnDebounceMs) || other.spawnDebounceMs == spawnDebounceMs)&&(identical(other.sfxThrottleMs, sfxThrottleMs) || other.sfxThrottleMs == sfxThrottleMs));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,startingGold,playerBaseHp,enemyBaseHp,worldWidthPx,worldHeightPx,playerBaseX,enemyBaseX,groundY,spawnDebounceMs,sfxThrottleMs);

@override
String toString() {
  return 'GameConstants(startingGold: $startingGold, playerBaseHp: $playerBaseHp, enemyBaseHp: $enemyBaseHp, worldWidthPx: $worldWidthPx, worldHeightPx: $worldHeightPx, playerBaseX: $playerBaseX, enemyBaseX: $enemyBaseX, groundY: $groundY, spawnDebounceMs: $spawnDebounceMs, sfxThrottleMs: $sfxThrottleMs)';
}


}

/// @nodoc
abstract mixin class $GameConstantsCopyWith<$Res>  {
  factory $GameConstantsCopyWith(GameConstants value, $Res Function(GameConstants) _then) = _$GameConstantsCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'starting_gold') int startingGold,@JsonKey(name: 'player_base_hp') int playerBaseHp,@JsonKey(name: 'enemy_base_hp') int enemyBaseHp,@JsonKey(name: 'world_width_px') double worldWidthPx,@JsonKey(name: 'world_height_px') double worldHeightPx,@JsonKey(name: 'player_base_x') double playerBaseX,@JsonKey(name: 'enemy_base_x') double enemyBaseX,@JsonKey(name: 'ground_y') double groundY,@JsonKey(name: 'spawn_debounce_ms') int spawnDebounceMs,@JsonKey(name: 'sfx_throttle_ms') int sfxThrottleMs
});




}
/// @nodoc
class _$GameConstantsCopyWithImpl<$Res>
    implements $GameConstantsCopyWith<$Res> {
  _$GameConstantsCopyWithImpl(this._self, this._then);

  final GameConstants _self;
  final $Res Function(GameConstants) _then;

/// Create a copy of GameConstants
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? startingGold = null,Object? playerBaseHp = null,Object? enemyBaseHp = null,Object? worldWidthPx = null,Object? worldHeightPx = null,Object? playerBaseX = null,Object? enemyBaseX = null,Object? groundY = null,Object? spawnDebounceMs = null,Object? sfxThrottleMs = null,}) {
  return _then(_self.copyWith(
startingGold: null == startingGold ? _self.startingGold : startingGold // ignore: cast_nullable_to_non_nullable
as int,playerBaseHp: null == playerBaseHp ? _self.playerBaseHp : playerBaseHp // ignore: cast_nullable_to_non_nullable
as int,enemyBaseHp: null == enemyBaseHp ? _self.enemyBaseHp : enemyBaseHp // ignore: cast_nullable_to_non_nullable
as int,worldWidthPx: null == worldWidthPx ? _self.worldWidthPx : worldWidthPx // ignore: cast_nullable_to_non_nullable
as double,worldHeightPx: null == worldHeightPx ? _self.worldHeightPx : worldHeightPx // ignore: cast_nullable_to_non_nullable
as double,playerBaseX: null == playerBaseX ? _self.playerBaseX : playerBaseX // ignore: cast_nullable_to_non_nullable
as double,enemyBaseX: null == enemyBaseX ? _self.enemyBaseX : enemyBaseX // ignore: cast_nullable_to_non_nullable
as double,groundY: null == groundY ? _self.groundY : groundY // ignore: cast_nullable_to_non_nullable
as double,spawnDebounceMs: null == spawnDebounceMs ? _self.spawnDebounceMs : spawnDebounceMs // ignore: cast_nullable_to_non_nullable
as int,sfxThrottleMs: null == sfxThrottleMs ? _self.sfxThrottleMs : sfxThrottleMs // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [GameConstants].
extension GameConstantsPatterns on GameConstants {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GameConstants value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GameConstants() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GameConstants value)  $default,){
final _that = this;
switch (_that) {
case _GameConstants():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GameConstants value)?  $default,){
final _that = this;
switch (_that) {
case _GameConstants() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'starting_gold')  int startingGold, @JsonKey(name: 'player_base_hp')  int playerBaseHp, @JsonKey(name: 'enemy_base_hp')  int enemyBaseHp, @JsonKey(name: 'world_width_px')  double worldWidthPx, @JsonKey(name: 'world_height_px')  double worldHeightPx, @JsonKey(name: 'player_base_x')  double playerBaseX, @JsonKey(name: 'enemy_base_x')  double enemyBaseX, @JsonKey(name: 'ground_y')  double groundY, @JsonKey(name: 'spawn_debounce_ms')  int spawnDebounceMs, @JsonKey(name: 'sfx_throttle_ms')  int sfxThrottleMs)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GameConstants() when $default != null:
return $default(_that.startingGold,_that.playerBaseHp,_that.enemyBaseHp,_that.worldWidthPx,_that.worldHeightPx,_that.playerBaseX,_that.enemyBaseX,_that.groundY,_that.spawnDebounceMs,_that.sfxThrottleMs);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'starting_gold')  int startingGold, @JsonKey(name: 'player_base_hp')  int playerBaseHp, @JsonKey(name: 'enemy_base_hp')  int enemyBaseHp, @JsonKey(name: 'world_width_px')  double worldWidthPx, @JsonKey(name: 'world_height_px')  double worldHeightPx, @JsonKey(name: 'player_base_x')  double playerBaseX, @JsonKey(name: 'enemy_base_x')  double enemyBaseX, @JsonKey(name: 'ground_y')  double groundY, @JsonKey(name: 'spawn_debounce_ms')  int spawnDebounceMs, @JsonKey(name: 'sfx_throttle_ms')  int sfxThrottleMs)  $default,) {final _that = this;
switch (_that) {
case _GameConstants():
return $default(_that.startingGold,_that.playerBaseHp,_that.enemyBaseHp,_that.worldWidthPx,_that.worldHeightPx,_that.playerBaseX,_that.enemyBaseX,_that.groundY,_that.spawnDebounceMs,_that.sfxThrottleMs);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'starting_gold')  int startingGold, @JsonKey(name: 'player_base_hp')  int playerBaseHp, @JsonKey(name: 'enemy_base_hp')  int enemyBaseHp, @JsonKey(name: 'world_width_px')  double worldWidthPx, @JsonKey(name: 'world_height_px')  double worldHeightPx, @JsonKey(name: 'player_base_x')  double playerBaseX, @JsonKey(name: 'enemy_base_x')  double enemyBaseX, @JsonKey(name: 'ground_y')  double groundY, @JsonKey(name: 'spawn_debounce_ms')  int spawnDebounceMs, @JsonKey(name: 'sfx_throttle_ms')  int sfxThrottleMs)?  $default,) {final _that = this;
switch (_that) {
case _GameConstants() when $default != null:
return $default(_that.startingGold,_that.playerBaseHp,_that.enemyBaseHp,_that.worldWidthPx,_that.worldHeightPx,_that.playerBaseX,_that.enemyBaseX,_that.groundY,_that.spawnDebounceMs,_that.sfxThrottleMs);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GameConstants implements GameConstants {
  const _GameConstants({@JsonKey(name: 'starting_gold') required this.startingGold, @JsonKey(name: 'player_base_hp') required this.playerBaseHp, @JsonKey(name: 'enemy_base_hp') required this.enemyBaseHp, @JsonKey(name: 'world_width_px') required this.worldWidthPx, @JsonKey(name: 'world_height_px') required this.worldHeightPx, @JsonKey(name: 'player_base_x') required this.playerBaseX, @JsonKey(name: 'enemy_base_x') required this.enemyBaseX, @JsonKey(name: 'ground_y') required this.groundY, @JsonKey(name: 'spawn_debounce_ms') required this.spawnDebounceMs, @JsonKey(name: 'sfx_throttle_ms') required this.sfxThrottleMs});
  factory _GameConstants.fromJson(Map<String, dynamic> json) => _$GameConstantsFromJson(json);

@override@JsonKey(name: 'starting_gold') final  int startingGold;
@override@JsonKey(name: 'player_base_hp') final  int playerBaseHp;
@override@JsonKey(name: 'enemy_base_hp') final  int enemyBaseHp;
@override@JsonKey(name: 'world_width_px') final  double worldWidthPx;
@override@JsonKey(name: 'world_height_px') final  double worldHeightPx;
@override@JsonKey(name: 'player_base_x') final  double playerBaseX;
@override@JsonKey(name: 'enemy_base_x') final  double enemyBaseX;
@override@JsonKey(name: 'ground_y') final  double groundY;
@override@JsonKey(name: 'spawn_debounce_ms') final  int spawnDebounceMs;
@override@JsonKey(name: 'sfx_throttle_ms') final  int sfxThrottleMs;

/// Create a copy of GameConstants
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GameConstantsCopyWith<_GameConstants> get copyWith => __$GameConstantsCopyWithImpl<_GameConstants>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GameConstantsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GameConstants&&(identical(other.startingGold, startingGold) || other.startingGold == startingGold)&&(identical(other.playerBaseHp, playerBaseHp) || other.playerBaseHp == playerBaseHp)&&(identical(other.enemyBaseHp, enemyBaseHp) || other.enemyBaseHp == enemyBaseHp)&&(identical(other.worldWidthPx, worldWidthPx) || other.worldWidthPx == worldWidthPx)&&(identical(other.worldHeightPx, worldHeightPx) || other.worldHeightPx == worldHeightPx)&&(identical(other.playerBaseX, playerBaseX) || other.playerBaseX == playerBaseX)&&(identical(other.enemyBaseX, enemyBaseX) || other.enemyBaseX == enemyBaseX)&&(identical(other.groundY, groundY) || other.groundY == groundY)&&(identical(other.spawnDebounceMs, spawnDebounceMs) || other.spawnDebounceMs == spawnDebounceMs)&&(identical(other.sfxThrottleMs, sfxThrottleMs) || other.sfxThrottleMs == sfxThrottleMs));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,startingGold,playerBaseHp,enemyBaseHp,worldWidthPx,worldHeightPx,playerBaseX,enemyBaseX,groundY,spawnDebounceMs,sfxThrottleMs);

@override
String toString() {
  return 'GameConstants(startingGold: $startingGold, playerBaseHp: $playerBaseHp, enemyBaseHp: $enemyBaseHp, worldWidthPx: $worldWidthPx, worldHeightPx: $worldHeightPx, playerBaseX: $playerBaseX, enemyBaseX: $enemyBaseX, groundY: $groundY, spawnDebounceMs: $spawnDebounceMs, sfxThrottleMs: $sfxThrottleMs)';
}


}

/// @nodoc
abstract mixin class _$GameConstantsCopyWith<$Res> implements $GameConstantsCopyWith<$Res> {
  factory _$GameConstantsCopyWith(_GameConstants value, $Res Function(_GameConstants) _then) = __$GameConstantsCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'starting_gold') int startingGold,@JsonKey(name: 'player_base_hp') int playerBaseHp,@JsonKey(name: 'enemy_base_hp') int enemyBaseHp,@JsonKey(name: 'world_width_px') double worldWidthPx,@JsonKey(name: 'world_height_px') double worldHeightPx,@JsonKey(name: 'player_base_x') double playerBaseX,@JsonKey(name: 'enemy_base_x') double enemyBaseX,@JsonKey(name: 'ground_y') double groundY,@JsonKey(name: 'spawn_debounce_ms') int spawnDebounceMs,@JsonKey(name: 'sfx_throttle_ms') int sfxThrottleMs
});




}
/// @nodoc
class __$GameConstantsCopyWithImpl<$Res>
    implements _$GameConstantsCopyWith<$Res> {
  __$GameConstantsCopyWithImpl(this._self, this._then);

  final _GameConstants _self;
  final $Res Function(_GameConstants) _then;

/// Create a copy of GameConstants
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? startingGold = null,Object? playerBaseHp = null,Object? enemyBaseHp = null,Object? worldWidthPx = null,Object? worldHeightPx = null,Object? playerBaseX = null,Object? enemyBaseX = null,Object? groundY = null,Object? spawnDebounceMs = null,Object? sfxThrottleMs = null,}) {
  return _then(_GameConstants(
startingGold: null == startingGold ? _self.startingGold : startingGold // ignore: cast_nullable_to_non_nullable
as int,playerBaseHp: null == playerBaseHp ? _self.playerBaseHp : playerBaseHp // ignore: cast_nullable_to_non_nullable
as int,enemyBaseHp: null == enemyBaseHp ? _self.enemyBaseHp : enemyBaseHp // ignore: cast_nullable_to_non_nullable
as int,worldWidthPx: null == worldWidthPx ? _self.worldWidthPx : worldWidthPx // ignore: cast_nullable_to_non_nullable
as double,worldHeightPx: null == worldHeightPx ? _self.worldHeightPx : worldHeightPx // ignore: cast_nullable_to_non_nullable
as double,playerBaseX: null == playerBaseX ? _self.playerBaseX : playerBaseX // ignore: cast_nullable_to_non_nullable
as double,enemyBaseX: null == enemyBaseX ? _self.enemyBaseX : enemyBaseX // ignore: cast_nullable_to_non_nullable
as double,groundY: null == groundY ? _self.groundY : groundY // ignore: cast_nullable_to_non_nullable
as double,spawnDebounceMs: null == spawnDebounceMs ? _self.spawnDebounceMs : spawnDebounceMs // ignore: cast_nullable_to_non_nullable
as int,sfxThrottleMs: null == sfxThrottleMs ? _self.sfxThrottleMs : sfxThrottleMs // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$GameConfig {

 Map<String, UnitDef> get units; Map<int, AgeDef> get ages; GameConstants get constants;
/// Create a copy of GameConfig
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GameConfigCopyWith<GameConfig> get copyWith => _$GameConfigCopyWithImpl<GameConfig>(this as GameConfig, _$identity);

  /// Serializes this GameConfig to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GameConfig&&const DeepCollectionEquality().equals(other.units, units)&&const DeepCollectionEquality().equals(other.ages, ages)&&(identical(other.constants, constants) || other.constants == constants));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(units),const DeepCollectionEquality().hash(ages),constants);

@override
String toString() {
  return 'GameConfig(units: $units, ages: $ages, constants: $constants)';
}


}

/// @nodoc
abstract mixin class $GameConfigCopyWith<$Res>  {
  factory $GameConfigCopyWith(GameConfig value, $Res Function(GameConfig) _then) = _$GameConfigCopyWithImpl;
@useResult
$Res call({
 Map<String, UnitDef> units, Map<int, AgeDef> ages, GameConstants constants
});


$GameConstantsCopyWith<$Res> get constants;

}
/// @nodoc
class _$GameConfigCopyWithImpl<$Res>
    implements $GameConfigCopyWith<$Res> {
  _$GameConfigCopyWithImpl(this._self, this._then);

  final GameConfig _self;
  final $Res Function(GameConfig) _then;

/// Create a copy of GameConfig
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? units = null,Object? ages = null,Object? constants = null,}) {
  return _then(_self.copyWith(
units: null == units ? _self.units : units // ignore: cast_nullable_to_non_nullable
as Map<String, UnitDef>,ages: null == ages ? _self.ages : ages // ignore: cast_nullable_to_non_nullable
as Map<int, AgeDef>,constants: null == constants ? _self.constants : constants // ignore: cast_nullable_to_non_nullable
as GameConstants,
  ));
}
/// Create a copy of GameConfig
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GameConstantsCopyWith<$Res> get constants {

  return $GameConstantsCopyWith<$Res>(_self.constants, (value) {
    return _then(_self.copyWith(constants: value));
  });
}
}


/// Adds pattern-matching-related methods to [GameConfig].
extension GameConfigPatterns on GameConfig {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GameConfig value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GameConfig() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GameConfig value)  $default,){
final _that = this;
switch (_that) {
case _GameConfig():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GameConfig value)?  $default,){
final _that = this;
switch (_that) {
case _GameConfig() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Map<String, UnitDef> units,  Map<int, AgeDef> ages,  GameConstants constants)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GameConfig() when $default != null:
return $default(_that.units,_that.ages,_that.constants);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Map<String, UnitDef> units,  Map<int, AgeDef> ages,  GameConstants constants)  $default,) {final _that = this;
switch (_that) {
case _GameConfig():
return $default(_that.units,_that.ages,_that.constants);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Map<String, UnitDef> units,  Map<int, AgeDef> ages,  GameConstants constants)?  $default,) {final _that = this;
switch (_that) {
case _GameConfig() when $default != null:
return $default(_that.units,_that.ages,_that.constants);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GameConfig implements GameConfig {
  const _GameConfig({required final  Map<String, UnitDef> units, required final  Map<int, AgeDef> ages, required this.constants}): _units = units,_ages = ages;
  factory _GameConfig.fromJson(Map<String, dynamic> json) => _$GameConfigFromJson(json);

 final  Map<String, UnitDef> _units;
@override Map<String, UnitDef> get units {
  if (_units is EqualUnmodifiableMapView) return _units;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_units);
}

 final  Map<int, AgeDef> _ages;
@override Map<int, AgeDef> get ages {
  if (_ages is EqualUnmodifiableMapView) return _ages;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_ages);
}

@override final  GameConstants constants;

/// Create a copy of GameConfig
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GameConfigCopyWith<_GameConfig> get copyWith => __$GameConfigCopyWithImpl<_GameConfig>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GameConfigToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GameConfig&&const DeepCollectionEquality().equals(other._units, _units)&&const DeepCollectionEquality().equals(other._ages, _ages)&&(identical(other.constants, constants) || other.constants == constants));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_units),const DeepCollectionEquality().hash(_ages),constants);

@override
String toString() {
  return 'GameConfig(units: $units, ages: $ages, constants: $constants)';
}


}

/// @nodoc
abstract mixin class _$GameConfigCopyWith<$Res> implements $GameConfigCopyWith<$Res> {
  factory _$GameConfigCopyWith(_GameConfig value, $Res Function(_GameConfig) _then) = __$GameConfigCopyWithImpl;
@override @useResult
$Res call({
 Map<String, UnitDef> units, Map<int, AgeDef> ages, GameConstants constants
});


@override $GameConstantsCopyWith<$Res> get constants;

}
/// @nodoc
class __$GameConfigCopyWithImpl<$Res>
    implements _$GameConfigCopyWith<$Res> {
  __$GameConfigCopyWithImpl(this._self, this._then);

  final _GameConfig _self;
  final $Res Function(_GameConfig) _then;

/// Create a copy of GameConfig
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? units = null,Object? ages = null,Object? constants = null,}) {
  return _then(_GameConfig(
units: null == units ? _self._units : units // ignore: cast_nullable_to_non_nullable
as Map<String, UnitDef>,ages: null == ages ? _self._ages : ages // ignore: cast_nullable_to_non_nullable
as Map<int, AgeDef>,constants: null == constants ? _self.constants : constants // ignore: cast_nullable_to_non_nullable
as GameConstants,
  ));
}

/// Create a copy of GameConfig
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GameConstantsCopyWith<$Res> get constants {

  return $GameConstantsCopyWith<$Res>(_self.constants, (value) {
    return _then(_self.copyWith(constants: value));
  });
}
}

// dart format on
