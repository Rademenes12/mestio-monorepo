// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'resident_space_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ResidentSpaceModel _$ResidentSpaceModelFromJson(Map<String, dynamic> json) =>
    _ResidentSpaceModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      estateId: json['estate_id'] as String,
      type: json['type'] as String,
      label: json['label'] as String,
      createdBy: json['created_by'] as String? ?? 'resident',
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$ResidentSpaceModelToJson(_ResidentSpaceModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'estate_id': instance.estateId,
      'type': instance.type,
      'label': instance.label,
      'created_by': instance.createdBy,
      'created_at': instance.createdAt?.toIso8601String(),
    };
