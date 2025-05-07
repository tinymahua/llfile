import 'package:fluent_ui/fluent_ui.dart';
import 'package:llfile/modules/settings/settings_values.dart';

class SettingsChangeContentEvent {
  final int index;
  final SettingsContentPage? settingsContentPage;

  SettingsChangeContentEvent({required this.index, this.settingsContentPage});
}


class SettingsSaveEvent {
  SettingsSaveEvent();
}
