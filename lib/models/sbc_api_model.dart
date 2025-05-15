import 'package:pal_dio_util/pal_dio_util.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:llfile/models/common_model.dart';
import 'package:llfile/models/sbc_object_model.dart';

part 'sbc_api_model.g.dart';


@JsonSerializable()
class SbcDeviceRegisterRequest extends BaseRequest{

  @JsonKey(name: 'public_key')
  String publicKey;

  @JsonKey(name: 'socket_addresses')
  Map<String, dynamic> socketAddresses;

  @JsonKey(name: 'derp_region')
  int derpRegion;

  @JsonKey(name: 'latest_active_at')
  int latestActiveAt;

  String label;

  SbcDeviceRegisterRequest(this.publicKey, this.socketAddresses, this.derpRegion, this.latestActiveAt, this.label);

  factory SbcDeviceRegisterRequest.fromJson(Map<String, dynamic> json) => _$SbcDeviceRegisterRequestFromJson(json);

  Map<String, dynamic> toJson() => _$SbcDeviceRegisterRequestToJson(this);
}

@JsonSerializable()
class SbcDeviceRegisterResponse extends BaseEmptyModel{

  String id;

  @JsonKey(name: 'public_key')
  String publicKey;

  SbcDeviceRegisterResponse(this.id, this.publicKey);

  factory SbcDeviceRegisterResponse.fromJson(Map<String, dynamic> json) => _$SbcDeviceRegisterResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SbcDeviceRegisterResponseToJson(this);
}

@JsonSerializable()
class SbcDeviceListRequest extends BaseRequest{
  SbcDeviceListRequest(this.page, this.size);

  int page;

  int size;

  factory SbcDeviceListRequest.fromJson(Map<String, dynamic> json) => _$SbcDeviceListRequestFromJson(json);

  Map<String, dynamic> toJson() => _$SbcDeviceListRequestToJson(this);
}

@JsonSerializable()
class SbcDeviceListResponse extends BaseEmptyModel{

  List<SbcDevice> results;

  SbcDeviceListResponse(this.results);

  factory SbcDeviceListResponse.fromJson(Map<String, dynamic> json) => _$SbcDeviceListResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SbcDeviceListResponseToJson(this);
}