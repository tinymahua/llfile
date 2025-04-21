import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:llfile/models/fs_model.dart';
import 'package:llfile/models/sbc_object_model.dart';

part 'app_config_model.g.dart';

@JsonSerializable()
class AppearanceConfig {
  
  @JsonKey(name: 'theme_mode')
  ThemeMode themeMode;
  
  AppearanceConfig({
    this.themeMode = ThemeMode.light,
  });
  
  factory AppearanceConfig.fromJson(Map<String, dynamic> json) => _$AppearanceConfigFromJson(json);
  
  Map<String, dynamic> toJson() => _$AppearanceConfigToJson(this);

}

@JsonSerializable()
class LanguageConfig {

  String languageCode;
  String countryCode;

  LanguageConfig({required this.languageCode, required this.countryCode});

  factory LanguageConfig.fromJson(Map<String, dynamic> json) => _$LanguageConfigFromJson(json);

  Map<String, dynamic> toJson() => _$LanguageConfigToJson(this);
}

@JsonSerializable()
class ConfigurationSaveLocationConfig {

  String directoryPath;

  ConfigurationSaveLocationConfig({required this.directoryPath});

  factory ConfigurationSaveLocationConfig.fromJson(Map<String, dynamic> json) => _$ConfigurationSaveLocationConfigFromJson(json);

  Map<String, dynamic> toJson() => _$ConfigurationSaveLocationConfigToJson(this);
}

enum FileDirectoryListMode {
  detailList,
  simpleList,
  itemGrid,
  multiColumn, // macOS式分栏
}

enum OrderingMode {
  asc,
  desc,
}

@JsonSerializable()
class FileDirectoryOptionsConfig {

  @JsonKey(name: 'list_mode')
  FileDirectoryListMode listMode;
  @JsonKey(name: 'ordering_fields')
  List<String> orderingFields;
  @JsonKey(name: 'ordering_mode')
  OrderingMode orderingMode;
  @JsonKey(name: 'group_enabled')
  bool groupEnabled;
  @JsonKey(name: 'group_field')
  String groupField;

  FileDirectoryOptionsConfig({required this.listMode, required this.orderingFields, required this.orderingMode, required this.groupEnabled, required this.groupField});

  factory FileDirectoryOptionsConfig.fromJson(Map<String, dynamic> json) => _$FileDirectoryOptionsConfigFromJson(json);

  Map<String, dynamic> toJson() => _$FileDirectoryOptionsConfigToJson(this);
}


@JsonSerializable()
class KeyItem {
  String key;
  String label;

  KeyItem({required this.key, required this.label});

  factory KeyItem.fromJson(Map<String, dynamic> json) => _$KeyItemFromJson(json);

  Map<String, dynamic> toJson() => _$KeyItemToJson(this);
}

@JsonSerializable()
class KeymapConfig {

  List<KeyItem> keyItems;

  KeymapConfig({required this.keyItems});

  factory KeymapConfig.fromJson(Map<String, dynamic> json) => _$KeymapConfigFromJson(json);

  Map<String, dynamic> toJson() => _$KeymapConfigToJson(this);
}

@JsonSerializable()
class PreferencesConfig {

  LanguageConfig language;
  ConfigurationSaveLocationConfig configurationSaveLocation;
  FileDirectoryOptionsConfig fileDirectoryOptions;
  KeymapConfig keymap;

  PreferencesConfig({required this.language, required this.configurationSaveLocation, required this.fileDirectoryOptions, required this.keymap});

  factory PreferencesConfig.fromJson(Map<String, dynamic> json) => _$PreferencesConfigFromJson(json);

  Map<String, dynamic> toJson() => _$PreferencesConfigToJson(this);
}

@JsonSerializable()
class ExtensionsConfig {

  ExtensionsConfig();

  factory ExtensionsConfig.fromJson(Map<String, dynamic> json) => _$ExtensionsConfigFromJson(json);

  Map<String, dynamic> toJson() => _$ExtensionsConfigToJson(this);
}

@JsonSerializable()
class AdvancedSettingsConfig {
  AdvancedSettingsConfig();

  factory AdvancedSettingsConfig.fromJson(Map<String, dynamic> json) => _$AdvancedSettingsConfigFromJson(json);

  Map<String, dynamic> toJson() => _$AdvancedSettingsConfigToJson(this);
}

@JsonSerializable()
class SandbarAuthInfo {
  SandbarAuthInfo(this.id, this.email, this.accessToken, this.passwordHash, this.serverPublicKey, this.cbPublicKey, this.cbPrivateKey);

  String id;
  String email;
  String accessToken;
  String passwordHash;
  String serverPublicKey;
  String cbPublicKey;
  String cbPrivateKey;
  
  factory SandbarAuthInfo.fromJson(Map<String, dynamic> json) => _$SandbarAuthInfoFromJson(json);
  
  Map<String, dynamic> toJson() => _$SandbarAuthInfoToJson(this);
}

@JsonSerializable()
class AccountSettingsConfig {
  AccountSettingsConfig({this.sandbarAuthInfo, this.sandbarDevices = const []});

  SandbarAuthInfo? sandbarAuthInfo;

  List<SbcDevice> sandbarDevices = [];
  
  factory AccountSettingsConfig.fromJson(Map<String, dynamic> json) => _$AccountSettingsConfigFromJson(json);
  
  Map<String, dynamic> toJson() => _$AccountSettingsConfigToJson(this);
}

@JsonSerializable()
class AppConfig {
  @JsonKey(name: 'file_icons')
  Map<String, FileIcon> fileIcons;

  AppearanceConfig appearance;
  PreferencesConfig preferences;
  ExtensionsConfig extensions;
  AdvancedSettingsConfig advancedSettings;
  AccountSettingsConfig accountSettings;
  String sbcApiHost;

  AppConfig({
    required this.fileIcons,
    required this.appearance,
    required this.preferences,
    required this.extensions,
    required this.advancedSettings,
    required this.accountSettings,
    required this.sbcApiHost,
  });

  factory AppConfig.fromJson(Map<String, dynamic> json) => _$AppConfigFromJson(json);

  Map<String, dynamic> toJson() => _$AppConfigToJson(this);
}