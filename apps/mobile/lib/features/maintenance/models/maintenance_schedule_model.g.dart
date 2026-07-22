// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'maintenance_schedule_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MaintenanceSchedule _$MaintenanceScheduleFromJson(Map<String, dynamic> json) =>
    _MaintenanceSchedule(
      id: json['id'] as String,
      estateId: json['estate_id'] as String,
      buildingId: json['building_id'] as String?,
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
      frequencyDays: (json['frequency_days'] as num).toInt(),
      lastPerformed: json['last_performed'] == null
          ? null
          : DateTime.parse(json['last_performed'] as String),
      nextDueDate: DateTime.parse(json['next_due_date'] as String),
    );

Map<String, dynamic> _$MaintenanceScheduleToJson(
  _MaintenanceSchedule instance,
) => <String, dynamic>{
  'id': instance.id,
  'estate_id': instance.estateId,
  'building_id': instance.buildingId,
  'name': instance.name,
  'description': instance.description,
  'frequency_days': instance.frequencyDays,
  'last_performed': instance.lastPerformed?.toIso8601String(),
  'next_due_date': instance.nextDueDate.toIso8601String(),
};
