enum OperateTargetType {
  file,
  dir,
}

enum OperateType {
  copy,
  cut,
  delete,
}


enum TaskStatus {
  waiting,
  running,
  paused,
  done,
  failed,
  terminated,
  warned,
}