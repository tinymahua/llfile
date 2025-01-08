import 'dart:async';

import 'package:flutter/material.dart';
import 'package:llfile/events/events.dart';
import 'package:llfile/events/path_events.dart';
import 'package:llfile/mixins/task_mixin.dart';
import 'package:llfile/models/fs_model.dart';
import 'package:llfile/models/types.dart';
import 'package:llfile/tasks/base_task.dart';
import 'package:llfile/utils/fs.dart';
import 'package:path/path.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CopyFileTaskWidget extends GeneralTask {
  const CopyFileTaskWidget(
      {super.key, required this.srcPath, required this.destPath, required this.isCut})
      : super(taskName: "CopyFile", taskLabel: "Copy");

  final String srcPath;
  final String destPath;
  final bool isCut;

  @override
  State<CopyFileTaskWidget> createState() => _CopyFileTaskWidgetState();
}

class _CopyFileTaskWidgetState extends State<CopyFileTaskWidget>
    with TaskMixin {
  final StreamController<FileDataProcessProgress> _streamController =
      StreamController<FileDataProcessProgress>();

  FileDataProcessProgress _newestProgress =
      FileDataProcessProgress.getDefault();

  double _iconSize = 16;
  StreamSubscription<List<int>>? _inputSubscription;
  TaskStatus _taskStatus = TaskStatus.waiting;

  bool get canStart {
    return _taskStatus == TaskStatus.waiting ||
        _taskStatus == TaskStatus.paused;
  }

  bool get canPause {
    return _taskStatus == TaskStatus.running;
  }

  bool get canCancel {
    return _taskStatus == TaskStatus.waiting ||
        _taskStatus == TaskStatus.running ||
        _taskStatus == TaskStatus.paused;
  }

  @override
  void initState() {
    super.initState();
    setupEvents();
  }

  setupEvents() async {
    _streamController.stream.listen((event) {
      updateProgress(event);
    });

    var inputSubscription = await llCopyFile(widget.srcPath, widget.destPath,
        progressStreamController: _streamController);
    setState(() {
      _inputSubscription = inputSubscription;
      _taskStatus = TaskStatus.running;
    });
  }

  updateProgress(FileDataProcessProgress progress)async{
    setState(() {
      _newestProgress = progress;
    });
    if (progress.percent == 100) {
      if (progress.done){
        if (widget.isCut){
          var delErr = await llDeleteFile(widget.srcPath);
          if (delErr!=null){
            print("delErr: ${delErr.desc}");
          }
        }
      }
      setState(() {
        _taskStatus = TaskStatus.done;
      });
    }
    if (progress.errorOccurred) {
      setState(() {
        _taskStatus = TaskStatus.failed;
      });
    }
  }

  makeControlButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        IconButton(
            onPressed: canStart
                ? () {
                    _inputSubscription!.resume();
                    setState(() {
                      _taskStatus = TaskStatus.running;
                    });
                  }
                : null,
            icon: Icon(
              Icons.play_arrow_sharp,
              size: _iconSize,
            )),
        IconButton(
            onPressed: canPause
                ? () {
                    _inputSubscription!.pause();
                    setState(() {
                      _taskStatus = TaskStatus.paused;
                    });
                  }
                : null,
            icon: Icon(
              Icons.pause,
              size: _iconSize,
            )),
        IconButton(
            onPressed: canCancel
                ? () {
                    _inputSubscription!.cancel();
                    setState(() {
                      _taskStatus = TaskStatus.terminated;
                    });
                  }
                : null,
            icon: Icon(
              Icons.cancel,
              size: _iconSize,
            ))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
                flex: 4,
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Text(
                              "${AppLocalizations.of(context)!.contextMenuCopy} ${basename(widget.srcPath)}",
                              overflow: TextOverflow.ellipsis,
                            )),
                      ),
                    ],
                  ),
                )),
            Expanded(
                flex: 2,
                child: Text(
                  "[${_newestProgress.percent}]",
                  textAlign: TextAlign.right,
                )),
          ],
        ),
        Container(
          child: makeControlButtons(),
        ),
        Row(
          children: [makeStatus(context, _taskStatus)],
        ),
      ],
    );
  }
}

class DeleteFileTaskWidget extends GeneralTask {
  final String path;

  const DeleteFileTaskWidget(this.path, {super.key})
      : super(taskName: "DeleteFile", taskLabel: "Delete");

  @override
  State<DeleteFileTaskWidget> createState() => _DeleteFileTaskWidgetState();
}

class _DeleteFileTaskWidgetState extends State<DeleteFileTaskWidget>
    with TaskMixin {
  TaskStatus _taskStatus = TaskStatus.waiting;

  @override
  void initState() {
    super.initState();
    setupEvents();
  }

  setupEvents() async {
    setState(() {
      _taskStatus = TaskStatus.running;
    });
    var deleteError = await llDeleteFile(widget.path);
    if (deleteError != null) {
      setState(() {
        _taskStatus = TaskStatus.failed;
      });
    } else {
      setState(() {
        _taskStatus = TaskStatus.done;
      });
      eventBus.fire(PathChangeEvent(path: dirname(widget.path)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
                flex: 4,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Text(
                    style: TextStyle(overflow: TextOverflow.ellipsis),
                      "${AppLocalizations.of(context)!.contextMenuDelete} ${widget.path}"),
                )),
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [makeStatus(context, _taskStatus)],
              ),
            ),
          ],
        )
      ],
    );
  }
}
