import 'dart:ui';

import 'package:flutter/material.dart';

class MoonBoxFloatingContainer extends ThemeExtension<MoonBoxFloatingContainer> {
  static Color lightBgColor = const Color(0xffd8eaf4);

  static Color darkBgColor = const Color(0xff494949);

  static double _borderRadius = 6.0;

  final Color bgColor;
  final double borderRadius;


  MoonBoxFloatingContainer({
    required this.bgColor,
    required this.borderRadius,
  });

  static MoonBoxFloatingContainer get light {
    return MoonBoxFloatingContainer(
      bgColor: lightBgColor,
      borderRadius: _borderRadius,
    );
  }

  static MoonBoxFloatingContainer get dark {
    return MoonBoxFloatingContainer(
      bgColor: darkBgColor,
      borderRadius: _borderRadius,
    );
  }

  @override
  ThemeExtension<MoonBoxFloatingContainer> copyWith({
    Color? withBgColor,
    double? withBorderRadius,
  }) {
    return MoonBoxFloatingContainer(
      bgColor: withBgColor ?? bgColor,
      borderRadius: withBorderRadius ?? borderRadius,
    );
  }

  @override
  MoonBoxFloatingContainer lerp(ThemeExtension<MoonBoxFloatingContainer>? other, double t) {
    if (other is! MoonBoxFloatingContainer) {
      return this;
    }
    return MoonBoxFloatingContainer(
      bgColor: Color.lerp(bgColor, other.bgColor, t) ?? bgColor,
      borderRadius: lerpDouble(borderRadius, other.borderRadius, t) ?? borderRadius,
    );
  }
}



class LlFileThemeData {
  static double dividerThickness = 1.0;
  static double iconSize = 21.0;
  
  static Color lightSurfaceColor = const Color(0xffffffff);
  static Color lightOnSurfaceColor = Colors.black87;
  static Color lightCanvasColor = const Color(0xfff9f9f9);
  static Color lightOnCanvasColor = Colors.black26;
  static Color lightPrimaryColor = Colors.blueAccent[700]!;
  static Color lightOnPrimaryColor = Colors.white;
  static Color lightError = Colors.red;
  static Color lightOnError = Colors.white;
  static Brightness lightBrightness = Brightness.light;
  static Color lightToolIconColor = const Color(0xff878787);


  static Color darkSurfaceColor = const Color(0xff262626);
  static Color darkOnSurfaceColor = Colors.white;
  static Color darkCanvasColor = const Color(0xff212121);
  static Color darkOnCanvasColor = Colors.white54;
  static Color darkPrimaryColor = Colors.blueAccent[700]!;
  static Color darkOnPrimaryColor = Colors.black;
  static Color darkError = Colors.red;
  static Color darkOnError = Colors.white;
  static Brightness darkBrightness = Brightness.dark;
  static Color darkToolIconColor = Colors.white60;

  static ThemeData get lightTheme {
    return ThemeData(
      fontFamily: 'NotoSansSC',
      appBarTheme: AppBarTheme(
        backgroundColor: lightCanvasColor,
        foregroundColor: lightOnCanvasColor,
        iconTheme: IconThemeData(color: lightToolIconColor, size: iconSize),
      ),
      bottomAppBarTheme: BottomAppBarTheme(
        color: lightCanvasColor
      ),
      dividerTheme: DividerThemeData(color: const Color(0xffe6e6e6), thickness: dividerThickness),
      scaffoldBackgroundColor: lightSurfaceColor,
      colorScheme: ColorScheme(
          brightness: LlFileThemeData.lightBrightness,
          primary: LlFileThemeData.lightPrimaryColor,
          onPrimary: LlFileThemeData.lightOnPrimaryColor,
          secondary: LlFileThemeData.lightPrimaryColor,
          onSecondary: LlFileThemeData.lightOnPrimaryColor,
          error: LlFileThemeData.lightError,
          onError: LlFileThemeData.lightOnError,
          surface: LlFileThemeData.lightSurfaceColor,
          onSurface: lightOnSurfaceColor,
          surfaceContainer: lightSurfaceColor,
      ),
      extensions: [
        MoonBoxFloatingContainer.light,
      ]
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      fontFamily: 'NotoSansSC',
      appBarTheme: AppBarTheme(
        backgroundColor: darkCanvasColor,
        foregroundColor: darkOnCanvasColor,
        iconTheme: IconThemeData(color: darkToolIconColor, size: iconSize),
      ),
      bottomAppBarTheme: const BottomAppBarTheme(
        color: Color(0xff262626),
      ),
      dividerTheme: DividerThemeData(color: const Color(0xff3b3b3b), thickness: dividerThickness),
      scaffoldBackgroundColor: darkSurfaceColor,
      colorScheme: ColorScheme(
          brightness: LlFileThemeData.darkBrightness,
          primary: LlFileThemeData.darkPrimaryColor,
          onPrimary: LlFileThemeData.darkOnPrimaryColor,
          secondary: LlFileThemeData.darkPrimaryColor,
          onSecondary: LlFileThemeData.darkOnPrimaryColor,
          error: LlFileThemeData.darkError,
          onError: LlFileThemeData.darkOnError,
          surface: LlFileThemeData.darkSurfaceColor,
          onSurface: darkOnSurfaceColor,
          surfaceContainer: darkSurfaceColor,
      ),
      // ...
      extensions: [
        MoonBoxFloatingContainer.dark,
      ]
    );
  }
}
