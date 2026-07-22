// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reports_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ReportsState implements DiagnosticableTreeMixin {




@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'ReportsState'))
    ;
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReportsState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'ReportsState()';
}


}

/// @nodoc
class $ReportsStateCopyWith<$Res>  {
$ReportsStateCopyWith(ReportsState _, $Res Function(ReportsState) __);
}


/// Adds pattern-matching-related methods to [ReportsState].
extension ReportsStatePatterns on ReportsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( ReportsInitial value)?  initial,TResult Function( ReportsLoading value)?  loading,TResult Function( ReportsLoaded value)?  loaded,TResult Function( ReportsError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case ReportsInitial() when initial != null:
return initial(_that);case ReportsLoading() when loading != null:
return loading(_that);case ReportsLoaded() when loaded != null:
return loaded(_that);case ReportsError() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( ReportsInitial value)  initial,required TResult Function( ReportsLoading value)  loading,required TResult Function( ReportsLoaded value)  loaded,required TResult Function( ReportsError value)  error,}){
final _that = this;
switch (_that) {
case ReportsInitial():
return initial(_that);case ReportsLoading():
return loading(_that);case ReportsLoaded():
return loaded(_that);case ReportsError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( ReportsInitial value)?  initial,TResult? Function( ReportsLoading value)?  loading,TResult? Function( ReportsLoaded value)?  loaded,TResult? Function( ReportsError value)?  error,}){
final _that = this;
switch (_that) {
case ReportsInitial() when initial != null:
return initial(_that);case ReportsLoading() when loading != null:
return loading(_that);case ReportsLoaded() when loaded != null:
return loaded(_that);case ReportsError() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( List<ReportModel> reports,  ResidentProfileModel? profile,  String? userId,  String? estateId,  List<StaffMemberModel> staff,  bool isSubmitting,  String? errorKey)?  loaded,TResult Function( String errorKey)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case ReportsInitial() when initial != null:
return initial();case ReportsLoading() when loading != null:
return loading();case ReportsLoaded() when loaded != null:
return loaded(_that.reports,_that.profile,_that.userId,_that.estateId,_that.staff,_that.isSubmitting,_that.errorKey);case ReportsError() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( List<ReportModel> reports,  ResidentProfileModel? profile,  String? userId,  String? estateId,  List<StaffMemberModel> staff,  bool isSubmitting,  String? errorKey)  loaded,required TResult Function( String errorKey)  error,}) {final _that = this;
switch (_that) {
case ReportsInitial():
return initial();case ReportsLoading():
return loading();case ReportsLoaded():
return loaded(_that.reports,_that.profile,_that.userId,_that.estateId,_that.staff,_that.isSubmitting,_that.errorKey);case ReportsError():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( List<ReportModel> reports,  ResidentProfileModel? profile,  String? userId,  String? estateId,  List<StaffMemberModel> staff,  bool isSubmitting,  String? errorKey)?  loaded,TResult? Function( String errorKey)?  error,}) {final _that = this;
switch (_that) {
case ReportsInitial() when initial != null:
return initial();case ReportsLoading() when loading != null:
return loading();case ReportsLoaded() when loaded != null:
return loaded(_that.reports,_that.profile,_that.userId,_that.estateId,_that.staff,_that.isSubmitting,_that.errorKey);case ReportsError() when error != null:
return error(_that.errorKey);case _:
  return null;

}
}

}

/// @nodoc


class ReportsInitial with DiagnosticableTreeMixin implements ReportsState {
  const ReportsInitial();
  





@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'ReportsState.initial'))
    ;
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReportsInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'ReportsState.initial()';
}


}




/// @nodoc


class ReportsLoading with DiagnosticableTreeMixin implements ReportsState {
  const ReportsLoading();
  





@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'ReportsState.loading'))
    ;
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReportsLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'ReportsState.loading()';
}


}




/// @nodoc


class ReportsLoaded with DiagnosticableTreeMixin implements ReportsState {
  const ReportsLoaded({required final  List<ReportModel> reports, this.profile, this.userId, this.estateId, final  List<StaffMemberModel> staff = const [], this.isSubmitting = false, this.errorKey}): _reports = reports,_staff = staff;
  

 final  List<ReportModel> _reports;
 List<ReportModel> get reports {
  if (_reports is EqualUnmodifiableListView) return _reports;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_reports);
}

 final  ResidentProfileModel? profile;
 final  String? userId;
 final  String? estateId;
 final  List<StaffMemberModel> _staff;
@JsonKey() List<StaffMemberModel> get staff {
  if (_staff is EqualUnmodifiableListView) return _staff;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_staff);
}

@JsonKey() final  bool isSubmitting;
 final  String? errorKey;

