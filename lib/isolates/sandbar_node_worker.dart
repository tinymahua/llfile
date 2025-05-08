import 'dart:isolate';

import 'package:easy_isolate/easy_isolate.dart' as easy_isolate;
import 'package:llfile/src/rust/api/sandbar_node.dart';
import 'package:llfile/src/rust/frb_generated.dart';

sandbarNodeWorkerMainMessageHandler(dynamic data, SendPort isolateSendPort){
  print('in main func');
}

sandbarNodeWorkerIsolateMessageHandler(dynamic data, SendPort isolateSendPort, easy_isolate.SendErrorFunction sendError,)async{
  print('in isolate func： ${data}');
  if (data is SandbarNodeOperateEvent){
    print('111');
    if (data.operate == Operate.start) {
      print('222');
      try {
        await RustLib.init();
      } catch (e) {
        //
      }
      print('do start');
      await startSandbarNodeService(
          configFilePath: "C:\\Users\\Maple\\.sbn1_remote\\config.toml");
    }else if (data.operate == Operate.stop){
      print('do stop');
      await stopSandbarNodeService(configFilePath: "C:\\Users\\Maple\\.sbn1_remote\\config.toml");
    }else if (data.operate == Operate.terminate){
      print('do terminate');
      RustLib.dispose();
    }
  }
}

// class SandbarNodeWorker {
//   SandbarNodeWorker(this.worker);
//
//   easy_isolate.Worker worker;
//
//   Future<void> init() async {
//     await worker.init(
//       mainMessageHandler,
//       controlSandbarNodeServiceIsolateMessageHandler,
//       errorHandler: print,
//     );
//     worker.sendMessage(SandbarNodeOperateEvent(Operate.start));
//   }
//
//   Future<void> sendMessage(SandbarNodeOperateEvent evt)async{
//     worker.sendMessage(evt);
//   }
//
//   void mainMessageHandler(dynamic data, SendPort isolateSendPort) {
//   }
//
//   static controlSandbarNodeServiceIsolateMessageHandler(
//       dynamic data,
//       SendPort mainSendPort,
//       easy_isolate.SendErrorFunction sendError,
//       ) async {
//     if (data is SandbarNodeOperateEvent){
//       print(data);
//       if (data.operate == Operate.start) {
//         print('do start');
//         await RustLib.init();
//         // Get.put(AppConfigDb());
//         // AppConfigDb _appConfigDb = Get.find<AppConfigDb>();
//         // AppConfig _appConfig = await _appConfigDb.read<AppConfig>();
//         // SandbarClientNodeConfig? sandbarClientNodeConfig = _appConfig.advancedSettings.sandbarClientNodeConfig;
//         await startSandbarNodeService(
//             configFilePath: "C:\\Users\\Maple\\.sbn1_remote\\config.toml");
//         RustLib.dispose();
//       }else if (data.operate == Operate.stop){
//         try {
//           await RustLib.init();
//         }catch (err) {
//           //
//         }
//         print('do stop');
//         await stopSandbarNodeService(configFilePath: "C:\\Users\\Maple\\.sbn1_remote\\config.toml");
//         RustLib.dispose();
//       }
//     }
//   }
// }

enum Operate {
  start,
  stop,
  terminate,
}

class SandbarNodeOperateEvent {
  Operate operate;
  SandbarNodeOperateEvent(this.operate);
}