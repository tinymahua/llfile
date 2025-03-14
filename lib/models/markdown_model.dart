import 'package:json_annotation/json_annotation.dart';

part 'markdown_model.g.dart';

@JsonSerializable()
class MdDocument {
  final String title;
  final String fsPath;

  MdDocument({
    required this.title,
    required this.fsPath,
  });

  factory MdDocument.fromJson(Map<String, dynamic> json) => _$MdDocumentFromJson(json);

  Map<String, dynamic> toJson() => _$MdDocumentToJson(this);
}

@JsonSerializable()
class MdCollect {
  final String name;
  final List<MdDocument> documents;
  final List<MdCollect> subCollects;

  MdCollect({
    required this.name,
    required this.documents,
    required this.subCollects,
  });

  factory MdCollect.fromJson(Map<String, dynamic> json) => _$MdCollectFromJson(json);

  Map<String, dynamic> toJson() => _$MdCollectToJson(this);
}


@JsonSerializable()
class MdData {
  final List<MdCollect> collects;

  MdData({
    required this.collects,
  });

  factory MdData.fromJson(Map<String, dynamic> json) => _$MdDataFromJson(json);

  Map<String, dynamic> toJson() => _$MdDataToJson(this);
}

@JsonSerializable()
class MdConfig {
  final String mdDataFsPath;
  final String theme;

  MdConfig({
    required this.mdDataFsPath,
    required this.theme,
  });

  factory MdConfig.fromJson(Map<String, dynamic> json) => _$MdConfigFromJson(json);
  
  Map<String, dynamic> toJson() => _$MdConfigToJson(this);
  
}