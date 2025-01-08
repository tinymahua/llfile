import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_colorful_tab/flutter_colorful_tab.dart';
import 'package:get/get.dart';
import 'package:llfile/events/events.dart';
import 'package:llfile/events/path_events.dart';
import 'package:llfile/utils/db.dart';
import 'package:llfile/widgets/common/buttons.dart';
import 'package:llfile/widgets/common/keep_alive_wrapper.dart';
import 'package:llfile/widgets/partials/ll_fs_entities_list_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LlTabBar extends StatefulWidget {
  const LlTabBar({super.key});

  @override
  State<LlTabBar> createState() => _LlTabBarState();
}

class _LlTabBarState extends State<LlTabBar> with TickerProviderStateMixin {
  List<TabItem> _tabItems = [];
  List<Widget> _tabViews = [];
  List<GlobalKey> _tabViewKeys = [];
  List<String> _tabCurrentPaths = [];
  TabController? _tabController;
  PageController _pageController = PageController(keepPage: true, initialPage: 0);
  double _tabWidth = 80;
  AppStatesMemDb _appStatesMemDb = Get.find<AppStatesMemDb>();

  @override
  void initState() {
    super.initState();
    setupEvents();
  }

  setupEvents() async{
    eventBus.on<UpdateTabEvent>().listen((evt) {
      updateTab(evt);
    });
  }

  @override
  Widget build(BuildContext context) {
    return _tabController != null && _tabItems.isNotEmpty
        ? Column(
            children: [
              Container(
                decoration: BoxDecoration(color: Theme.of(context).appBarTheme.backgroundColor),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: Container(
                          padding: EdgeInsets.only(bottom: 3),
                          decoration: BoxDecoration(
                            color: Theme.of(context).appBarTheme.backgroundColor,
                          ),
                          child: ColorfulTabBar(
                            tabShape: RoundedRectangleBorder(
                              side: BorderSide(color: Theme.of(context).dividerTheme.color!),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(4.0),
                                  topRight: Radius.circular(4.0),
                                )
                            ),
                            indicatorHeight: 1,
                            unselectedHeight: 24,
                            selectedHeight: 24,
                            tabs: _tabItems,
                            controller: _tabController,
                            alignment: TabAxisAlignment.start,
                          )),
                    ),
                    TapOrDoubleTapButton(
                      hoverColor: Theme.of(context).dividerTheme.color!,
                      child: Icon(
                        Icons.chevron_left,
                        size: 21,
                      ),
                      onTap: () {
                        clickTabsLeft(false);
                      },
                      onDoubleTap: () {
                        clickTabsLeft(true);
                      },
                    ),
                    TapOrDoubleTapButton(
                      hoverColor: Theme.of(context).dividerTheme.color!,
                      child: Icon(
                        Icons.chevron_right,
                        size: 21,
                      ),
                      onTap: () {
                        clickTabsRight(false);
                      },
                      onDoubleTap: () {
                        clickTabsRight(true);
                      },
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          fit: FlexFit.loose,
                          child: Container(
                            decoration: BoxDecoration(
                              color:
                                  Theme.of(context).appBarTheme.backgroundColor,
                              // border: Border(bottom: BorderSide(color: Theme.of(context).dividerTheme.color!, width: 2))
                            ),
                            child: TextButton(
                                style: ButtonStyle(
                                  padding:
                                      WidgetStatePropertyAll(EdgeInsets.all(2)),
                                ),
                                onPressed: () {
                                  addTab("新标签");
                                },
                                child: Icon(Icons.add)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: PageView(
                  controller: _pageController,
                  scrollDirection: Axis.horizontal,
                  pageSnapping: true,
                  children: _tabViews,
                ),
              )
            ],
          )
        : Container();
  }

  updateTab(UpdateTabEvent evt) {
    setState(() {
      _tabItems[_tabController!.index] = makeTabItem(evt.label);
      _tabCurrentPaths[_tabController!.index] = evt.path;
    });
  }

  switchTab(int index){
    _tabController!.index = index;
    switchPage(index);
  }

  switchPage(int index){
    _pageController.jumpToPage(index);
    if (_tabCurrentPaths[index].isNotEmpty){
      eventBus.fire(PathChangeEvent(path: _tabCurrentPaths[index]));
    }
    _appStatesMemDb.activatedFileBrowserTabIdx = index;
    Get.put(_appStatesMemDb);
  }

  makeTabItem(String tabLabel) {
    return TabItem(
        color: Theme.of(context).dividerTheme.color!,
        unselectedColor: Theme.of(context).appBarTheme.backgroundColor!,
        title: Container(
          width: _tabWidth,
          child: Text(
            tabLabel,
            style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
          ),
        ));
  }

  addTab(String tabLabel) {
    int oldTabsLength = _tabItems.length;
    Timer.periodic(Duration(milliseconds: 100), (t) {
      if (_tabController!.length == _tabItems.length) {
        print("addTab done");
        t.cancel();
        setState(() {
          int newTabIdx = _tabController!.length - 1;
          switchTab(newTabIdx);
        });
      }
    });
    GlobalKey newViewKey = GlobalKey();
    setState(() {
      _tabItems.add(makeTabItem(AppLocalizations.of(context)!.tabLabelBlank));
      _tabViewKeys.add(newViewKey);
      _tabCurrentPaths.add("");
      _tabViews.add(KeepAliveWrapper(
        keepAlive: true,
        child: LlFsEntitiesListWidget(
          key: newViewKey,
          tabIndex: oldTabsLength,
        ),
      ));
      _tabController = TabController(length: oldTabsLength + 1, vsync: this);
      _tabController!.addListener(() {
        if (_tabController!.indexIsChanging) {
          print("indexIsChanging");
          switchPage(_tabController!.index);
        }
      });
    });
  }

  clickTabsLeft(bool doubleTap) {
    if (doubleTap){
      int firstIndex = 0;
      switchTab(firstIndex);
    }else{
      if (_tabController!.index >= 1){
        int preIndex = _tabController!.index - 1;
        switchTab(preIndex);
      }
    }

  }

  clickTabsRight(bool doubleTap) {
    if (doubleTap){
      int lastIndex = _tabItems.length - 1;
      switchTab(lastIndex);
    }else{
      if (_tabController!.index < _tabItems.length - 1){
        int nextIndex = _tabController!.index + 1;
        switchTab(nextIndex);
      }
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    addTab("新标签");
  }
}
