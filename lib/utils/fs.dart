import 'dart:async';
import 'dart:io';

import 'package:llfile/models/fs_model.dart';

sendFileDataProcessErrorProgress(
    StreamController<FileDataProcessProgress>?
        progressStreamController, FsError error) async {
    progressStreamController?.add(FileDataProcessProgress(
        percent: 0,
        totalBytes: 0,
        processedBytes: 0,
        time: DateTime.now(),
        errorOccurred: true,
        error: error));
}


Future<StreamSubscription<List<int>>?> llCopyFile(String src, String dest,
    {StreamController<FileDataProcessProgress>?
        progressStreamController}) async {
  if (!FileSystemEntity.isFileSync(src)) {
    sendFileDataProcessErrorProgress(progressStreamController, FsError(path: src, desc: "Copy source isn't a regular file."));
    return null;
  }
  if (FileSystemEntity.isDirectorySync(dest)) {
    sendFileDataProcessErrorProgress(progressStreamController, FsError(path: src, desc: "Copy source isn't a regular file."));
    return null;
  }

  File srcFile = File(src);
  if (!srcFile.existsSync()) {
    sendFileDataProcessErrorProgress(progressStreamController, FsError(path: src, desc: "Copy source doesn't exist."));
    return null;
  }
  File destFile = File(dest);
  if (!destFile.parent.existsSync()) {
    sendFileDataProcessErrorProgress(progressStreamController, FsError(path: src, desc: "Copy destination's parent directory doesn't exist."));
    return null;
  }
  try {
    int totalBytes = srcFile.lengthSync();
    int processedBytes = 0;
    Stream<List<int>> inputStream = srcFile.openRead();
    StreamSubscription<List<int>> inputSubscription = inputStream.listen(null);
    IOSink outSink = destFile.openWrite();
    inputSubscription.onData((List<int> data) {
      outSink.add(data);
      processedBytes += data.length;
      if (progressStreamController != null) {
        progressStreamController.add(FileDataProcessProgress(
            percent: processedBytes * 100 ~/ totalBytes,
            totalBytes: totalBytes,
            processedBytes: processedBytes,
            time: DateTime.now()));
      }
    });
    inputSubscription.onDone((){
      outSink.close();
    });
    inputSubscription.onError((e){
      throw e;
    });
    return inputSubscription;
  } catch (e) {
    sendFileDataProcessErrorProgress(progressStreamController, FsError(path: src, desc: e.toString()));
    return null;
  }
}
