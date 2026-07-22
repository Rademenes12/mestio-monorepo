// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'session_status_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SessionStatusModel {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SessionStatusModel);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SessionStatusModel()';
}


}

/// @nodoc
class $SessionStatusModelCopyWith<$Res>  {
$SessionStatusModelCopyWith(SessionStatusModel _, $Res Function(SessionStatusModel) __);
}


/// Adds pattern-matching-related methods to [SessionStatusModel].
extension SessionStatusModelPatterns on SessionStatusModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( SessionStatusLoading value)?  loading,TResult Function( SessionStatusUnauthenticated value)?  unauthenticated,TResult Function( SessionStatusAuthenticated value)?  authenticated,required TResult orElse(),}){
final _that = this;
switch (_that) {
case SessionStatusLoading() when loading != null:
return loading(_that);case SessionStatusUnauthenticated() when unauthenticated != null:
return unauthenticated(_that);case SessionStatusAuthenticated() when authenticated != null:
return authenticated(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( SessionStatusLoading value)  loading,required TResult Function( SessionStatusUnauthenticated value)  unauthenticated,required TResult Function( SessionStatusAuthenticated value)  authenticated,}){
final _that = this;
switch (_that) {
case SessionStatusLoading():
return loading(_that);case SessionStatusUnauthenticated():
return unauthenticated(_that);case SessionStatusAuthenticated():
return authenticated(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( SessionStatusLoading value)?  loading,TResult? Function( SessionStatusUnauthenticated value)?  unauthenticated,TResult? Function( SessionStatusAuthenticated value)?  authenticated,}){
final _that = this;
switch (_that) {
case SessionStatusLoading() when loading != null:
return loading(_that);case SessionStatusUnauthenticated() when unauthenticated != null:
return unauthenticated(_that);case SessionStatusAuthenticated() when authenticated != null:
return authenticated(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  loading,TResult Function()?  unauthenticated,TResult Function( UserSessionModel session)?  authenticated,required TResult orElse(),}) {final _that = this;
switch (_that) {
case SessionStatusLoading() when loading != null:
return loading();case SessionStatusUnauthenticated() when unauthenticated != null:
return unauthenticated();case SessionStatusAuthenticated() when authenticated != null:
return authenticated(_that.session);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  loading,required TResult Function()  unauthenticated,required TResult Function( UserSessionModel session)  authenticated,}) {final _that = this;
switch (_that) {
case SessionStatusLoading():
return loading();case SessionStatusUnauthenticated():
return unauthenticated();case SessionStatusAuthenticated():
return authenticated(_that.session);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  loading,TResult? Function()?  unauthenticated,TResult? Function( UserSessionModel session)?  authenticated,}) {final _that = this;
switch (_that) {
case SessionStatusLoading() when loading != null:
return loading();case SessionStatusUnauthenticated() when unauthenticated != null:
return unauthenticated();case SessionStatusAuthenticated() when authenticated != null:
return authenticated(_that.session);case _:
  return null;

}
}

}

/// @nodoc


class SessionStatusLoading implements SessionStatusModel {
  const SessionStatusLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SessionStatusLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SessionStatusModel.loading()';
}


}




/// @nodoc


class SessionStatusUnauthenticated implements SessionStatusModel {
  const SessionStatusUnauthenticated();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SessionStatusUnauthenticated);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SessionStatusModel.unauthenticated()';
}


}




/// @nodoc


class SessionStatusAuthenticated implements SessionStatusModel {
  const SessionStatusAuthenticated({required this.session});
  

 final  UserSessionModel session;

/// Create a copy of SessionStatusModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SessionStatusAuthenticatedCopyWith<SessionStatusAuthenticated> get copyWith => _$SessionStatusAuthenticatedCopyWithImpl<SessionStatusAuthenticated>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SessionStatusAuthenticated&&(identical(other.session, session) || other.session == session));
}


@override
int get hashCode => Object.hash(runtimeType,session);

@override
String toString() {
  return 'SessionStatusModel.authenticated(session: $session)';
}


}

/// @nodoc
abstract mixin class $SessionStatusAuthenticatedCopyWith<$Res> implements $SessionStatusModelCopyWith<$Res> {
  factory $SessionStatusAuthenticatedCopyWith(SessionStatusAuthenticated value, $Res Function(SessionStatusAuthenticated) _then) = _$SessionStatusAuthenticatedCopyWithImpl;
@useResult
$Res call({
 UserSessionModel session
});


$UserSessionModelCopyWith<$Res> get session;

}
/// @nodoc
class _$SessionStatusAuthenticatedCopyWithImpl<$Res>
    implements $SessionStatusAuthenticatedCopyWith<$Res> {
  _$SessionStatusAuthenticatedCopyWithImpl(this._self, this._then);

  final SessionStatusAuthenticated _self;
  final $Res Function(SessionStatusAuthenticated) _then;

/// Create a copy of SessionStatusModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? session = null,}) {
  return _then(SessionStatusAuthenticated(
session: null == session ? _self.session : session // ignore: cast_nullable_to_non_nullable
as UserSessionModel,
  ));
}

/// Create a copy of SessionStatusModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserSessionModelCopyWith<$Res> get session {
  
  return $UserSessionModelCopyWith<$Res>(_self.session, (value) {
    return _then(_self.copyWith(session: value));
  });
}
}

// dart format on
