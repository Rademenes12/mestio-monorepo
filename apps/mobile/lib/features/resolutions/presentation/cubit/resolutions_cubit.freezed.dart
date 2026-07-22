// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'resolutions_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ResolutionsState implements DiagnosticableTreeMixin {




@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'ResolutionsState'))
    ;
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ResolutionsState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'ResolutionsState()';
}


}

/// @nodoc
class $ResolutionsStateCopyWith<$Res>  {
$ResolutionsStateCopyWith(ResolutionsState _, $Res Function(ResolutionsState) __);
}


/// Adds pattern-matching-related methods to [ResolutionsState].
extension ResolutionsStatePatterns on ResolutionsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( ResolutionsInitial value)?  initial,TResult Function( ResolutionsLoading value)?  loading,TResult Function( ResolutionsLoaded value)?  loaded,TResult Function( ResolutionsError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case ResolutionsInitial() when initial != null:
return initial(_that);case ResolutionsLoading() when loading != null:
return loading(_that);case ResolutionsLoaded() when loaded != null:
return loaded(_that);case ResolutionsError() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( ResolutionsInitial value)  initial,required TResult Function( ResolutionsLoading value)  loading,required TResult Function( ResolutionsLoaded value)  loaded,required TResult Function( ResolutionsError value)  error,}){
final _that = this;
switch (_that) {
case ResolutionsInitial():
return initial(_that);case ResolutionsLoading():
return loading(_that);case ResolutionsLoaded():
return loaded(_that);case ResolutionsError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( ResolutionsInitial value)?  initial,TResult? Function( ResolutionsLoading value)?  loading,TResult? Function( ResolutionsLoaded value)?  loaded,TResult? Function( ResolutionsError value)?  error,}){
final _that = this;
switch (_that) {
case ResolutionsInitial() when initial != null:
return initial(_that);case ResolutionsLoading() when loading != null:
return loading(_that);case ResolutionsLoaded() when loaded != null:
return loaded(_that);case ResolutionsError() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( List<Resolution> resolutions,  bool isSubmitting,  String? errorKey)?  loaded,TResult Function( String errorKey)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case ResolutionsInitial() when initial != null:
return initial();case ResolutionsLoading() when loading != null:
return loading();case ResolutionsLoaded() when loaded != null:
return loaded(_that.resolutions,_that.isSubmitting,_that.errorKey);case ResolutionsError() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( List<Resolution> resolutions,  bool isSubmitting,  String? errorKey)  loaded,required TResult Function( String errorKey)  error,}) {final _that = this;
switch (_that) {
case ResolutionsInitial():
return initial();case ResolutionsLoading():
return loading();case ResolutionsLoaded():
return loaded(_that.resolutions,_that.isSubmitting,_that.errorKey);case ResolutionsError():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( List<Resolution> resolutions,  bool isSubmitting,  String? errorKey)?  loaded,TResult? Function( String errorKey)?  error,}) {final _that = this;
switch (_that) {
case ResolutionsInitial() when initial != null:
return initial();case ResolutionsLoading() when loading != null:
return loading();case ResolutionsLoaded() when loaded != null:
return loaded(_that.resolutions,_that.isSubmitting,_that.errorKey);case ResolutionsError() when error != null:
return error(_that.errorKey);case _:
  return null;

}
}

}

/// @nodoc


class ResolutionsInitial with DiagnosticableTreeMixin implements ResolutionsState {
  const ResolutionsInitial();
  





@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'ResolutionsState.initial'))
    ;
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ResolutionsInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'ResolutionsState.initial()';
}


}




/// @nodoc


class ResolutionsLoading with DiagnosticableTreeMixin implements ResolutionsState {
  const ResolutionsLoading();
  





@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'ResolutionsState.loading'))
    ;
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ResolutionsLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'ResolutionsState.loading()';
}


}




/// @nodoc


class ResolutionsLoaded with DiagnosticableTreeMixin implements ResolutionsState {
  const ResolutionsLoaded({required final  List<Resolution> resolutions, this.isSubmitting = false, this.errorKey}): _resolutions = resolutions;
  

