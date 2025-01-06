import 'package:flutter/material.dart';

abstract class GeneralTask extends StatefulWidget{
  const GeneralTask({super.key, required this.taskName, required this.taskLabel});

  final String taskName;
  final String taskLabel;
}