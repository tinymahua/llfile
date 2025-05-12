import 'dart:isolate';

import 'package:easy_isolate/easy_isolate.dart' as easy_isolate;
import 'package:llfile/src/rust/api/sandbar_node.dart';
import 'package:llfile/src/rust/frb_generated.dart';

sandbarNodeWorkerMainMessageHandler(dynamic data, SendPort isolateSendPort){
  print('in main func');
}

sandbarNodeWorkerIsolateMessageHandler(dynamic data, SendPort isolateSendPort, easy_isolate.SendErrorFunction sendError,)async{
  print('in isolate func： ${data}');
  try {
    await RustLib.init();
  } catch (e) {
    //
  }
  if (data is SandbarNodeOperateEvent){
    print('111');
    String configFile = data.sandbarNodeConfigFile;
    if (data.operate == Operate.start) {
      print('222');

      print('do start');
      await startSandbarNodeService(
          configFilePath: configFile);
    }else if (data.operate == Operate.stop){
      print('do stop');
      await stopSandbarNodeService(configFilePath: configFile);
    }else if (data.operate == Operate.terminate){
      print('do terminate');
      RustLib.dispose();
    }
  }
}


enum Operate {
  start,
  stop,
  terminate,
}

class SandbarNodeOperateEvent {
  Operate operate;
  String sandbarNodeConfigFile;
  SandbarNodeOperateEvent(this.operate, this.sandbarNodeConfigFile);
}