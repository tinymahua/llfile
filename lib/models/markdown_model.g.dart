// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'markdown_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MdDocument _$MdDocumentFromJson(Map<String, dynamic> json) => MdDocument(
      title: json['title'] as String,
      fsPath: json['fsPath'] as String,
    );

Map<String, dynamic> _$MdDocumentToJson(MdDocument instance) =>
    <String, dynamic>{
      'title': instance.title,
      'fsPath': instance.fsPath,
    };

MdCollect _$MdCollectFromJson(Map<String, dynamic> json) => MdCollect(
      name: json['name'] as String,
      documents: (json['documents'] as List<dynamic>)
          .map((e) => MdDocument.fromJson(e as Map<String, dynamic>))
          .toList(),
      subCollects: (json['subCollects'] as List<dynamic>)
          .map((e) => MdCollect.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MdCollectToJson(MdCollect instance) => <String, dynamic>{
      'name': instance.name,
      'documents': instance.documents,
      'subCollects': instance.subCollects,
    };

MdData _$MdDataFromJson(Map<String, dynamic> json) => MdData(
      collects: (json['collects'] as List<dynamic>)
          .map((e) => MdCollect.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MdDataToJson(MdData instance) => <String, dynamic>{
      'collects': instance.collects,
    };

MdConfig _$MdConfigFromJson(Map<String, dynamic> json) => MdConfig(
      mdDataFsPath: json['mdDataFsPath'] as String,
      theme: json['theme'] as String,
    );

Map<String, dynamic> _$MdConfigToJson(MdConfig instance) => <String, dynamic>{
      'mdDataFsPath': instance.mdDataFsPath,
      'theme': instance.theme,
    };
