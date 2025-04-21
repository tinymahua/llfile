import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:llfile/events/events.dart';
import 'package:llfile/events/sbc_auth_events.dart';
import 'package:llfile/mixins/sbc_auth_mixin.dart';
import 'package:llfile/models/app_config_model.dart';
import 'package:llfile/models/sbc_auth_model.dart';
import 'package:llfile/service/sbc_auth_service.dart';
import 'package:llfile/utils/db.dart';
import 'package:pretty_json/pretty_json.dart';

class SbcLoginWidget extends StatefulWidget {
  const SbcLoginWidget({super.key});

  @override
  State<SbcLoginWidget> createState() => _SbcLoginWidgetState();
}

class _SbcLoginWidgetState extends State<SbcLoginWidget> with SbcAuthMixin{
  SbcAuthService _sbcAuthService = Get.find<SbcAuthService>();

  TextEditingController _emailEditController = TextEditingController();
  TextEditingController _passwordEditController = TextEditingController();

  AppConfigDb _appConfigDb = Get.find<AppConfigDb>();
  AppConfig? _appConfig;

  @override
  void initState() {
    super.initState();
    setupEvents();
  }

  setupEvents()async{
    var _readAppConfig = await _appConfigDb.read<AppConfig>();
    setState(() {
      _appConfig = _readAppConfig;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 6,
        ),
        Row(
          children: [
            Expanded(
                child: TextField(
                  controller: _emailEditController,
                  decoration: InputDecoration(
                      labelText:
                      AppLocalizations.of(context)!.loginFormEmailLabel),
                )),
          ],
        ),
        Row(children: [
          Expanded(child: TextField(
            controller: _passwordEditController,
            decoration: InputDecoration(labelText: AppLocalizations.of(context)!.loginFormPasswordLabel),
          )),
        ],),
        SizedBox(height: 6,),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(onPressed: (){
              sbcLogin();
            }, child: Text(AppLocalizations.of(context)!.loginFormSubmitLabel)),
          ],)
      ],
    );
  }

  sbcLogin()async{
    var email = _emailEditController.text.trim();
    var password = _passwordEditController.text.trim();

    var req = SbcLoginRequest(email);
    var resp = await _sbcAuthService.login(req);
    if (resp != null){
      print(prettyJson(resp.toJson()));
      var sandbarAuthInfo = await decryptSbcAuth(resp, password);
      _appConfig!.accountSettings.sandbarAuthInfo = sandbarAuthInfo;
      await _appConfigDb.write(_appConfig!);
      eventBus.fire(SbcLoginSuccessEvent(sandbarAuthInfo));
    }
  }
}
