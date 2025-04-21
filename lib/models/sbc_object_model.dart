import 'package:json_annotation/json_annotation.dart';

part 'sbc_object_model.g.dart';

@JsonSerializable()
class SbcDevice {
  String uuid;

  @JsonKey(name: 'public_key')
  String publicKey;

  @JsonKey(name: 'socket_addresses')
  Map<String, dynamic> socketAddresses;

  @JsonKey(name: 'derp_region')
  int derpRegion;

  @JsonKey(name: 'latest_active_at')
  int latestActiveAt;

  bool online;

  String label;

  SbcDevice(this.uuid, this.publicKey, this.socketAddresses, this.derpRegion, this.latestActiveAt, this.online, this.label);

  factory SbcDevice.fromJson(Map<String, dynamic> json) => _$SbcDeviceFromJson(json);

  Map<String, dynamic> toJson() => _$SbcDeviceToJson(this);
}