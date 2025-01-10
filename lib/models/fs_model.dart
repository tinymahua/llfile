import 'package:json_annotation/json_annotation.dart';

part 'fs_model.g.dart';

@JsonSerializable()
class FileIcon {

  @JsonKey(name: 'ext_name')
  String extName;
  String resource;

  FileIcon({
    required this.extName,
    required this.resource,
  });

  factory FileIcon.fromJson(Map<String, dynamic> json) => _$FileIconFromJson(json);

  Map<String, dynamic> toJson() => _$FileIconToJson(this);
}


@JsonSerializable()
class FsError {
  String path;
  String desc;

  FsError({
    required this.path,
    required this.desc,
  });

  factory FsError.fromJson(Map<String, dynamic> json) => _$FsErrorFromJson(json);

  Map<String, dynamic> toJson() => _$FsErrorToJson(this);
}


@JsonSerializable()
class FileDataProcessProgress{
  int percent;
  int totalBytes;
  int processedBytes;
  DateTime time;
  bool errorOccurred;
  FsError? error;
  bool done = false;

  FileDataProcessProgress({
    required this.percent,
    required this.totalBytes,
    required this.processedBytes,
    required this.time,
    this.errorOccurred = false,
    this.error,
    this.done = false,
  });

  factory FileDataProcessProgress.fromJson(Map<String, dynamic> json) => _$FileDataProcessProgressFromJson(json);

  Map<String, dynamic> toJson() => _$FileDataProcessProgressToJson(this);

  factory FileDataProcessProgress.getDefault(){
    return FileDataProcessProgress(
      percent: 0,
      totalBytes: 0,
      processedBytes: 0,
      time: DateTime.now(),
      errorOccurred: false,
      error: null,
    );
  }
}


