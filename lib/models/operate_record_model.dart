import 'package:json_annotation/json_annotation.dart';

part 'operate_record_model.g.dart';


enum OperateTargetType {
  file,
  dir,
}

enum OperateType {
  copy,
  cut,
  delete,
}

@JsonSerializable()
class OperateRecord {

  @JsonKey(name: 'type')
  OperateType type;
  @JsonKey(name: 'target_type')
  OperateTargetType targetType;
  @JsonKey(name: 'target_path')
  String targetPath;

  bool done;

  OperateRecord({required this.type, required this.targetType, required this.targetPath, this.done = false});

  factory OperateRecord.fromJson(Map<String, dynamic> json) => _$OperateRecordFromJson(json);

  Map<String, dynamic> toJson() => _$OperateRecordToJson(this);
}