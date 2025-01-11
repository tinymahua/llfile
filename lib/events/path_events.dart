import 'package:llfile/src/rust/api/llfs.dart';

class PathChangeEvent {
  String path;
  PathChangeEvent({required this.path});
}

class UpdateTabEvent {
  String label;
  String path;

  UpdateTabEvent({required this.label, required this.path});
}

class PreviewFsEntityEvent {
  String fsPath;
  FsEntity fsEntity;

  PreviewFsEntityEvent({required this.fsPath, required this.fsEntity});
}