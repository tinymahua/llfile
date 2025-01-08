import 'package:flutter/material.dart';

class ContextMenuItem extends StatefulWidget {
  const ContextMenuItem(
      {super.key,
        required this.icon,
        required this.title,
        this.onTap,
        this.shortcut,
        this.hoveredColor});

  final Widget icon;
  final Widget title;
  final Function()? onTap;
  final String? shortcut;
  final Color? hoveredColor;

  @override
  State<ContextMenuItem> createState() => _ContextMenuItemState();
}

class _ContextMenuItemState extends State<ContextMenuItem> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: _hovered
            ? widget.hoveredColor ?? Colors.grey.withOpacity(0.2)
            : Colors.transparent,
      ),
      child: MouseRegion(
          onHover: (_) {
            setState(() {
              _hovered = true;
            });
          },
          onExit: (_) {
            setState(() {
              _hovered = false;
            });
          },
          child: GestureDetector(
            onTap: widget.onTap,
            child: Container(
              color: Colors.transparent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        SizedBox(width: 6,),
                        widget.icon,
                        SizedBox(
                          width: 5,
                        ),
                        widget.title,
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      widget.shortcut != null ? Text(widget.shortcut!) : Container(),
                      SizedBox(width: 6,),
                    ],
                  ),
                ],
              ),
            ),
          )),
    );
  }
}

class ContextMenuView extends StatelessWidget {
  const ContextMenuView(
      {super.key, required this.menuSections, this.divider, this.padding});

  final List<List<Widget>> menuSections;
  final Widget? divider;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).dividerTheme.color!, width: 1),
      ),
      padding: padding ?? const EdgeInsets.symmetric(vertical: 3),
      child: Column(
        children: List<Widget>.generate(
            menuSections.length,
                (index) => Column(
                children: List<Widget>.generate(menuSections[index].length,
                        (subIndex) {
                      return Container(
                          child: menuSections[index][subIndex]);
                    })
                  ..add(
                    SizedBox(
                      height: 4,
                    ),
                  )
                  ..add(divider != null && index != menuSections.length - 1
                      ? divider!
                      : Container())
              // ..add(
              //   SizedBox(
              //     height: 4,
              //   ),
              // ),
            )),
      ),
    );
  }
}
