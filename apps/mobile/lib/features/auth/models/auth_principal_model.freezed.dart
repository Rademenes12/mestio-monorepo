// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_principal_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AuthPrincipalModel {

 String get userId; String? get email; bool get isAnonymous;
/// Create a copy of AuthPrincipalModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthPrincipalModelCopyWith<AuthPrincipalModel> get copyWith => _$AuthPrincipalModelCopyWithImpl<AuthPrincipalModel>(this as AuthPrincipalModel, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthPrincipalModel&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.email, email) || other.email == email)&&(identical(other.isAnonymous, isAnonymous) || other.isAnonymous == isAnonymous));
}


@override
int get hashCode => Object.hash(runtimeType,userId,email,isAnonymous);

@override
String toString() {
  return 'AuthPrincipalModel(userId: $userId, email: $email, isAnonymous: $isAnonymous)';
}


}

/// @nodoc
abstract mixin class $AuthPrincipalModelCopyWith<$Res>  {
  factory $AuthPrincipalModelCopyWith(AuthPrincipalModel value, $Res Function(AuthPrincipalModel) _then) = _$AuthPrincipalModelCopyWithImpl;
@useResult
$Res call({
 String userId, String? email, bool isAnonymous
});




}
/// @nodoc
class _$AuthPrincipalModelCopyWithImpl<$Res>
    implements $AuthPrincipalModelCopyWith<$Res> {
  _$AuthPrincipalModelCopyWithImpl(this._self, this._then);

  final AuthPrincipalModel _self;
  final $Res Function(AuthPrincipalModel) _then;

/// Create a copy of AuthPrincipalModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = null,Object? email = freezed,Object? isAnonymous = null,}) {
  return _then(_self.copyWith(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,isAnonymous: null == isAnonymous ? _self.isAnonymous : isAnonymous // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [AuthPrincipalModel].
extension AuthPrincipalModelPatterns on AuthPrincipalModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AuthPrincipalModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AuthPrincipalModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AuthPrincipalModel value)  $default,){
final _that = this;
switch (_that) {
case _AuthPrincipalModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AuthPrincipalModel value)?  $default,){
final _that = this;
switch (_that) {
case _AuthPrincipalModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String userId,  String? email,  bool isAnonymous)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AuthPrincipalModel() when $default != null:
return $default(_that.userId,_that.email,_that.isAnonymous);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String userId,  String? email,  bool isAnonymous)  $default,) {final _that = this;
switch (_that) {
case _AuthPrincipalModel():
return $default(_that.userId,_that.email,_that.isAnonymous);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String userId,  String? email,  bool isAnonymous)?  $default,) {final _that = this;
switch (_that) {
case _AuthPrincipalModel() when $default != null:
return $default(_that.userId,_that.email,_that.isAnonymous);case _:
  return null;

}
}

}

/// @nodoc


class _AuthPrincipalModel extends AuthPrincipalModel {
  const _AuthPrincipalModel({required this.userId, required this.email, required this.isAnonymous}): super._();
  

@override final  String userId;
@override final  String? email;
@override final  bool isAnonymous;

/// Create a copy of AuthPrincipalModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AuthPrincipalModelCopyWith<_AuthPrincipalModel> get copyWith => __$AuthPrincipalModelCopyWithImpl<_AuthPrincipalModel>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AuthPrincipalModel&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.email, email) || other.email == email)&&(identical(other.isAnonymous, isAnonymous) || other.isAnonymous == isAnonymous));
}


@override
int get hashCode => Object.hash(runtimeType,userId,email,isAnonymous);

@override
String toString() {
  return 'AuthPrincipalModel(userId: $userId, email: $email, isAnonymous: $isAnonymous)';
}


}

/// @nodoc
abstract mixin class _$AuthPrincipalModelCopyWith<$Res> implements $AuthPrincipalModelCopyWith<$Res> {
  factory _$AuthPrincipalModelCopyWith(_AuthPrincipalModel value, $Res Function(_AuthPrincipalModel) _then) = __$AuthPrincipalModelCopyWithImpl;
@override @useResult
$Res call({
 String userId, String? email, bool isAnonymous
});




}
/// @nodoc
class __$AuthPrincipalModelCopyWithImpl<$Res>
    implements _$AuthPrincipalModelCopyWith<$Res> {
  __$AuthPrincipalModelCopyWithImpl(this._self, this._then);

  final _AuthPrincipalModel _self;
  final $Res Function(_AuthPrincipalModel) _then;

/// Create a copy of AuthPrincipalModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? email = freezed,Object? isAnonymous = null,}) {
  return _then(_AuthPrincipalModel(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,isAnonymous: null == isAnonymous ? _self.isAnonymous : isAnonymous // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
