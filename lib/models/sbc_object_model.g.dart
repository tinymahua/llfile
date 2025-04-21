// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sbc_object_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SbcDevice _$SbcDeviceFromJson(Map<String, dynamic> json) => SbcDevice(
      json['uuid'] as String,
      json['public_key'] as String,
      json['socket_addresses'] as Map<String, dynamic>,
      (json['derp_region'] as num).toInt(),
      (json['latest_active_at'] as num).toInt(),
      json['online'] as bool,
      json['label'] as String,
    );

Map<String, dynamic> _$SbcDeviceToJson(SbcDevice instance) => <String, dynamic>{
      'uuid': instance.uuid,
      'public_key': instance.publicKey,
      'socket_addresses': instance.socketAddresses,
      'derp_region': instance.derpRegion,
      'latest_active_at': instance.latestActiveAt,
      'online': instance.online,
      'label': instance.label,
    };
