// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'residents_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ResidentsState implements DiagnosticableTreeMixin {




@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'ResidentsState'))
    ;
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ResidentsState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'ResidentsState()';
}


}

/// @nodoc
class $ResidentsStateCopyWith<$Res>  {
$ResidentsStateCopyWith(ResidentsState _, $Res Function(ResidentsState) __);
}


/// Adds pattern-matching-related methods to [ResidentsState].
extension ResidentsStatePatterns on ResidentsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( ResidentsInitial value)?  initial,TResult Function( ResidentsLoading value)?  loading,TResult Function( ResidentsLoaded value)?  loaded,TResult Function( ResidentsError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case ResidentsInitial() when initial != null:
return initial(_that);case ResidentsLoading() when loading != null:
return loading(_that);case ResidentsLoaded() when loaded != null:
return loaded(_that);case ResidentsError() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( ResidentsInitial value)  initial,required TResult Function( ResidentsLoading value)  loading,required TResult Function( ResidentsLoaded value)  loaded,required TResult Function( ResidentsError value)  error,}){
final _that = this;
switch (_that) {
case ResidentsInitial():
return initial(_that);case ResidentsLoading():
return loading(_that);case ResidentsLoaded():
return loaded(_that);case ResidentsError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( ResidentsInitial value)?  initial,TResult? Function( ResidentsLoading value)?  loading,TResult? Function( ResidentsLoaded value)?  loaded,TResult? Function( ResidentsError value)?  error,}){
final _that = this;
switch (_that) {
case ResidentsInitial() when initial != null:
return initial(_that);case ResidentsLoading() when loading != null:
return loading(_that);case ResidentsLoaded() when loaded != null:
return loaded(_that);case ResidentsError() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( List<ResidentModel> residents,  bool visibleToBoard)?  loaded,TResult Function( String errorKey)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case ResidentsInitial() when initial != null:
return initial();case ResidentsLoading() when loading != null:
return loading();case ResidentsLoaded() when loaded != null:
return loaded(_that.residents,_that.visibleToBoard);case ResidentsError() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( List<ResidentModel> residents,  bool visibleToBoard)  loaded,required TResult Function( String errorKey)  error,}) {final _that = this;
switch (_that) {
case ResidentsInitial():
return initial();case ResidentsLoading():
return loading();case ResidentsLoaded():
return loaded(_that.residents,_that.visibleToBoard);case ResidentsError():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( List<ResidentModel> residents,  bool visibleToBoard)?  loaded,TResult? Function( String errorKey)?  error,}) {final _that = this;
switch (_that) {
case ResidentsInitial() when initial != null:
return initial();case ResidentsLoading() when loading != null:
return loading();case ResidentsLoaded() when loaded != null:
return loaded(_that.residents,_that.visibleToBoard);case ResidentsError() when error != null:
return error(_that.errorKey);case _:
  return null;

}
}

}

/// @nodoc


class ResidentsInitial with DiagnosticableTreeMixin implements ResidentsState {
  const ResidentsInitial();
  





@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'ResidentsState.initial'))
    ;
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ResidentsInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'ResidentsState.initial()';
}


}




/// @nodoc


class ResidentsLoading with DiagnosticableTreeMixin implements ResidentsState {
  const ResidentsLoading();
  





@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'ResidentsState.loading'))
    ;
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ResidentsLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'ResidentsState.loading()';
}


}




/// @nodoc


class ResidentsLoaded with DiagnosticableTreeMixin implements ResidentsState {
  const ResidentsLoaded({required final  List<ResidentModel> residents, this.visibleToBoard = false}): _residents = residents;
  

 final  List<ResidentModel> _residents;
 List<ResidentModel> get residents {
  if (_residents is EqualUnmodifiableListView) return _residents;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_residents);
}

@JsonKey() final  bool visibleToBoard;

/// Create a copy of ResidentsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ResidentsLoadedCopyWith<ResidentsLoaded> get copyWith => _$ResidentsLoadedCopyWithImpl<ResidentsLoaded>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'ResidentsState.loaded'))
    ..add(DiagnosticsProperty('residents', residents))..add(DiagnosticsProperty('visibleToBoard', visibleToBoard));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ResidentsLoaded&&const DeepCollectionEquality().equals(other._residents, _residents)&&(identical(other.visibleToBoard, visibleToBoard) || other.visibleToBoard == visibleToBoard));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_residents),visibleToBoard);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'ResidentsState.loaded(residents: $residents, visibleToBoard: $visibleToBoard)';
}


}

/// @nodoc
abstract mixin class $ResidentsLoadedCopyWith<$Res> implements $ResidentsStateCopyWith<$Res> {
  factory $ResidentsLoadedCopyWith(ResidentsLoaded value, $Res Function(ResidentsLoaded) _then) = _$ResidentsLoadedCopyWithImpl;
@useResult
$Res call({
 List<ResidentModel> residents, bool visibleToBoard
});




}
/// @nodoc
class _$ResidentsLoadedCopyWithImpl<$Res>
    implements $ResidentsLoadedCopyWith<$Res> {
  _$ResidentsLoadedCopyWithImpl(this._self, this._then);

  final ResidentsLoaded _self;
  final $Res Function(ResidentsLoaded) _then;

/// Create a copy of ResidentsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? residents = null,Object? visibleToBoard = null,}) {
  return _then(ResidentsLoaded(
residents: null == residents ? _self._residents : residents // ignore: cast_nullable_to_non_nullable
as List<ResidentModel>,visibleToBoard: null == visibleToBoard ? _self.visibleToBoard : visibleToBoard // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class ResidentsError with DiagnosticableTreeMixin implements ResidentsState {
  const ResidentsError({required this.errorKey});
  

 final  String errorKey;

/// Create a copy of ResidentsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ResidentsErrorCopyWith<ResidentsError> get copyWith => _$ResidentsErrorCopyWithImpl<ResidentsError>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'ResidentsState.error'))
    ..add(DiagnosticsProperty('errorKey', errorKey));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ResidentsError&&(identical(other.errorKey, errorKey) || other.errorKey == errorKey));
}


@override
int get hashCode => Object.hash(runtimeType,errorKey);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'ResidentsState.error(errorKey: $errorKey)';
}


}

/// @nodoc
abstract mixin class $ResidentsErrorCopyWith<$Res> implements $ResidentsStateCopyWith<$Res> {
  factory $ResidentsErrorCopyWith(ResidentsError value, $Res Function(ResidentsError) _then) = _$ResidentsErrorCopyWithImpl;
@useResult
$Res call({
 String errorKey
});




}
/// @nodoc
class _$ResidentsErrorCopyWithImpl<$Res>
    implements $ResidentsErrorCopyWith<$Res> {
  _$ResidentsErrorCopyWithImpl(this._self, this._then);

  final ResidentsError _self;
  final $Res Function(ResidentsError) _then;

/// Create a copy of ResidentsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? errorKey = null,}) {
  return _then(ResidentsError(
errorKey: null == errorKey ? _self.errorKey : errorKey // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
