// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'announcement_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Announcement {

 String get id; String get title; String get content; String? get authorId; String? get authorName; String? get authorRole;/// Legacy target label (free text)
 String? get targetLabel; String? get estateId; DateTime? get expiresAt; bool get isActive; DateTime? get createdAt;/// Structured scope: 'estate', 'building', 'stairwell'
 String get scopeType; String? get scopeBuildingId; String? get scopeStairwellId;
/// Create a copy of Announcement
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AnnouncementCopyWith<Announcement> get copyWith => _$AnnouncementCopyWithImpl<Announcement>(this as Announcement, _$identity);

  /// Serializes this Announcement to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Announcement&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.content, content) || other.content == content)&&(identical(other.authorId, authorId) || other.authorId == authorId)&&(identical(other.authorName, authorName) || other.authorName == authorName)&&(identical(other.authorRole, authorRole) || other.authorRole == authorRole)&&(identical(other.targetLabel, targetLabel) || other.targetLabel == targetLabel)&&(identical(other.estateId, estateId) || other.estateId == estateId)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.scopeType, scopeType) || other.scopeType == scopeType)&&(identical(other.scopeBuildingId, scopeBuildingId) || other.scopeBuildingId == scopeBuildingId)&&(identical(other.scopeStairwellId, scopeStairwellId) || other.scopeStairwellId == scopeStairwellId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,content,authorId,authorName,authorRole,targetLabel,estateId,expiresAt,isActive,createdAt,scopeType,scopeBuildingId,scopeStairwellId);

@override
String toString() {
  return 'Announcement(id: $id, title: $title, content: $content, authorId: $authorId, authorName: $authorName, authorRole: $authorRole, targetLabel: $targetLabel, estateId: $estateId, expiresAt: $expiresAt, isActive: $isActive, createdAt: $createdAt, scopeType: $scopeType, scopeBuildingId: $scopeBuildingId, scopeStairwellId: $scopeStairwellId)';
}


}

/// @nodoc
abstract mixin class $AnnouncementCopyWith<$Res>  {
  factory $AnnouncementCopyWith(Announcement value, $Res Function(Announcement) _then) = _$AnnouncementCopyWithImpl;
@useResult
$Res call({
 String id, String title, String content, String? authorId, String? authorName, String? authorRole, String? targetLabel, String? estateId, DateTime? expiresAt, bool isActive, DateTime? createdAt, String scopeType, String? scopeBuildingId, String? scopeStairwellId
});




}
/// @nodoc
class _$AnnouncementCopyWithImpl<$Res>
    implements $AnnouncementCopyWith<$Res> {
  _$AnnouncementCopyWithImpl(this._self, this._then);

  final Announcement _self;
  final $Res Function(Announcement) _then;

/// Create a copy of Announcement
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? content = null,Object? authorId = freezed,Object? authorName = freezed,Object? authorRole = freezed,Object? targetLabel = freezed,Object? estateId = freezed,Object? expiresAt = freezed,Object? isActive = null,Object? createdAt = freezed,Object? scopeType = null,Object? scopeBuildingId = freezed,Object? scopeStairwellId = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,authorId: freezed == authorId ? _self.authorId : authorId // ignore: cast_nullable_to_non_nullable
as String?,authorName: freezed == authorName ? _self.authorName : authorName // ignore: cast_nullable_to_non_nullable
as String?,authorRole: freezed == authorRole ? _self.authorRole : authorRole // ignore: cast_nullable_to_non_nullable
as String?,targetLabel: freezed == targetLabel ? _self.targetLabel : targetLabel // ignore: cast_nullable_to_non_nullable
as String?,estateId: freezed == estateId ? _self.estateId : estateId // ignore: cast_nullable_to_non_nullable
as String?,expiresAt: freezed == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime?,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,scopeType: null == scopeType ? _self.scopeType : scopeType // ignore: cast_nullable_to_non_nullable
as String,scopeBuildingId: freezed == scopeBuildingId ? _self.scopeBuildingId : scopeBuildingId // ignore: cast_nullable_to_non_nullable
as String?,scopeStairwellId: freezed == scopeStairwellId ? _self.scopeStairwellId : scopeStairwellId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Announcement].
extension AnnouncementPatterns on Announcement {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Announcement value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Announcement() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Announcement value)  $default,){
final _that = this;
switch (_that) {
case _Announcement():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Announcement value)?  $default,){
final _that = this;
switch (_that) {
case _Announcement() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String content,  String? authorId,  String? authorName,  String? authorRole,  String? targetLabel,  String? estateId,  DateTime? expiresAt,  bool isActive,  DateTime? createdAt,  String scopeType,  String? scopeBuildingId,  String? scopeStairwellId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Announcement() when $default != null:
return $default(_that.id,_that.title,_that.content,_that.authorId,_that.authorName,_that.authorRole,_that.targetLabel,_that.estateId,_that.expiresAt,_that.isActive,_that.createdAt,_that.scopeType,_that.scopeBuildingId,_that.scopeStairwellId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String content,  String? authorId,  String? authorName,  String? authorRole,  String? targetLabel,  String? estateId,  DateTime? expiresAt,  bool isActive,  DateTime? createdAt,  String scopeType,  String? scopeBuildingId,  String? scopeStairwellId)  $default,) {final _that = this;
switch (_that) {
case _Announcement():
return $default(_that.id,_that.title,_that.content,_that.authorId,_that.authorName,_that.authorRole,_that.targetLabel,_that.estateId,_that.expiresAt,_that.isActive,_that.createdAt,_that.scopeType,_that.scopeBuildingId,_that.scopeStairwellId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String content,  String? authorId,  String? authorName,  String? authorRole,  String? targetLabel,  String? estateId,  DateTime? expiresAt,  bool isActive,  DateTime? createdAt,  String scopeType,  String? scopeBuildingId,  String? scopeStairwellId)?  $default,) {final _that = this;
switch (_that) {
case _Announcement() when $default != null:
return $default(_that.id,_that.title,_that.content,_that.authorId,_that.authorName,_that.authorRole,_that.targetLabel,_that.estateId,_that.expiresAt,_that.isActive,_that.createdAt,_that.scopeType,_that.scopeBuildingId,_that.scopeStairwellId);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _Announcement extends Announcement {
  const _Announcement({required this.id, required this.title, required this.content, this.authorId, this.authorName, this.authorRole, this.targetLabel, this.estateId, this.expiresAt, this.isActive = true, this.createdAt, this.scopeType = 'estate', this.scopeBuildingId, this.scopeStairwellId}): super._();
  factory _Announcement.fromJson(Map<String, dynamic> json) => _$AnnouncementFromJson(json);

@override final  String id;
@override final  String title;
@override final  String content;
@override final  String? authorId;
@override final  String? authorName;
@override final  String? authorRole;
/// Legacy target label (free text)
@override final  String? targetLabel;
@override final  String? estateId;
@override final  DateTime? expiresAt;
@override@JsonKey() final  bool isActive;
@override final  DateTime? createdAt;
/// Structured scope: 'estate', 'building', 'stairwell'
@override@JsonKey() final  String scopeType;
@override final  String? scopeBuildingId;
@override final  String? scopeStairwellId;

/// Create a copy of Announcement
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AnnouncementCopyWith<_Announcement> get copyWith => __$AnnouncementCopyWithImpl<_Announcement>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AnnouncementToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Announcement&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.content, content) || other.content == content)&&(identical(other.authorId, authorId) || other.authorId == authorId)&&(identical(other.authorName, authorName) || other.authorName == authorName)&&(identical(other.authorRole, authorRole) || other.authorRole == authorRole)&&(identical(other.targetLabel, targetLabel) || other.targetLabel == targetLabel)&&(identical(other.estateId, estateId) || other.estateId == estateId)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.scopeType, scopeType) || other.scopeType == scopeType)&&(identical(other.scopeBuildingId, scopeBuildingId) || other.scopeBuildingId == scopeBuildingId)&&(identical(other.scopeStairwellId, scopeStairwellId) || other.scopeStairwellId == scopeStairwellId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,content,authorId,authorName,authorRole,targetLabel,estateId,expiresAt,isActive,createdAt,scopeType,scopeBuildingId,scopeStairwellId);

@override
String toString() {
  return 'Announcement(id: $id, title: $title, content: $content, authorId: $authorId, authorName: $authorName, authorRole: $authorRole, targetLabel: $targetLabel, estateId: $estateId, expiresAt: $expiresAt, isActive: $isActive, createdAt: $createdAt, scopeType: $scopeType, scopeBuildingId: $scopeBuildingId, scopeStairwellId: $scopeStairwellId)';
}


}

