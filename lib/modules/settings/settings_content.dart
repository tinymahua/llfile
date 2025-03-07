import 'package:flutter/material.dart';
import 'package:llfile/events/events.dart';
import 'package:llfile/events/settings_events.dart';
import 'package:llfile/modules/settings/sub_settings/account_setting.dart';
import 'package:llfile/modules/settings/sub_settings/language_setting.dart';
import 'package:llfile/modules/settings/sub_settings/sbc_api_host_setting.dart';

class LlSettingsContentWidget extends StatefulWidget {
  const LlSettingsContentWidget({super.key});

  @override
  State<LlSettingsContentWidget> createState() => _LlSettingsContentWidgetState();
}

class _LlSettingsContentWidgetState extends State<LlSettingsContentWidget> {
  final PageController _pageController = PageController();
  final List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();
    _pages.addAll([
      // Preferences
      LlLanguageSetting(),
      LlLanguageSetting(),
      LlLanguageSetting(),
      LlLanguageSetting(),
      // Extends
      LlLanguageSetting(),
      // Advanced
      LlLanguageSetting(),
      // Account
      LlAccountSetting(),
      // SbcApiHost
      SbcApiHostSetting(),
    ]);

    setupEvents();
  }

  setupEvents()async{
    eventBus.on<SettingsChangeContentEvent>().listen((evt){
      _pageController.jumpToPage(evt.index);
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
