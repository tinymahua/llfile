// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'markdown_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MdDocument _$MdDocumentFromJson(Map<String, dynamic> json) => MdDocument(
      objectType: json['objectType'] as String,
      id: json['id'] as String,
      title: json['title'] as String,
      fsPath: json['fsPath'] as String,
      parentObjectId: json['parentObjectId'] as String,
    );

Map<String, dynamic> _$MdDocumentToJson(MdDocument instance) =>
    <String, dynamic>{
      'objectType': instance.objectType,
      'id': instance.id,
      'title': instance.title,
      'fsPath': instance.fsPath,
      'parentObjectId': instance.parentObjectId,
    };

MdCollection _$MdCollectionFromJson(Map<String, dynamic> json) => MdCollection(
      objectType: json['objectType'] as String,
      id: json['id'] as String,
      name: json['name'] as String,
      documents: (json['documents'] as List<dynamic>)
          .map((e) => MdDocument.fromJson(e as Map<String, dynamic>))
          .toList(),
      parentObjectId: json['parentObjectId'] as String,
    );

Map<String, dynamic> _$MdCollectionToJson(MdCollection instance) =>
    <String, dynamic>{
      'objectType': instance.objectType,
      'id': instance.id,
      'name': instance.name,
      'documents': instance.documents,
      'parentObjectId': instance.parentObjectId,
    };

MdData _$MdDataFromJson(Map<String, dynamic> json) => MdData(
      mdObjects: (json['mdObjects'] as List<dynamic>)
          .map((e) => MdObject.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MdDataToJson(MdData instance) => <String, dynamic>{
      'mdObjects': instance.mdObjects,
    };

MdConfig _$MdConfigFromJson(Map<String, dynamic> json) => MdConfig(
      mdDataFsPath: json['mdDataFsPath'] as String,
      theme: json['theme'] as String,
      expandedObjectIds: (json['expandedObjectIds'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$MdConfigToJson(MdConfig instance) => <String, dynamic>{
      'mdDataFsPath': instance.mdDataFsPath,
      'theme': instance.theme,
      'expandedObjectIds': instance.expandedObjectIds,
    };
