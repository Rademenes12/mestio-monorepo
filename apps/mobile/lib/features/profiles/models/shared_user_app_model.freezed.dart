// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'shared_user_app_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SharedUserAppModel {

 String get appId; String get appName; DateTime get lastSeenAt;
/// Create a copy of SharedUserAppModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SharedUserAppModelCopyWith<SharedUserAppModel> get copyWith => _$SharedUserAppModelCopyWithImpl<SharedUserAppModel>(this as SharedUserAppModel, _$identity);

  /// Serializes this SharedUserAppModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SharedUserAppModel&&(identical(other.appId, appId) || other.appId == appId)&&(identical(other.appName, appName) || other.appName == appName)&&(identical(other.lastSeenAt, lastSeenAt) || other.lastSeenAt == lastSeenAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,appId,appName,lastSeenAt);

@override
String toString() {
  return 'SharedUserAppModel(appId: $appId, appName: $appName, lastSeenAt: $lastSeenAt)';
}


}

/// @nodoc
abstract mixin class $SharedUserAppModelCopyWith<$Res>  {
  factory $SharedUserAppModelCopyWith(SharedUserAppModel value, $Res Function(SharedUserAppModel) _then) = _$SharedUserAppModelCopyWithImpl;
@useResult
$Res call({
 String appId, String appName, DateTime lastSeenAt
});




}
/// @nodoc
class _$SharedUserAppModelCopyWithImpl<$Res>
    implements $SharedUserAppModelCopyWith<$Res> {
  _$SharedUserAppModelCopyWithImpl(this._self, this._then);

  final SharedUserAppModel _self;
  final $Res Function(SharedUserAppModel) _then;

/// Create a copy of SharedUserAppModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? appId = null,Object? appName = null,Object? lastSeenAt = null,}) {
  return _then(_self.copyWith(
appId: null == appId ? _self.appId : appId // ignore: cast_nullable_to_non_nullable
as String,appName: null == appName ? _self.appName : appName // ignore: cast_nullable_to_non_nullable
as String,lastSeenAt: null == lastSeenAt ? _self.lastSeenAt : lastSeenAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [SharedUserAppModel].
extension SharedUserAppModelPatterns on SharedUserAppModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SharedUserAppModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SharedUserAppModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SharedUserAppModel value)  $default,){
final _that = this;
switch (_that) {
case _SharedUserAppModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SharedUserAppModel value)?  $default,){
final _that = this;
switch (_that) {
case _SharedUserAppModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String appId,  String appName,  DateTime lastSeenAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SharedUserAppModel() when $default != null:
return $default(_that.appId,_that.appName,_that.lastSeenAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String appId,  String appName,  DateTime lastSeenAt)  $default,) {final _that = this;
switch (_that) {
case _SharedUserAppModel():
return $default(_that.appId,_that.appName,_that.lastSeenAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String appId,  String appName,  DateTime lastSeenAt)?  $default,) {final _that = this;
switch (_that) {
case _SharedUserAppModel() when $default != null:
return $default(_that.appId,_that.appName,_that.lastSeenAt);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _SharedUserAppModel extends SharedUserAppModel {
  const _SharedUserAppModel({required this.appId, required this.appName, required this.lastSeenAt}): super._();
  factory _SharedUserAppModel.fromJson(Map<String, dynamic> json) => _$SharedUserAppModelFromJson(json);

@override final  String appId;
@override final  String appName;
@override final  DateTime lastSeenAt;

/// Create a copy of SharedUserAppModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SharedUserAppModelCopyWith<_SharedUserAppModel> get copyWith => __$SharedUserAppModelCopyWithImpl<_SharedUserAppModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SharedUserAppModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SharedUserAppModel&&(identical(other.appId, appId) || other.appId == appId)&&(identical(other.appName, appName) || other.appName == appName)&&(identical(other.lastSeenAt, lastSeenAt) || other.lastSeenAt == lastSeenAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,appId,appName,lastSeenAt);

@override
String toString() {
  return 'SharedUserAppModel(appId: $appId, appName: $appName, lastSeenAt: $lastSeenAt)';
}


}

/// @nodoc
abstract mixin class _$SharedUserAppModelCopyWith<$Res> implements $SharedUserAppModelCopyWith<$Res> {
  factory _$SharedUserAppModelCopyWith(_SharedUserAppModel value, $Res Function(_SharedUserAppModel) _then) = __$SharedUserAppModelCopyWithImpl;
@override @useResult
$Res call({
 String appId, String appName, DateTime lastSeenAt
});




}
/// @nodoc
class __$SharedUserAppModelCopyWithImpl<$Res>
    implements _$SharedUserAppModelCopyWith<$Res> {
  __$SharedUserAppModelCopyWithImpl(this._self, this._then);

  final _SharedUserAppModel _self;
  final $Res Function(_SharedUserAppModel) _then;

/// Create a copy of SharedUserAppModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? appId = null,Object? appName = null,Object? lastSeenAt = null,}) {
  return _then(_SharedUserAppModel(
appId: null == appId ? _self.appId : appId // ignore: cast_nullable_to_non_nullable
as String,appName: null == appName ? _self.appName : appName // ignore: cast_nullable_to_non_nullable
as String,lastSeenAt: null == lastSeenAt ? _self.lastSeenAt : lastSeenAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
