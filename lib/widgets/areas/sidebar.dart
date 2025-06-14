import 'package:flutter/material.dart';
import 'package:llfile/widgets/partials/ll_disk_list_widget.dart';

class LlSidebar extends StatefulWidget {
  const LlSidebar({super.key, required this.sidebarFolded});

  final bool sidebarFolded;

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: 6,),
        LlDiskListWidget(sidebarFolded: widget.sidebarFolded,),
        SizedBox(height: 6,),
      ],
    );
  }
}
