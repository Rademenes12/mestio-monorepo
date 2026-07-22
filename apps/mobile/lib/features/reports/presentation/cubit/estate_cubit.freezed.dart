// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'estate_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$EstateState implements DiagnosticableTreeMixin {




@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'EstateState'))
    ;
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EstateState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'EstateState()';
}


}

/// @nodoc
class $EstateStateCopyWith<$Res>  {
$EstateStateCopyWith(EstateState _, $Res Function(EstateState) __);
}


/// Adds pattern-matching-related methods to [EstateState].
extension EstateStatePatterns on EstateState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( EstateInitial value)?  initial,TResult Function( EstateLoading value)?  loading,TResult Function( EstateLoaded value)?  loaded,TResult Function( EstateError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case EstateInitial() when initial != null:
return initial(_that);case EstateLoading() when loading != null:
return loading(_that);case EstateLoaded() when loaded != null:
return loaded(_that);case EstateError() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( EstateInitial value)  initial,required TResult Function( EstateLoading value)  loading,required TResult Function( EstateLoaded value)  loaded,required TResult Function( EstateError value)  error,}){
final _that = this;
switch (_that) {
case EstateInitial():
return initial(_that);case EstateLoading():
return loading(_that);case EstateLoaded():
return loaded(_that);case EstateError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( EstateInitial value)?  initial,TResult? Function( EstateLoading value)?  loading,TResult? Function( EstateLoaded value)?  loaded,TResult? Function( EstateError value)?  error,}){
final _that = this;
switch (_that) {
case EstateInitial() when initial != null:
return initial(_that);case EstateLoading() when loading != null:
return loading(_that);case EstateLoaded() when loaded != null:
return loaded(_that);case EstateError() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( List<BuildingWithStairwells> buildings,  bool isSubmitting,  String? errorKey)?  loaded,TResult Function( String errorKey)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case EstateInitial() when initial != null:
return initial();case EstateLoading() when loading != null:
return loading();case EstateLoaded() when loaded != null:
return loaded(_that.buildings,_that.isSubmitting,_that.errorKey);case EstateError() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( List<BuildingWithStairwells> buildings,  bool isSubmitting,  String? errorKey)  loaded,required TResult Function( String errorKey)  error,}) {final _that = this;
switch (_that) {
case EstateInitial():
return initial();case EstateLoading():
return loading();case EstateLoaded():
return loaded(_that.buildings,_that.isSubmitting,_that.errorKey);case EstateError():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( List<BuildingWithStairwells> buildings,  bool isSubmitting,  String? errorKey)?  loaded,TResult? Function( String errorKey)?  error,}) {final _that = this;
switch (_that) {
case EstateInitial() when initial != null:
return initial();case EstateLoading() when loading != null:
return loading();case EstateLoaded() when loaded != null:
return loaded(_that.buildings,_that.isSubmitting,_that.errorKey);case EstateError() when error != null:
return error(_that.errorKey);case _:
  return null;

}
}

}

/// @nodoc


class EstateInitial with DiagnosticableTreeMixin implements EstateState {
  const EstateInitial();
  





@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'EstateState.initial'))
    ;
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EstateInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'EstateState.initial()';
}


}




/// @nodoc


class EstateLoading with DiagnosticableTreeMixin implements EstateState {
  const EstateLoading();
  





@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'EstateState.loading'))
    ;
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EstateLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'EstateState.loading()';
}


}




/// @nodoc


class EstateLoaded with DiagnosticableTreeMixin implements EstateState {
  const EstateLoaded({required final  List<BuildingWithStairwells> buildings, this.isSubmitting = false, this.errorKey}): _buildings = buildings;
  

 final  List<BuildingWithStairwells> _buildings;
 List<BuildingWithStairwells> get buildings {
  if (_buildings is EqualUnmodifiableListView) return _buildings;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_buildings);
}

@JsonKey() final  bool isSubmitting;
 final  String? errorKey;

/// Create a copy of EstateState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EstateLoadedCopyWith<EstateLoaded> get copyWith => _$EstateLoadedCopyWithImpl<EstateLoaded>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'EstateState.loaded'))
    ..add(DiagnosticsProperty('buildings', buildings))..add(DiagnosticsProperty('isSubmitting', isSubmitting))..add(DiagnosticsProperty('errorKey', errorKey));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EstateLoaded&&const DeepCollectionEquality().equals(other._buildings, _buildings)&&(identical(other.isSubmitting, isSubmitting) || other.isSubmitting == isSubmitting)&&(identical(other.errorKey, errorKey) || other.errorKey == errorKey));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_buildings),isSubmitting,errorKey);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'EstateState.loaded(buildings: $buildings, isSubmitting: $isSubmitting, errorKey: $errorKey)';
}


}

/// @nodoc
abstract mixin class $EstateLoadedCopyWith<$Res> implements $EstateStateCopyWith<$Res> {
  factory $EstateLoadedCopyWith(EstateLoaded value, $Res Function(EstateLoaded) _then) = _$EstateLoadedCopyWithImpl;
@useResult
$Res call({
 List<BuildingWithStairwells> buildings, bool isSubmitting, String? errorKey
});




}
/// @nodoc
class _$EstateLoadedCopyWithImpl<$Res>
    implements $EstateLoadedCopyWith<$Res> {
  _$EstateLoadedCopyWithImpl(this._self, this._then);

  final EstateLoaded _self;
  final $Res Function(EstateLoaded) _then;

/// Create a copy of EstateState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? buildings = null,Object? isSubmitting = null,Object? errorKey = freezed,}) {
  return _then(EstateLoaded(
buildings: null == buildings ? _self._buildings : buildings // ignore: cast_nullable_to_non_nullable
as List<BuildingWithStairwells>,isSubmitting: null == isSubmitting ? _self.isSubmitting : isSubmitting // ignore: cast_nullable_to_non_nullable
as bool,errorKey: freezed == errorKey ? _self.errorKey : errorKey // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class EstateError with DiagnosticableTreeMixin implements EstateState {
  const EstateError({required this.errorKey});
  

 final  String errorKey;

/// Create a copy of EstateState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EstateErrorCopyWith<EstateError> get copyWith => _$EstateErrorCopyWithImpl<EstateError>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'EstateState.error'))
    ..add(DiagnosticsProperty('errorKey', errorKey));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EstateError&&(identical(other.errorKey, errorKey) || other.errorKey == errorKey));
}


@override
int get hashCode => Object.hash(runtimeType,errorKey);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'EstateState.error(errorKey: $errorKey)';
}


}

/// @nodoc
abstract mixin class $EstateErrorCopyWith<$Res> implements $EstateStateCopyWith<$Res> {
  factory $EstateErrorCopyWith(EstateError value, $Res Function(EstateError) _then) = _$EstateErrorCopyWithImpl;
@useResult
$Res call({
 String errorKey
});




}
/// @nodoc
class _$EstateErrorCopyWithImpl<$Res>
    implements $EstateErrorCopyWith<$Res> {
  _$EstateErrorCopyWithImpl(this._self, this._then);

  final EstateError _self;
  final $Res Function(EstateError) _then;

/// Create a copy of EstateState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? errorKey = null,}) {
  return _then(EstateError(
errorKey: null == errorKey ? _self.errorKey : errorKey // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
