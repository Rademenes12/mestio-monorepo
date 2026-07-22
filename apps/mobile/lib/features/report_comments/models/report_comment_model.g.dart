// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_comment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ReportComment _$ReportCommentFromJson(Map<String, dynamic> json) =>
    _ReportComment(
      id: json['id'] as String,
      reportId: json['report_id'] as String,
      userId: json['user_id'] as String?,
      authorName: json['author_name'] as String?,
      authorRole: json['author_role'] as String?,
      comment: json['comment'] as String,
      isInternal: json['is_internal'] as bool? ?? false,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$ReportCommentToJson(_ReportComment instance) =>
    <String, dynamic>{
      'id': instance.id,
      'report_id': instance.reportId,
      'user_id': instance.userId,
      'author_name': instance.authorName,
      'author_role': instance.authorRole,
      'comment': instance.comment,
      'is_internal': instance.isInternal,
      'created_at': instance.createdAt?.toIso8601String(),
    };
