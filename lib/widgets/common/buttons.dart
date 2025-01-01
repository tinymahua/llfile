import 'package:flutter/material.dart';

class TapOrDoubleTapButton extends StatefulWidget {
  TapOrDoubleTapButton({super.key, required this.child, this.onTap, this.onDoubleTap, this.hoverColor = Colors.transparent});

  Widget child;
  final Function()? onTap;
  final Function()? onDoubleTap;
  Color hoverColor;

  @override
  State<TapOrDoubleTapButton> createState() => _TapOrDoubleTapButtonState();
}

class _TapOrDoubleTapButtonState extends State<TapOrDoubleTapButton> {
  // int _lastClickMilliseconds = -1;
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // int currMills = DateTime.now().millisecondsSinceEpoch;
        // if ((currMills - _lastClickMilliseconds) < 500) {
        //   widget.onDoubleTap?.call();
        // } else {
        //   _lastClickMilliseconds = currMills;
        //   widget.onTap?.call();
        // }
        widget.onTap?.call();
      },
      onDoubleTap: (){
        widget.onDoubleTap?.call();
      },
      child: Container(
        decoration: BoxDecoration(color: _isHovered ? widget.hoverColor : Colors.transparent),
        child: MouseRegion(
          onHover: (_){
            setState(() {
              _isHovered = true;
            });
          },
          onExit: (_){
            setState(() {
              _isHovered = false;
            });
          },
          child: widget.child,
        ),
      ),
    );
  }
}
