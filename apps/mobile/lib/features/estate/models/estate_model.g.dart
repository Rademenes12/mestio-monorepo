// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'estate_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Estate _$EstateFromJson(Map<String, dynamic> json) => _Estate(
  id: json['id'] as String,
  name: json['name'] as String,
  role: json['role'] as String? ?? 'resident',
  companyName: json['company_name'] as String?,
  adminName: json['admin_name'] as String?,
  adminEmail: json['admin_email'] as String?,
  adminPhone: json['admin_phone'] as String?,
  hideResidentContacts: json['hide_resident_contacts'] as bool? ?? false,
);

Map<String, dynamic> _$EstateToJson(_Estate instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'role': instance.role,
  'company_name': instance.companyName,
  'admin_name': instance.adminName,
  'admin_email': instance.adminEmail,
  'admin_phone': instance.adminPhone,
  'hide_resident_contacts': instance.hideResidentContacts,
};
