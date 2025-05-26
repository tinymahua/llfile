import 'package:json_annotation/json_annotation.dart';

part 'sbn_model.g.dart';

@JsonSerializable()
class SandbarFsAddPathProgressFound {
  int id;
  String name;
  int size;

  SandbarFsAddPathProgressFound(this.id, this.name, this.size);

  factory SandbarFsAddPathProgressFound.fromJson(Map<String, dynamic> json) => _$SandbarFsAddPathProgressFoundFromJson(json);
  Map<String, dynamic> toJson() => _$SandbarFsAddPathProgressFoundToJson(this);
}

@JsonSerializable()
class SandbarFsAddPathProgressProgress {
  int id;
  int offset;

  SandbarFsAddPathProgressProgress(this.id, this.offset);

  factory SandbarFsAddPathProgressProgress.fromJson(Map<String, dynamic> json) => _$SandbarFsAddPathProgressProgressFromJson(json);
  Map<String, dynamic> toJson() => _$SandbarFsAddPathProgressProgressToJson(this);
}

@JsonSerializable()
class SandbarFsAddPathProgressDone {
  int id;
  String hash;

  SandbarFsAddPathProgressDone(this.id, this.hash);

  factory SandbarFsAddPathProgressDone.fromJson(Map<String, dynamic> json) => _$SandbarFsAddPathProgressDoneFromJson(json);
  Map<String, dynamic> toJson() => _$SandbarFsAddPathProgressDoneToJson(this);
}

@JsonSerializable()
class SandbarFsAddPathProgressAllDone {
  String hash;
  String format;
  List<int> tag;

  SandbarFsAddPathProgressAllDone(this.hash, this.format, this.tag);
  factory SandbarFsAddPathProgressAllDone.fromJson(Map<String, dynamic> json) => _$SandbarFsAddPathProgressAllDoneFromJson(json);
  Map<String, dynamic> toJson() => _$SandbarFsAddPathProgressAllDoneToJson(this);
}

@JsonSerializable()
class SandbarFsAddPathProgressAbort {
  String error;

  SandbarFsAddPathProgressAbort(this.error);

  factory SandbarFsAddPathProgressAbort.fromJson(Map<String, dynamic> json) => _$SandbarFsAddPathProgressAbortFromJson(json);
  Map<String, dynamic> toJson() => _$SandbarFsAddPathProgressAbortToJson(this);
}
