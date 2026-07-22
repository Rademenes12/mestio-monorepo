// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'resolution_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Resolution {

 String get id; String get title; String? get description;/// 'open' | 'passed' | 'rejected'
 String get status; DateTime? get deadline; DateTime? get createdAt; DateTime? get closedAt; int? get votesFor; int? get votesAgainst;/// Caller's own vote: 'for' | 'against' | null (not voted).
 String? get myVote;
/// Create a copy of Resolution
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ResolutionCopyWith<Resolution> get copyWith => _$ResolutionCopyWithImpl<Resolution>(this as Resolution, _$identity);

  /// Serializes this Resolution to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Resolution&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.status, status) || other.status == status)&&(identical(other.deadline, deadline) || other.deadline == deadline)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.closedAt, closedAt) || other.closedAt == closedAt)&&(identical(other.votesFor, votesFor) || other.votesFor == votesFor)&&(identical(other.votesAgainst, votesAgainst) || other.votesAgainst == votesAgainst)&&(identical(other.myVote, myVote) || other.myVote == myVote));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,description,status,deadline,createdAt,closedAt,votesFor,votesAgainst,myVote);

@override
String toString() {
  return 'Resolution(id: $id, title: $title, description: $description, status: $status, deadline: $deadline, createdAt: $createdAt, closedAt: $closedAt, votesFor: $votesFor, votesAgainst: $votesAgainst, myVote: $myVote)';
}


}

/// @nodoc
abstract mixin class $ResolutionCopyWith<$Res>  {
  factory $ResolutionCopyWith(Resolution value, $Res Function(Resolution) _then) = _$ResolutionCopyWithImpl;
@useResult
$Res call({
 String id, String title, String? description, String status, DateTime? deadline, DateTime? createdAt, DateTime? closedAt, int? votesFor, int? votesAgainst, String? myVote
});




}
/// @nodoc
class _$ResolutionCopyWithImpl<$Res>
    implements $ResolutionCopyWith<$Res> {
  _$ResolutionCopyWithImpl(this._self, this._then);

  final Resolution _self;
  final $Res Function(Resolution) _then;

/// Create a copy of Resolution
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? description = freezed,Object? status = null,Object? deadline = freezed,Object? createdAt = freezed,Object? closedAt = freezed,Object? votesFor = freezed,Object? votesAgainst = freezed,Object? myVote = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,deadline: freezed == deadline ? _self.deadline : deadline // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,closedAt: freezed == closedAt ? _self.closedAt : closedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,votesFor: freezed == votesFor ? _self.votesFor : votesFor // ignore: cast_nullable_to_non_nullable
as int?,votesAgainst: freezed == votesAgainst ? _self.votesAgainst : votesAgainst // ignore: cast_nullable_to_non_nullable
as int?,myVote: freezed == myVote ? _self.myVote : myVote // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Resolution].
extension ResolutionPatterns on Resolution {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Resolution value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Resolution() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Resolution value)  $default,){
final _that = this;
switch (_that) {
case _Resolution():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Resolution value)?  $default,){
final _that = this;
switch (_that) {
case _Resolution() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String? description,  String status,  DateTime? deadline,  DateTime? createdAt,  DateTime? closedAt,  int? votesFor,  int? votesAgainst,  String? myVote)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Resolution() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.status,_that.deadline,_that.createdAt,_that.closedAt,_that.votesFor,_that.votesAgainst,_that.myVote);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String? description,  String status,  DateTime? deadline,  DateTime? createdAt,  DateTime? closedAt,  int? votesFor,  int? votesAgainst,  String? myVote)  $default,) {final _that = this;
switch (_that) {
case _Resolution():
return $default(_that.id,_that.title,_that.description,_that.status,_that.deadline,_that.createdAt,_that.closedAt,_that.votesFor,_that.votesAgainst,_that.myVote);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String? description,  String status,  DateTime? deadline,  DateTime? createdAt,  DateTime? closedAt,  int? votesFor,  int? votesAgainst,  String? myVote)?  $default,) {final _that = this;
switch (_that) {
case _Resolution() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.status,_that.deadline,_that.createdAt,_that.closedAt,_that.votesFor,_that.votesAgainst,_that.myVote);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _Resolution extends Resolution {
  const _Resolution({required this.id, required this.title, this.description, this.status = 'open', this.deadline, this.createdAt, this.closedAt, this.votesFor, this.votesAgainst, this.myVote}): super._();
  factory _Resolution.fromJson(Map<String, dynamic> json) => _$ResolutionFromJson(json);

@override final  String id;
@override final  String title;
@override final  String? description;
/// 'open' | 'passed' | 'rejected'
@override@JsonKey() final  String status;
@override final  DateTime? deadline;
@override final  DateTime? createdAt;
@override final  DateTime? closedAt;
@override final  int? votesFor;
@override final  int? votesAgainst;
/// Caller's own vote: 'for' | 'against' | null (not voted).
@override final  String? myVote;

/// Create a copy of Resolution
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ResolutionCopyWith<_Resolution> get copyWith => __$ResolutionCopyWithImpl<_Resolution>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ResolutionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Resolution&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.status, status) || other.status == status)&&(identical(other.deadline, deadline) || other.deadline == deadline)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.closedAt, closedAt) || other.closedAt == closedAt)&&(identical(other.votesFor, votesFor) || other.votesFor == votesFor)&&(identical(other.votesAgainst, votesAgainst) || other.votesAgainst == votesAgainst)&&(identical(other.myVote, myVote) || other.myVote == myVote));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,description,status,deadline,createdAt,closedAt,votesFor,votesAgainst,myVote);

@override
String toString() {
  return 'Resolution(id: $id, title: $title, description: $description, status: $status, deadline: $deadline, createdAt: $createdAt, closedAt: $closedAt, votesFor: $votesFor, votesAgainst: $votesAgainst, myVote: $myVote)';
}


}

/// @nodoc
abstract mixin class _$ResolutionCopyWith<$Res> implements $ResolutionCopyWith<$Res> {
  factory _$ResolutionCopyWith(_Resolution value, $Res Function(_Resolution) _then) = __$ResolutionCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String? description, String status, DateTime? deadline, DateTime? createdAt, DateTime? closedAt, int? votesFor, int? votesAgainst, String? myVote
});




}
/// @nodoc
class __$ResolutionCopyWithImpl<$Res>
    implements _$ResolutionCopyWith<$Res> {
  __$ResolutionCopyWithImpl(this._self, this._then);

  final _Resolution _self;
  final $Res Function(_Resolution) _then;

/// Create a copy of Resolution
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? description = freezed,Object? status = null,Object? deadline = freezed,Object? createdAt = freezed,Object? closedAt = freezed,Object? votesFor = freezed,Object? votesAgainst = freezed,Object? myVote = freezed,}) {
  return _then(_Resolution(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,deadline: freezed == deadline ? _self.deadline : deadline // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,closedAt: freezed == closedAt ? _self.closedAt : closedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,votesFor: freezed == votesFor ? _self.votesFor : votesFor // ignore: cast_nullable_to_non_nullable
as int?,votesAgainst: freezed == votesAgainst ? _self.votesAgainst : votesAgainst // ignore: cast_nullable_to_non_nullable
as int?,myVote: freezed == myVote ? _self.myVote : myVote // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
