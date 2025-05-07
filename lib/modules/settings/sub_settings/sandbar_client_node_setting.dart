import 'package:flutter/material.dart';
import 'package:llfile/modules/settings/settings_values.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SandbarClientNodeSetting extends SettingsContentPageBaseWidget {
  const SandbarClientNodeSetting({super.key, }): super(pageName: SettingsContentPage.sandbarClientNodeConfig);

  @override
  State<SandbarClientNodeSetting> createState() => _SandbarClientNodeSettingState();
}

class _SandbarClientNodeSettingState extends State<SandbarClientNodeSetting> {
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
              TextField()
            )
          ],
        )
      ],
    );
  }
}