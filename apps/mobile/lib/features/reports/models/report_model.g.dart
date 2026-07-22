// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ReportModel _$ReportModelFromJson(Map<String, dynamic> json) => _ReportModel(
  id: json['id'] as String,
  displayId: json['display_id'] as String?,
  title: json['title'] as String,
  description: json['description'] as String,
  category: json['category'] as String,
  reporterName: json['reporter_name'] as String? ?? '',
  reporterEmail: json['reporter_email'] as String? ?? '',
  reporterBuilding: json['reporter_building'] as String? ?? '',
  reporterFootbridge: json['reporter_footbridge'] as String? ?? '',
  reporterFloor: json['reporter_floor'] as String? ?? '',
  reporterApartment: json['reporter_apartment'] as String? ?? '',
  status: json['status'] as String? ?? 'Nowe',
  statusEnum: json['status_enum'] as String?,
  timestamp: (json['timestamp'] as num).toInt(),
  estateId: json['estate_id'] as String,
  photoPath: json['photo_path'] as String?,
  latitude: (json['latitude'] as num?)?.toDouble(),
  longitude: (json['longitude'] as num?)?.toDouble(),
  additionalInfo: json['additional_info'] as String?,
  assignedTo: json['assigned_to'] as String?,
  assignedToUserId: json['assigned_to_user_id'] as String?,
  assignedToName: json['assigned_to_name'] as String?,
  assignedToRole: json['assigned_to_role'] as String?,
  boardNotes: json['board_notes'] as String?,
  techNotes: json['tech_notes'] as String?,
  attachmentsJson: json['attachments_json'] as String?,
  revealBoardNotesToTech: json['reveal_board_notes_to_tech'] as bool? ?? false,
  priority: json['priority'] as String? ?? 'normal',
  slaDeadline: json['sla_deadline'] as String?,
  csatRating: (json['csat_rating'] as num?)?.toInt(),
  auditTrail: (json['audit_trail'] as List<dynamic>?)
      ?.map((e) => e as Map<String, dynamic>)
      .toList(),
);

Map<String, dynamic> _$ReportModelToJson(_ReportModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'display_id': instance.displayId,
      'title': instance.title,
      'description': instance.description,
      'category': instance.category,
      'reporter_name': instance.reporterName,
      'reporter_email': instance.reporterEmail,
      'reporter_building': instance.reporterBuilding,
      'reporter_footbridge': instance.reporterFootbridge,
      'reporter_floor': instance.reporterFloor,
      'reporter_apartment': instance.reporterApartment,
      'status': instance.status,
      'status_enum': instance.statusEnum,
      'timestamp': instance.timestamp,
      'estate_id': instance.estateId,
      'photo_path': instance.photoPath,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'additional_info': instance.additionalInfo,
      'assigned_to': instance.assignedTo,
      'assigned_to_user_id': instance.assignedToUserId,
      'assigned_to_name': instance.assignedToName,
      'assigned_to_role': instance.assignedToRole,
      'board_notes': instance.boardNotes,
      'tech_notes': instance.techNotes,
      'attachments_json': instance.attachmentsJson,
      'reveal_board_notes_to_tech': instance.revealBoardNotesToTech,
      'priority': instance.priority,
      'sla_deadline': instance.slaDeadline,
      'csat_rating': instance.csatRating,
      'audit_trail': instance.auditTrail,
    };
