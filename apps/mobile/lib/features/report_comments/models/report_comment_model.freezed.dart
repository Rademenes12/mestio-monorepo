// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'report_comment_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ReportComment {

 String get id; String get reportId; String? get userId; String? get authorName; String? get authorRole; String get comment; bool get isInternal; DateTime? get createdAt;
/// Create a copy of ReportComment
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReportCommentCopyWith<ReportComment> get copyWith => _$ReportCommentCopyWithImpl<ReportComment>(this as ReportComment, _$identity);

  /// Serializes this ReportComment to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReportComment&&(identical(other.id, id) || other.id == id)&&(identical(other.reportId, reportId) || other.reportId == reportId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.authorName, authorName) || other.authorName == authorName)&&(identical(other.authorRole, authorRole) || other.authorRole == authorRole)&&(identical(other.comment, comment) || other.comment == comment)&&(identical(other.isInternal, isInternal) || other.isInternal == isInternal)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,reportId,userId,authorName,authorRole,comment,isInternal,createdAt);

@override
String toString() {
  return 'ReportComment(id: $id, reportId: $reportId, userId: $userId, authorName: $authorName, authorRole: $authorRole, comment: $comment, isInternal: $isInternal, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $ReportCommentCopyWith<$Res>  {
  factory $ReportCommentCopyWith(ReportComment value, $Res Function(ReportComment) _then) = _$ReportCommentCopyWithImpl;
@useResult
$Res call({
 String id, String reportId, String? userId, String? authorName, String? authorRole, String comment, bool isInternal, DateTime? createdAt
});




}
/// @nodoc
class _$ReportCommentCopyWithImpl<$Res>
    implements $ReportCommentCopyWith<$Res> {
  _$ReportCommentCopyWithImpl(this._self, this._then);

  final ReportComment _self;
  final $Res Function(ReportComment) _then;

/// Create a copy of ReportComment
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? reportId = null,Object? userId = freezed,Object? authorName = freezed,Object? authorRole = freezed,Object? comment = null,Object? isInternal = null,Object? createdAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,reportId: null == reportId ? _self.reportId : reportId // ignore: cast_nullable_to_non_nullable
as String,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,authorName: freezed == authorName ? _self.authorName : authorName // ignore: cast_nullable_to_non_nullable
as String?,authorRole: freezed == authorRole ? _self.authorRole : authorRole // ignore: cast_nullable_to_non_nullable
as String?,comment: null == comment ? _self.comment : comment // ignore: cast_nullable_to_non_nullable
as String,isInternal: null == isInternal ? _self.isInternal : isInternal // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [ReportComment].
extension ReportCommentPatterns on ReportComment {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReportComment value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReportComment() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReportComment value)  $default,){
final _that = this;
switch (_that) {
case _ReportComment():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReportComment value)?  $default,){
final _that = this;
switch (_that) {
case _ReportComment() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String reportId,  String? userId,  String? authorName,  String? authorRole,  String comment,  bool isInternal,  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReportComment() when $default != null:
return $default(_that.id,_that.reportId,_that.userId,_that.authorName,_that.authorRole,_that.comment,_that.isInternal,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String reportId,  String? userId,  String? authorName,  String? authorRole,  String comment,  bool isInternal,  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _ReportComment():
return $default(_that.id,_that.reportId,_that.userId,_that.authorName,_that.authorRole,_that.comment,_that.isInternal,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String reportId,  String? userId,  String? authorName,  String? authorRole,  String comment,  bool isInternal,  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _ReportComment() when $default != null:
return $default(_that.id,_that.reportId,_that.userId,_that.authorName,_that.authorRole,_that.comment,_that.isInternal,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _ReportComment extends ReportComment {
  const _ReportComment({required this.id, required this.reportId, this.userId, this.authorName, this.authorRole, required this.comment, this.isInternal = false, this.createdAt}): super._();
  factory _ReportComment.fromJson(Map<String, dynamic> json) => _$ReportCommentFromJson(json);

@override final  String id;
@override final  String reportId;
@override final  String? userId;
@override final  String? authorName;
@override final  String? authorRole;
@override final  String comment;
@override@JsonKey() final  bool isInternal;
@override final  DateTime? createdAt;

/// Create a copy of ReportComment
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReportCommentCopyWith<_ReportComment> get copyWith => __$ReportCommentCopyWithImpl<_ReportComment>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReportCommentToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReportComment&&(identical(other.id, id) || other.id == id)&&(identical(other.reportId, reportId) || other.reportId == reportId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.authorName, authorName) || other.authorName == authorName)&&(identical(other.authorRole, authorRole) || other.authorRole == authorRole)&&(identical(other.comment, comment) || other.comment == comment)&&(identical(other.isInternal, isInternal) || other.isInternal == isInternal)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,reportId,userId,authorName,authorRole,comment,isInternal,createdAt);

@override
String toString() {
  return 'ReportComment(id: $id, reportId: $reportId, userId: $userId, authorName: $authorName, authorRole: $authorRole, comment: $comment, isInternal: $isInternal, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$ReportCommentCopyWith<$Res> implements $ReportCommentCopyWith<$Res> {
  factory _$ReportCommentCopyWith(_ReportComment value, $Res Function(_ReportComment) _then) = __$ReportCommentCopyWithImpl;
@override @useResult
$Res call({
 String id, String reportId, String? userId, String? authorName, String? authorRole, String comment, bool isInternal, DateTime? createdAt
});




}
/// @nodoc
class __$ReportCommentCopyWithImpl<$Res>
    implements _$ReportCommentCopyWith<$Res> {
  __$ReportCommentCopyWithImpl(this._self, this._then);

  final _ReportComment _self;
  final $Res Function(_ReportComment) _then;

/// Create a copy of ReportComment
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? reportId = null,Object? userId = freezed,Object? authorName = freezed,Object? authorRole = freezed,Object? comment = null,Object? isInternal = null,Object? createdAt = freezed,}) {
  return _then(_ReportComment(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,reportId: null == reportId ? _self.reportId : reportId // ignore: cast_nullable_to_non_nullable
as String,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,authorName: freezed == authorName ? _self.authorName : authorName // ignore: cast_nullable_to_non_nullable
as String?,authorRole: freezed == authorRole ? _self.authorRole : authorRole // ignore: cast_nullable_to_non_nullable
as String?,comment: null == comment ? _self.comment : comment // ignore: cast_nullable_to_non_nullable
as String,isInternal: null == isInternal ? _self.isInternal : isInternal // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
