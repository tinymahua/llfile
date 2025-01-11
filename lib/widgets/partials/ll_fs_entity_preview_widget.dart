import 'dart:io';

import 'package:flutter/material.dart';
import 'package:llfile/events/events.dart';
import 'package:llfile/events/path_events.dart';
import 'package:llfile/src/rust/api/llfs.dart';
import 'package:llfile/utils/fs.dart';
import 'package:path/path.dart';


class LlFsEntityPreviewWidget extends StatefulWidget {
  const LlFsEntityPreviewWidget({super.key});

  @override
  State<LlFsEntityPreviewWidget> createState() => _LlFsEntityPreviewWidgetState();
}

class _LlFsEntityPreviewWidgetState extends State<LlFsEntityPreviewWidget> {

  String? _currentFsPath;
  FsEntity? _fsEntity;

  String get _fsEntityAbsPath {
    return _fsEntity == null ? "" : join(_currentFsPath!, _fsEntity!.name);
  }

  @override
  void initState() {
    super.initState();
    setupEvents();
  }

  setupEvents()async{
    eventBus.on<PreviewFsEntityEvent>().listen((evt){
      setState(() {
        _currentFsPath = evt.fsPath;
        _fsEntity = evt.fsEntity;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildPreview(),
      ],
    );
  }

  Widget _buildPreview(){
    Widget w = SizedBox();
    if(isImage(_fsEntityAbsPath)){
      return _makeImagePreview(_fsEntityAbsPath);
    }
    return w;
  }

  Widget _makeImagePreview(String imageAbsPath){
    return Container(child: Image(image: FileImage(File(imageAbsPath))),);
  }
}