 final  List<Resolution> _resolutions;
 List<Resolution> get resolutions {
  if (_resolutions is EqualUnmodifiableListView) return _resolutions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_resolutions);
}

@JsonKey() final  bool isSubmitting;
 final  String? errorKey;

/// Create a copy of ResolutionsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ResolutionsLoadedCopyWith<ResolutionsLoaded> get copyWith => _$ResolutionsLoadedCopyWithImpl<ResolutionsLoaded>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'ResolutionsState.loaded'))
    ..add(DiagnosticsProperty('resolutions', resolutions))..add(DiagnosticsProperty('isSubmitting', isSubmitting))..add(DiagnosticsProperty('errorKey', errorKey));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ResolutionsLoaded&&const DeepCollectionEquality().equals(other._resolutions, _resolutions)&&(identical(other.isSubmitting, isSubmitting) || other.isSubmitting == isSubmitting)&&(identical(other.errorKey, errorKey) || other.errorKey == errorKey));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_resolutions),isSubmitting,errorKey);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'ResolutionsState.loaded(resolutions: $resolutions, isSubmitting: $isSubmitting, errorKey: $errorKey)';
}


}

/// @nodoc
abstract mixin class $ResolutionsLoadedCopyWith<$Res> implements $ResolutionsStateCopyWith<$Res> {
  factory $ResolutionsLoadedCopyWith(ResolutionsLoaded value, $Res Function(ResolutionsLoaded) _then) = _$ResolutionsLoadedCopyWithImpl;
@useResult
$Res call({
 List<Resolution> resolutions, bool isSubmitting, String? errorKey
});




}
/// @nodoc
class _$ResolutionsLoadedCopyWithImpl<$Res>
    implements $ResolutionsLoadedCopyWith<$Res> {
  _$ResolutionsLoadedCopyWithImpl(this._self, this._then);

  final ResolutionsLoaded _self;
  final $Res Function(ResolutionsLoaded) _then;

/// Create a copy of ResolutionsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? resolutions = null,Object? isSubmitting = null,Object? errorKey = freezed,}) {
  return _then(ResolutionsLoaded(
resolutions: null == resolutions ? _self._resolutions : resolutions // ignore: cast_nullable_to_non_nullable
as List<Resolution>,isSubmitting: null == isSubmitting ? _self.isSubmitting : isSubmitting // ignore: cast_nullable_to_non_nullable
as bool,errorKey: freezed == errorKey ? _self.errorKey : errorKey // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class ResolutionsError with DiagnosticableTreeMixin implements ResolutionsState {
  const ResolutionsError({required this.errorKey});
  

 final  String errorKey;

/// Create a copy of ResolutionsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ResolutionsErrorCopyWith<ResolutionsError> get copyWith => _$ResolutionsErrorCopyWithImpl<ResolutionsError>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'ResolutionsState.error'))
    ..add(DiagnosticsProperty('errorKey', errorKey));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ResolutionsError&&(identical(other.errorKey, errorKey) || other.errorKey == errorKey));
}


@override
int get hashCode => Object.hash(runtimeType,errorKey);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'ResolutionsState.error(errorKey: $errorKey)';
}


}

/// @nodoc
abstract mixin class $ResolutionsErrorCopyWith<$Res> implements $ResolutionsStateCopyWith<$Res> {
  factory $ResolutionsErrorCopyWith(ResolutionsError value, $Res Function(ResolutionsError) _then) = _$ResolutionsErrorCopyWithImpl;
@useResult
$Res call({
 String errorKey
});




}
/// @nodoc
class _$ResolutionsErrorCopyWithImpl<$Res>
    implements $ResolutionsErrorCopyWith<$Res> {
  _$ResolutionsErrorCopyWithImpl(this._self, this._then);

  final ResolutionsError _self;
  final $Res Function(ResolutionsError) _then;

/// Create a copy of ResolutionsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? errorKey = null,}) {
  return _then(ResolutionsError(
errorKey: null == errorKey ? _self.errorKey : errorKey // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
