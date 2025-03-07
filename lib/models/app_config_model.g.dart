// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_config_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppearanceConfig _$AppearanceConfigFromJson(Map<String, dynamic> json) =>
    AppearanceConfig(
      themeMode: $enumDecodeNullable(_$ThemeModeEnumMap, json['theme_mode']) ??
          ThemeMode.light,
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

LanguageConfig _$LanguageConfigFromJson(Map<String, dynamic> json) =>
    LanguageConfig(
      languageCode: json['languageCode'] as String,
      countryCode: json['countryCode'] as String,
    );

Map<String, dynamic> _$LanguageConfigToJson(LanguageConfig instance) =>
    <String, dynamic>{
      'languageCode': instance.languageCode,
      'countryCode': instance.countryCode,
    };

ConfigurationSaveLocationConfig _$ConfigurationSaveLocationConfigFromJson(
        Map<String, dynamic> json) =>
    ConfigurationSaveLocationConfig(
      directoryPath: json['directoryPath'] as String,
    );

Map<String, dynamic> _$ConfigurationSaveLocationConfigToJson(
        ConfigurationSaveLocationConfig instance) =>
    <String, dynamic>{
      'directoryPath': instance.directoryPath,
    };

FileDirectoryOptionsConfig _$FileDirectoryOptionsConfigFromJson(
        Map<String, dynamic> json) =>
    FileDirectoryOptionsConfig(
      listMode: $enumDecode(_$FileDirectoryListModeEnumMap, json['list_mode']),
      orderingFields: (json['ordering_fields'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      orderingMode: $enumDecode(_$OrderingModeEnumMap, json['ordering_mode']),
      groupEnabled: json['group_enabled'] as bool,
      groupField: json['group_field'] as String,
    );

Map<String, dynamic> _$FileDirectoryOptionsConfigToJson(
        FileDirectoryOptionsConfig instance) =>
    <String, dynamic>{
      'list_mode': _$FileDirectoryListModeEnumMap[instance.listMode]!,
      'ordering_fields': instance.orderingFields,
      'ordering_mode': _$OrderingModeEnumMap[instance.orderingMode]!,
      'group_enabled': instance.groupEnabled,
      'group_field': instance.groupField,
    };

const _$FileDirectoryListModeEnumMap = {
  FileDirectoryListMode.detailList: 'detailList',
  FileDirectoryListMode.simpleList: 'simpleList',
  FileDirectoryListMode.itemGrid: 'itemGrid',
  FileDirectoryListMode.multiColumn: 'multiColumn',
};

const _$OrderingModeEnumMap = {
  OrderingMode.asc: 'asc',
  OrderingMode.desc: 'desc',
};

KeyItem _$KeyItemFromJson(Map<String, dynamic> json) => KeyItem(
      key: json['key'] as String,
      label: json['label'] as String,
    );

Map<String, dynamic> _$KeyItemToJson(KeyItem instance) => <String, dynamic>{
      'key': instance.key,
      'label': instance.label,
    };

KeymapConfig _$KeymapConfigFromJson(Map<String, dynamic> json) => KeymapConfig(
      keyItems: (json['keyItems'] as List<dynamic>)
          .map((e) => KeyItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$KeymapConfigToJson(KeymapConfig instance) =>
    <String, dynamic>{
      'keyItems': instance.keyItems,
    };

PreferencesConfig _$PreferencesConfigFromJson(Map<String, dynamic> json) =>
    PreferencesConfig(
      language:
          LanguageConfig.fromJson(json['language'] as Map<String, dynamic>),
      configurationSaveLocation: ConfigurationSaveLocationConfig.fromJson(
          json['configurationSaveLocation'] as Map<String, dynamic>),
      fileDirectoryOptions: FileDirectoryOptionsConfig.fromJson(
          json['fileDirectoryOptions'] as Map<String, dynamic>),
      keymap: KeymapConfig.fromJson(json['keymap'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PreferencesConfigToJson(PreferencesConfig instance) =>
    <String, dynamic>{
      'language': instance.language,
      'configurationSaveLocation': instance.configurationSaveLocation,
      'fileDirectoryOptions': instance.fileDirectoryOptions,
      'keymap': instance.keymap,
    };

ExtensionsConfig _$ExtensionsConfigFromJson(Map<String, dynamic> json) =>
    ExtensionsConfig();

Map<String, dynamic> _$ExtensionsConfigToJson(ExtensionsConfig instance) =>
    <String, dynamic>{};

AdvancedSettingsConfig _$AdvancedSettingsConfigFromJson(
        Map<String, dynamic> json) =>
    AdvancedSettingsConfig();

Map<String, dynamic> _$AdvancedSettingsConfigToJson(
        AdvancedSettingsConfig instance) =>
    <String, dynamic>{};

SandbarAuthInfo _$SandbarAuthInfoFromJson(Map<String, dynamic> json) =>
    SandbarAuthInfo(
      json['email'] as String,
      json['accessToken'] as String,
      json['passwordHash'] as String,
      json['serverPublicKey'] as String,
      json['cbPublicKey'] as String,
      json['cbPrivateKey'] as String,
    );

Map<String, dynamic> _$SandbarAuthInfoToJson(SandbarAuthInfo instance) =>
    <String, dynamic>{
      'email': instance.email,
      'accessToken': instance.accessToken,
      'passwordHash': instance.passwordHash,
      'serverPublicKey': instance.serverPublicKey,
      'cbPublicKey': instance.cbPublicKey,
      'cbPrivateKey': instance.cbPrivateKey,
    };

AccountSettingsConfig _$AccountSettingsConfigFromJson(
        Map<String, dynamic> json) =>
    AccountSettingsConfig(
      sandbarAuthInfo: json['sandbarAuthInfo'] == null
          ? null
          : SandbarAuthInfo.fromJson(
              json['sandbarAuthInfo'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AccountSettingsConfigToJson(
        AccountSettingsConfig instance) =>
    <String, dynamic>{
      'sandbarAuthInfo': instance.sandbarAuthInfo,
    };

AppConfig _$AppConfigFromJson(Map<String, dynamic> json) => AppConfig(
      fileIcons: (json['file_icons'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, FileIcon.fromJson(e as Map<String, dynamic>)),
      ),
      appearance:
          AppearanceConfig.fromJson(json['appearance'] as Map<String, dynamic>),
      preferences: PreferencesConfig.fromJson(
          json['preferences'] as Map<String, dynamic>),
      extensions:
          ExtensionsConfig.fromJson(json['extensions'] as Map<String, dynamic>),
      advancedSettings: AdvancedSettingsConfig.fromJson(
          json['advancedSettings'] as Map<String, dynamic>),
      accountSettings: AccountSettingsConfig.fromJson(
          json['accountSettings'] as Map<String, dynamic>),
      sbcApiHost: json['sbcApiHost'] as String,
    );

Map<String, dynamic> _$AppConfigToJson(AppConfig instance) => <String, dynamic>{
      'file_icons': instance.fileIcons,
      'appearance': instance.appearance,
      'preferences': instance.preferences,
      'extensions': instance.extensions,
      'advancedSettings': instance.advancedSettings,
      'accountSettings': instance.accountSettings,
      'sbcApiHost': instance.sbcApiHost,
    };
