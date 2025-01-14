// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_config_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppearanceConfig _$AppearanceConfigFromJson(Map<String, dynamic> json) =>
    AppearanceConfig(
      themeMode: $enumDecode(_$ThemeModeEnumMap, json['theme_mode']),
    );

Map<String, dynamic> _$AppearanceConfigToJson(AppearanceConfig instance) =>
    <String, dynamic>{
      'theme_mode': _$ThemeModeEnumMap[instance.themeMode]!,
    };

const _$ThemeModeEnumMap = {
  ThemeMode.system: 'system',
  ThemeMode.light: 'light',
  ThemeMode.dark: 'dark',
};

AppConfig _$AppConfigFromJson(Map<String, dynamic> json) => AppConfig(
      fileIcons: (json['file_icons'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, FileIcon.fromJson(e as Map<String, dynamic>)),
      ),
      appearance:
          AppearanceConfig.fromJson(json['appearance'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AppConfigToJson(AppConfig instance) => <String, dynamic>{
      'file_icons': instance.fileIcons,
      'appearance': instance.appearance,
    };