/// @nodoc
abstract mixin class _$AnnouncementCopyWith<$Res> implements $AnnouncementCopyWith<$Res> {
  factory _$AnnouncementCopyWith(_Announcement value, $Res Function(_Announcement) _then) = __$AnnouncementCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String content, String? authorId, String? authorName, String? authorRole, String? targetLabel, String? estateId, DateTime? expiresAt, bool isActive, DateTime? createdAt, String scopeType, String? scopeBuildingId, String? scopeStairwellId
});




}
/// @nodoc
class __$AnnouncementCopyWithImpl<$Res>
    implements _$AnnouncementCopyWith<$Res> {
  __$AnnouncementCopyWithImpl(this._self, this._then);

  final _Announcement _self;
  final $Res Function(_Announcement) _then;

/// Create a copy of Announcement
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? content = null,Object? authorId = freezed,Object? authorName = freezed,Object? authorRole = freezed,Object? targetLabel = freezed,Object? estateId = freezed,Object? expiresAt = freezed,Object? isActive = null,Object? createdAt = freezed,Object? scopeType = null,Object? scopeBuildingId = freezed,Object? scopeStairwellId = freezed,}) {
  return _then(_Announcement(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,authorId: freezed == authorId ? _self.authorId : authorId // ignore: cast_nullable_to_non_nullable
as String?,authorName: freezed == authorName ? _self.authorName : authorName // ignore: cast_nullable_to_non_nullable
as String?,authorRole: freezed == authorRole ? _self.authorRole : authorRole // ignore: cast_nullable_to_non_nullable
as String?,targetLabel: freezed == targetLabel ? _self.targetLabel : targetLabel // ignore: cast_nullable_to_non_nullable
as String?,estateId: freezed == estateId ? _self.estateId : estateId // ignore: cast_nullable_to_non_nullable
as String?,expiresAt: freezed == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime?,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,scopeType: null == scopeType ? _self.scopeType : scopeType // ignore: cast_nullable_to_non_nullable
as String,scopeBuildingId: freezed == scopeBuildingId ? _self.scopeBuildingId : scopeBuildingId // ignore: cast_nullable_to_non_nullable
as String?,scopeStairwellId: freezed == scopeStairwellId ? _self.scopeStairwellId : scopeStairwellId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
