// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'announcements_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AnnouncementsState implements DiagnosticableTreeMixin {




@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'AnnouncementsState'))
    ;
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AnnouncementsState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'AnnouncementsState()';
}


}

/// @nodoc
class $AnnouncementsStateCopyWith<$Res>  {
$AnnouncementsStateCopyWith(AnnouncementsState _, $Res Function(AnnouncementsState) __);
}


/// Adds pattern-matching-related methods to [AnnouncementsState].
extension AnnouncementsStatePatterns on AnnouncementsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( AnnouncementsInitial value)?  initial,TResult Function( AnnouncementsLoading value)?  loading,TResult Function( AnnouncementsLoaded value)?  loaded,TResult Function( AnnouncementsError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case AnnouncementsInitial() when initial != null:
return initial(_that);case AnnouncementsLoading() when loading != null:
return loading(_that);case AnnouncementsLoaded() when loaded != null:
return loaded(_that);case AnnouncementsError() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( AnnouncementsInitial value)  initial,required TResult Function( AnnouncementsLoading value)  loading,required TResult Function( AnnouncementsLoaded value)  loaded,required TResult Function( AnnouncementsError value)  error,}){
final _that = this;
switch (_that) {
case AnnouncementsInitial():
return initial(_that);case AnnouncementsLoading():
return loading(_that);case AnnouncementsLoaded():
return loaded(_that);case AnnouncementsError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( AnnouncementsInitial value)?  initial,TResult? Function( AnnouncementsLoading value)?  loading,TResult? Function( AnnouncementsLoaded value)?  loaded,TResult? Function( AnnouncementsError value)?  error,}){
final _that = this;
switch (_that) {
case AnnouncementsInitial() when initial != null:
return initial(_that);case AnnouncementsLoading() when loading != null:
return loading(_that);case AnnouncementsLoaded() when loaded != null:
return loaded(_that);case AnnouncementsError() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( List<Announcement> announcements,  bool isSubmitting,  String? errorKey)?  loaded,TResult Function( String errorKey)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case AnnouncementsInitial() when initial != null:
return initial();case AnnouncementsLoading() when loading != null:
return loading();case AnnouncementsLoaded() when loaded != null:
return loaded(_that.announcements,_that.isSubmitting,_that.errorKey);case AnnouncementsError() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( List<Announcement> announcements,  bool isSubmitting,  String? errorKey)  loaded,required TResult Function( String errorKey)  error,}) {final _that = this;
switch (_that) {
case AnnouncementsInitial():
return initial();case AnnouncementsLoading():
return loading();case AnnouncementsLoaded():
return loaded(_that.announcements,_that.isSubmitting,_that.errorKey);case AnnouncementsError():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( List<Announcement> announcements,  bool isSubmitting,  String? errorKey)?  loaded,TResult? Function( String errorKey)?  error,}) {final _that = this;
switch (_that) {
case AnnouncementsInitial() when initial != null:
return initial();case AnnouncementsLoading() when loading != null:
return loading();case AnnouncementsLoaded() when loaded != null:
return loaded(_that.announcements,_that.isSubmitting,_that.errorKey);case AnnouncementsError() when error != null:
return error(_that.errorKey);case _:
  return null;

}
}

}

/// @nodoc


class AnnouncementsInitial with DiagnosticableTreeMixin implements AnnouncementsState {
  const AnnouncementsInitial();
  





@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'AnnouncementsState.initial'))
    ;
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AnnouncementsInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'AnnouncementsState.initial()';
}


}




/// @nodoc


class AnnouncementsLoading with DiagnosticableTreeMixin implements AnnouncementsState {
  const AnnouncementsLoading();
  





@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'AnnouncementsState.loading'))
    ;
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AnnouncementsLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'AnnouncementsState.loading()';
}


}




/// @nodoc


class AnnouncementsLoaded with DiagnosticableTreeMixin implements AnnouncementsState {
  const AnnouncementsLoaded({required final  List<Announcement> announcements, this.isSubmitting = false, this.errorKey}): _announcements = announcements;
  

