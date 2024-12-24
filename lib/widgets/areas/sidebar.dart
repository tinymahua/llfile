import 'package:flutter/material.dart';
import 'package:llfile/widgets/partials/ll_disk_list_widget.dart';

class LlSidebar extends StatefulWidget {
  const LlSidebar({super.key});

  @override
  State<LlSidebar> createState() => _LlSidebarState();
}

class _LlSidebarState extends State<LlSidebar> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 6,),
        LlDiskListWidget()
      ],
    );
  }
}
