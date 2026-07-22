// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'announcement_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Announcement _$AnnouncementFromJson(Map<String, dynamic> json) =>
    _Announcement(
      id: json['id'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      authorId: json['author_id'] as String?,
      authorName: json['author_name'] as String?,
      authorRole: json['author_role'] as String?,
      targetLabel: json['target_label'] as String?,
      estateId: json['estate_id'] as String?,
      expiresAt: json['expires_at'] == null
          ? null
          : DateTime.parse(json['expires_at'] as String),
      isActive: json['is_active'] as bool? ?? true,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      scopeType: json['scope_type'] as String? ?? 'estate',
      scopeBuildingId: json['scope_building_id'] as String?,
      scopeStairwellId: json['scope_stairwell_id'] as String?,
    );

Map<String, dynamic> _$AnnouncementToJson(_Announcement instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'content': instance.content,
      'author_id': instance.authorId,
      'author_name': instance.authorName,
      'author_role': instance.authorRole,
      'target_label': instance.targetLabel,
      'estate_id': instance.estateId,
      'expires_at': instance.expiresAt?.toIso8601String(),
      'is_active': instance.isActive,
      'created_at': instance.createdAt?.toIso8601String(),
      'scope_type': instance.scopeType,
      'scope_building_id': instance.scopeBuildingId,
      'scope_stairwell_id': instance.scopeStairwellId,
    };