 final  List<Announcement> _announcements;
 List<Announcement> get announcements {
  if (_announcements is EqualUnmodifiableListView) return _announcements;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_announcements);
}

@JsonKey() final  bool isSubmitting;
 final  String? errorKey;

/// Create a copy of AnnouncementsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AnnouncementsLoadedCopyWith<AnnouncementsLoaded> get copyWith => _$AnnouncementsLoadedCopyWithImpl<AnnouncementsLoaded>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'AnnouncementsState.loaded'))
    ..add(DiagnosticsProperty('announcements', announcements))..add(DiagnosticsProperty('isSubmitting', isSubmitting))..add(DiagnosticsProperty('errorKey', errorKey));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AnnouncementsLoaded&&const DeepCollectionEquality().equals(other._announcements, _announcements)&&(identical(other.isSubmitting, isSubmitting) || other.isSubmitting == isSubmitting)&&(identical(other.errorKey, errorKey) || other.errorKey == errorKey));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_announcements),isSubmitting,errorKey);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'AnnouncementsState.loaded(announcements: $announcements, isSubmitting: $isSubmitting, errorKey: $errorKey)';
}


}

/// @nodoc
abstract mixin class $AnnouncementsLoadedCopyWith<$Res> implements $AnnouncementsStateCopyWith<$Res> {
  factory $AnnouncementsLoadedCopyWith(AnnouncementsLoaded value, $Res Function(AnnouncementsLoaded) _then) = _$AnnouncementsLoadedCopyWithImpl;
@useResult
$Res call({
 List<Announcement> announcements, bool isSubmitting, String? errorKey
});




}
/// @nodoc
class _$AnnouncementsLoadedCopyWithImpl<$Res>
    implements $AnnouncementsLoadedCopyWith<$Res> {
  _$AnnouncementsLoadedCopyWithImpl(this._self, this._then);

  final AnnouncementsLoaded _self;
  final $Res Function(AnnouncementsLoaded) _then;

/// Create a copy of AnnouncementsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? announcements = null,Object? isSubmitting = null,Object? errorKey = freezed,}) {
  return _then(AnnouncementsLoaded(
announcements: null == announcements ? _self._announcements : announcements // ignore: cast_nullable_to_non_nullable
as List<Announcement>,isSubmitting: null == isSubmitting ? _self.isSubmitting : isSubmitting // ignore: cast_nullable_to_non_nullable
as bool,errorKey: freezed == errorKey ? _self.errorKey : errorKey // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class AnnouncementsError with DiagnosticableTreeMixin implements AnnouncementsState {
  const AnnouncementsError({required this.errorKey});
  

 final  String errorKey;

/// Create a copy of AnnouncementsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AnnouncementsErrorCopyWith<AnnouncementsError> get copyWith => _$AnnouncementsErrorCopyWithImpl<AnnouncementsError>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'AnnouncementsState.error'))
    ..add(DiagnosticsProperty('errorKey', errorKey));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AnnouncementsError&&(identical(other.errorKey, errorKey) || other.errorKey == errorKey));
}


@override
int get hashCode => Object.hash(runtimeType,errorKey);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'AnnouncementsState.error(errorKey: $errorKey)';
}


}

/// @nodoc
abstract mixin class $AnnouncementsErrorCopyWith<$Res> implements $AnnouncementsStateCopyWith<$Res> {
  factory $AnnouncementsErrorCopyWith(AnnouncementsError value, $Res Function(AnnouncementsError) _then) = _$AnnouncementsErrorCopyWithImpl;
@useResult
$Res call({
 String errorKey
});




}
/// @nodoc
class _$AnnouncementsErrorCopyWithImpl<$Res>
    implements $AnnouncementsErrorCopyWith<$Res> {
  _$AnnouncementsErrorCopyWithImpl(this._self, this._then);

  final AnnouncementsError _self;
  final $Res Function(AnnouncementsError) _then;

/// Create a copy of AnnouncementsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? errorKey = null,}) {
  return _then(AnnouncementsError(
errorKey: null == errorKey ? _self.errorKey : errorKey // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
