import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:llfile/pages/fsmgr_page.dart';
import 'package:llfile/src/rust/api/simple.dart';
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
    size: Size(960, 800),
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

  await RustLib.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final virtualWindowFrameBuilder = VirtualWindowFrameInit();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: const Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: LlFileThemeData.lightTheme,
      darkTheme: LlFileThemeData.darkTheme,
      themeMode: ThemeMode.light,
      // home: ThemeTestWidget(),
      builder: (context, child) => virtualWindowFrameBuilder(context, child),
      home: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onPanStart: (details) {
          windowManager.startDragging();
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























