import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:llfile/models/fs_model.dart';

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
class AppConfig {
  @JsonKey(name: 'file_icons')
  Map<String, FileIcon> fileIcons;

  AppearanceConfig appearance;

  AppConfig({
    required this.fileIcons,
    required this.appearance,
  });

  factory AppConfig.fromJson(Map<String, dynamic> json) => _$AppConfigFromJson(json);

  Map<String, dynamic> toJson() => _$AppConfigToJson(this);
}