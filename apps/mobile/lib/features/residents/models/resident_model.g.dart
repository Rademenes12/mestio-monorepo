// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'resident_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ResidentModel _$ResidentModelFromJson(Map<String, dynamic> json) =>
    _ResidentModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      buildingId: json['buildingId'] as String?,
      stairwellId: json['stairwellId'] as String?,
      apartmentNumber: json['apartmentNumber'] as String?,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      phone: json['phone'] as String?,
      email: json['email'] as String,
      registeredAt: json['registeredAt'] == null
          ? null
          : DateTime.parse(json['registeredAt'] as String),
      invitationCodeUsed: json['invitationCodeUsed'] as String?,
      isActive: json['isActive'] as bool? ?? true,
      building: json['building'] as String?,
      footbridge: json['footbridge'] as String?,
      floor: json['floor'] as String?,
    );

Map<String, dynamic> _$ResidentModelToJson(_ResidentModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'buildingId': instance.buildingId,
      'stairwellId': instance.stairwellId,
      'apartmentNumber': instance.apartmentNumber,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'phone': instance.phone,
      'email': instance.email,
      'registeredAt': instance.registeredAt?.toIso8601String(),
      'invitationCodeUsed': instance.invitationCodeUsed,
      'isActive': instance.isActive,
      'building': instance.building,
      'footbridge': instance.footbridge,
      'floor': instance.floor,
    };
