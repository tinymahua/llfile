import 'package:flutter/material.dart';
import 'package:llfile/widgets/common/ll_window_widget.dart';

class LlMdWidget extends StatefulWidget {
  const LlMdWidget({super.key});

  @override
  State<LlMdWidget> createState() => _LlMdWidgetState();
}

class _LlMdWidgetState extends State<LlMdWidget> {
  @override
  Widget build(BuildContext context) {
    return LlWindowWidget(isHome: false, content: Container(),);
  }
}
