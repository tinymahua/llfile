import 'package:flutter/material.dart';

class LlFileThemeData {
  static Color lightSurfaceColor = Colors.white60;
  static Color lightOnSurfaceColor = Colors.black87;
  static Color lightPrimaryColor = Colors.blueAccent;
  static Color lightOnPrimaryColor = Colors.white;
  static Color lightError = Colors.red;
  static Color lightOnError = Colors.white;
  static Brightness lightBrightness = Brightness.light;

  static Color darkSurfaceColor = Colors.black54;
  static Color darkOnSurfaceColor = Colors.white;
  static Color darkPrimaryColor = Colors.yellow[200]!;
  static Color darkOnPrimaryColor = Colors.black;
  static Color darkError = Colors.red;
  static Color darkOnError = Colors.white;
  static Brightness darkBrightness = Brightness.dark;

  static ThemeData get lightTheme {
    return ThemeData(
      colorScheme: ColorScheme(
          brightness: LlFileThemeData.lightBrightness,
          primary: LlFileThemeData.lightPrimaryColor, onPrimary: LlFileThemeData.lightOnPrimaryColor,
          secondary: LlFileThemeData.lightPrimaryColor, onSecondary: LlFileThemeData.lightOnPrimaryColor,
          error: LlFileThemeData.lightError, onError: LlFileThemeData.lightOnError,
          surface: LlFileThemeData.lightSurfaceColor, onSurface: lightOnSurfaceColor
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      colorScheme: ColorScheme(
          brightness: LlFileThemeData.darkBrightness,
          primary: LlFileThemeData.darkPrimaryColor, onPrimary: LlFileThemeData.darkOnPrimaryColor,
          secondary: LlFileThemeData.darkPrimaryColor, onSecondary: LlFileThemeData.darkOnPrimaryColor,
          error: LlFileThemeData.darkError, onError: LlFileThemeData.darkOnError,
          surface: LlFileThemeData.darkSurfaceColor, onSurface: darkOnSurfaceColor
      ),
      // ...
    );
  }
}

