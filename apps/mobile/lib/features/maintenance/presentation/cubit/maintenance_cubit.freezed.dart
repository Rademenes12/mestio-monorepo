// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'maintenance_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MaintenanceState implements DiagnosticableTreeMixin {




@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'MaintenanceState'))
    ;
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MaintenanceState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'MaintenanceState()';
}


}

/// @nodoc
class $MaintenanceStateCopyWith<$Res>  {
$MaintenanceStateCopyWith(MaintenanceState _, $Res Function(MaintenanceState) __);
}


/// Adds pattern-matching-related methods to [MaintenanceState].
extension MaintenanceStatePatterns on MaintenanceState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( MaintenanceInitial value)?  initial,TResult Function( MaintenanceLoading value)?  loading,TResult Function( MaintenanceLoaded value)?  loaded,TResult Function( MaintenanceError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case MaintenanceInitial() when initial != null:
return initial(_that);case MaintenanceLoading() when loading != null:
return loading(_that);case MaintenanceLoaded() when loaded != null:
return loaded(_that);case MaintenanceError() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( MaintenanceInitial value)  initial,required TResult Function( MaintenanceLoading value)  loading,required TResult Function( MaintenanceLoaded value)  loaded,required TResult Function( MaintenanceError value)  error,}){
final _that = this;
switch (_that) {
case MaintenanceInitial():
return initial(_that);case MaintenanceLoading():
return loading(_that);case MaintenanceLoaded():
return loaded(_that);case MaintenanceError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( MaintenanceInitial value)?  initial,TResult? Function( MaintenanceLoading value)?  loading,TResult? Function( MaintenanceLoaded value)?  loaded,TResult? Function( MaintenanceError value)?  error,}){
final _that = this;
switch (_that) {
case MaintenanceInitial() when initial != null:
return initial(_that);case MaintenanceLoading() when loading != null:
return loading(_that);case MaintenanceLoaded() when loaded != null:
return loaded(_that);case MaintenanceError() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( List<MaintenanceSchedule> schedules,  bool isSubmitting,  String? errorKey)?  loaded,TResult Function( String errorKey)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case MaintenanceInitial() when initial != null:
return initial();case MaintenanceLoading() when loading != null:
return loading();case MaintenanceLoaded() when loaded != null:
return loaded(_that.schedules,_that.isSubmitting,_that.errorKey);case MaintenanceError() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( List<MaintenanceSchedule> schedules,  bool isSubmitting,  String? errorKey)  loaded,required TResult Function( String errorKey)  error,}) {final _that = this;
switch (_that) {
case MaintenanceInitial():
return initial();case MaintenanceLoading():
return loading();case MaintenanceLoaded():
return loaded(_that.schedules,_that.isSubmitting,_that.errorKey);case MaintenanceError():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( List<MaintenanceSchedule> schedules,  bool isSubmitting,  String? errorKey)?  loaded,TResult? Function( String errorKey)?  error,}) {final _that = this;
switch (_that) {
case MaintenanceInitial() when initial != null:
return initial();case MaintenanceLoading() when loading != null:
return loading();case MaintenanceLoaded() when loaded != null:
return loaded(_that.schedules,_that.isSubmitting,_that.errorKey);case MaintenanceError() when error != null:
return error(_that.errorKey);case _:
  return null;

}
}

}

/// @nodoc


class MaintenanceInitial with DiagnosticableTreeMixin implements MaintenanceState {
  const MaintenanceInitial();
  





@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'MaintenanceState.initial'))
    ;
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MaintenanceInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'MaintenanceState.initial()';
}


}




/// @nodoc


class MaintenanceLoading with DiagnosticableTreeMixin implements MaintenanceState {
  const MaintenanceLoading();
  





@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'MaintenanceState.loading'))
    ;
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MaintenanceLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'MaintenanceState.loading()';
}


}




/// @nodoc


class MaintenanceLoaded with DiagnosticableTreeMixin implements MaintenanceState {
  const MaintenanceLoaded({required final  List<MaintenanceSchedule> schedules, this.isSubmitting = false, this.errorKey}): _schedules = schedules;
  

