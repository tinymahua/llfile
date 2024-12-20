import 'package:flutter/material.dart';
import 'package:llfile/src/rust/api/simple.dart';
import 'package:llfile/src/rust/frb_generated.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:llfile/theme.dart';

Future<void> main() async {
  await RustLib.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: const Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: LlFileThemeData.lightTheme,
      darkTheme: LlFileThemeData.darkTheme,
      themeMode: ThemeMode.dark,
      home: ThemeTestWidget(),
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
          width: 200,
          height: 50,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).colorScheme.primary, width: 1.5),
          ),
          child: Text("LlFile Theme"),
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























