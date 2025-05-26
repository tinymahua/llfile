// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sbn_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SandbarFsAddPathProgressFound _$SandbarFsAddPathProgressFoundFromJson(
        Map<String, dynamic> json) =>
    SandbarFsAddPathProgressFound(
      (json['id'] as num).toInt(),
      json['name'] as String,
      (json['size'] as num).toInt(),
    );

Map<String, dynamic> _$SandbarFsAddPathProgressFoundToJson(
        SandbarFsAddPathProgressFound instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'size': instance.size,
    };

SandbarFsAddPathProgressProgress _$SandbarFsAddPathProgressProgressFromJson(
        Map<String, dynamic> json) =>
    SandbarFsAddPathProgressProgress(
      (json['id'] as num).toInt(),
      (json['offset'] as num).toInt(),
    );

Map<String, dynamic> _$SandbarFsAddPathProgressProgressToJson(
        SandbarFsAddPathProgressProgress instance) =>
    <String, dynamic>{
      'id': instance.id,
      'offset': instance.offset,
    };

SandbarFsAddPathProgressDone _$SandbarFsAddPathProgressDoneFromJson(
        Map<String, dynamic> json) =>
    SandbarFsAddPathProgressDone(
      (json['id'] as num).toInt(),
      json['hash'] as String,
    );

Map<String, dynamic> _$SandbarFsAddPathProgressDoneToJson(
        SandbarFsAddPathProgressDone instance) =>
    <String, dynamic>{
      'id': instance.id,
      'hash': instance.hash,
    };

SandbarFsAddPathProgressAllDone _$SandbarFsAddPathProgressAllDoneFromJson(
        Map<String, dynamic> json) =>
    SandbarFsAddPathProgressAllDone(
      json['hash'] as String,
      json['format'] as String,
      (json['tag'] as List<dynamic>).map((e) => (e as num).toInt()).toList(),
    );

Map<String, dynamic> _$SandbarFsAddPathProgressAllDoneToJson(
        SandbarFsAddPathProgressAllDone instance) =>
    <String, dynamic>{
      'hash': instance.hash,
      'format': instance.format,
      'tag': instance.tag,
    };

SandbarFsAddPathProgressAbort _$SandbarFsAddPathProgressAbortFromJson(
        Map<String, dynamic> json) =>
    SandbarFsAddPathProgressAbort(
      json['error'] as String,
    );

Map<String, dynamic> _$SandbarFsAddPathProgressAbortToJson(
        SandbarFsAddPathProgressAbort instance) =>
    <String, dynamic>{
      'error': instance.error,
    };
