// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'shared_user_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SharedUserModel {

 String get id; String? get firstName;
/// Create a copy of SharedUserModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SharedUserModelCopyWith<SharedUserModel> get copyWith => _$SharedUserModelCopyWithImpl<SharedUserModel>(this as SharedUserModel, _$identity);

  /// Serializes this SharedUserModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SharedUserModel&&(identical(other.id, id) || other.id == id)&&(identical(other.firstName, firstName) || other.firstName == firstName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,firstName);

@override
String toString() {
  return 'SharedUserModel(id: $id, firstName: $firstName)';
}


}

/// @nodoc
abstract mixin class $SharedUserModelCopyWith<$Res>  {
  factory $SharedUserModelCopyWith(SharedUserModel value, $Res Function(SharedUserModel) _then) = _$SharedUserModelCopyWithImpl;
@useResult
$Res call({
 String id, String? firstName
});




}
/// @nodoc
class _$SharedUserModelCopyWithImpl<$Res>
    implements $SharedUserModelCopyWith<$Res> {
  _$SharedUserModelCopyWithImpl(this._self, this._then);

  final SharedUserModel _self;
  final $Res Function(SharedUserModel) _then;

/// Create a copy of SharedUserModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? firstName = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,firstName: freezed == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [SharedUserModel].
extension SharedUserModelPatterns on SharedUserModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SharedUserModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SharedUserModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SharedUserModel value)  $default,){
final _that = this;
switch (_that) {
case _SharedUserModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SharedUserModel value)?  $default,){
final _that = this;
switch (_that) {
case _SharedUserModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String? firstName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SharedUserModel() when $default != null:
return $default(_that.id,_that.firstName);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String? firstName)  $default,) {final _that = this;
switch (_that) {
case _SharedUserModel():
return $default(_that.id,_that.firstName);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String? firstName)?  $default,) {final _that = this;
switch (_that) {
case _SharedUserModel() when $default != null:
return $default(_that.id,_that.firstName);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _SharedUserModel extends SharedUserModel {
  const _SharedUserModel({required this.id, this.firstName}): super._();
  factory _SharedUserModel.fromJson(Map<String, dynamic> json) => _$SharedUserModelFromJson(json);

@override final  String id;
@override final  String? firstName;

/// Create a copy of SharedUserModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SharedUserModelCopyWith<_SharedUserModel> get copyWith => __$SharedUserModelCopyWithImpl<_SharedUserModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SharedUserModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SharedUserModel&&(identical(other.id, id) || other.id == id)&&(identical(other.firstName, firstName) || other.firstName == firstName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,firstName);

@override
String toString() {
  return 'SharedUserModel(id: $id, firstName: $firstName)';
}


}

/// @nodoc
abstract mixin class _$SharedUserModelCopyWith<$Res> implements $SharedUserModelCopyWith<$Res> {
  factory _$SharedUserModelCopyWith(_SharedUserModel value, $Res Function(_SharedUserModel) _then) = __$SharedUserModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String? firstName
});




}
/// @nodoc
class __$SharedUserModelCopyWithImpl<$Res>
    implements _$SharedUserModelCopyWith<$Res> {
  __$SharedUserModelCopyWithImpl(this._self, this._then);

  final _SharedUserModel _self;
  final $Res Function(_SharedUserModel) _then;

/// Create a copy of SharedUserModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? firstName = freezed,}) {
  return _then(_SharedUserModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,firstName: freezed == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
