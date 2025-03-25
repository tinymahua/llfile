import 'package:json_annotation/json_annotation.dart';

part 'markdown_model.g.dart';

enum MdObjectType {
  collection,
  document,
}

@JsonSerializable()
class MdDocument {
  final String objectType;
  final String id;
  final String title;
  final String fsPath;
  final String parentObjectId;

  MdDocument({
    required this.objectType,
    required this.id,
    required this.title,
    required this.fsPath,
    required this.parentObjectId,
  });

  factory MdDocument.fromJson(Map<String, dynamic> json) => _$MdDocumentFromJson(json);

  Map<String, dynamic> toJson() => _$MdDocumentToJson(this);
}

@JsonSerializable()
class MdCollection {
  final String objectType;
  final String id;
  final String name;
  final List<MdDocument> documents;
  final String parentObjectId;

  MdCollection({
    required this.objectType,
    required this.id,
    required this.name,
    required this.documents,
    required this.parentObjectId,
  });

  factory MdCollection.fromJson(Map<String, dynamic> json) => _$MdCollectionFromJson(json);

  Map<String, dynamic> toJson() => _$MdCollectionToJson(this);
}



class MdObject {
  final String id;
  final MdObjectType type;
  final Map<String, dynamic> data;
  final String parentObjectId;

  MdObject({
    required this.id,
    required this.type,
    required this.data,
    required this.parentObjectId,
  });

  factory MdObject.fromJson(Map<String, dynamic> json) {
    final type = MdObjectType.values.firstWhere((element) => element.toString() == json['type']);
    return MdObject(
      id: json['id'],
      parentObjectId: json['parentObjectId'],
      type: type,
      data: json['data'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      'type': type.toString(),
     'data': data,
      'parentObjectId': parentObjectId,
    };
  }

  String get objectName {
    switch (type) {
      case MdObjectType.collection:
        return data['name'];
      case MdObjectType.document:
        return data['title'];
        default:
          return '--';
    }
  }
}

@JsonSerializable()
class MdData {
  final List<MdObject> mdObjects;

  MdData({
    required this.mdObjects,
  });

  factory MdData.fromJson(Map<String, dynamic> json) => _$MdDataFromJson(json);

  Map<String, dynamic> toJson() => _$MdDataToJson(this);
}

@JsonSerializable()
class MdConfig {
  final String mdDataFsPath;
  final String mdDocsRootPath;
  final String theme;
  List<String> expandedObjectIds;

  MdConfig({
    required this.mdDataFsPath,
    required this.mdDocsRootPath,
    required this.theme,
    required this.expandedObjectIds,
  });

  factory MdConfig.fromJson(Map<String, dynamic> json) => _$MdConfigFromJson(json);
  
  Map<String, dynamic> toJson() => _$MdConfigToJson(this);
  
}