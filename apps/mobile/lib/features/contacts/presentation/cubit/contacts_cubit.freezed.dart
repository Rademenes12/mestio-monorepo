// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'contacts_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ContactsState implements DiagnosticableTreeMixin {




@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'ContactsState'))
    ;
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ContactsState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'ContactsState()';
}


}

/// @nodoc
class $ContactsStateCopyWith<$Res>  {
$ContactsStateCopyWith(ContactsState _, $Res Function(ContactsState) __);
}


/// Adds pattern-matching-related methods to [ContactsState].
extension ContactsStatePatterns on ContactsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( ContactsInitial value)?  initial,TResult Function( ContactsLoading value)?  loading,TResult Function( ContactsLoaded value)?  loaded,TResult Function( ContactsError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case ContactsInitial() when initial != null:
return initial(_that);case ContactsLoading() when loading != null:
return loading(_that);case ContactsLoaded() when loaded != null:
return loaded(_that);case ContactsError() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( ContactsInitial value)  initial,required TResult Function( ContactsLoading value)  loading,required TResult Function( ContactsLoaded value)  loaded,required TResult Function( ContactsError value)  error,}){
final _that = this;
switch (_that) {
case ContactsInitial():
return initial(_that);case ContactsLoading():
return loading(_that);case ContactsLoaded():
return loaded(_that);case ContactsError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( ContactsInitial value)?  initial,TResult? Function( ContactsLoading value)?  loading,TResult? Function( ContactsLoaded value)?  loaded,TResult? Function( ContactsError value)?  error,}){
final _that = this;
switch (_that) {
case ContactsInitial() when initial != null:
return initial(_that);case ContactsLoading() when loading != null:
return loading(_that);case ContactsLoaded() when loaded != null:
return loaded(_that);case ContactsError() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( List<EmergencyContact> contacts,  bool isSubmitting,  String? errorKey)?  loaded,TResult Function( String errorKey)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case ContactsInitial() when initial != null:
return initial();case ContactsLoading() when loading != null:
return loading();case ContactsLoaded() when loaded != null:
return loaded(_that.contacts,_that.isSubmitting,_that.errorKey);case ContactsError() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( List<EmergencyContact> contacts,  bool isSubmitting,  String? errorKey)  loaded,required TResult Function( String errorKey)  error,}) {final _that = this;
switch (_that) {
case ContactsInitial():
return initial();case ContactsLoading():
return loading();case ContactsLoaded():
return loaded(_that.contacts,_that.isSubmitting,_that.errorKey);case ContactsError():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( List<EmergencyContact> contacts,  bool isSubmitting,  String? errorKey)?  loaded,TResult? Function( String errorKey)?  error,}) {final _that = this;
switch (_that) {
case ContactsInitial() when initial != null:
return initial();case ContactsLoading() when loading != null:
return loading();case ContactsLoaded() when loaded != null:
return loaded(_that.contacts,_that.isSubmitting,_that.errorKey);case ContactsError() when error != null:
return error(_that.errorKey);case _:
  return null;

}
}

}

/// @nodoc


class ContactsInitial with DiagnosticableTreeMixin implements ContactsState {
  const ContactsInitial();
  





@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'ContactsState.initial'))
    ;
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ContactsInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'ContactsState.initial()';
}


}




/// @nodoc


class ContactsLoading with DiagnosticableTreeMixin implements ContactsState {
  const ContactsLoading();
  





@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'ContactsState.loading'))
    ;
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ContactsLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'ContactsState.loading()';
}


}




/// @nodoc


class ContactsLoaded with DiagnosticableTreeMixin implements ContactsState {
  const ContactsLoaded({required final  List<EmergencyContact> contacts, this.isSubmitting = false, this.errorKey}): _contacts = contacts;
  

 final  List<EmergencyContact> _contacts;
 List<EmergencyContact> get contacts {
  if (_contacts is EqualUnmodifiableListView) return _contacts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_contacts);
}

@JsonKey() final  bool isSubmitting;
 final  String? errorKey;

/// Create a copy of ContactsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ContactsLoadedCopyWith<ContactsLoaded> get copyWith => _$ContactsLoadedCopyWithImpl<ContactsLoaded>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'ContactsState.loaded'))
    ..add(DiagnosticsProperty('contacts', contacts))..add(DiagnosticsProperty('isSubmitting', isSubmitting))..add(DiagnosticsProperty('errorKey', errorKey));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ContactsLoaded&&const DeepCollectionEquality().equals(other._contacts, _contacts)&&(identical(other.isSubmitting, isSubmitting) || other.isSubmitting == isSubmitting)&&(identical(other.errorKey, errorKey) || other.errorKey == errorKey));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_contacts),isSubmitting,errorKey);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'ContactsState.loaded(contacts: $contacts, isSubmitting: $isSubmitting, errorKey: $errorKey)';
}


}

/// @nodoc
abstract mixin class $ContactsLoadedCopyWith<$Res> implements $ContactsStateCopyWith<$Res> {
  factory $ContactsLoadedCopyWith(ContactsLoaded value, $Res Function(ContactsLoaded) _then) = _$ContactsLoadedCopyWithImpl;
@useResult
$Res call({
 List<EmergencyContact> contacts, bool isSubmitting, String? errorKey
});




}
/// @nodoc
class _$ContactsLoadedCopyWithImpl<$Res>
    implements $ContactsLoadedCopyWith<$Res> {
  _$ContactsLoadedCopyWithImpl(this._self, this._then);

  final ContactsLoaded _self;
  final $Res Function(ContactsLoaded) _then;

/// Create a copy of ContactsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? contacts = null,Object? isSubmitting = null,Object? errorKey = freezed,}) {
  return _then(ContactsLoaded(
contacts: null == contacts ? _self._contacts : contacts // ignore: cast_nullable_to_non_nullable
as List<EmergencyContact>,isSubmitting: null == isSubmitting ? _self.isSubmitting : isSubmitting // ignore: cast_nullable_to_non_nullable
as bool,errorKey: freezed == errorKey ? _self.errorKey : errorKey // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class ContactsError with DiagnosticableTreeMixin implements ContactsState {
  const ContactsError({required this.errorKey});
  

 final  String errorKey;

/// Create a copy of ContactsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ContactsErrorCopyWith<ContactsError> get copyWith => _$ContactsErrorCopyWithImpl<ContactsError>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'ContactsState.error'))
    ..add(DiagnosticsProperty('errorKey', errorKey));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ContactsError&&(identical(other.errorKey, errorKey) || other.errorKey == errorKey));
}


@override
int get hashCode => Object.hash(runtimeType,errorKey);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'ContactsState.error(errorKey: $errorKey)';
}


}

/// @nodoc
abstract mixin class $ContactsErrorCopyWith<$Res> implements $ContactsStateCopyWith<$Res> {
  factory $ContactsErrorCopyWith(ContactsError value, $Res Function(ContactsError) _then) = _$ContactsErrorCopyWithImpl;
@useResult
$Res call({
 String errorKey
});




}
/// @nodoc
class _$ContactsErrorCopyWithImpl<$Res>
    implements $ContactsErrorCopyWith<$Res> {
  _$ContactsErrorCopyWithImpl(this._self, this._then);

  final ContactsError _self;
  final $Res Function(ContactsError) _then;

/// Create a copy of ContactsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? errorKey = null,}) {
  return _then(ContactsError(
errorKey: null == errorKey ? _self.errorKey : errorKey // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
