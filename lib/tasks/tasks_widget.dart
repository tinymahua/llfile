import 'package:flutter/material.dart';
import 'package:llfile/events/events.dart';
import 'package:llfile/tasks/base_task.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LlTasksWidget extends StatefulWidget {
  const LlTasksWidget({super.key, required this.taskCenterFolded});

  final bool taskCenterFolded;

  @override
  State<LlTasksWidget> createState() => _LlTasksWidgetState();
}

class _LlTasksWidgetState extends State<LlTasksWidget> {

  List<GeneralTask> tasks = [];

  @override
  void initState() {
    super.initState();
    setupEvents();
  }

  setupEvents(){
    eventBus.on<GeneralTask>().listen((evt){
      setState(() {tasks.add(evt);});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: widget.taskCenterFolded ? 0 : 300,
      child: Column(
        children: [
          widget.taskCenterFolded ? Container() :Text(AppLocalizations.of(context)!.taskListTitleLabel),
          Expanded(child: Container(
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: Theme.of(context).dividerTheme.color!)),
            ),
            child: ListView.builder(itemBuilder: (BuildContext context, int idx){
              GeneralTask task = tasks[idx];
              return Container(
                padding: EdgeInsets.only(left: 4, right: 6, bottom: 4),
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Theme.of(context).dividerTheme.color!)),
                ),
                child: task
              );
            }, itemCount: tasks.length,),
          )),
        ],
      ),
    );
  }
}
