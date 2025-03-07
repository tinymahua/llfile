
import 'package:json_annotation/json_annotation.dart';

part 'common_model.g.dart';


class BaseEmptyModel{
  BaseEmptyModel();

  toJson()=>{};
}

class BaseEntityModel extends BaseEmptyModel {
  final String id;

  BaseEntityModel({
    required this.id});
}


@JsonSerializable()
class ErrorResponse{

  @JsonKey(name: 'eid')
  final String eId;

  @JsonKey(name: 'eval')
  final String eVal;

  ErrorResponse({required this.eId, required this.eVal});

  factory ErrorResponse.fromJson(Map<String, dynamic> json) => _$ErrorResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ErrorResponseToJson(this);
}


@JsonSerializable()
class SuccessResponse {
  SuccessResponse();
  
  factory SuccessResponse.fromJson(Map<String, dynamic> json) => _$SuccessResponseFromJson(json);
  
  Map<String, dynamic> toJson() => _$SuccessResponseToJson(this);
}