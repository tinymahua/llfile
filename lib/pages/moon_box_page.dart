import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:llfile/events/events.dart';
import 'package:llfile/events/ui_events.dart';
import 'package:llfile/pages/scenes/audio_scene_page.dart';
import 'package:llfile/utils/db.dart';
import 'package:llfile/models/app_config_model.dart';
import 'package:llfile/pages/scenes/note_scene_page.dart';
import 'package:llfile/theme.dart';
import 'package:get/get.dart';
import 'package:window_manager/window_manager.dart';

class MoonBoxPage extends StatefulWidget {
  const MoonBoxPage({super.key});

  @override
  State<MoonBoxPage> createState() => _MoonBoxPageState();
}

const double topStatusHeight = 8.0;
const floatBarSize = 30.0;

class _MoonBoxPageState extends State<MoonBoxPage> {
  AppConfigDb appConfigDb = Get.find<AppConfigDb>();
  late AppConfig appConfig;

  bool aroundToolbarShow = false;
  AppScene appScene = AppScene.note;

  final focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    setupEvents();
  }

  setupEvents()async{
    AppConfig appConfig = await appConfigDb.read<AppConfig>();
    appScene = appConfig.scene;
  }

  Widget makeSceneSwitchWidget(){
    // Widget icon = Icon(Icons.multiple_stop, size: 16,);
    // void Function()? onPressed;
    // if (appScene == AppScene.note) {
    //   icon = Icon(Icons.note_alt_outlined, size: 16,);
    //   onPressed = () {
    //     setState(() {
    //       appScene = AppScene.note;
    //     });
    //   };
    // } else if (appScene == AppScene.chat) {
    //   icon = Icon(Icons.chat_outlined, size: 16,);
    //   onPressed = () {
    //     setState(() {
    //       appScene = AppScene.chat;
    //     });
    //   };
    // }

    Widget sceneButtonBox = Row(children: [
      IconButton(icon: Icon(Icons.note_alt_outlined, size: 16,), onPressed: () {
        setState(() {
          appScene = AppScene.note;
        });
      },),
      IconButton(onPressed: () {
        setState(() {
          appScene = AppScene.chat;
        });
      }, icon: Icon(Icons.chat_outlined, size: 16,)),
      IconButton(onPressed: () {
        setState(() {
          appScene = AppScene.audio;
        });
      }, icon: Icon(Icons.multitrack_audio_outlined, size: 16,))
    ]);

    return sceneButtonBox;
  }

  Widget getSceneContentWidget(){
    Widget w = Container();
    if (appScene == AppScene.note) {
      w = NoteScenePage();
    } else if (appScene == AppScene.chat) {
      w = Container(
        child: Text('chat'),
      );
    }else if (appScene == AppScene.audio){
      w = Container(
        child: AudioScenePage(),
      );
    }
    return w;
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: focusNode,
      autofocus: true,
      onKeyEvent: (event) {
        if (event is KeyUpEvent && event.logicalKey == LogicalKeyboardKey.escape){
          setState(() {
            aroundToolbarShow = !aroundToolbarShow;
          });
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          // borderRadius: BorderRadius.circular(6),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  aroundToolbarShow = false;
                });
              },
              child: MouseRegion(
                onHover: (event) {
                  var dx = event.localPosition.dx;
                  var dy = event.localPosition.dy;
                  // print("dx, dy: ${dx} ${dy}");
                  // checkTriggerFloatBar(dx, dy);
                },
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            getSceneContentWidget(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            aroundToolbarShow
                ? Positioned(
              top: topStatusHeight,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onPanStart: (details) async {
                  windowManager.startDragging();
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: Theme.of(context).extension<MoonBoxFloatingContainer>()!.bgColor,
                      borderRadius: BorderRadius.all(Radius.circular(Theme.of(context).extension<MoonBoxFloatingContainer>()!.borderRadius))
                  ),
                  width: MediaQuery.of(context).size.width - 32 * 2,
                  height: floatBarSize,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // makeAppModeSwitchWidget(),
                      makeSceneSwitchWidget(),
                    ],
                  ),
                ),
              ),
            )
                : SizedBox(),
            aroundToolbarShow
                ? Positioned(
              left: 0,
              child: GestureDetector(
                onPanStart: (details) async {
                  windowManager.startDragging();
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: Theme.of(context).extension<MoonBoxFloatingContainer>()!.bgColor,
                      borderRadius: BorderRadius.all(Radius.circular(Theme.of(context).extension<MoonBoxFloatingContainer>()!.borderRadius))
                  ),
                  height: MediaQuery.of(context).size.height - 46 - 36,
                  width: floatBarSize,
                ),
              ),
            )
                : SizedBox(),
            aroundToolbarShow
                ? Positioned(
              bottom: 0,
              child: GestureDetector(
                onPanStart: (details) async {
                  windowManager.startDragging();
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: Theme.of(context).extension<MoonBoxFloatingContainer>()!.bgColor,
                      borderRadius: BorderRadius.all(Radius.circular(Theme.of(context).extension<MoonBoxFloatingContainer>()!.borderRadius))
                  ),
                  width: MediaQuery.of(context).size.width - 32 * 2,
                  height: floatBarSize,
                ),
              ),
            )
                : SizedBox(),
            aroundToolbarShow
                ? Positioned(
              right: 0,
              child: GestureDetector(
                onPanStart: (details) async {
                  windowManager.startDragging();
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: Theme.of(context).extension<MoonBoxFloatingContainer>()!.bgColor,
                      borderRadius: BorderRadius.all(Radius.circular(Theme.of(context).extension<MoonBoxFloatingContainer>()!.borderRadius))
                  ),
                  height: MediaQuery.of(context).size.height - 46 - 36,
                  width: floatBarSize,
                ),
              ),
            )
                : SizedBox(),
            Positioned(
                top: 6, right: 2,
                child: SizedBox(
                    width: 28, height: 28,
                    child: IconButton(onPressed: (){
                      windowManager.close();
                    }, icon: Icon(Icons.close_rounded, size: 14, weight: 6,)))),
            Positioned(
                top: 6, left: 2,
                child: SizedBox(
                    width: 28, height: 28,
                    child: IconButton(onPressed: (){
                      eventBus.fire(AppModeChangedEvent(AppMode.fsMgr));
                    }, icon: Icon(Icons.arrow_back_outlined, size: 12,))))
      
          ],
        ),
      ),
    );
  }

  checkTriggerFloatBar(double x, double y){
    if (x <= floatBarSize / 2 || x >= MediaQuery.of(context).size.width - floatBarSize / 2 || y <= floatBarSize / 2 || y >= MediaQuery.of(context).size.height - floatBarSize / 2){
      setState(() {
        aroundToolbarShow = true;
      });
    }else{
      // setState(() {
      //   aroundToolbarShow = false;
      // });
    }
  }
}
