import 'package:dio_util/dio_util.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:llfile/models/common_model.dart';

part 'sbc_auth_model.g.dart';

@JsonSerializable()
class SbcRegisterRequest extends BaseRequest{
  SbcRegisterRequest(this.email, this.assistEmail, this.masterKeyEncrypted, this.privateKeyEncrypted, this.publicKey);

  @JsonKey(name: 'email')
  String? email;

  @JsonKey(name: 'assist_email')
  String? assistEmail;

  @JsonKey(name: 'master_key_encrypted')
  String? masterKeyEncrypted;

  @JsonKey(name: 'private_key_encrypted')
  String? privateKeyEncrypted;

  @JsonKey(name: 'public_key')
  String? publicKey;
  
  factory SbcRegisterRequest.fromJson(Map<String, dynamic> json) => _$SbcRegisterRequestFromJson(json);
  
  Map<String, dynamic> toJson() => _$SbcRegisterRequestToJson(this);
}

@JsonSerializable()
class SbcRegisterResponse extends BaseEmptyModel{
  SbcRegisterResponse(this.uid, this.email, this.publicKey, this.accessTokenEncrypted, this.privateKeyEncrypted, this.masterKeyEncrypted, this.fernetKeyEncrypted, this.serverPublicKey);

  @JsonKey(name: 'uid')
  String? uid;

  @JsonKey(name: 'email')
  String? email;

  @JsonKey(name: 'public_key')
  String? publicKey;

  @JsonKey(name: 'access_token_encrypted')
  String? accessTokenEncrypted;

  @JsonKey(name: 'private_key_encrypted')
  String? privateKeyEncrypted;

  @JsonKey(name: 'master_key_encrypted')
  String? masterKeyEncrypted;

  @JsonKey(name: 'fernet_key_encrypted')
  String? fernetKeyEncrypted;

  @JsonKey(name: 'server_public_key')
  String? serverPublicKey;

  factory SbcRegisterResponse.fromJson(Map<String, dynamic> json) => _$SbcRegisterResponseFromJson(json);
  
  Map<String, dynamic> toJson() => _$SbcRegisterResponseToJson(this);
}


@JsonSerializable()
class SbcLoginRequest extends BaseRequest{
  SbcLoginRequest(this.email);

  @JsonKey(name: 'email')
  String? email;

  factory SbcLoginRequest.fromJson(Map<String, dynamic> json) => _$SbcLoginRequestFromJson(json);

  Map<String, dynamic> toJson() => _$SbcLoginRequestToJson(this);
}


typedef SbcLoginResponse = SbcRegisterResponse;