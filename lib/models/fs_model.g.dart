// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fs_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FsError _$FsErrorFromJson(Map<String, dynamic> json) => FsError(
      path: json['path'] as String,
      desc: json['desc'] as String,
    );

Map<String, dynamic> _$FsErrorToJson(FsError instance) => <String, dynamic>{
      'path': instance.path,
      'desc': instance.desc,
    };

FileDataProcessProgress _$FileDataProcessProgressFromJson(
        Map<String, dynamic> json) =>
    FileDataProcessProgress(
      percent: (json['percent'] as num).toInt(),
      totalBytes: (json['totalBytes'] as num).toInt(),
      processedBytes: (json['processedBytes'] as num).toInt(),
      time: DateTime.parse(json['time'] as String),
    );

Map<String, dynamic> _$FileDataProcessProgressToJson(
        FileDataProcessProgress instance) =>
    <String, dynamic>{
      'percent': instance.percent,
      'totalBytes': instance.totalBytes,
      'processedBytes': instance.processedBytes,
      'time': instance.time.toIso8601String(),
    };
