import 'package:flutter/material.dart';
import 'package:multi_split_view/multi_split_view.dart';


class FsmgrPage extends StatefulWidget {
  const FsmgrPage({super.key});

  @override
  State<FsmgrPage> createState() => _FsmgrPageState();
}

class _FsmgrPageState extends State<FsmgrPage> {
  final MultiSplitViewController _mainMultiSplitViewController =
      MultiSplitViewController();
  final MultiSplitViewController _middleMultiSplitViewController =
      MultiSplitViewController();
  bool _pushDividers = false;
  double _toolsSize = 48.0;
  double _statusSize = 24.0;
  double _sideSize = 200.0;
  double _sideSizeMin = 120.0;
  double _sideSizeMax = 400.0;
  double _extraSize = 160;
  double _extraSizeMin = 120.0;
  double _extraSizeMax = 240;

  @override
  void initState() {
    super.initState();
    _middleMultiSplitViewController.areas = [
      Area(data: null, id: "side", size: _sideSize, min: _sideSizeMin, max: _sideSizeMax),
      Area(data: null, id: "content", flex: 1),
      Area(data: null, id: "extra", size: _extraSize, min: _extraSizeMin, max: _extraSizeMax),
    ];
    _mainMultiSplitViewController.areas = [
      Area(data: null, id: "tools", size: _toolsSize, min: _toolsSize, max: _toolsSize),
      Area(data: null, id: "middle", flex: 1),
      Area(data: null, id: "status", size: _statusSize, min: _statusSize, max: _statusSize),
    ];
  }

  Widget buildToolsArea(){
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).appBarTheme.backgroundColor,
      ),
    );
  }

  Widget buildSideArea() {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).appBarTheme.backgroundColor,
      ),
    );
  }

  Widget buildContentArea() {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
    );
  }

  Widget buildExtraArea() {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
    );
  }

  Widget buildMiddleArea() {
    MultiSplitView middleMultiSplitView = MultiSplitView(
      controller: _middleMultiSplitViewController,
      pushDividers: _pushDividers,
      dividerBuilder: (axis, index, resizable, dragging, highlighted, themeData) {
        return Container(
          color: Theme.of(context).dividerTheme.color!,
        );
      },
      axis: Axis.horizontal,
      builder: (BuildContext context, Area area) {
        if (area.id == "side") {
          return buildSideArea();
        } else if (area.id == "content") {
          return buildContentArea();
        } else if (area.id == "extra") {
          return buildExtraArea();
        }
        return Container();
      },
    );

    return MultiSplitViewTheme(
        data: MultiSplitViewThemeData(
          dividerThickness: Theme.of(context).dividerTheme.thickness!,
        ),
        child: middleMultiSplitView);
  }

  Widget buildStatusArea() {
    return Container(
        decoration: BoxDecoration(
      color: Theme.of(context).bottomAppBarTheme.color,
    ));
  }

  Widget buildLayout() {
    MultiSplitView mainMultiSplitView = MultiSplitView(
        controller: _mainMultiSplitViewController,
        pushDividers: _pushDividers,
        dividerBuilder:
            (axis, index, resizable, dragging, highlighted, themeData) {
          return Container(
            color: Theme.of(context).dividerTheme.color!,
          );
        },
        axis: Axis.vertical,
        builder: (BuildContext context, Area area) {
          if (area.id == "tools") {
            return buildToolsArea();
          } else if (area.id == "middle") {
            return buildMiddleArea();
          } else if (area.id == "status") {
            return buildStatusArea();
          }
          return Container();
        });

    return MultiSplitViewTheme(
        data: MultiSplitViewThemeData(
          dividerThickness: Theme.of(context).dividerTheme.thickness!,
        ),
        child: mainMultiSplitView);
  }

  @override
  Widget build(BuildContext context) {
    return Container(color: Colors.transparent, child: buildLayout());
  }
}

















