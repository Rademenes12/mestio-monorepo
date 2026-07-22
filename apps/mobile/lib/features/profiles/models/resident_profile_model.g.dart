// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'resident_profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ResidentProfileModel _$ResidentProfileModelFromJson(
  Map<String, dynamic> json,
) => _ResidentProfileModel(
  name: json['name'] as String? ?? '',
  email: json['email'] as String? ?? '',
  phone: json['phone'] as String? ?? '',
  verificationCode: json['verification_code'] as String? ?? '',
  building: json['building'] as String? ?? '',
  footbridge: json['footbridge'] as String? ?? '',
  floor: json['floor'] as String? ?? '',
  apartment: json['apartment'] as String? ?? '',
  isVerified: json['is_verified'] as bool? ?? false,
  role: json['role'] as String? ?? 'Mieszkaniec',
  companyName: json['company_name'] as String? ?? '',
  termsAcceptedAt: json['terms_accepted_at'] == null
      ? null
      : DateTime.parse(json['terms_accepted_at'] as String),
);

Map<String, dynamic> _$ResidentProfileModelToJson(
  _ResidentProfileModel instance,
) => <String, dynamic>{
  'name': instance.name,
  'email': instance.email,
  'phone': instance.phone,
  'verification_code': instance.verificationCode,
  'building': instance.building,
  'footbridge': instance.footbridge,
  'floor': instance.floor,
  'apartment': instance.apartment,
  'is_verified': instance.isVerified,
  'role': instance.role,
  'company_name': instance.companyName,
  'terms_accepted_at': instance.termsAcceptedAt?.toIso8601String(),
};
