import 'package:json_annotation/json_annotation.dart';
import 'package:llfile/models/fs_model.dart';

part 'app_config_model.g.dart';


@JsonSerializable()
class AppConfig {
  @JsonKey(name: 'file_icons')
  Map<String, FileIcon> fileIcons;

  AppConfig({
    required this.fileIcons,
  });

  factory AppConfig.fromJson(Map<String, dynamic> json) => _$AppConfigFromJson(json);

  Map<String, dynamic> toJson() => _$AppConfigToJson(this);
}