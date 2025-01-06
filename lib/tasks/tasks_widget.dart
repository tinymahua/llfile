import 'package:flutter/material.dart';
import 'package:llfile/events/events.dart';
import 'package:llfile/tasks/base_task.dart';

class LlTasksWidget extends StatefulWidget {
  const LlTasksWidget({super.key});

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
    return Column(
      children: [
        const Text("Tasks"),
        Expanded(child: Container(
          decoration: BoxDecoration(
            border: Border(top: BorderSide(color: Theme.of(context).dividerTheme.color!)),
          ),
          child: ListView.builder(itemBuilder: (BuildContext context, int idx){
            GeneralTask task = tasks[idx];
            return Container(
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Theme.of(context).dividerTheme.color!)),
              ),
              child: task
            );
          }, itemCount: tasks.length,),
        )),
      ],
    );
  }
}
