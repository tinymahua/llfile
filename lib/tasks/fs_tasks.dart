import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:llfile/events/events.dart';
import 'package:llfile/events/path_events.dart';
import 'package:llfile/events/sbn_events.dart';
import 'package:llfile/mixins/sbn_mixin.dart';
import 'package:llfile/mixins/task_mixin.dart';
import 'package:llfile/models/app_config_model.dart';
import 'package:llfile/models/fs_model.dart';
import 'package:llfile/models/sbn_model.dart';
import 'package:llfile/models/types.dart';
import 'package:llfile/src/rust/api/sandbar_node.dart';
import 'package:llfile/tasks/base_task.dart';
import 'package:llfile/utils/db.dart';
import 'package:llfile/utils/fs.dart';
import 'package:path/path.dart';
import 'package:llfile/generated/i10n/app_localizations.dart';

class AddToSandbarFsTaskWidget extends GeneralTask {
  const AddToSandbarFsTaskWidget(this.path, {super.key})
      : super(taskName: "AddToSandbarFs", taskLabel: "Add To SandbarFS");

  final String path;

  @override
  State<AddToSandbarFsTaskWidget> createState() =>
      _AddToSandbarFsTaskWidgetState();
}

class AddToSandbarFsTaskInfo {
  int? id;
  String? name;
  int? size;
  String? hash;
  String? allDoneHash;
  String? allDoneFormat;
  List<int>? allDoneTag;
  String? error;
}

class _AddToSandbarFsTaskWidgetState extends State<AddToSandbarFsTaskWidget>
    with TaskMixin, SbnMixin {
  final _appConfigDb = Get.find<AppConfigDb>();
  AppConfig? _appConfig;
  bool _sandbarNodeReady = false;

  TaskStatus _taskStatus = TaskStatus.waiting;
  AddToSandbarFsTaskInfo _taskInfo = AddToSandbarFsTaskInfo();

  late Stream<SandbarFsAddPathResponse> _stream;

  // List<SandbarFsAddPathResponse> _addPathResponses = [];

  // SandbarFsAddPathResponse? get _latestAddPathResponse =>
  //     _addPathResponses.isNotEmpty ? _addPathResponses.last : null;
  int _totalSize = -1;
  int _offsetSize = -1;

  int get _percent => _offsetSize >= 0 && _totalSize > 0
      ? (_offsetSize * 100 / _totalSize).toInt()
      : 0;

  @override
  void initState() {
    super.initState();

    setupEvents();
  }

  setupEvents() async {

    var appConfig = await _appConfigDb.read<AppConfig>();
    setState(() {
      _appConfig = appConfig;
    });

    var sandbarNodeReady = await isReady(_appConfig);
    setState(() {
      _sandbarNodeReady = sandbarNodeReady;
    });
    print('_sandbarNodeReady__: ${_sandbarNodeReady}');
    if (_sandbarNodeReady){
      var configPath = getSandbarNodeConfigFilePath(_appConfig!);
      var myStream = addPathToSandbarFs(configFilePath: configPath, path: widget.path);
      print("myStream: ${myStream}");
      setState(() {
        _stream = myStream;
      });

      _stream.listen((evt) {
        print("Got progress from sandbar fs: ${evt.jsonData}");
        updateProgress(evt);
      });
    }

    eventBus.on<SbnReadyEvent>().listen((evt){
      setState(() {
        _sandbarNodeReady = evt.ready;
      });
      if(evt.ready){
        var configPath = getSandbarNodeConfigFilePath(_appConfig!);
        setState(() {
          _stream = addPathToSandbarFs(configFilePath: configPath, path: widget.path);
        });
      }else{
        // Cancel
        resetTask();
      }
    });
  }

  resetTask(){
    setState(() {
      _taskStatus = TaskStatus.waiting;
      _taskInfo = AddToSandbarFsTaskInfo();
      _totalSize = -1;
      _offsetSize = -1;
    });
  }

  updateProgress(SandbarFsAddPathResponse response) async {
    Map<String, dynamic> jsonMap = jsonDecode(response.jsonData);
    Map<String, dynamic> infoData = jsonMap[response.kind];
    switch (response.kind) {
      case "Found":
        processFound(SandbarFsAddPathProgressFound.fromJson(infoData));
        break;
      case "Progress":
        processProgress(SandbarFsAddPathProgressProgress.fromJson(infoData));
        break;
      case "Done":
        processDone(SandbarFsAddPathProgressDone.fromJson(infoData));
        break;
      case "AllDone":
        processAllDone(SandbarFsAddPathProgressAllDone.fromJson(infoData));
        break;
      case "Abort":
        processAbort(SandbarFsAddPathProgressAbort.fromJson(infoData));
        break;
      default:
        break;
    }
  }

  processFound(SandbarFsAddPathProgressFound found) async {
    setState(() {
      _totalSize = found.size;
      _offsetSize = 0;
      _taskInfo.id = found.id;
      _taskInfo.name = found.name;
      _taskInfo.size = found.size;
    });
  }

  processProgress(SandbarFsAddPathProgressProgress progress) async {
    setState(() {
      _offsetSize = progress.offset;
    });
  }

  processDone(SandbarFsAddPathProgressDone done) async {
    setState(() {
      _taskInfo.hash = done.hash;
    });
  }

  processAllDone(SandbarFsAddPathProgressAllDone allDone) async {
    setState(() {
      _taskInfo.allDoneHash = allDone.hash;
      _taskInfo.allDoneFormat = allDone.format;
      _taskInfo.allDoneTag = allDone.tag;
      _taskStatus = TaskStatus.done;
    });
  }

  processAbort(SandbarFsAddPathProgressAbort abort) async {
    setState(() {
      _taskInfo.error = abort.error;
    });
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
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Text(
                              "${AppLocalizations.of(context)!.contextMenuCopy} ${basename(widget.path)}",
                              overflow: TextOverflow.ellipsis,
                            )),
                      ),
                    ],
                  ),
                ),
                flex: 4,
              ),
              Expanded(
                child: Text(
                  "[${_percent}]",
                  textAlign: TextAlign.right,
                ),
                flex: 2,
              ),
            ]),
        Row(
          children: [makeStatus(context, _taskStatus)],
        )
      ],
    );
  }
}

class CopyFileTaskWidget extends GeneralTask {
  const CopyFileTaskWidget(
      {super.key,
      required this.srcPath,
      required this.destPath,
      required this.isCut})
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

  updateProgress(FileDataProcessProgress progress) async {
    setState(() {
      _newestProgress = progress;
    });
    if (progress.percent == 100) {
      if (progress.done) {
        if (widget.isCut) {
          var delErr = await llDeleteFile(widget.srcPath);
          if (delErr != null) {
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
      : super(
          taskName: "DeleteFile",
          taskLabel: "Delete",
        );

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
    print("_status: ${_taskStatus}");
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
