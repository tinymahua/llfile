import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:llfile/models/types.dart';
import 'package:llfile/generated/i10n/app_localizations.dart';

mixin TaskMixin {
  Widget makeStatus(BuildContext context, TaskStatus taskStatus){
    Widget w = Text("");
    TextStyle textStyle = TextStyle(fontSize: 11);
    if (taskStatus == TaskStatus.running){
      w = Text("${AppLocalizations.of(context)!.taskStatusRunning}", style: textStyle,);
    }else if (taskStatus == TaskStatus.paused){
      w = Text("${AppLocalizations.of(context)!.taskStatusPaused}", style: textStyle,);
    }else if (taskStatus == TaskStatus.failed){
      w = Text("${AppLocalizations.of(context)!.taskStatusFailed}", style: textStyle,);
    }else if (taskStatus == TaskStatus.done){
      w = Text("${AppLocalizations.of(context)!.taskStatusDone}", style: textStyle,);
    }else if (taskStatus == TaskStatus.terminated){
      w = Text("${AppLocalizations.of(context)!.taskStatusTerminated}", style: textStyle,);
    }else if (taskStatus == TaskStatus.waiting){
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
}