// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'resident_space_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ResidentSpaceModel {

 String get id; String get userId; String get estateId; String get type; String get label; String get createdBy; DateTime? get createdAt;
/// Create a copy of ResidentSpaceModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ResidentSpaceModelCopyWith<ResidentSpaceModel> get copyWith => _$ResidentSpaceModelCopyWithImpl<ResidentSpaceModel>(this as ResidentSpaceModel, _$identity);

  /// Serializes this ResidentSpaceModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ResidentSpaceModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.estateId, estateId) || other.estateId == estateId)&&(identical(other.type, type) || other.type == type)&&(identical(other.label, label) || other.label == label)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,estateId,type,label,createdBy,createdAt);

@override
String toString() {
  return 'ResidentSpaceModel(id: $id, userId: $userId, estateId: $estateId, type: $type, label: $label, createdBy: $createdBy, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $ResidentSpaceModelCopyWith<$Res>  {
  factory $ResidentSpaceModelCopyWith(ResidentSpaceModel value, $Res Function(ResidentSpaceModel) _then) = _$ResidentSpaceModelCopyWithImpl;
@useResult
$Res call({
 String id, String userId, String estateId, String type, String label, String createdBy, DateTime? createdAt
});




}
/// @nodoc
class _$ResidentSpaceModelCopyWithImpl<$Res>
    implements $ResidentSpaceModelCopyWith<$Res> {
  _$ResidentSpaceModelCopyWithImpl(this._self, this._then);

  final ResidentSpaceModel _self;
  final $Res Function(ResidentSpaceModel) _then;

/// Create a copy of ResidentSpaceModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? estateId = null,Object? type = null,Object? label = null,Object? createdBy = null,Object? createdAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,estateId: null == estateId ? _self.estateId : estateId // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,createdBy: null == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [ResidentSpaceModel].
extension ResidentSpaceModelPatterns on ResidentSpaceModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ResidentSpaceModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ResidentSpaceModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ResidentSpaceModel value)  $default,){
final _that = this;
switch (_that) {
case _ResidentSpaceModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ResidentSpaceModel value)?  $default,){
final _that = this;
switch (_that) {
case _ResidentSpaceModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String userId,  String estateId,  String type,  String label,  String createdBy,  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ResidentSpaceModel() when $default != null:
return $default(_that.id,_that.userId,_that.estateId,_that.type,_that.label,_that.createdBy,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String userId,  String estateId,  String type,  String label,  String createdBy,  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _ResidentSpaceModel():
return $default(_that.id,_that.userId,_that.estateId,_that.type,_that.label,_that.createdBy,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String userId,  String estateId,  String type,  String label,  String createdBy,  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _ResidentSpaceModel() when $default != null:
return $default(_that.id,_that.userId,_that.estateId,_that.type,_that.label,_that.createdBy,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _ResidentSpaceModel extends ResidentSpaceModel {
  const _ResidentSpaceModel({required this.id, required this.userId, required this.estateId, required this.type, required this.label, this.createdBy = 'resident', this.createdAt}): super._();
  factory _ResidentSpaceModel.fromJson(Map<String, dynamic> json) => _$ResidentSpaceModelFromJson(json);

@override final  String id;
@override final  String userId;
@override final  String estateId;
@override final  String type;
@override final  String label;
@override@JsonKey() final  String createdBy;
@override final  DateTime? createdAt;

/// Create a copy of ResidentSpaceModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ResidentSpaceModelCopyWith<_ResidentSpaceModel> get copyWith => __$ResidentSpaceModelCopyWithImpl<_ResidentSpaceModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ResidentSpaceModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ResidentSpaceModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.estateId, estateId) || other.estateId == estateId)&&(identical(other.type, type) || other.type == type)&&(identical(other.label, label) || other.label == label)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,estateId,type,label,createdBy,createdAt);

@override
String toString() {
  return 'ResidentSpaceModel(id: $id, userId: $userId, estateId: $estateId, type: $type, label: $label, createdBy: $createdBy, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$ResidentSpaceModelCopyWith<$Res> implements $ResidentSpaceModelCopyWith<$Res> {
  factory _$ResidentSpaceModelCopyWith(_ResidentSpaceModel value, $Res Function(_ResidentSpaceModel) _then) = __$ResidentSpaceModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId, String estateId, String type, String label, String createdBy, DateTime? createdAt
});




}
/// @nodoc
class __$ResidentSpaceModelCopyWithImpl<$Res>
    implements _$ResidentSpaceModelCopyWith<$Res> {
  __$ResidentSpaceModelCopyWithImpl(this._self, this._then);

  final _ResidentSpaceModel _self;
  final $Res Function(_ResidentSpaceModel) _then;

/// Create a copy of ResidentSpaceModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? estateId = null,Object? type = null,Object? label = null,Object? createdBy = null,Object? createdAt = freezed,}) {
  return _then(_ResidentSpaceModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,estateId: null == estateId ? _self.estateId : estateId // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,createdBy: null == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
