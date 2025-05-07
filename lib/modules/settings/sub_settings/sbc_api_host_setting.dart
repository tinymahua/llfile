import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:llfile/events/events.dart';
import 'package:llfile/events/settings_events.dart';
import 'package:llfile/models/app_config_model.dart';
import 'package:llfile/modules/settings/settings_values.dart';
import 'package:llfile/utils/db.dart';


class SbcApiHostSetting extends SettingsContentPageBaseWidget {

  const SbcApiHostSetting({super.key}): super(pageName: SettingsContentPage.sbcApiHost);

  @override
  State<SbcApiHostSetting> createState() => _SbcApiHostSettingState();
}

class _SbcApiHostSettingState extends State<SbcApiHostSetting> {
  AppConfigDb _appConfigDb = Get.find<AppConfigDb>();
  AppConfig? _appConfig;

  TextEditingController _sbcApiHostEditController = TextEditingController();

  @override
  void initState() {
    super.initState();
    setupEvents();
  }

  setupEvents() async {
    _appConfig = await _appConfigDb.read<AppConfig>();
    _sbcApiHostEditController.text = _appConfig!.sbcApiHost;

    eventBus.on<SettingsSaveEvent>().listen((evt)async{
      if (mounted){
        await _appConfigDb.write(_appConfig!);
        print("Settings Saved: ${_appConfig!.sbcApiHost}");
      }
    });

  }
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(children: [
          Expanded(child: TextField(
            onChanged: (v){
              onSbcApiHostChanged(v);
            },
            controller: _sbcApiHostEditController,
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.settingsSbcApiHostLabel,
            ),
          ))
        ],)
      ],
    );
  }

  onSbcApiHostChanged(String v){
    _appConfig!.sbcApiHost = v.trim();
  }
}
