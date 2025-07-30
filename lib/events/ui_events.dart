import 'package:flutter/material.dart';
import 'package:llfile/models/app_config_model.dart';

class ThemeChangedEvent {
  final ThemeMode themeMode;

  ThemeChangedEvent(this.themeMode);
}


class AppModeChangedEvent {
  final AppMode appMode;
  AppModeChangedEvent(this.appMode);
}