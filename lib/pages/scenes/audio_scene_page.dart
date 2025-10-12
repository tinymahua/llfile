  import 'package:flutter/material.dart';

class AudioScenePage extends StatefulWidget {
    const AudioScenePage({super.key});

    @override
    State<AudioScenePage> createState() => _AudioScenePageState();
  }

  class _AudioScenePageState extends State<AudioScenePage> {
    @override
    Widget build(BuildContext context) {
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Text('Audio')],),
        ],
      );
    }
  }
