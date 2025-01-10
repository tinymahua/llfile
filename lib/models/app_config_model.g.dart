// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_config_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppConfig _$AppConfigFromJson(Map<String, dynamic> json) => AppConfig(
      fileIcons: (json['file_icons'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, FileIcon.fromJson(e as Map<String, dynamic>)),
      ),
    );

Map<String, dynamic> _$AppConfigToJson(AppConfig instance) => <String, dynamic>{
      'file_icons': instance.fileIcons,
    };
