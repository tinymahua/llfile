import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:llfile/events/events.dart';
import 'package:llfile/events/layout_events.dart';
import 'package:llfile/events/path_events.dart';
import 'package:llfile/events/ui_events.dart';
import 'package:llfile/models/app_config_model.dart';
import 'package:llfile/models/path_model.dart';
import 'package:llfile/pages/settings_page.dart';
import 'package:llfile/utils/db.dart';
import 'package:path/path.dart';
import 'package:window_manager/window_manager.dart';

class LlToolbar extends StatefulWidget {
  const LlToolbar({super.key});

  @override
  State<LlToolbar> createState() => _LlToolbarState();
}

class _LlToolbarState extends State<LlToolbar> {
  bool _isMaximized = false;

  final TextEditingController _fsPathTextController = TextEditingController();
  final FocusNode _fsPathFocusNode = FocusNode();
  final PathHistoryDb _pathHistoryDb = Get.find<PathHistoryDb>();

  final AppConfigDb _appConfigDb = Get.find<AppConfigDb>();
  AppConfig? _appConfig;

  @override
  void initState() {
    super.initState();
    setupEvents();
  }

  setupEvents()async{
    var appConfig = await _appConfigDb.read<AppConfig>();
    setState(() {
      _appConfig = appConfig;
    });

    eventBus.on<PathChangeEvent>().listen((evt){
      setState(() {
        _fsPathTextController.text = evt.path;
      });
      eventBus.fire(UpdateTabEvent(label: basename(evt.path), path: evt.path));
    });
  }

  toggleSidebarSwitch() {
    eventBus.fire(ToggleSidebarSwitchEvent());
  }

  @override
  Widget build(BuildContext context) {
    print("_appConfig!.appearance.themeMode:  ${_appConfig != null ? _appConfig!.appearance.toJson(): ""}");
    return Container(
      // 这里可以设置工具栏的高度等样式属性
      height: 50,
      // color: Colors.grey[300],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 折叠侧边栏按钮
          Expanded(
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.view_sidebar_outlined,
                    weight: 0.6,
                    size: Theme.of(context).appBarTheme.iconTheme!.size,
                    color: Theme.of(context).appBarTheme.iconTheme!.color!,
                  ),
                  onPressed: () {
                    toggleSidebarSwitch();
                  },
                ),
                IconButton(
                    onPressed: () {
                      onBackPath();
                    },
                    icon: Icon(
                      Icons.chevron_left,
                      weight: 0.6,
                      size: Theme.of(context).appBarTheme.iconTheme!.size,
                      color: Theme.of(context).appBarTheme.iconTheme!.color!,
                    )),
                IconButton(
                    onPressed: () {
                      refreshFsEntities();
                    },
                    icon: Icon(
                      Icons.refresh,
                      weight: 0.6,
                      size: Theme.of(context).appBarTheme.iconTheme!.size,
                      color: Theme.of(context).appBarTheme.iconTheme!.color!,
                    )),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(left: 4),
                    height: 28,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                          color: Theme.of(context).dividerTheme.color!,
                          width: Theme.of(context).dividerTheme.thickness!),
                    ),
                    child: TextField(
                        focusNode: _fsPathFocusNode,
                        onEditingComplete: () => onFsPathInputDone(),
                        onTapOutside: (e) => onFsPathInputDone(),
                        textAlignVertical: TextAlignVertical.center,
                        style: TextStyle(
                            // fontFamily: "NotoSansSC",
                            fontWeight: FontWeight.w900,
                            fontSize: 12.0,
                            color: Theme.of(context).colorScheme.onSurface),
                        controller: _fsPathTextController,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(vertical: 0),
                          focusedBorder:
                              OutlineInputBorder(borderSide: BorderSide.none),
                          border: OutlineInputBorder(borderSide: BorderSide.none),
                        )),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 30),
          // 放置最小化、最大化、关闭按钮的Row

          Row(children: [
            IconButton(
              alignment: Alignment.center,
              icon: Icon(
                _appConfig != null && _appConfig!.appearance.themeMode == ThemeMode.light ? Icons.dark_mode :Icons.light_mode,
                size: Theme.of(context).appBarTheme.iconTheme!.size,
                color: Theme.of(context).appBarTheme.iconTheme!.color!,
              ),
              onPressed: () {
                if (_appConfig != null){
                  setState(() {
                    _appConfig!.appearance.themeMode = _appConfig!.appearance.themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
                  });
                  _appConfigDb.write(_appConfig!);
                  Get.put(_appConfigDb);
                  eventBus.fire(ThemeChangedEvent(_appConfig!.appearance.themeMode));
                }
              },
            ),
            IconButton(
              alignment: Alignment.center,
              icon: Icon(
                Icons.settings,
                size: Theme.of(context).appBarTheme.iconTheme!.size,
                color: Theme.of(context).appBarTheme.iconTheme!.color!,
              ),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){
                  return SettingsPage();
                }));
              },
            ),
          ],),
          VerticalDivider(width: 1,),
          Row(
            children: [
              IconButton(
                alignment: Alignment.center,
                icon: Icon(
                  Icons.horizontal_rule_rounded,
                  size: Theme.of(context).appBarTheme.iconTheme!.size,
                  color: Theme.of(context).appBarTheme.iconTheme!.color!,
                ),
                onPressed: () {
                  windowManager.minimize();
                },
              ),
              IconButton(
                icon: Icon(
                  _isMaximized ? Icons.fullscreen_exit : Icons.fullscreen,
                  size: Theme.of(context).appBarTheme.iconTheme!.size,
                  color: Theme.of(context).appBarTheme.iconTheme!.color!,
                ),
                onPressed: _isMaximized
                    ? () {
                        windowManager.restore();
                        setState(() {
                          _isMaximized = false;
                        });
                      }
                    : () {
                        windowManager.maximize();
                        setState(() {
                          _isMaximized = true;
                        });
                      },
              ),
              IconButton(
                icon: Icon(
                  Icons.close,
                  size: Theme.of(context).appBarTheme.iconTheme!.size,
                  color: Theme.of(context).appBarTheme.iconTheme!.color!,
                ),
                onPressed: () {
                  windowManager.close();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }



  refreshFsEntities() async {
    String fsPath = _fsPathTextController.text.trim();
    eventBus.fire(PathChangeEvent(path: fsPath));
  }

  onFsPathInputDone() async {
    String fsPath = _fsPathTextController.text.trim();
    eventBus.fire(PathChangeEvent(path: fsPath));
  }

  onBackPath() async {
    var pathHistories = await _pathHistoryDb.read<PathHistories>();
    if (pathHistories.histories.length > 1){
      pathHistories.histories.removeLast();
      _pathHistoryDb.write(pathHistories);
      if (pathHistories.histories.isNotEmpty){
        eventBus.fire(PathChangeEvent(path: pathHistories.histories.last));
        _fsPathFocusNode.unfocus();
      }
    }
  }
}
