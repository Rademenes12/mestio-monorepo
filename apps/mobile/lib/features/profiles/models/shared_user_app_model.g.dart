// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shared_user_app_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SharedUserAppModel _$SharedUserAppModelFromJson(Map<String, dynamic> json) =>
    _SharedUserAppModel(
      appId: json['app_id'] as String,
      appName: json['app_name'] as String,
      lastSeenAt: DateTime.parse(json['last_seen_at'] as String),
    );

Map<String, dynamic> _$SharedUserAppModelToJson(_SharedUserAppModel instance) =>
    <String, dynamic>{
      'app_id': instance.appId,
      'app_name': instance.appName,
      'last_seen_at': instance.lastSeenAt.toIso8601String(),
    };
