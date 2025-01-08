class PathChangeEvent {
  String path;
  PathChangeEvent({required this.path});
}

class UpdateTabEvent {
  String label;
  String path;

  UpdateTabEvent({required this.label, required this.path});
}
