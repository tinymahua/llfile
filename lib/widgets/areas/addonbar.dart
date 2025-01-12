import 'package:flutter/material.dart';
import 'package:llfile/events/addon_events.dart';
import 'package:llfile/events/events.dart';
import 'package:llfile/events/layout_events.dart';
import 'package:llfile/src/rust/api/llfs.dart';
import 'package:llfile/widgets/common/buttons.dart';
import 'package:llfile/widgets/partials/ll_md_widget.dart';
import 'package:llfile/widgets/partials/ll_terminal_widget.dart';

class LlAddonBar extends StatefulWidget {
  const LlAddonBar({super.key});

  @override
  State<LlAddonBar> createState() => _LlAddonBarState();
}

class _LlAddonBarState extends State<LlAddonBar> {
  double _iconSize = 20;
  bool _extraContentFolded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MouseRegion(
          child: TapOrDoubleTapButton(
            hoverColor: Theme.of(context).dividerTheme.color!,
            child: Icon(
              _extraContentFolded? Icons.keyboard_double_arrow_left: Icons.keyboard_double_arrow_right,
              size: _iconSize,
            ),
            onTap: () {
              toggleExtraContentSwitch();
            },
          ),
        ),
        SizedBox(height: 4,),
        Divider(height: 1, color: Theme.of(context).dividerTheme.color!,),
        MouseRegion(
          child: TapOrDoubleTapButton(
            hoverColor: Theme.of(context).dividerTheme.color!,
            child: Icon(
              Icons.task_alt,
              size: _iconSize,
            ),
            onTap: () {
              switchAddon(0);
            },
          ),
        ),
        SizedBox(height: 4,),
        MouseRegion(
          child: TapOrDoubleTapButton(
            hoverColor: Theme.of(context).dividerTheme.color!,
            child: Icon(
              Icons.preview_outlined,
              size: _iconSize,
            ),
            onTap: () {
              switchAddon(1);
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
              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){
                return LlMdWidget();
              }));
            },
          ),
        ),
        SizedBox(height: 4,),
        MouseRegion(
          child: TapOrDoubleTapButton(
            hoverColor: Theme.of(context).dividerTheme.color!,
            child: Icon(
              Icons.terminal_outlined,
              size: _iconSize,
            ),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){
                return LlTerminalWidget();
              }));
            },
          ),
        ),
      ],
    );
  }

  switchAddon(int index){
    eventBus.fire(SwitchAddonEvent(index));
  }

  toggleExtraContentSwitch() {
    setState(() {
      _extraContentFolded = !_extraContentFolded;
    });
    eventBus.fire(ToggleExtraContentSwitchEvent());
  }
}
