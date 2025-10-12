import 'package:flutter/material.dart';

class NoteScenePage extends StatefulWidget {
  const NoteScenePage({super.key});

  @override
  State<NoteScenePage> createState() => _NoteScenePageState();
}

class _NoteScenePageState extends State<NoteScenePage> {
  @override
  Widget build(BuildContext context) {
    return Container(child: Center(child: Text('Note')));
  }
}
