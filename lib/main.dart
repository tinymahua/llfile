import 'package:flutter/material.dart';
import 'package:llfile/src/rust/api/simple.dart';
import 'package:llfile/src/rust/frb_generated.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
      home: Scaffold(
        appBar: AppBar(title: const Text('flutter_rust_bridge quickstart')),
        body: L10nTestWidget(),
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

