 final  List<MaintenanceSchedule> _schedules;
 List<MaintenanceSchedule> get schedules {
  if (_schedules is EqualUnmodifiableListView) return _schedules;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_schedules);
}

@JsonKey() final  bool isSubmitting;
 final  String? errorKey;

/// Create a copy of MaintenanceState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MaintenanceLoadedCopyWith<MaintenanceLoaded> get copyWith => _$MaintenanceLoadedCopyWithImpl<MaintenanceLoaded>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'MaintenanceState.loaded'))
    ..add(DiagnosticsProperty('schedules', schedules))..add(DiagnosticsProperty('isSubmitting', isSubmitting))..add(DiagnosticsProperty('errorKey', errorKey));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MaintenanceLoaded&&const DeepCollectionEquality().equals(other._schedules, _schedules)&&(identical(other.isSubmitting, isSubmitting) || other.isSubmitting == isSubmitting)&&(identical(other.errorKey, errorKey) || other.errorKey == errorKey));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_schedules),isSubmitting,errorKey);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'MaintenanceState.loaded(schedules: $schedules, isSubmitting: $isSubmitting, errorKey: $errorKey)';
}


}

/// @nodoc
abstract mixin class $MaintenanceLoadedCopyWith<$Res> implements $MaintenanceStateCopyWith<$Res> {
  factory $MaintenanceLoadedCopyWith(MaintenanceLoaded value, $Res Function(MaintenanceLoaded) _then) = _$MaintenanceLoadedCopyWithImpl;
@useResult
$Res call({
 List<MaintenanceSchedule> schedules, bool isSubmitting, String? errorKey
});




}
/// @nodoc
class _$MaintenanceLoadedCopyWithImpl<$Res>
    implements $MaintenanceLoadedCopyWith<$Res> {
  _$MaintenanceLoadedCopyWithImpl(this._self, this._then);

  final MaintenanceLoaded _self;
  final $Res Function(MaintenanceLoaded) _then;

/// Create a copy of MaintenanceState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? schedules = null,Object? isSubmitting = null,Object? errorKey = freezed,}) {
  return _then(MaintenanceLoaded(
schedules: null == schedules ? _self._schedules : schedules // ignore: cast_nullable_to_non_nullable
as List<MaintenanceSchedule>,isSubmitting: null == isSubmitting ? _self.isSubmitting : isSubmitting // ignore: cast_nullable_to_non_nullable
as bool,errorKey: freezed == errorKey ? _self.errorKey : errorKey // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class MaintenanceError with DiagnosticableTreeMixin implements MaintenanceState {
  const MaintenanceError({required this.errorKey});
  

 final  String errorKey;

/// Create a copy of MaintenanceState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MaintenanceErrorCopyWith<MaintenanceError> get copyWith => _$MaintenanceErrorCopyWithImpl<MaintenanceError>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'MaintenanceState.error'))
    ..add(DiagnosticsProperty('errorKey', errorKey));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MaintenanceError&&(identical(other.errorKey, errorKey) || other.errorKey == errorKey));
}


@override
int get hashCode => Object.hash(runtimeType,errorKey);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'MaintenanceState.error(errorKey: $errorKey)';
}


}

/// @nodoc
abstract mixin class $MaintenanceErrorCopyWith<$Res> implements $MaintenanceStateCopyWith<$Res> {
  factory $MaintenanceErrorCopyWith(MaintenanceError value, $Res Function(MaintenanceError) _then) = _$MaintenanceErrorCopyWithImpl;
@useResult
$Res call({
 String errorKey
});




}
/// @nodoc
class _$MaintenanceErrorCopyWithImpl<$Res>
    implements $MaintenanceErrorCopyWith<$Res> {
  _$MaintenanceErrorCopyWithImpl(this._self, this._then);

  final MaintenanceError _self;
  final $Res Function(MaintenanceError) _then;

/// Create a copy of MaintenanceState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? errorKey = null,}) {
  return _then(MaintenanceError(
errorKey: null == errorKey ? _self.errorKey : errorKey // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
