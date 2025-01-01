import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_colorful_tab/flutter_colorful_tab.dart';
import 'package:get/get.dart';
import 'package:llfile/events/events.dart';
import 'package:llfile/events/path_events.dart';
import 'package:llfile/models/app_states_model.dart';
import 'package:llfile/utils/db.dart';
import 'package:llfile/widgets/common/buttons.dart';
import 'package:llfile/widgets/common/keep_alive_wrapper.dart';
import 'package:llfile/widgets/partials/ll_fs_entities_list_widget.dart';

class LlTabBar extends StatefulWidget {
  const LlTabBar({super.key});

  @override
  State<LlTabBar> createState() => _LlTabBarState();
}

class _LlTabBarState extends State<LlTabBar> with TickerProviderStateMixin {
  List<TabItem> _tabItems = [];
  List<Widget> _tabViews = [];
  TabController? _tabController;
  PageController? _pageController;
  double _tabWidth = 60;
  AppStatesDb _appStatesDb = Get.find<AppStatesDb>();
  AppStatesMemDb _appStatesMemDb = Get.find<AppStatesMemDb>();

  @override
  void initState() {
    super.initState();
    setupEvents();

    _pageController = PageController(keepPage: true, initialPage: 0);
    _pageController!.addListener(() {
      print("_pageController.index: ${_pageController!.page}");
    });
  }

  setupEvents() async{
    eventBus.on<UpdateTabEvent>().listen((evt) {
      updateTab(evt.label);
    });

    var appStates = await _appStatesDb.read<AppStates>();
    if (appStates.activatedFileBrowserTabIdx >= _tabItems.length){
      await _appStatesDb.setActivatedFileBrowserTabIdx(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _tabController != null && _pageController != null
        ? Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TapOrDoubleTapButton(
                    hoverColor: Theme.of(context).dividerTheme.color!,
                    child: Icon(
                      Icons.chevron_left,
                      size: 18,
                    ),
                    onTap: () {
                      clickTabsLeft(false);
                    },
                    onDoubleTap: () {
                      clickTabsLeft(true);
                    },
                  ),
                  Expanded(
                    child: Container(
                        padding: EdgeInsets.only(bottom: 3),
                        decoration: BoxDecoration(
                          color: Theme.of(context).appBarTheme.backgroundColor,
                        ),
                        child: ColorfulTabBar(
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
                      Icons.chevron_right,
                      size: 18,
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
              // Expanded(
              //     child: TabBarView(
              //   children: _tabViews,
              //   controller: _tabController,
              // )),
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

  makeTabItem(String tabLabel) {
    return TabItem(
        color: Theme.of(context).scaffoldBackgroundColor,
        unselectedColor: Theme.of(context).dividerTheme.color!,
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
          _tabController!.index = _tabController!.length - 1;
          _pageController!.jumpToPage(_tabController!.length - 1);
          _appStatesMemDb.activatedFileBrowserTabIdx = _tabController!.index;
          Get.put(_appStatesMemDb);
        });
      }
    });
    setState(() {
      _tabItems.add(makeTabItem("New Tab"));
      _tabViews.add(KeepAliveWrapper(
        keepAlive: true,
        child: LlFsEntitiesListWidget(
          tabIndex: oldTabsLength,
        ),
      ));
      _tabController = TabController(length: oldTabsLength + 1, vsync: this);
      _tabController!.addListener(() {
        if (_tabController!.indexIsChanging) {
          print("indexIsChanging");
          // print("ID ${_tabViews[0].tabIndex}");
          _pageController!.jumpToPage(_tabController!.index);
          _appStatesMemDb.activatedFileBrowserTabIdx = _tabController!.index;
          Get.put(_appStatesMemDb);
        }
      });
      

      
    });
  }

  updateTab(String tabLabel) {
    setState(() {
      _tabItems[_tabController!.index] = makeTabItem(tabLabel);
    });
    _tabController!.index = _tabController!.index;
  }

  clickTabsLeft(bool doubleTap) {
    print("clickTabsLeft: $doubleTap");
    _tabController!.index = 0;
  }

  clickTabsRight(bool doubleTap) {
    print("_tabController.tabs: ${_tabController!.length}");
    print("clickTabsRight: $doubleTap ${_tabItems.length - 1}");
    _tabController!.index = _tabItems.length - 1;
    _pageController!.jumpToPage(_tabItems.length - 1);
    _appStatesMemDb.activatedFileBrowserTabIdx = _tabController!.index;
    Get.put(_appStatesMemDb);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    addTab("新标签");
    // makeAddTab();
  }
}
