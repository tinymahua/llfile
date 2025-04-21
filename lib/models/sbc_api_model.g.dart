// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sbc_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SbcDeviceRegisterRequest _$SbcDeviceRegisterRequestFromJson(
        Map<String, dynamic> json) =>
    SbcDeviceRegisterRequest(
      json['public_key'] as String,
      json['socket_addresses'] as Map<String, dynamic>,
      (json['derp_region'] as num).toInt(),
      (json['latest_active_at'] as num).toInt(),
      json['label'] as String,
    );

Map<String, dynamic> _$SbcDeviceRegisterRequestToJson(
        SbcDeviceRegisterRequest instance) =>
    <String, dynamic>{
      'public_key': instance.publicKey,
      'socket_addresses': instance.socketAddresses,
      'derp_region': instance.derpRegion,
      'latest_active_at': instance.latestActiveAt,
      'label': instance.label,
    };

SbcDeviceRegisterResponse _$SbcDeviceRegisterResponseFromJson(
        Map<String, dynamic> json) =>
    SbcDeviceRegisterResponse(
      json['id'] as String,
      json['public_key'] as String,
    );

Map<String, dynamic> _$SbcDeviceRegisterResponseToJson(
        SbcDeviceRegisterResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'public_key': instance.publicKey,
    };

SbcDeviceListRequest _$SbcDeviceListRequestFromJson(
        Map<String, dynamic> json) =>
    SbcDeviceListRequest(
      (json['page'] as num).toInt(),
      (json['size'] as num).toInt(),
    );

Map<String, dynamic> _$SbcDeviceListRequestToJson(
        SbcDeviceListRequest instance) =>
    <String, dynamic>{
      'page': instance.page,
      'size': instance.size,
    };

SbcDeviceListResponse _$SbcDeviceListResponseFromJson(
        Map<String, dynamic> json) =>
    SbcDeviceListResponse(
      (json['results'] as List<dynamic>)
          .map((e) => SbcDevice.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SbcDeviceListResponseToJson(
        SbcDeviceListResponse instance) =>
    <String, dynamic>{
      'results': instance.results,
    };
