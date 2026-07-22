// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'report_comments_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ReportCommentsState implements DiagnosticableTreeMixin {




@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'ReportCommentsState'))
    ;
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReportCommentsState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'ReportCommentsState()';
}


}

/// @nodoc
class $ReportCommentsStateCopyWith<$Res>  {
$ReportCommentsStateCopyWith(ReportCommentsState _, $Res Function(ReportCommentsState) __);
}


/// Adds pattern-matching-related methods to [ReportCommentsState].
extension ReportCommentsStatePatterns on ReportCommentsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( ReportCommentsInitial value)?  initial,TResult Function( ReportCommentsLoading value)?  loading,TResult Function( ReportCommentsLoaded value)?  loaded,TResult Function( ReportCommentsError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case ReportCommentsInitial() when initial != null:
return initial(_that);case ReportCommentsLoading() when loading != null:
return loading(_that);case ReportCommentsLoaded() when loaded != null:
return loaded(_that);case ReportCommentsError() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( ReportCommentsInitial value)  initial,required TResult Function( ReportCommentsLoading value)  loading,required TResult Function( ReportCommentsLoaded value)  loaded,required TResult Function( ReportCommentsError value)  error,}){
final _that = this;
switch (_that) {
case ReportCommentsInitial():
return initial(_that);case ReportCommentsLoading():
return loading(_that);case ReportCommentsLoaded():
return loaded(_that);case ReportCommentsError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( ReportCommentsInitial value)?  initial,TResult? Function( ReportCommentsLoading value)?  loading,TResult? Function( ReportCommentsLoaded value)?  loaded,TResult? Function( ReportCommentsError value)?  error,}){
final _that = this;
switch (_that) {
case ReportCommentsInitial() when initial != null:
return initial(_that);case ReportCommentsLoading() when loading != null:
return loading(_that);case ReportCommentsLoaded() when loaded != null:
return loaded(_that);case ReportCommentsError() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( List<ReportComment> comments,  bool isSubmitting,  String? errorKey)?  loaded,TResult Function( String errorKey)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case ReportCommentsInitial() when initial != null:
return initial();case ReportCommentsLoading() when loading != null:
return loading();case ReportCommentsLoaded() when loaded != null:
return loaded(_that.comments,_that.isSubmitting,_that.errorKey);case ReportCommentsError() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( List<ReportComment> comments,  bool isSubmitting,  String? errorKey)  loaded,required TResult Function( String errorKey)  error,}) {final _that = this;
switch (_that) {
case ReportCommentsInitial():
return initial();case ReportCommentsLoading():
return loading();case ReportCommentsLoaded():
return loaded(_that.comments,_that.isSubmitting,_that.errorKey);case ReportCommentsError():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( List<ReportComment> comments,  bool isSubmitting,  String? errorKey)?  loaded,TResult? Function( String errorKey)?  error,}) {final _that = this;
switch (_that) {
case ReportCommentsInitial() when initial != null:
return initial();case ReportCommentsLoading() when loading != null:
return loading();case ReportCommentsLoaded() when loaded != null:
return loaded(_that.comments,_that.isSubmitting,_that.errorKey);case ReportCommentsError() when error != null:
return error(_that.errorKey);case _:
  return null;

}
}

}

/// @nodoc


class ReportCommentsInitial with DiagnosticableTreeMixin implements ReportCommentsState {
  const ReportCommentsInitial();
  





@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'ReportCommentsState.initial'))
    ;
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReportCommentsInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'ReportCommentsState.initial()';
}


}




/// @nodoc


class ReportCommentsLoading with DiagnosticableTreeMixin implements ReportCommentsState {
  const ReportCommentsLoading();
  





@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'ReportCommentsState.loading'))
    ;
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReportCommentsLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'ReportCommentsState.loading()';
}


}




/// @nodoc


class ReportCommentsLoaded with DiagnosticableTreeMixin implements ReportCommentsState {
  const ReportCommentsLoaded({required final  List<ReportComment> comments, this.isSubmitting = false, this.errorKey}): _comments = comments;
  

