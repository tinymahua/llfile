import 'package:flutter/material.dart';
import 'package:llfile/events/addon_events.dart';
import 'package:llfile/events/events.dart';
import 'package:llfile/tasks/tasks_widget.dart';
import 'package:llfile/widgets/common/keep_alive_wrapper.dart';
import 'package:llfile/widgets/partials/ll_fs_entity_preview_widget.dart';

class ExtraContentWidget extends StatefulWidget {
  const ExtraContentWidget({super.key});

  @override
  State<ExtraContentWidget> createState() => _ExtraContentWidgetState();
}

class _ExtraContentWidgetState extends State<ExtraContentWidget> {
  List<Widget> _pageViews = [];
  PageController _pageController = PageController(keepPage: true, initialPage: 0);

  @override
  void initState() {
    super.initState();
    _pageViews.add(KeepAliveWrapper(child: LlTasksWidget()));
    _pageViews.add(KeepAliveWrapper(child: LlFsEntityPreviewWidget()));
    setupEvents();
  }

  setupEvents()async{
    eventBus.on<SwitchAddonEvent>().listen((evt){
      _pageController.jumpToPage(evt.addonIndex);
    });
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _pageController,
      children: _pageViews,
    );
  }
}
