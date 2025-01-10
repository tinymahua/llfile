import 'package:flutter/material.dart';
import 'package:llfile/widgets/common/buttons.dart';

class LlAddonBar extends StatefulWidget {
  const LlAddonBar({super.key});

  @override
  State<LlAddonBar> createState() => _LlAddonBarState();
}

class _LlAddonBarState extends State<LlAddonBar> {
  double _iconSize = 14;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MouseRegion(
          child: TapOrDoubleTapButton(
            hoverColor: Theme.of(context).dividerTheme.color!,
            child: Icon(
              Icons.terminal,
              size: 24,
            ),
            onTap: () {
              openTerminal();
            },
          ),
        ),
      ],
    );
  }

  openTerminal() {
    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){
      return Scaffold(appBar: AppBar(title: Text('Terminal')), body: Container(),);
    }));
  }
}
