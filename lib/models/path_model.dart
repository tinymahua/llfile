import 'package:json_annotation/json_annotation.dart';

part 'path_model.g.dart';

@JsonSerializable()
class PathHistories {
  List<String> histories = [];

  PathHistories(this.histories);

  factory PathHistories.fromJson(Map<String, dynamic> json) => _$PathHistoriesFromJson(json);

  Map<String, dynamic> toJson() => _$PathHistoriesToJson(this);
}