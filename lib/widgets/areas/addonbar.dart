import 'package:flutter/material.dart';
import 'package:llfile/events/events.dart';
import 'package:llfile/events/layout_events.dart';
import 'package:llfile/widgets/common/buttons.dart';

class LlAddonBar extends StatefulWidget {
  const LlAddonBar({super.key});

  @override
  State<LlAddonBar> createState() => _LlAddonBarState();
}

class _LlAddonBarState extends State<LlAddonBar> {
  double _iconSize = 20;
  bool _taskCenterFoled = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MouseRegion(
          child: TapOrDoubleTapButton(
            hoverColor: Theme.of(context).dividerTheme.color!,
            child: Icon(
              Icons.task_alt,
              size: _iconSize,
            ),
            onTap: () {
              toggleTaskCenterSwitch();
            },
          ),
        ),
        SizedBox(height: 4,),
        Divider(height: 1, color: Theme.of(context).dividerTheme.color!,),
        SizedBox(height: 4,),
        MouseRegion(
          child: TapOrDoubleTapButton(
            hoverColor: Theme.of(context).dividerTheme.color!,
            child: Icon(
              Icons.note_alt_outlined,
              size: _iconSize,
            ),
            onTap: () {

            },
          ),
        ),
      ],
    );
  }

  toggleTaskCenterSwitch() {
    setState(() {
      _taskCenterFoled = !_taskCenterFoled;
    });
    eventBus.fire(ToggleTaskCenterSwitchEvent());
  }

}
