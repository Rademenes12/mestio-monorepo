// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'delete_account_preflight_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DeleteAccountPreflightState implements DiagnosticableTreeMixin {




@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'DeleteAccountPreflightState'))
    ;
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DeleteAccountPreflightState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'DeleteAccountPreflightState()';
}


}

/// @nodoc
class $DeleteAccountPreflightStateCopyWith<$Res>  {
$DeleteAccountPreflightStateCopyWith(DeleteAccountPreflightState _, $Res Function(DeleteAccountPreflightState) __);
}


/// Adds pattern-matching-related methods to [DeleteAccountPreflightState].
extension DeleteAccountPreflightStatePatterns on DeleteAccountPreflightState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( DeleteAccountPreflightLoading value)?  loading,TResult Function( DeleteAccountPreflightLoaded value)?  loaded,TResult Function( DeleteAccountPreflightError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case DeleteAccountPreflightLoading() when loading != null:
return loading(_that);case DeleteAccountPreflightLoaded() when loaded != null:
return loaded(_that);case DeleteAccountPreflightError() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( DeleteAccountPreflightLoading value)  loading,required TResult Function( DeleteAccountPreflightLoaded value)  loaded,required TResult Function( DeleteAccountPreflightError value)  error,}){
final _that = this;
switch (_that) {
case DeleteAccountPreflightLoading():
return loading(_that);case DeleteAccountPreflightLoaded():
return loaded(_that);case DeleteAccountPreflightError():
return error(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( DeleteAccountPreflightLoading value)?  loading,TResult? Function( DeleteAccountPreflightLoaded value)?  loaded,TResult? Function( DeleteAccountPreflightError value)?  error,}){
final _that = this;
switch (_that) {
case DeleteAccountPreflightLoading() when loading != null:
return loading(_that);case DeleteAccountPreflightLoaded() when loaded != null:
return loaded(_that);case DeleteAccountPreflightError() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  loading,TResult Function( List<SharedUserAppModel> otherApps)?  loaded,TResult Function( String errorKey)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case DeleteAccountPreflightLoading() when loading != null:
return loading();case DeleteAccountPreflightLoaded() when loaded != null:
return loaded(_that.otherApps);case DeleteAccountPreflightError() when error != null:
return error(_that.errorKey);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  loading,required TResult Function( List<SharedUserAppModel> otherApps)  loaded,required TResult Function( String errorKey)  error,}) {final _that = this;
switch (_that) {
case DeleteAccountPreflightLoading():
return loading();case DeleteAccountPreflightLoaded():
return loaded(_that.otherApps);case DeleteAccountPreflightError():
return error(_that.errorKey);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  loading,TResult? Function( List<SharedUserAppModel> otherApps)?  loaded,TResult? Function( String errorKey)?  error,}) {final _that = this;
switch (_that) {
case DeleteAccountPreflightLoading() when loading != null:
return loading();case DeleteAccountPreflightLoaded() when loaded != null:
return loaded(_that.otherApps);case DeleteAccountPreflightError() when error != null:
return error(_that.errorKey);case _:
  return null;

}
}

}

/// @nodoc


class DeleteAccountPreflightLoading with DiagnosticableTreeMixin implements DeleteAccountPreflightState {
  const DeleteAccountPreflightLoading();
  





@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'DeleteAccountPreflightState.loading'))
    ;
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DeleteAccountPreflightLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'DeleteAccountPreflightState.loading()';
}


}




/// @nodoc


class DeleteAccountPreflightLoaded with DiagnosticableTreeMixin implements DeleteAccountPreflightState {
  const DeleteAccountPreflightLoaded({required final  List<SharedUserAppModel> otherApps}): _otherApps = otherApps;
  

 final  List<SharedUserAppModel> _otherApps;
 List<SharedUserAppModel> get otherApps {
  if (_otherApps is EqualUnmodifiableListView) return _otherApps;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_otherApps);
}


/// Create a copy of DeleteAccountPreflightState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DeleteAccountPreflightLoadedCopyWith<DeleteAccountPreflightLoaded> get copyWith => _$DeleteAccountPreflightLoadedCopyWithImpl<DeleteAccountPreflightLoaded>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'DeleteAccountPreflightState.loaded'))
    ..add(DiagnosticsProperty('otherApps', otherApps));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DeleteAccountPreflightLoaded&&const DeepCollectionEquality().equals(other._otherApps, _otherApps));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_otherApps));

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'DeleteAccountPreflightState.loaded(otherApps: $otherApps)';
}


}

/// @nodoc
abstract mixin class $DeleteAccountPreflightLoadedCopyWith<$Res> implements $DeleteAccountPreflightStateCopyWith<$Res> {
  factory $DeleteAccountPreflightLoadedCopyWith(DeleteAccountPreflightLoaded value, $Res Function(DeleteAccountPreflightLoaded) _then) = _$DeleteAccountPreflightLoadedCopyWithImpl;
@useResult
$Res call({
 List<SharedUserAppModel> otherApps
});




}
/// @nodoc
class _$DeleteAccountPreflightLoadedCopyWithImpl<$Res>
    implements $DeleteAccountPreflightLoadedCopyWith<$Res> {
  _$DeleteAccountPreflightLoadedCopyWithImpl(this._self, this._then);

  final DeleteAccountPreflightLoaded _self;
  final $Res Function(DeleteAccountPreflightLoaded) _then;

/// Create a copy of DeleteAccountPreflightState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? otherApps = null,}) {
  return _then(DeleteAccountPreflightLoaded(
otherApps: null == otherApps ? _self._otherApps : otherApps // ignore: cast_nullable_to_non_nullable
as List<SharedUserAppModel>,
  ));
}


}

/// @nodoc


class DeleteAccountPreflightError with DiagnosticableTreeMixin implements DeleteAccountPreflightState {
  const DeleteAccountPreflightError({required this.errorKey});
  

 final  String errorKey;

/// Create a copy of DeleteAccountPreflightState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DeleteAccountPreflightErrorCopyWith<DeleteAccountPreflightError> get copyWith => _$DeleteAccountPreflightErrorCopyWithImpl<DeleteAccountPreflightError>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'DeleteAccountPreflightState.error'))
    ..add(DiagnosticsProperty('errorKey', errorKey));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DeleteAccountPreflightError&&(identical(other.errorKey, errorKey) || other.errorKey == errorKey));
}


@override
int get hashCode => Object.hash(runtimeType,errorKey);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'DeleteAccountPreflightState.error(errorKey: $errorKey)';
}


}

/// @nodoc
abstract mixin class $DeleteAccountPreflightErrorCopyWith<$Res> implements $DeleteAccountPreflightStateCopyWith<$Res> {
  factory $DeleteAccountPreflightErrorCopyWith(DeleteAccountPreflightError value, $Res Function(DeleteAccountPreflightError) _then) = _$DeleteAccountPreflightErrorCopyWithImpl;
@useResult
$Res call({
 String errorKey
});




}
/// @nodoc
class _$DeleteAccountPreflightErrorCopyWithImpl<$Res>
    implements $DeleteAccountPreflightErrorCopyWith<$Res> {
  _$DeleteAccountPreflightErrorCopyWithImpl(this._self, this._then);

  final DeleteAccountPreflightError _self;
  final $Res Function(DeleteAccountPreflightError) _then;

/// Create a copy of DeleteAccountPreflightState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? errorKey = null,}) {
  return _then(DeleteAccountPreflightError(
errorKey: null == errorKey ? _self.errorKey : errorKey // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
