import 'package:json_annotation/json_annotation.dart';
import 'package:llfile/models/types.dart';

part 'fs_model.g.dart';


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

  FileDataProcessProgress({
    required this.percent,
    required this.totalBytes,
    required this.processedBytes,
    required this.time,
    this.errorOccurred = false,
    this.error,
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


