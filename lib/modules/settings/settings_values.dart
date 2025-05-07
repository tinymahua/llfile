import 'package:fluent_ui/fluent_ui.dart';

enum SettingsContentPage {
  placeHolder,
  account,
  language,
  sbcApiHost,
  sandbarClientNodeConfig,
}

abstract class SettingsContentPageBaseWidget extends StatefulWidget {
  final SettingsContentPage pageName;

  const SettingsContentPageBaseWidget({super.key, required this.pageName});
}