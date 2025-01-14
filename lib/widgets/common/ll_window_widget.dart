import 'package:flutter/material.dart';
import 'package:multi_split_view/multi_split_view.dart';
import 'package:window_manager/window_manager.dart';

class LlWindowWidget extends StatefulWidget {
  LlWindowWidget(
      {super.key,
      this.isHome = true,
      this.toolsSize = 48.0,
      this.statusSize = 24.0,
      this.sideSize = 200.0,
      this.sideSizeMin = 40.0,
      this.sideSizeMax = 400.0,
      this.extraSize = 300.0,
      this.extraSizeMin = 30.0,
      this.extraSizeMax = 400.0,
        this.toolbar,
        this.sidebar,
        this.statusBar,
        required this.content,
        this.extra,
      });

  bool isHome = true;

  double toolsSize;
  double statusSize;
  double sideSize;
  double sideSizeMin;
  double sideSizeMax;
  double extraSize;
  double extraSizeMin;
  double extraSizeMax;

  Widget? toolbar;
  Widget? sidebar;
  Widget? statusBar;
  Widget content;
  Widget? extra;

  @override
  State<LlWindowWidget> createState() => _LlWindowWidgetState();
}

class _LlWindowWidgetState extends State<LlWindowWidget> {
  double _toolsSize = 48.0;
  double _statusSize = 24.0;
  double _sideSize = 200.0;
  double _sideSizeMin = 40.0;
  double _sideSizeMax = 400.0;
  double _extraSize = 300;
  double _extraSizeMin = 30;
  double _extraSizeMax = 400;

  final MultiSplitViewController _mainMultiSplitViewController =
      MultiSplitViewController();
  final MultiSplitViewController _middleMultiSplitViewController =
      MultiSplitViewController();

  bool _pushDividers = false;

  bool _sidebarFolded = false;
  bool _taskCenterFoled = false;

  @override
  void initState() {
    super.initState();
    _toolsSize = widget.toolsSize;
    _statusSize = widget.statusSize;
    _sideSize = widget.sideSize;
    _sideSizeMin = widget.sideSizeMin;
    _sideSizeMax = widget.sideSizeMax;
    _extraSize = widget.extraSize;
    _extraSizeMax = widget.extraSizeMax;
    _extraSizeMin = widget.extraSizeMin;

    _middleMultiSplitViewController.areas = [
      Area(
          data: null,
          id: "side",
          size: _sideSize,
          min: _sideSizeMin,
          max: _sideSizeMax),
      Area(data: null, id: "content", flex: 1),
      Area(
          data: null,
          id: "extra",
          size: _extraSize,
          min: _extraSizeMin,
          max: _extraSizeMax),
    ];
    _mainMultiSplitViewController.areas = [
      Area(
          data: null,
          id: "tools",
          size: _toolsSize,
          min: _toolsSize,
          max: _toolsSize),
      Area(data: null, id: "middle", flex: 1),
      Area(
          data: null,
          id: "status",
          size: _statusSize,
          min: _statusSize,
          max: _statusSize),
    ];
    setupEvents();
  }

  setupEvents() {}

  Widget buildToolsArea() {
    return GestureDetector(
      onPanStart: (details) {
        windowManager.startDragging();
      },
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).appBarTheme.backgroundColor,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            widget.toolbar??Container(),
            Row(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.close,
                    size: Theme.of(context).appBarTheme.iconTheme!.size,
                    color: Theme.of(context).appBarTheme.iconTheme!.color!,
                  ),
                  onPressed: () {
                    if (widget.isHome) {
                      windowManager.close();
                    } else {
                      Navigator.of(context).pop();
                    }
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget buildSideArea() {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).appBarTheme.backgroundColor,
      ),
      child: widget.sidebar,
    );
  }

  Widget buildContentArea() {
    return Container(
      padding: EdgeInsets.only(left: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      // child: const LlFsEntitiesListWidget(),
      child: widget.content,
    );
  }

  Widget buildExtraArea() {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      child: widget.extra,
    );
  }

  Widget buildMiddleArea() {
    MultiSplitView middleMultiSplitView = MultiSplitView(
      controller: _middleMultiSplitViewController,
      pushDividers: _pushDividers,
      dividerBuilder:
          (axis, index, resizable, dragging, highlighted, themeData) {
        Widget d = Container(
          color: Theme.of(context).dividerTheme.color!,
        );
        if (index == 0 && _sideSizeMax == 0){
          d = Container();
        }
        if (index == 2 && _extraSizeMax == 0){
          d = Container();
        }
        if (_sideSizeMax == 0 && _extraSizeMax == 0){
          d = Container();
        }
        return d;
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
    return Scaffold(
        appBar: null,
        body: Container(
            decoration: const BoxDecoration(
                color: Colors.transparent
            ),
            child: buildLayout()));
  }
}
