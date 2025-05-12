import 'package:flutter/material.dart';
import 'package:llfile/events/events.dart';
import 'package:llfile/events/settings_events.dart';
import 'package:llfile/modules/settings/settings_values.dart';
import 'package:llfile/modules/settings/sub_settings/account_setting.dart';
import 'package:llfile/modules/settings/sub_settings/language_setting.dart';
// import 'package:llfile/modules/settings/sub_settings/sandbar_client_node_setting.dart';
import 'package:llfile/modules/settings/sub_settings/sbc_api_host_setting.dart';



class LlSettingsContentWidget extends StatefulWidget {
  const LlSettingsContentWidget({super.key});

  @override
  State<LlSettingsContentWidget> createState() => _LlSettingsContentWidgetState();
}

class _LlSettingsContentWidgetState extends State<LlSettingsContentWidget> {
  final PageController _pageController = PageController();
  final List<SettingsContentPageBaseWidget> _pages = [
    const LlAccountSetting(),
    const LlLanguageSetting(),
    const SbcApiHostSetting(),
    // const SandbarClientNodeSetting(),
  ];


  @override
  void initState() {
    super.initState();
    setupEvents();
  }

  setupEvents()async{
    eventBus.on<SettingsChangeContentEvent>().listen((evt){
      var _contentPage = evt.settingsContentPage;
      var targetIndex = _pages.indexWhere((e)=>e.pageName == _contentPage);
      print('Got targetIndex: ${targetIndex}');
      if (targetIndex < 0){
        return;
      }
      _pageController.jumpToPage(targetIndex);
    });
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _pageController,
      children: _pages,
    );
  }
}
