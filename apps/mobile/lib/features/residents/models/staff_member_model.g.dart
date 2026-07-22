// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'staff_member_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_StaffMemberModel _$StaffMemberModelFromJson(Map<String, dynamic> json) =>
    _StaffMemberModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      role: json['role'] as String,
    );

Map<String, dynamic> _$StaffMemberModelToJson(_StaffMemberModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'role': instance.role,
    };