/// Create a copy of ReportsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReportsLoadedCopyWith<ReportsLoaded> get copyWith => _$ReportsLoadedCopyWithImpl<ReportsLoaded>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'ReportsState.loaded'))
    ..add(DiagnosticsProperty('reports', reports))..add(DiagnosticsProperty('profile', profile))..add(DiagnosticsProperty('userId', userId))..add(DiagnosticsProperty('estateId', estateId))..add(DiagnosticsProperty('staff', staff))..add(DiagnosticsProperty('isSubmitting', isSubmitting))..add(DiagnosticsProperty('errorKey', errorKey));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReportsLoaded&&const DeepCollectionEquality().equals(other._reports, _reports)&&(identical(other.profile, profile) || other.profile == profile)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.estateId, estateId) || other.estateId == estateId)&&const DeepCollectionEquality().equals(other._staff, _staff)&&(identical(other.isSubmitting, isSubmitting) || other.isSubmitting == isSubmitting)&&(identical(other.errorKey, errorKey) || other.errorKey == errorKey));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_reports),profile,userId,estateId,const DeepCollectionEquality().hash(_staff),isSubmitting,errorKey);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'ReportsState.loaded(reports: $reports, profile: $profile, userId: $userId, estateId: $estateId, staff: $staff, isSubmitting: $isSubmitting, errorKey: $errorKey)';
}


}

/// @nodoc
abstract mixin class $ReportsLoadedCopyWith<$Res> implements $ReportsStateCopyWith<$Res> {
  factory $ReportsLoadedCopyWith(ReportsLoaded value, $Res Function(ReportsLoaded) _then) = _$ReportsLoadedCopyWithImpl;
@useResult
$Res call({
 List<ReportModel> reports, ResidentProfileModel? profile, String? userId, String? estateId, List<StaffMemberModel> staff, bool isSubmitting, String? errorKey
});


$ResidentProfileModelCopyWith<$Res>? get profile;

}
/// @nodoc
class _$ReportsLoadedCopyWithImpl<$Res>
    implements $ReportsLoadedCopyWith<$Res> {
  _$ReportsLoadedCopyWithImpl(this._self, this._then);

  final ReportsLoaded _self;
  final $Res Function(ReportsLoaded) _then;

/// Create a copy of ReportsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? reports = null,Object? profile = freezed,Object? userId = freezed,Object? estateId = freezed,Object? staff = null,Object? isSubmitting = null,Object? errorKey = freezed,}) {
  return _then(ReportsLoaded(
reports: null == reports ? _self._reports : reports // ignore: cast_nullable_to_non_nullable
as List<ReportModel>,profile: freezed == profile ? _self.profile : profile // ignore: cast_nullable_to_non_nullable
as ResidentProfileModel?,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,estateId: freezed == estateId ? _self.estateId : estateId // ignore: cast_nullable_to_non_nullable
as String?,staff: null == staff ? _self._staff : staff // ignore: cast_nullable_to_non_nullable
as List<StaffMemberModel>,isSubmitting: null == isSubmitting ? _self.isSubmitting : isSubmitting // ignore: cast_nullable_to_non_nullable
as bool,errorKey: freezed == errorKey ? _self.errorKey : errorKey // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of ReportsState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ResidentProfileModelCopyWith<$Res>? get profile {
    if (_self.profile == null) {
    return null;
  }

  return $ResidentProfileModelCopyWith<$Res>(_self.profile!, (value) {
    return _then(_self.copyWith(profile: value));
  });
}
}

/// @nodoc


class ReportsError with DiagnosticableTreeMixin implements ReportsState {
  const ReportsError({required this.errorKey});
  

 final  String errorKey;

/// Create a copy of ReportsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReportsErrorCopyWith<ReportsError> get copyWith => _$ReportsErrorCopyWithImpl<ReportsError>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'ReportsState.error'))
    ..add(DiagnosticsProperty('errorKey', errorKey));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReportsError&&(identical(other.errorKey, errorKey) || other.errorKey == errorKey));
}


@override
int get hashCode => Object.hash(runtimeType,errorKey);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'ReportsState.error(errorKey: $errorKey)';
}


}

/// @nodoc
abstract mixin class $ReportsErrorCopyWith<$Res> implements $ReportsStateCopyWith<$Res> {
  factory $ReportsErrorCopyWith(ReportsError value, $Res Function(ReportsError) _then) = _$ReportsErrorCopyWithImpl;
@useResult
$Res call({
 String errorKey
});




}
/// @nodoc
class _$ReportsErrorCopyWithImpl<$Res>
    implements $ReportsErrorCopyWith<$Res> {
  _$ReportsErrorCopyWithImpl(this._self, this._then);

  final ReportsError _self;
  final $Res Function(ReportsError) _then;

/// Create a copy of ReportsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? errorKey = null,}) {
  return _then(ReportsError(
errorKey: null == errorKey ? _self.errorKey : errorKey // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
