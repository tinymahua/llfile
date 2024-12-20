import 'package:flutter/material.dart';
import 'package:llfile/events/events.dart';
import 'package:llfile/events/some_events.dart';

class FirstWidget extends StatefulWidget {
  const FirstWidget({super.key});

  @override
  State<FirstWidget> createState() => _FirstWidgetState();
}

class _FirstWidgetState extends State<FirstWidget> {
  List<String> msgList = [];

  @override
  void initState() {
    super.initState();
    setupEvents();
  }

  setupEvents() {
    eventBus.on<AEvent>().listen((event) {
      setState(() {
        msgList.add("AEvent: ${event.name} ${event.msg}");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(children: [
          ElevatedButton(onPressed: () {
            eventBus.fire(BEvent("First Widget Say", DateTime.now().toString()));
          }, child: Text("Send BEvent"))
        ]),
        Column(
          mainAxisSize: MainAxisSize.max,
            children: List<Widget>.generate(msgList.length, (int idx) {
          return Text(msgList[idx]);
        })),
      ],
    );
  }
}




class SecondWidget extends StatefulWidget {
  const SecondWidget({super.key});

  @override
  State<SecondWidget> createState() => _SecondWidgetState();
}

class _SecondWidgetState extends State<SecondWidget> {
  List<String> msgList = [];

  @override
  void initState() {
    super.initState();
    setupEvents();
  }

  setupEvents() {
    eventBus.on<BEvent>().listen((event) {
      setState(() {
        msgList.add("BEvent: ${event.name} ${event.msg}");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(children: [
          ElevatedButton(onPressed: () {
            eventBus.fire(AEvent("Second Widget Say", DateTime.now().toString()));
          }, child: Text("Send AEvent"))
        ]),
        Column(
          mainAxisSize: MainAxisSize.max,
          children: List<Widget>.generate(msgList.length, (int idx) {
            return Text(msgList[idx]);
          }),
        ),
      ],
    );
  }
}
