// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'account_actions_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AccountActionsEffect implements DiagnosticableTreeMixin {




@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'AccountActionsEffect'))
    ;
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AccountActionsEffect);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'AccountActionsEffect()';
}


}

/// @nodoc
class $AccountActionsEffectCopyWith<$Res>  {
$AccountActionsEffectCopyWith(AccountActionsEffect _, $Res Function(AccountActionsEffect) __);
}


/// Adds pattern-matching-related methods to [AccountActionsEffect].
extension AccountActionsEffectPatterns on AccountActionsEffect {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( AccountActionsEffectOpenPaywall value)?  openPaywall,required TResult orElse(),}){
final _that = this;
switch (_that) {
case AccountActionsEffectOpenPaywall() when openPaywall != null:
return openPaywall(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( AccountActionsEffectOpenPaywall value)  openPaywall,}){
final _that = this;
switch (_that) {
case AccountActionsEffectOpenPaywall():
return openPaywall(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( AccountActionsEffectOpenPaywall value)?  openPaywall,}){
final _that = this;
switch (_that) {
case AccountActionsEffectOpenPaywall() when openPaywall != null:
return openPaywall(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  openPaywall,required TResult orElse(),}) {final _that = this;
switch (_that) {
case AccountActionsEffectOpenPaywall() when openPaywall != null:
return openPaywall();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  openPaywall,}) {final _that = this;
switch (_that) {
case AccountActionsEffectOpenPaywall():
return openPaywall();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  openPaywall,}) {final _that = this;
switch (_that) {
case AccountActionsEffectOpenPaywall() when openPaywall != null:
return openPaywall();case _:
  return null;

}
}

}

/// @nodoc


class AccountActionsEffectOpenPaywall with DiagnosticableTreeMixin implements AccountActionsEffect {
  const AccountActionsEffectOpenPaywall();
  





@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'AccountActionsEffect.openPaywall'))
    ;
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AccountActionsEffectOpenPaywall);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'AccountActionsEffect.openPaywall()';
}


}




/// @nodoc
mixin _$AccountActionsState implements DiagnosticableTreeMixin {

 AccountAction? get activeAction; String? get errorKey; String? get successKey; AccountActionsEffect? get effect;
/// Create a copy of AccountActionsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AccountActionsStateCopyWith<AccountActionsState> get copyWith => _$AccountActionsStateCopyWithImpl<AccountActionsState>(this as AccountActionsState, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'AccountActionsState'))
    ..add(DiagnosticsProperty('activeAction', activeAction))..add(DiagnosticsProperty('errorKey', errorKey))..add(DiagnosticsProperty('successKey', successKey))..add(DiagnosticsProperty('effect', effect));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AccountActionsState&&(identical(other.activeAction, activeAction) || other.activeAction == activeAction)&&(identical(other.errorKey, errorKey) || other.errorKey == errorKey)&&(identical(other.successKey, successKey) || other.successKey == successKey)&&(identical(other.effect, effect) || other.effect == effect));
}


@override
int get hashCode => Object.hash(runtimeType,activeAction,errorKey,successKey,effect);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'AccountActionsState(activeAction: $activeAction, errorKey: $errorKey, successKey: $successKey, effect: $effect)';
}


}

/// @nodoc
abstract mixin class $AccountActionsStateCopyWith<$Res>  {
  factory $AccountActionsStateCopyWith(AccountActionsState value, $Res Function(AccountActionsState) _then) = _$AccountActionsStateCopyWithImpl;
@useResult
$Res call({
 AccountAction? activeAction, String? errorKey, String? successKey, AccountActionsEffect? effect
});


$AccountActionsEffectCopyWith<$Res>? get effect;

}
/// @nodoc
class _$AccountActionsStateCopyWithImpl<$Res>
    implements $AccountActionsStateCopyWith<$Res> {
  _$AccountActionsStateCopyWithImpl(this._self, this._then);

  final AccountActionsState _self;
  final $Res Function(AccountActionsState) _then;

/// Create a copy of AccountActionsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? activeAction = freezed,Object? errorKey = freezed,Object? successKey = freezed,Object? effect = freezed,}) {
  return _then(_self.copyWith(
activeAction: freezed == activeAction ? _self.activeAction : activeAction // ignore: cast_nullable_to_non_nullable
as AccountAction?,errorKey: freezed == errorKey ? _self.errorKey : errorKey // ignore: cast_nullable_to_non_nullable
as String?,successKey: freezed == successKey ? _self.successKey : successKey // ignore: cast_nullable_to_non_nullable
as String?,effect: freezed == effect ? _self.effect : effect // ignore: cast_nullable_to_non_nullable
as AccountActionsEffect?,
  ));
}
/// Create a copy of AccountActionsState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AccountActionsEffectCopyWith<$Res>? get effect {
    if (_self.effect == null) {
    return null;
  }

  return $AccountActionsEffectCopyWith<$Res>(_self.effect!, (value) {
    return _then(_self.copyWith(effect: value));
  });
}
}


