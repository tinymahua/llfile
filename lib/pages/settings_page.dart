import 'package:flutter/material.dart';
import 'package:llfile/events/events.dart';
import 'package:llfile/events/settings_events.dart';
import 'package:llfile/modules/settings/settings_content.dart';
import 'package:llfile/modules/settings/settings_values.dart';
import 'package:llfile/modules/settings/side_nav.dart';
import 'package:llfile/widgets/common/ll_window_widget.dart';
import 'package:llfile/generated/i10n/app_localizations.dart';

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
              titleWidget: Text(AppLocalizations.of(context)!.settingsLanguage),
              data: SettingsContentPage.language,
              onTap: (data) {
                switchSettingsPage(0, settingsContentPage: data);
              },
            ),
            // LlNavTreeNode(
            //     key: ValueKey(102),
            //     titleWidget: Text(AppLocalizations.of(context)!
            //         .settingsConfigurationSaveLocation),
            //     data: SettingsContentPage.language,
            //     onTap: (data) {
            //       switchSettingsPage(1,  settingsContentPage: data);
            //     }),
            // LlNavTreeNode(
            //     key: ValueKey(103),
            //     titleWidget: Text(
            //         AppLocalizations.of(context)!.settingsFileDirectoryOptions),
            //     onTap: (node) {
            //       switchSettingsPage(2);
            //     }),
            // LlNavTreeNode(
            //     key: ValueKey(104),
            //     titleWidget: Text(AppLocalizations.of(context)!.settingsKeymap),
            //     onTap: (node) {
            //       switchSettingsPage(3);
            //     }),
          ]),
      // LlNavTreeNode(
      //     key: ValueKey(200),
      //     titleWidget: Text(AppLocalizations.of(context)!.settingsExtensions),
      //     onTap: (node) {
      //       switchSettingsPage(4);
      //     }),
      LlNavTreeNode(
          key: ValueKey(300),
          titleWidget:
              Text(AppLocalizations.of(context)!.settingsAdvancedSettings),
          onTap: (node) {
            switchSettingsPage(5);
          },
          children: [
            // LlNavTreeNode(
            //     key: ValueKey(301),
            //     titleWidget: Text(AppLocalizations.of(context)!
            //         .settingsAdvancedSandbarClientNodeConfig),
            //     onTap: (data) {
            //       print('tapped node from tree: ${data}');
            //       switchSettingsPage(0, settingsContentPage: data);
            //     }, data: SettingsContentPage.sandbarClientNodeConfig),
          ]),
      LlNavTreeNode(
          key: ValueKey(400),
          titleWidget:
              Text(AppLocalizations.of(context)!.settingsAccountSettings),
          data: SettingsContentPage.account,
          onTap: (data) {
            switchSettingsPage(6, settingsContentPage: data);
          }),
      LlNavTreeNode(
          key: ValueKey(500),
          titleWidget:
              Text(AppLocalizations.of(context)!.settingsSbcApiHostLabel),
          data: SettingsContentPage.sbcApiHost,
          onTap: (data) {
            switchSettingsPage(7, settingsContentPage: data);
          })
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
                    onPressed: () {
                      eventBus.fire(SettingsSaveEvent());
                      Navigator.pop(context);
                    },
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
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      AppLocalizations.of(context)!.settingsCancel,
                      style: TextStyle(
                          color: Theme.of(context).appBarTheme.foregroundColor),
                    )),
                SizedBox(
                  width: 5,
                ),
                // ElevatedButton(
                //     style: ButtonStyle(
                //       foregroundColor: WidgetStatePropertyAll(
                //           Theme.of(context).colorScheme.onSurface),
                //       shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                //           side: BorderSide(
                //               color: Theme.of(context).dividerTheme.color!),
                //           borderRadius: BorderRadius.all(Radius.circular(5)))),
                //     ),
                //     onPressed: () {
                //
                //     },
                //     child: Text(
                //       AppLocalizations.of(context)!.settingsApply,
                //       style: TextStyle(
                //           color: Theme.of(context).dividerTheme.color!),
                //     ))
              ],
            )
          ],
        ),
      ),
    );
  }

  switchSettingsPage(int index, {SettingsContentPage? settingsContentPage}) {
    eventBus.fire(SettingsChangeContentEvent(index: index, settingsContentPage: settingsContentPage));
  }
}
