// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'resolution_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Resolution _$ResolutionFromJson(Map<String, dynamic> json) => _Resolution(
  id: json['id'] as String,
  title: json['title'] as String,
  description: json['description'] as String?,
  status: json['status'] as String? ?? 'open',
  deadline: json['deadline'] == null
      ? null
      : DateTime.parse(json['deadline'] as String),
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
  closedAt: json['closed_at'] == null
      ? null
      : DateTime.parse(json['closed_at'] as String),
  votesFor: (json['votes_for'] as num?)?.toInt(),
  votesAgainst: (json['votes_against'] as num?)?.toInt(),
  myVote: json['my_vote'] as String?,
);

Map<String, dynamic> _$ResolutionToJson(_Resolution instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'status': instance.status,
      'deadline': instance.deadline?.toIso8601String(),
      'created_at': instance.createdAt?.toIso8601String(),
      'closed_at': instance.closedAt?.toIso8601String(),
      'votes_for': instance.votesFor,
      'votes_against': instance.votesAgainst,
      'my_vote': instance.myVote,
    };
