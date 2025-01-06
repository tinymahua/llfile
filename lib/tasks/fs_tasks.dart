import 'dart:async';

import 'package:flutter/material.dart';
import 'package:llfile/models/fs_model.dart';
import 'package:llfile/models/types.dart';
import 'package:llfile/tasks/base_task.dart';
import 'package:llfile/utils/fs.dart';
import 'package:path/path.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CopyFileTaskWidget extends GeneralTask {
  const CopyFileTaskWidget(
      {super.key, required this.srcPath, required this.destPath})
      : super(taskName: "CopyFile", taskLabel: "Copy");

  final String srcPath;
  final String destPath;

  @override
  State<CopyFileTaskWidget> createState() => _CopyFileTaskWidgetState();
}

class _CopyFileTaskWidgetState extends State<CopyFileTaskWidget> {
  final StreamController<FileDataProcessProgress> _streamController =
      StreamController<FileDataProcessProgress>();

  FileDataProcessProgress _newestProgress =
      FileDataProcessProgress.getDefault();

  double _iconSize = 16;
  StreamSubscription<List<int>>? _inputSubscription;
  TaskStatus _taskStatus = TaskStatus.waiting;

  bool get canStart {
    return _taskStatus == TaskStatus.waiting || _taskStatus == TaskStatus.paused;
  }

  bool get canPause {
    return _taskStatus == TaskStatus.running;
  }

  bool get canCancel {
    return _taskStatus == TaskStatus.waiting || _taskStatus == TaskStatus.running || _taskStatus == TaskStatus.paused;
  }

  @override
  void initState() {
    super.initState();
    setupEvents();
  }

  setupEvents() async {
    _streamController.stream.listen((event) {
      setState(() {
        _newestProgress = event;
      });
      if (event.percent == 100){
        setState(() {
          _taskStatus = TaskStatus.done;
        });
      }
      if (event.errorOccurred){
        setState(() {
          _taskStatus = TaskStatus.failed;
        });
      }
    });

    var inputSubscription = await llCopyFile(widget.srcPath, widget.destPath,
        progressStreamController: _streamController);
    setState(() {
      _inputSubscription = inputSubscription;
      _taskStatus = TaskStatus.running;
    });
  }

  makeControlButtons(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        IconButton(
            onPressed: canStart? () {
              _inputSubscription!.resume();
              setState(() {
                _taskStatus = TaskStatus.running;
              });
            }: null,
            icon: Icon(
              Icons.play_arrow_sharp,
              size: _iconSize,
            )),
        IconButton(
            onPressed: canPause? () {
              _inputSubscription!.pause();
              setState(() {
                _taskStatus = TaskStatus.paused;
              });
            }: null,
            icon: Icon(
              Icons.pause,
              size: _iconSize,
            )),
        IconButton(
            onPressed: canCancel? () {
              _inputSubscription!.cancel();
              setState(() {
                _taskStatus = TaskStatus.terminated;
              });
            }: null,
            icon: Icon(
              Icons.cancel,
              size: _iconSize,
            ))
      ],
    );
  }

  Widget makeStatus(BuildContext context){
    Widget w = Text("");
    TextStyle textStyle = TextStyle(fontSize: 11);
    if (_taskStatus == TaskStatus.running){
      w = Text("${AppLocalizations.of(context)!.taskStatusRunning}", style: textStyle,);
    }else if (_taskStatus == TaskStatus.paused){
      w = Text("${AppLocalizations.of(context)!.taskStatusPaused}", style: textStyle,);
    }else if (_taskStatus == TaskStatus.failed){
      w = Text("${AppLocalizations.of(context)!.taskStatusFailed}", style: textStyle,);
    }else if (_taskStatus == TaskStatus.done){
      w = Text("${AppLocalizations.of(context)!.taskStatusDone}", style: textStyle,);
    }else if (_taskStatus == TaskStatus.terminated){
      w = Text("${AppLocalizations.of(context)!.taskStatusTerminated}", style: textStyle,);
    }else if (_taskStatus == TaskStatus.waiting){
      w = Text("${AppLocalizations.of(context)!.taskStatusWaiting}", style: textStyle,);
    }
    return Container(
      height: 21,
      padding: EdgeInsets.symmetric(horizontal: 2, vertical: 1),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Theme.of(context).dividerTheme.color!,
      ),
      child: w,);
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
        Row(children: [makeStatus(context)],),
      ],
    );
  }
}
