import 'package:fluent_ui/fluent_ui.dart' as fui;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:llfile/app.dart';
import 'package:llfile/models/app_config_model.dart';
import 'package:llfile/models/markdown_model.dart';
import 'package:llfile/service/sbc_auth_service.dart';
import 'package:llfile/service/sbc_device_service.dart';
import 'package:llfile/src/rust/frb_generated.dart';
import 'package:llfile/utils/db.dart';
import 'package:window_manager/window_manager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
  WindowOptions windowOptions = const WindowOptions(
    size: Size(1200, 800),
    center: true,
    backgroundColor: Colors.black87,
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.hidden,
    windowButtonVisibility: false,
  );
  windowManager.waitUntilReadyToShow(windowOptions, ()async {
    await windowManager.setAsFrameless();
  });



  Get.put(PathHistoryDb());
  Get.put(AppStatesMemDb());
  var appConfigDb = AppConfigDb();
  await appConfigDb.read<AppConfig>();
  Get.put(AppConfigDb());

  Get.put(SbcAuthService());
  Get.put(SbcDeviceService());

  var mdConfigDb = MdConfigDb();
  await mdConfigDb.read<MdConfig>();
  Get.put(MdConfigDb());
  Get.put(FsFavoriteItemsDb());

  await RustLib.init();
  runApp(const LlFileApp());
}





















