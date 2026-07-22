// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'data_export_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DataExportState {

 bool get isLoading; String? get errorKey; String? get successKey;
/// Create a copy of DataExportState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DataExportStateCopyWith<DataExportState> get copyWith => _$DataExportStateCopyWithImpl<DataExportState>(this as DataExportState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DataExportState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.errorKey, errorKey) || other.errorKey == errorKey)&&(identical(other.successKey, successKey) || other.successKey == successKey));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,errorKey,successKey);

@override
String toString() {
  return 'DataExportState(isLoading: $isLoading, errorKey: $errorKey, successKey: $successKey)';
}


}

/// @nodoc
abstract mixin class $DataExportStateCopyWith<$Res>  {
  factory $DataExportStateCopyWith(DataExportState value, $Res Function(DataExportState) _then) = _$DataExportStateCopyWithImpl;
@useResult
$Res call({
 bool isLoading, String? errorKey, String? successKey
});




}
/// @nodoc
class _$DataExportStateCopyWithImpl<$Res>
    implements $DataExportStateCopyWith<$Res> {
  _$DataExportStateCopyWithImpl(this._self, this._then);

  final DataExportState _self;
  final $Res Function(DataExportState) _then;

/// Create a copy of DataExportState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isLoading = null,Object? errorKey = freezed,Object? successKey = freezed,}) {
  return _then(_self.copyWith(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,errorKey: freezed == errorKey ? _self.errorKey : errorKey // ignore: cast_nullable_to_non_nullable
as String?,successKey: freezed == successKey ? _self.successKey : successKey // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [DataExportState].
extension DataExportStatePatterns on DataExportState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DataExportState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DataExportState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DataExportState value)  $default,){
final _that = this;
switch (_that) {
case _DataExportState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DataExportState value)?  $default,){
final _that = this;
switch (_that) {
case _DataExportState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isLoading,  String? errorKey,  String? successKey)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DataExportState() when $default != null:
return $default(_that.isLoading,_that.errorKey,_that.successKey);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isLoading,  String? errorKey,  String? successKey)  $default,) {final _that = this;
switch (_that) {
case _DataExportState():
return $default(_that.isLoading,_that.errorKey,_that.successKey);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isLoading,  String? errorKey,  String? successKey)?  $default,) {final _that = this;
switch (_that) {
case _DataExportState() when $default != null:
return $default(_that.isLoading,_that.errorKey,_that.successKey);case _:
  return null;

}
}

}

/// @nodoc


class _DataExportState implements DataExportState {
  const _DataExportState({this.isLoading = false, this.errorKey, this.successKey});
  

@override@JsonKey() final  bool isLoading;
@override final  String? errorKey;
@override final  String? successKey;

/// Create a copy of DataExportState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DataExportStateCopyWith<_DataExportState> get copyWith => __$DataExportStateCopyWithImpl<_DataExportState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DataExportState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.errorKey, errorKey) || other.errorKey == errorKey)&&(identical(other.successKey, successKey) || other.successKey == successKey));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,errorKey,successKey);

@override
String toString() {
  return 'DataExportState(isLoading: $isLoading, errorKey: $errorKey, successKey: $successKey)';
}


}

/// @nodoc
abstract mixin class _$DataExportStateCopyWith<$Res> implements $DataExportStateCopyWith<$Res> {
  factory _$DataExportStateCopyWith(_DataExportState value, $Res Function(_DataExportState) _then) = __$DataExportStateCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, String? errorKey, String? successKey
});




}
/// @nodoc
class __$DataExportStateCopyWithImpl<$Res>
    implements _$DataExportStateCopyWith<$Res> {
  __$DataExportStateCopyWithImpl(this._self, this._then);

  final _DataExportState _self;
  final $Res Function(_DataExportState) _then;

/// Create a copy of DataExportState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? errorKey = freezed,Object? successKey = freezed,}) {
  return _then(_DataExportState(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,errorKey: freezed == errorKey ? _self.errorKey : errorKey // ignore: cast_nullable_to_non_nullable
as String?,successKey: freezed == successKey ? _self.successKey : successKey // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
