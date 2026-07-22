// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'maintenance_schedule_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MaintenanceSchedule {

 String get id; String get estateId; String? get buildingId; String get name; String get description; int get frequencyDays; DateTime? get lastPerformed; DateTime get nextDueDate;
/// Create a copy of MaintenanceSchedule
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MaintenanceScheduleCopyWith<MaintenanceSchedule> get copyWith => _$MaintenanceScheduleCopyWithImpl<MaintenanceSchedule>(this as MaintenanceSchedule, _$identity);

  /// Serializes this MaintenanceSchedule to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MaintenanceSchedule&&(identical(other.id, id) || other.id == id)&&(identical(other.estateId, estateId) || other.estateId == estateId)&&(identical(other.buildingId, buildingId) || other.buildingId == buildingId)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.frequencyDays, frequencyDays) || other.frequencyDays == frequencyDays)&&(identical(other.lastPerformed, lastPerformed) || other.lastPerformed == lastPerformed)&&(identical(other.nextDueDate, nextDueDate) || other.nextDueDate == nextDueDate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,estateId,buildingId,name,description,frequencyDays,lastPerformed,nextDueDate);

@override
String toString() {
  return 'MaintenanceSchedule(id: $id, estateId: $estateId, buildingId: $buildingId, name: $name, description: $description, frequencyDays: $frequencyDays, lastPerformed: $lastPerformed, nextDueDate: $nextDueDate)';
}


}

/// @nodoc
abstract mixin class $MaintenanceScheduleCopyWith<$Res>  {
  factory $MaintenanceScheduleCopyWith(MaintenanceSchedule value, $Res Function(MaintenanceSchedule) _then) = _$MaintenanceScheduleCopyWithImpl;
@useResult
$Res call({
 String id, String estateId, String? buildingId, String name, String description, int frequencyDays, DateTime? lastPerformed, DateTime nextDueDate
});




}
/// @nodoc
class _$MaintenanceScheduleCopyWithImpl<$Res>
    implements $MaintenanceScheduleCopyWith<$Res> {
  _$MaintenanceScheduleCopyWithImpl(this._self, this._then);

  final MaintenanceSchedule _self;
  final $Res Function(MaintenanceSchedule) _then;

/// Create a copy of MaintenanceSchedule
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? estateId = null,Object? buildingId = freezed,Object? name = null,Object? description = null,Object? frequencyDays = null,Object? lastPerformed = freezed,Object? nextDueDate = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,estateId: null == estateId ? _self.estateId : estateId // ignore: cast_nullable_to_non_nullable
as String,buildingId: freezed == buildingId ? _self.buildingId : buildingId // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,frequencyDays: null == frequencyDays ? _self.frequencyDays : frequencyDays // ignore: cast_nullable_to_non_nullable
as int,lastPerformed: freezed == lastPerformed ? _self.lastPerformed : lastPerformed // ignore: cast_nullable_to_non_nullable
as DateTime?,nextDueDate: null == nextDueDate ? _self.nextDueDate : nextDueDate // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [MaintenanceSchedule].
extension MaintenanceSchedulePatterns on MaintenanceSchedule {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MaintenanceSchedule value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MaintenanceSchedule() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MaintenanceSchedule value)  $default,){
final _that = this;
switch (_that) {
case _MaintenanceSchedule():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MaintenanceSchedule value)?  $default,){
final _that = this;
switch (_that) {
case _MaintenanceSchedule() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String estateId,  String? buildingId,  String name,  String description,  int frequencyDays,  DateTime? lastPerformed,  DateTime nextDueDate)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MaintenanceSchedule() when $default != null:
return $default(_that.id,_that.estateId,_that.buildingId,_that.name,_that.description,_that.frequencyDays,_that.lastPerformed,_that.nextDueDate);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String estateId,  String? buildingId,  String name,  String description,  int frequencyDays,  DateTime? lastPerformed,  DateTime nextDueDate)  $default,) {final _that = this;
switch (_that) {
case _MaintenanceSchedule():
return $default(_that.id,_that.estateId,_that.buildingId,_that.name,_that.description,_that.frequencyDays,_that.lastPerformed,_that.nextDueDate);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String estateId,  String? buildingId,  String name,  String description,  int frequencyDays,  DateTime? lastPerformed,  DateTime nextDueDate)?  $default,) {final _that = this;
switch (_that) {
case _MaintenanceSchedule() when $default != null:
return $default(_that.id,_that.estateId,_that.buildingId,_that.name,_that.description,_that.frequencyDays,_that.lastPerformed,_that.nextDueDate);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _MaintenanceSchedule extends MaintenanceSchedule {
  const _MaintenanceSchedule({required this.id, required this.estateId, this.buildingId, required this.name, this.description = '', required this.frequencyDays, this.lastPerformed, required this.nextDueDate}): super._();
  factory _MaintenanceSchedule.fromJson(Map<String, dynamic> json) => _$MaintenanceScheduleFromJson(json);

@override final  String id;
@override final  String estateId;
@override final  String? buildingId;
@override final  String name;
@override@JsonKey() final  String description;
@override final  int frequencyDays;
@override final  DateTime? lastPerformed;
@override final  DateTime nextDueDate;

/// Create a copy of MaintenanceSchedule
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MaintenanceScheduleCopyWith<_MaintenanceSchedule> get copyWith => __$MaintenanceScheduleCopyWithImpl<_MaintenanceSchedule>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MaintenanceScheduleToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MaintenanceSchedule&&(identical(other.id, id) || other.id == id)&&(identical(other.estateId, estateId) || other.estateId == estateId)&&(identical(other.buildingId, buildingId) || other.buildingId == buildingId)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.frequencyDays, frequencyDays) || other.frequencyDays == frequencyDays)&&(identical(other.lastPerformed, lastPerformed) || other.lastPerformed == lastPerformed)&&(identical(other.nextDueDate, nextDueDate) || other.nextDueDate == nextDueDate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,estateId,buildingId,name,description,frequencyDays,lastPerformed,nextDueDate);

@override
String toString() {
  return 'MaintenanceSchedule(id: $id, estateId: $estateId, buildingId: $buildingId, name: $name, description: $description, frequencyDays: $frequencyDays, lastPerformed: $lastPerformed, nextDueDate: $nextDueDate)';
}


}

