// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'path_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PathHistories _$PathHistoriesFromJson(Map<String, dynamic> json) =>
    PathHistories(
      (json['histories'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$PathHistoriesToJson(PathHistories instance) =>
    <String, dynamic>{
      'histories': instance.histories,
    };
