import 'package:flutter/material.dart';
import 'package:llfile/widgets/common/ll_window_widget.dart';

class LlTerminalWidget extends StatefulWidget {
  const LlTerminalWidget({super.key});

  @override
  State<LlTerminalWidget> createState() => _LlTerminalWidgetState();
}

class _LlTerminalWidgetState extends State<LlTerminalWidget> {
  @override
  Widget build(BuildContext context) {
    return LlWindowWidget(
      isHome: false,
      sideSize: 0,
      sideSizeMax: 0,
      sideSizeMin: 0,
      extraSize: 0,
      extraSizeMax: 0,
      extraSizeMin: 0,
      content: const Center(),
    );
  }
}
