import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:llfile/events/events.dart';
import 'package:llfile/events/ui_events.dart';
import 'package:llfile/models/app_config_model.dart';
import 'package:llfile/pages/fsmgr_page.dart';
import 'package:llfile/src/rust/frb_generated.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:llfile/theme.dart';
import 'package:llfile/utils/db.dart';
import 'package:llfile/widgets/event_bus_test.dart';
import 'package:window_manager/window_manager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
  WindowOptions windowOptions = const WindowOptions(
    size: Size(1200, 800),
    center: true,
    backgroundColor: Colors.black87,
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.hidden,
    windowButtonVisibility: false,
  );
  windowManager.waitUntilReadyToShow(windowOptions, ()async {
    await windowManager.setAsFrameless();
  });

  Get.put(PathHistoryDb());
  Get.put(AppStatesMemDb());
  Get.put(AppConfigDb());

  await RustLib.init();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  ThemeMode _themeMode = ThemeMode.light;
  final AppConfigDb _appConfigDb = Get.find<AppConfigDb>();
  LanguageConfig? _languageConfig;

  @override
  void initState() {
    super.initState();

    setupEvents();
  }

  setupEvents()async{
    var appConfig = await _appConfigDb.read<AppConfig>();
    setState(() {
      _themeMode = appConfig.appearance.themeMode;
      _languageConfig = appConfig.preferences.language;
    });

    eventBus.on<ThemeChangedEvent>().listen((evt){
      setState(() {
        _themeMode = evt.themeMode;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final virtualWindowFrameBuilder = VirtualWindowFrameInit();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: _languageConfig != null ? Locale(_languageConfig!.languageCode, _languageConfig!.countryCode) :const Locale('en', 'US'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: LlFileThemeData.lightTheme,
      darkTheme: LlFileThemeData.darkTheme,
      themeMode: _themeMode,
      // home: ThemeTestWidget(),
      builder: (context, child) => virtualWindowFrameBuilder(context, child),
      home: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onPanStart: (details)async {
          if (!await windowManager.isMaximized()){
            windowManager.startDragging();
          }
        },
        child: FsmgrPage(),
      ),
    );
  }
}




class ThemeTestWidget extends StatelessWidget {
  const ThemeTestWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: Container(
          // width: 200,
          // height: 50,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).colorScheme.primary, width: 1.5),
          ),
          child: const Row(children: [
            Expanded(child: FirstWidget()),
            VerticalDivider(width: 2,),
            Expanded(child: SecondWidget()),
          ]),
        ),
      ),
    );
  }
}





class L10nTestWidget extends StatelessWidget {
  const L10nTestWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(AppLocalizations.of(context)!.hello("张三")));
  }
}























