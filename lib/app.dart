import 'package:llfile/pages/fsmgr_page.dart';
import 'package:llfile/pages/moon_box_page.dart';
import 'package:llfile/pages/toolbox_page.dart';
import 'package:llfile/utils/db.dart';
import 'package:llfile/events/events.dart';
import 'package:llfile/events/ui_events.dart';
import 'package:llfile/generated/i10n/app_localizations.dart';
import 'package:llfile/models/app_config_model.dart';
import 'package:llfile/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:window_manager/window_manager.dart';
import 'package:fluent_ui/fluent_ui.dart' as fui;

class LlFileApp extends StatefulWidget {
  const LlFileApp({super.key});

  @override
  State<LlFileApp> createState() => _LlFileAppState();
}

class _LlFileAppState extends State<LlFileApp> {

  ThemeMode _themeMode = ThemeMode.light;
  AppMode _appMode = AppMode.fsMgr;
  final AppConfigDb _appConfigDb = Get.find<AppConfigDb>();
  AppConfig? _appConfig;
  LanguageConfig? _languageConfig;

  @override
  void initState() {
    super.initState();

    setupEvents();
  }

  setupEvents()async{
    var appConfig = await _appConfigDb.read<AppConfig>();
    setState(() {
      _appConfig = appConfig;
      _themeMode = appConfig.appearance.themeMode;
      _appMode = appConfig.appMode;
      _languageConfig = appConfig.preferences.language;
    });

    eventBus.on<ThemeChangedEvent>().listen((evt){
      setState(() {
        _themeMode = evt.themeMode;
      });
    });

    eventBus.on<AppModeChangedEvent>().listen((evt){
      setState(() {
        _appMode = evt.appMode;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final virtualWindowFrameBuilder = VirtualWindowFrameInit();

    List<LocalizationsDelegate<dynamic>> localizationsDelegates = [];
    localizationsDelegates.addAll(AppLocalizations.localizationsDelegates);
    localizationsDelegates.addAll(fui.FluentLocalizations.localizationsDelegates);

    List<Locale> supportedLocales = [];
    supportedLocales.addAll(AppLocalizations.supportedLocales);
    supportedLocales.addAll(fui.FluentLocalizations.supportedLocales);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: _languageConfig != null ? Locale(_languageConfig!.languageCode, _languageConfig!.countryCode) :const Locale('en', 'US'),
      localizationsDelegates: localizationsDelegates,
      supportedLocales: supportedLocales,
      theme: LlFileThemeData.lightTheme,
      darkTheme: LlFileThemeData.darkTheme,
      themeMode: _themeMode,
      // home: ThemeTestWidget(),
      builder: (context, child) => virtualWindowFrameBuilder(context, child),
      home: GestureDetector(
        behavior: HitTestBehavior.translucent,
        // onPanStart: (details)async {
        //   if (!await windowManager.isMaximized()){
        //     windowManager.startDragging();
        //   }
        // },
        // child: MoonBoxPage(),
        child: _appMode == AppMode.toolBox
            ? ToolBoxPage()
            : _appMode == AppMode.fsMgr
                ? FsmgrPage()
                : MoonBoxPage(),
      ),
    );
  }
}
