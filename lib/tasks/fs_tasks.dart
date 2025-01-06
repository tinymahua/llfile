import 'dart:async';

import 'package:flutter/material.dart';
import 'package:llfile/models/fs_model.dart';
import 'package:llfile/tasks/base_task.dart';
import 'package:llfile/utils/fs.dart';
import 'package:path/path.dart';

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

  @override
  void initState() {
    super.initState();
    setupEvents();
  }

  setupEvents() async {
    _streamController.stream.listen((event) {
      setState(() {_newestProgress = event;});
    });

    await llCopyFile(widget.srcPath, widget.destPath,
        progressStreamController: _streamController);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
                flex: 4,
                child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Text(
                      "Copy ${basename(widget.srcPath)}",
                      overflow: TextOverflow.ellipsis,
                    ))),
            Expanded(
                flex: 2,
                child: Text(
                  "[${_newestProgress.percent}]",
                  textAlign: TextAlign.right,
                )),
          ],
        ),
      ],
    );
  }
}