 final  List<ReportComment> _comments;
 List<ReportComment> get comments {
  if (_comments is EqualUnmodifiableListView) return _comments;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_comments);
}

@JsonKey() final  bool isSubmitting;
 final  String? errorKey;

/// Create a copy of ReportCommentsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReportCommentsLoadedCopyWith<ReportCommentsLoaded> get copyWith => _$ReportCommentsLoadedCopyWithImpl<ReportCommentsLoaded>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'ReportCommentsState.loaded'))
    ..add(DiagnosticsProperty('comments', comments))..add(DiagnosticsProperty('isSubmitting', isSubmitting))..add(DiagnosticsProperty('errorKey', errorKey));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReportCommentsLoaded&&const DeepCollectionEquality().equals(other._comments, _comments)&&(identical(other.isSubmitting, isSubmitting) || other.isSubmitting == isSubmitting)&&(identical(other.errorKey, errorKey) || other.errorKey == errorKey));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_comments),isSubmitting,errorKey);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'ReportCommentsState.loaded(comments: $comments, isSubmitting: $isSubmitting, errorKey: $errorKey)';
}


}

/// @nodoc
abstract mixin class $ReportCommentsLoadedCopyWith<$Res> implements $ReportCommentsStateCopyWith<$Res> {
  factory $ReportCommentsLoadedCopyWith(ReportCommentsLoaded value, $Res Function(ReportCommentsLoaded) _then) = _$ReportCommentsLoadedCopyWithImpl;
@useResult
$Res call({
 List<ReportComment> comments, bool isSubmitting, String? errorKey
});




}
/// @nodoc
class _$ReportCommentsLoadedCopyWithImpl<$Res>
    implements $ReportCommentsLoadedCopyWith<$Res> {
  _$ReportCommentsLoadedCopyWithImpl(this._self, this._then);

  final ReportCommentsLoaded _self;
  final $Res Function(ReportCommentsLoaded) _then;

/// Create a copy of ReportCommentsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? comments = null,Object? isSubmitting = null,Object? errorKey = freezed,}) {
  return _then(ReportCommentsLoaded(
comments: null == comments ? _self._comments : comments // ignore: cast_nullable_to_non_nullable
as List<ReportComment>,isSubmitting: null == isSubmitting ? _self.isSubmitting : isSubmitting // ignore: cast_nullable_to_non_nullable
as bool,errorKey: freezed == errorKey ? _self.errorKey : errorKey // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class ReportCommentsError with DiagnosticableTreeMixin implements ReportCommentsState {
  const ReportCommentsError({required this.errorKey});
  

 final  String errorKey;

/// Create a copy of ReportCommentsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReportCommentsErrorCopyWith<ReportCommentsError> get copyWith => _$ReportCommentsErrorCopyWithImpl<ReportCommentsError>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'ReportCommentsState.error'))
    ..add(DiagnosticsProperty('errorKey', errorKey));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReportCommentsError&&(identical(other.errorKey, errorKey) || other.errorKey == errorKey));
}


@override
int get hashCode => Object.hash(runtimeType,errorKey);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'ReportCommentsState.error(errorKey: $errorKey)';
}


}

/// @nodoc
abstract mixin class $ReportCommentsErrorCopyWith<$Res> implements $ReportCommentsStateCopyWith<$Res> {
  factory $ReportCommentsErrorCopyWith(ReportCommentsError value, $Res Function(ReportCommentsError) _then) = _$ReportCommentsErrorCopyWithImpl;
@useResult
$Res call({
 String errorKey
});




}
/// @nodoc
class _$ReportCommentsErrorCopyWithImpl<$Res>
    implements $ReportCommentsErrorCopyWith<$Res> {
  _$ReportCommentsErrorCopyWithImpl(this._self, this._then);

  final ReportCommentsError _self;
  final $Res Function(ReportCommentsError) _then;

/// Create a copy of ReportCommentsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? errorKey = null,}) {
  return _then(ReportCommentsError(
errorKey: null == errorKey ? _self.errorKey : errorKey // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
