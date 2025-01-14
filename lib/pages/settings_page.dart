import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:llfile/models/app_config_model.dart';
import 'package:llfile/utils/db.dart';
import 'package:llfile/widgets/common/ll_window_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  AppConfigDb _appConfigDb = Get.find<AppConfigDb>();
  AppConfig? _appConfig;

  @override
  void initState() {
    super.initState();
    setupEvents();
  }

  setupEvents()async{
    _appConfig = await _appConfigDb.read<AppConfig>();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.75,
      decoration: const BoxDecoration(
      ),
      child: LlWindowWidget(
        isHome: false,
        toolbar: Row(
          children: [
            SizedBox(width: 4,),
            Text(AppLocalizations.of(context)!.settingsTitle)],
        ),
        content: const Center(child: Text("Settings Page")),
      ),
    );
  }
}
