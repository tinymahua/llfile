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

List<String> imageExtensions = [
  'jpg',
  'jpeg',
  'png',
  'gif',
  'bmp',
  'webp',
  'svg',
  'ico',
  'tiff',
  'tif',
  'psd',
  'raw',
  'arw',
  'nef',
  'dng',
  'cr2',
  'orf',
  'sr2',
  'raf',
  'rw2',];