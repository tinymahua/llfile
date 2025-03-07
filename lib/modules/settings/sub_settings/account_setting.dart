import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:llfile/events/events.dart';
import 'package:llfile/events/sbc_auth_events.dart';
import 'package:llfile/models/app_config_model.dart';
import 'package:llfile/utils/db.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:llfile/widgets/partials/login_or_register_widget.dart';

class LlAccountSetting extends StatefulWidget {
  const LlAccountSetting({super.key});

  @override
  State<LlAccountSetting> createState() => _LlAccountSettingState();
}

class _LlAccountSettingState extends State<LlAccountSetting> {
  AppConfigDb _appConfigDb = Get.find<AppConfigDb>();
  AppConfig? _appConfig;

  bool get _loggedIn => _appConfig != null && _appConfig!.accountSettings.sandbarAuthInfo != null;

  @override
  void initState() {
    super.initState();
    setupEvents();
  }

  setupEvents() async {
    var _readAppConfig = await _appConfigDb.read<AppConfig>();
    setState(() {
      _appConfig = _readAppConfig;
    });

    eventBus.on<SbcRegisterSuccessEvent>().listen((evt)async{
      if (mounted){
        var _readAppConfig = await _appConfigDb.read<AppConfig>();
        setState(() {
          _appConfig = _readAppConfig;
        });
      }
    });
  }

  Widget _buildLoggedInContent() {
    return Container(child: Center(child: Text(AppLocalizations.of(context)!.loggedInLabel)),);
  }

  Widget _buildNotLoggedInContent() {
    return LoginOrRegisterWidget();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
      _loggedIn ? _buildLoggedInContent() : _buildNotLoggedInContent(),
    ],);
  }
}
