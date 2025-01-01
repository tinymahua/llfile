import 'package:json_annotation/json_annotation.dart';

part 'app_states_model.g.dart';


@JsonSerializable()
class AppStates {
  int activatedFileBrowserTabIdx = 0;

  AppStates();

  factory AppStates.fromJson(Map<String, dynamic> json) => _$AppStatesFromJson(json);

  Map<String, dynamic> toJson() => _$AppStatesToJson(this);
}