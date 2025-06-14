// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fs_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FileIcon _$FileIconFromJson(Map<String, dynamic> json) => FileIcon(
      extName: json['ext_name'] as String,
      resource: json['resource'] as String,
    );

Map<String, dynamic> _$FileIconToJson(FileIcon instance) => <String, dynamic>{
      'ext_name': instance.extName,
      'resource': instance.resource,
    };

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
      errorOccurred: json['errorOccurred'] as bool? ?? false,
      error: json['error'] == null
          ? null
          : FsError.fromJson(json['error'] as Map<String, dynamic>),
      done: json['done'] as bool? ?? false,
    );

Map<String, dynamic> _$FileDataProcessProgressToJson(
        FileDataProcessProgress instance) =>
    <String, dynamic>{
      'percent': instance.percent,
      'totalBytes': instance.totalBytes,
      'processedBytes': instance.processedBytes,
      'time': instance.time.toIso8601String(),
      'errorOccurred': instance.errorOccurred,
      'error': instance.error,
      'done': instance.done,
    };

FsFavoriteDir _$FsFavoriteDirFromJson(Map<String, dynamic> json) =>
    FsFavoriteDir(
      path: json['path'] as String,
      name: json['name'] as String,
    );

Map<String, dynamic> _$FsFavoriteDirToJson(FsFavoriteDir instance) =>
    <String, dynamic>{
      'path': instance.path,
      'name': instance.name,
    };
