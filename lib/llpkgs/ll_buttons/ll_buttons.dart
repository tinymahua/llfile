import 'package:flutter/widgets.dart';

/// Makes its icon button children small.
///
/// See also:
///
///  * [IconButton], which turns small when wrapped in this.
class LlSmallIconButton extends InheritedWidget {
  /// Creates a small icon button.
  const LlSmallIconButton({super.key, required super.child});

  static LlSmallIconButton? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<LlSmallIconButton>();
  }

  @override
  bool updateShouldNotify(LlSmallIconButton oldWidget) {
    return true;
  }
}