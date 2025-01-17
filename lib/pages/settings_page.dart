import 'package:flutter/material.dart';
import 'package:llfile/events/events.dart';
import 'package:llfile/events/settings_events.dart';
import 'package:llfile/modules/settings/settings_content.dart';
import 'package:llfile/modules/settings/side_nav.dart';
import 'package:llfile/widgets/common/ll_window_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  void initState() {
    super.initState();
    setupEvents();
  }

  setupEvents() async {}

  @override
  Widget build(BuildContext context) {
    final List<LlNavTreeNode> navItems = [
      LlNavTreeNode(
          key: ValueKey(100),
          titleWidget: Text(AppLocalizations.of(context)!.settingsPreferences),
          children: [
            LlNavTreeNode(
                key: ValueKey(101),
                titleWidget:
                    Text(AppLocalizations.of(context)!.settingsLanguage),
                onTap: () {
                  switchSettingsPage(0);
                }),
            LlNavTreeNode(
                key: ValueKey(102),
                titleWidget: Text(AppLocalizations.of(context)!
                    .settingsConfigurationSaveLocation),
                onTap: () {
                  switchSettingsPage(1);
                }),
            LlNavTreeNode(
                key: ValueKey(103),
                titleWidget: Text(
                    AppLocalizations.of(context)!.settingsFileDirectoryOptions),
                onTap: () {
                  switchSettingsPage(2);
                }),
            LlNavTreeNode(
                key: ValueKey(104),
                titleWidget: Text(AppLocalizations.of(context)!.settingsKeymap),
                onTap: () {
                  switchSettingsPage(3);
                }),
          ]),
      LlNavTreeNode(
          key: ValueKey(200),
          titleWidget: Text(AppLocalizations.of(context)!.settingsExtensions)),
      LlNavTreeNode(
          key: ValueKey(300),
          titleWidget:
              Text(AppLocalizations.of(context)!.settingsAdvancedSettings)),
    ];

    return Container(
      width: MediaQuery.of(context).size.width * 0.75,
      decoration: const BoxDecoration(),
      child: LlWindowWidget(
        statusSize: 80,
        isHome: false,
        toolbar: Row(
          children: [
            SizedBox(
              width: 4,
            ),
            Text(AppLocalizations.of(context)!.settingsTitle)
          ],
        ),
        sidebar: LlSettingsSideNavWidget(
          navItems: navItems,
        ),
        content: const LlSettingsContentWidget(),
        statusBar: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(
                          Theme.of(context).colorScheme.primary),
                      foregroundColor: WidgetStatePropertyAll(
                          Theme.of(context).colorScheme.onSurface),
                      shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)))),
                    ),
                    onPressed: () {},
                    child: Text(AppLocalizations.of(context)!.settingsOk)),
                SizedBox(
                  width: 5,
                ),
                ElevatedButton(
                    style: ButtonStyle(
                      foregroundColor: WidgetStatePropertyAll(
                          Theme.of(context).colorScheme.onSurface),
                      shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                          side: BorderSide(
                              color: Theme.of(context).dividerTheme.color!),
                          borderRadius: BorderRadius.all(Radius.circular(5)))),
                    ),
                    onPressed: () {},
                    child: Text(
                      AppLocalizations.of(context)!.settingsCancel,
                      style: TextStyle(
                          color: Theme.of(context).appBarTheme.foregroundColor),
                    )),
                SizedBox(
                  width: 5,
                ),
                ElevatedButton(
                    style: ButtonStyle(
                      foregroundColor: WidgetStatePropertyAll(
                          Theme.of(context).colorScheme.onSurface),
                      shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                          side: BorderSide(
                              color: Theme.of(context).dividerTheme.color!),
                          borderRadius: BorderRadius.all(Radius.circular(5)))),
                    ),
                    onPressed: () {},
                    child: Text(
                      AppLocalizations.of(context)!.settingsApply,
                      style: TextStyle(
                          color: Theme.of(context).dividerTheme.color!),
                    ))
              ],
            )
          ],
        ),
      ),
    );
  }

  switchSettingsPage(int index) {
    eventBus.fire(SettingsChangeContentEvent(index: index));
  }
}
