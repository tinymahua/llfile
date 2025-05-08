import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:llfile/events/events.dart';
import 'package:llfile/events/settings_events.dart';
import 'package:llfile/isolates/sandbar_node_worker.dart';
import 'package:llfile/models/app_config_model.dart';
import 'package:llfile/modules/settings/settings_values.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:llfile/src/rust/api/sandbar_node.dart';
import 'package:llfile/utils/db.dart';
import 'package:easy_isolate/easy_isolate.dart' as easy_isolate;


class SandbarClientNodeSetting extends SettingsContentPageBaseWidget {
  const SandbarClientNodeSetting({super.key, }): super(pageName: SettingsContentPage.sandbarClientNodeConfig);

  @override
  State<SandbarClientNodeSetting> createState() => _SandbarClientNodeSettingState();
}

class _SandbarClientNodeSettingState extends State<SandbarClientNodeSetting> {
  TextEditingController _textEditingController = TextEditingController();

  AppConfigDb _appConfigDb = Get.find<AppConfigDb>();
  AppConfig? _appConfig;
  SandbarClientNodeConfig? _sandbarClientNodeConfig;

  easy_isolate.Worker _worker = easy_isolate.Worker();
  
  @override
  void initState() {
    super.initState();
    _textEditingController.text = '';
    
    setupEvents();
  }

  setupEvents()async{
    _appConfig = await _appConfigDb.read<AppConfig>();
    _sandbarClientNodeConfig = _appConfig!.advancedSettings.sandbarClientNodeConfig;
    _textEditingController.text = _sandbarClientNodeConfig != null ? _sandbarClientNodeConfig!.dataLocation: '';
    
    eventBus.on<SettingsSaveEvent>().listen((evt)async{
      if (mounted){
        await _appConfigDb.write(_appConfig!);
        print("Settings Saved: ${_appConfig!.advancedSettings.sandbarClientNodeConfig!.toJson()}");
      }
    });

    await _worker.init(sandbarNodeWorkerMainMessageHandler, sandbarNodeWorkerIsolateMessageHandler);
    print('sandbar node is ready to start');
  }
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(width: 120, child: Text(AppLocalizations.of(context)!.settingsAdvancedSandbarClientDataLocation),),
            SizedBox(width: 12,),
            Expanded(child:
              TextField(controller: _textEditingController, readOnly: true,)
            ),
            IconButton(
              onPressed: ()async{
                String? selectedDirectory = await FilePicker.platform.getDirectoryPath();

                if (selectedDirectory == null) {
                  // User canceled the picker
                  return;
                }
                print('Selected dir: ${selectedDirectory}');
                setState(() {
                  _textEditingController.text = selectedDirectory;
                  _appConfig!.advancedSettings.sandbarClientNodeConfig = SandbarClientNodeConfig(selectedDirectory);
                });
              },
              icon: Icon(Icons.folder_open),
            )
          ],
        ),
        Row(
          children: [
            ElevatedButton(onPressed: (){
              onStartSandbarNodeService();
            }, child: Text('Start')),
            ElevatedButton(onPressed: (){
              onStopSandbarNodeService();
            }, child: Text('Stop')),
            // ElevatedButton(onPressed: (){
            //   onStopSandbarNodeService();
            // }, child: Text('Terminal'))
          ],
        ),
      ],
    );
  }

  onStartSandbarNodeService()async{
    _worker.sendMessage(SandbarNodeOperateEvent(Operate.start));
  }

  onStopSandbarNodeService()async{
    _worker.sendMessage(SandbarNodeOperateEvent(Operate.stop));
  }

}