/// Adds pattern-matching-related methods to [AccountActionsState].
extension AccountActionsStatePatterns on AccountActionsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AccountActionsState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AccountActionsState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AccountActionsState value)  $default,){
final _that = this;
switch (_that) {
case _AccountActionsState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AccountActionsState value)?  $default,){
final _that = this;
switch (_that) {
case _AccountActionsState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( AccountAction? activeAction,  String? errorKey,  String? successKey,  AccountActionsEffect? effect)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AccountActionsState() when $default != null:
return $default(_that.activeAction,_that.errorKey,_that.successKey,_that.effect);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( AccountAction? activeAction,  String? errorKey,  String? successKey,  AccountActionsEffect? effect)  $default,) {final _that = this;
switch (_that) {
case _AccountActionsState():
return $default(_that.activeAction,_that.errorKey,_that.successKey,_that.effect);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( AccountAction? activeAction,  String? errorKey,  String? successKey,  AccountActionsEffect? effect)?  $default,) {final _that = this;
switch (_that) {
case _AccountActionsState() when $default != null:
return $default(_that.activeAction,_that.errorKey,_that.successKey,_that.effect);case _:
  return null;

}
}

}

/// @nodoc


class _AccountActionsState with DiagnosticableTreeMixin implements AccountActionsState {
  const _AccountActionsState({this.activeAction, this.errorKey, this.successKey, this.effect});
  

@override final  AccountAction? activeAction;
@override final  String? errorKey;
@override final  String? successKey;
@override final  AccountActionsEffect? effect;

/// Create a copy of AccountActionsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AccountActionsStateCopyWith<_AccountActionsState> get copyWith => __$AccountActionsStateCopyWithImpl<_AccountActionsState>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'AccountActionsState'))
    ..add(DiagnosticsProperty('activeAction', activeAction))..add(DiagnosticsProperty('errorKey', errorKey))..add(DiagnosticsProperty('successKey', successKey))..add(DiagnosticsProperty('effect', effect));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AccountActionsState&&(identical(other.activeAction, activeAction) || other.activeAction == activeAction)&&(identical(other.errorKey, errorKey) || other.errorKey == errorKey)&&(identical(other.successKey, successKey) || other.successKey == successKey)&&(identical(other.effect, effect) || other.effect == effect));
}


@override
int get hashCode => Object.hash(runtimeType,activeAction,errorKey,successKey,effect);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'AccountActionsState(activeAction: $activeAction, errorKey: $errorKey, successKey: $successKey, effect: $effect)';
}


}

/// @nodoc
abstract mixin class _$AccountActionsStateCopyWith<$Res> implements $AccountActionsStateCopyWith<$Res> {
  factory _$AccountActionsStateCopyWith(_AccountActionsState value, $Res Function(_AccountActionsState) _then) = __$AccountActionsStateCopyWithImpl;
@override @useResult
$Res call({
 AccountAction? activeAction, String? errorKey, String? successKey, AccountActionsEffect? effect
});


@override $AccountActionsEffectCopyWith<$Res>? get effect;

}
/// @nodoc
class __$AccountActionsStateCopyWithImpl<$Res>
    implements _$AccountActionsStateCopyWith<$Res> {
  __$AccountActionsStateCopyWithImpl(this._self, this._then);

  final _AccountActionsState _self;
  final $Res Function(_AccountActionsState) _then;

/// Create a copy of AccountActionsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? activeAction = freezed,Object? errorKey = freezed,Object? successKey = freezed,Object? effect = freezed,}) {
  return _then(_AccountActionsState(
activeAction: freezed == activeAction ? _self.activeAction : activeAction // ignore: cast_nullable_to_non_nullable
as AccountAction?,errorKey: freezed == errorKey ? _self.errorKey : errorKey // ignore: cast_nullable_to_non_nullable
as String?,successKey: freezed == successKey ? _self.successKey : successKey // ignore: cast_nullable_to_non_nullable
as String?,effect: freezed == effect ? _self.effect : effect // ignore: cast_nullable_to_non_nullable
as AccountActionsEffect?,
  ));
}

/// Create a copy of AccountActionsState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AccountActionsEffectCopyWith<$Res>? get effect {
    if (_self.effect == null) {
    return null;
  }

  return $AccountActionsEffectCopyWith<$Res>(_self.effect!, (value) {
    return _then(_self.copyWith(effect: value));
  });
}
}

// dart format on
