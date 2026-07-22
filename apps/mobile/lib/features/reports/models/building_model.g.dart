// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'building_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BuildingModel _$BuildingModelFromJson(Map<String, dynamic> json) =>
    _BuildingModel(
      id: json['id'] as String,
      name: json['name'] as String,
      address: json['address'] as String?,
      buildingType: json['building_type'] as String? ?? 'residential',
      displayOrder: (json['display_order'] as num?)?.toInt() ?? 0,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$BuildingModelToJson(_BuildingModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'address': instance.address,
      'building_type': instance.buildingType,
      'display_order': instance.displayOrder,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };

_StairwellModel _$StairwellModelFromJson(Map<String, dynamic> json) =>
    _StairwellModel(
      id: json['id'] as String,
      buildingId: json['building_id'] as String,
      name: json['name'] as String,
      floorMin: (json['floor_min'] as num?)?.toInt() ?? 0,
      floorMax: (json['floor_max'] as num?)?.toInt() ?? 4,
      garageEntranceLabel: json['garage_entrance_label'] as String?,
      displayOrder: (json['display_order'] as num?)?.toInt() ?? 0,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$StairwellModelToJson(_StairwellModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'building_id': instance.buildingId,
      'name': instance.name,
      'floor_min': instance.floorMin,
      'floor_max': instance.floorMax,
      'garage_entrance_label': instance.garageEntranceLabel,
      'display_order': instance.displayOrder,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
