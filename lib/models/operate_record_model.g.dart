// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'operate_record_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OperateRecord _$OperateRecordFromJson(Map<String, dynamic> json) =>
    OperateRecord(
      type: $enumDecode(_$OperateTypeEnumMap, json['type']),
      targetType: $enumDecode(_$OperateTargetTypeEnumMap, json['target_type']),
      targetPath: json['target_path'] as String,
      done: json['done'] as bool? ?? false,
    );

Map<String, dynamic> _$OperateRecordToJson(OperateRecord instance) =>
    <String, dynamic>{
      'type': _$OperateTypeEnumMap[instance.type]!,
      'target_type': _$OperateTargetTypeEnumMap[instance.targetType]!,
      'target_path': instance.targetPath,
      'done': instance.done,
    };

const _$OperateTypeEnumMap = {
  OperateType.copy: 'copy',
  OperateType.cut: 'cut',
  OperateType.delete: 'delete',
};

const _$OperateTargetTypeEnumMap = {
  OperateTargetType.file: 'file',
  OperateTargetType.dir: 'dir',
};