/// @nodoc
abstract mixin class _$MaintenanceScheduleCopyWith<$Res> implements $MaintenanceScheduleCopyWith<$Res> {
  factory _$MaintenanceScheduleCopyWith(_MaintenanceSchedule value, $Res Function(_MaintenanceSchedule) _then) = __$MaintenanceScheduleCopyWithImpl;
@override @useResult
$Res call({
 String id, String estateId, String? buildingId, String name, String description, int frequencyDays, DateTime? lastPerformed, DateTime nextDueDate
});




}
/// @nodoc
class __$MaintenanceScheduleCopyWithImpl<$Res>
    implements _$MaintenanceScheduleCopyWith<$Res> {
  __$MaintenanceScheduleCopyWithImpl(this._self, this._then);

  final _MaintenanceSchedule _self;
  final $Res Function(_MaintenanceSchedule) _then;

/// Create a copy of MaintenanceSchedule
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? estateId = null,Object? buildingId = freezed,Object? name = null,Object? description = null,Object? frequencyDays = null,Object? lastPerformed = freezed,Object? nextDueDate = null,}) {
  return _then(_MaintenanceSchedule(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,estateId: null == estateId ? _self.estateId : estateId // ignore: cast_nullable_to_non_nullable
as String,buildingId: freezed == buildingId ? _self.buildingId : buildingId // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,frequencyDays: null == frequencyDays ? _self.frequencyDays : frequencyDays // ignore: cast_nullable_to_non_nullable
as int,lastPerformed: freezed == lastPerformed ? _self.lastPerformed : lastPerformed // ignore: cast_nullable_to_non_nullable
as DateTime?,nextDueDate: null == nextDueDate ? _self.nextDueDate : nextDueDate // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
