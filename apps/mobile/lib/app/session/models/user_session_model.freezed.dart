// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_session_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$UserSessionModel {

 String get userId; String? get email; bool get isAnonymous; SharedUserModel? get sharedUser; bool get isPro;
/// Create a copy of UserSessionModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserSessionModelCopyWith<UserSessionModel> get copyWith => _$UserSessionModelCopyWithImpl<UserSessionModel>(this as UserSessionModel, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserSessionModel&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.email, email) || other.email == email)&&(identical(other.isAnonymous, isAnonymous) || other.isAnonymous == isAnonymous)&&(identical(other.sharedUser, sharedUser) || other.sharedUser == sharedUser)&&(identical(other.isPro, isPro) || other.isPro == isPro));
}


@override
int get hashCode => Object.hash(runtimeType,userId,email,isAnonymous,sharedUser,isPro);

@override
String toString() {
  return 'UserSessionModel(userId: $userId, email: $email, isAnonymous: $isAnonymous, sharedUser: $sharedUser, isPro: $isPro)';
}


}

/// @nodoc
abstract mixin class $UserSessionModelCopyWith<$Res>  {
  factory $UserSessionModelCopyWith(UserSessionModel value, $Res Function(UserSessionModel) _then) = _$UserSessionModelCopyWithImpl;
@useResult
$Res call({
 String userId, String? email, bool isAnonymous, SharedUserModel? sharedUser, bool isPro
});


$SharedUserModelCopyWith<$Res>? get sharedUser;

}
/// @nodoc
class _$UserSessionModelCopyWithImpl<$Res>
    implements $UserSessionModelCopyWith<$Res> {
  _$UserSessionModelCopyWithImpl(this._self, this._then);

  final UserSessionModel _self;
  final $Res Function(UserSessionModel) _then;

/// Create a copy of UserSessionModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = null,Object? email = freezed,Object? isAnonymous = null,Object? sharedUser = freezed,Object? isPro = null,}) {
  return _then(_self.copyWith(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,isAnonymous: null == isAnonymous ? _self.isAnonymous : isAnonymous // ignore: cast_nullable_to_non_nullable
as bool,sharedUser: freezed == sharedUser ? _self.sharedUser : sharedUser // ignore: cast_nullable_to_non_nullable
as SharedUserModel?,isPro: null == isPro ? _self.isPro : isPro // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of UserSessionModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SharedUserModelCopyWith<$Res>? get sharedUser {
    if (_self.sharedUser == null) {
    return null;
  }

  return $SharedUserModelCopyWith<$Res>(_self.sharedUser!, (value) {
    return _then(_self.copyWith(sharedUser: value));
  });
}
}


/// Adds pattern-matching-related methods to [UserSessionModel].
extension UserSessionModelPatterns on UserSessionModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserSessionModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserSessionModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserSessionModel value)  $default,){
final _that = this;
switch (_that) {
case _UserSessionModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserSessionModel value)?  $default,){
final _that = this;
switch (_that) {
case _UserSessionModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String userId,  String? email,  bool isAnonymous,  SharedUserModel? sharedUser,  bool isPro)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserSessionModel() when $default != null:
return $default(_that.userId,_that.email,_that.isAnonymous,_that.sharedUser,_that.isPro);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String userId,  String? email,  bool isAnonymous,  SharedUserModel? sharedUser,  bool isPro)  $default,) {final _that = this;
switch (_that) {
case _UserSessionModel():
return $default(_that.userId,_that.email,_that.isAnonymous,_that.sharedUser,_that.isPro);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String userId,  String? email,  bool isAnonymous,  SharedUserModel? sharedUser,  bool isPro)?  $default,) {final _that = this;
switch (_that) {
case _UserSessionModel() when $default != null:
return $default(_that.userId,_that.email,_that.isAnonymous,_that.sharedUser,_that.isPro);case _:
  return null;

}
}

}

/// @nodoc


class _UserSessionModel extends UserSessionModel {
  const _UserSessionModel({required this.userId, required this.email, required this.isAnonymous, required this.sharedUser, this.isPro = false}): super._();
  

@override final  String userId;
@override final  String? email;
@override final  bool isAnonymous;
@override final  SharedUserModel? sharedUser;
@override@JsonKey() final  bool isPro;

/// Create a copy of UserSessionModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserSessionModelCopyWith<_UserSessionModel> get copyWith => __$UserSessionModelCopyWithImpl<_UserSessionModel>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserSessionModel&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.email, email) || other.email == email)&&(identical(other.isAnonymous, isAnonymous) || other.isAnonymous == isAnonymous)&&(identical(other.sharedUser, sharedUser) || other.sharedUser == sharedUser)&&(identical(other.isPro, isPro) || other.isPro == isPro));
}


@override
int get hashCode => Object.hash(runtimeType,userId,email,isAnonymous,sharedUser,isPro);

@override
String toString() {
  return 'UserSessionModel(userId: $userId, email: $email, isAnonymous: $isAnonymous, sharedUser: $sharedUser, isPro: $isPro)';
}


}

/// @nodoc
abstract mixin class _$UserSessionModelCopyWith<$Res> implements $UserSessionModelCopyWith<$Res> {
  factory _$UserSessionModelCopyWith(_UserSessionModel value, $Res Function(_UserSessionModel) _then) = __$UserSessionModelCopyWithImpl;
@override @useResult
$Res call({
 String userId, String? email, bool isAnonymous, SharedUserModel? sharedUser, bool isPro
});


@override $SharedUserModelCopyWith<$Res>? get sharedUser;

}
/// @nodoc
class __$UserSessionModelCopyWithImpl<$Res>
    implements _$UserSessionModelCopyWith<$Res> {
  __$UserSessionModelCopyWithImpl(this._self, this._then);

  final _UserSessionModel _self;
  final $Res Function(_UserSessionModel) _then;

/// Create a copy of UserSessionModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? email = freezed,Object? isAnonymous = null,Object? sharedUser = freezed,Object? isPro = null,}) {
  return _then(_UserSessionModel(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,isAnonymous: null == isAnonymous ? _self.isAnonymous : isAnonymous // ignore: cast_nullable_to_non_nullable
as bool,sharedUser: freezed == sharedUser ? _self.sharedUser : sharedUser // ignore: cast_nullable_to_non_nullable
as SharedUserModel?,isPro: null == isPro ? _self.isPro : isPro // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of UserSessionModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SharedUserModelCopyWith<$Res>? get sharedUser {
    if (_self.sharedUser == null) {
    return null;
  }

  return $SharedUserModelCopyWith<$Res>(_self.sharedUser!, (value) {
    return _then(_self.copyWith(sharedUser: value));
  });
}
}

// dart format on
