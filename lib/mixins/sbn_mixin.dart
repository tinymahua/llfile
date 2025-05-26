import 'dart:io';

import 'package:llfile/models/app_config_model.dart';
import 'package:llfile/src/rust/api/sandbar_node.dart';

mixin SbnMixin {

  String getSandbarNodeConfigFilePath(AppConfig appConfig){
    return appConfig.advancedSettings.sandbarClientNodeConfig?.configLocation ?? '';
  }

  Future<bool> isReady(AppConfig? appConfig) async {
    if (appConfig == null){
      return false;
    }

    var sandbarClientNodeConfig = appConfig.advancedSettings.sandbarClientNodeConfig;
    if (sandbarClientNodeConfig == null){
      return false;
    }

    var configFile = sandbarClientNodeConfig.configLocation;
    if (!File(configFile).existsSync()){
      return false;
    }

    var sandbarStat = await getSandbarNodeStat(
        configFilePath:configFile);

    return appConfig.accountSettings.sandbarAuthInfo != null &&
        appConfig.advancedSettings.sandbarClientNodeEnabled &&
        sandbarStat.running;
  }

  addPathToSandbarFs(String path) async {

  }
}
