// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sbc_auth_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SbcRegisterRequest _$SbcRegisterRequestFromJson(Map<String, dynamic> json) =>
    SbcRegisterRequest(
      json['email'] as String?,
      json['assist_email'] as String?,
      json['master_key_encrypted'] as String?,
      json['private_key_encrypted'] as String?,
      json['public_key'] as String?,
    );

Map<String, dynamic> _$SbcRegisterRequestToJson(SbcRegisterRequest instance) =>
    <String, dynamic>{
      'email': instance.email,
      'assist_email': instance.assistEmail,
      'master_key_encrypted': instance.masterKeyEncrypted,
      'private_key_encrypted': instance.privateKeyEncrypted,
      'public_key': instance.publicKey,
    };

SbcRegisterResponse _$SbcRegisterResponseFromJson(Map<String, dynamic> json) =>
    SbcRegisterResponse(
      json['uid'] as String?,
      json['email'] as String?,
      json['public_key'] as String?,
      json['access_token_encrypted'] as String?,
      json['private_key_encrypted'] as String?,
      json['master_key_encrypted'] as String?,
      json['fernet_key_encrypted'] as String?,
      json['server_public_key'] as String?,
    );

Map<String, dynamic> _$SbcRegisterResponseToJson(
        SbcRegisterResponse instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'email': instance.email,
      'public_key': instance.publicKey,
      'access_token_encrypted': instance.accessTokenEncrypted,
      'private_key_encrypted': instance.privateKeyEncrypted,
      'master_key_encrypted': instance.masterKeyEncrypted,
      'fernet_key_encrypted': instance.fernetKeyEncrypted,
      'server_public_key': instance.serverPublicKey,
    };

SbcLoginRequest _$SbcLoginRequestFromJson(Map<String, dynamic> json) =>
    SbcLoginRequest(
      json['email'] as String?,
    );

Map<String, dynamic> _$SbcLoginRequestToJson(SbcLoginRequest instance) =>
    <String, dynamic>{
      'email': instance.email,
    };
