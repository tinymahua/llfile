import 'package:flutter/material.dart';
import 'package:llfile/generated/i10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:llfile/events/events.dart';
import 'package:llfile/events/sbc_auth_events.dart';
import 'package:llfile/mixins/sbc_auth_mixin.dart';
import 'package:llfile/models/app_config_model.dart';
import 'package:llfile/models/sbc_auth_model.dart';
import 'package:llfile/service/sbc_auth_service.dart';
import 'package:llfile/src/rust/api/sandbar.dart';
import 'package:llfile/utils/db.dart';
import 'package:pretty_json/pretty_json.dart';

class SbcRegisterWidget extends StatefulWidget {
  const SbcRegisterWidget({super.key});

  @override
  State<SbcRegisterWidget> createState() => _SbcRegisterWidgetState();
}

class _SbcRegisterWidgetState extends State<SbcRegisterWidget> with SbcAuthMixin{
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
    _appConfig = await _appConfigDb.read<AppConfig>();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Text(AppLocalizations.of(context)!.registerFormLabel),
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
                      AppLocalizations.of(context)!.registerFormEmailLabel),
            )),
          ],
        ),
        Row(children: [
          Expanded(child: TextField(
            controller: _passwordEditController,
            decoration: InputDecoration(labelText: AppLocalizations.of(context)!.registerFormPasswordLabel),
          )),
        ],),
        SizedBox(height: 6,),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          ElevatedButton(onPressed: (){
            sbcRegister();
          }, child: Text(AppLocalizations.of(context)!.registerFormSubmitLabel)),
        ],)
      ],
    );
  }

  Future<void> sbcRegister()async{
    var email = _emailEditController.text.trim();
    var password = _passwordEditController.text.trim();
    var sbcLocalAuth = await generateAuth(password: password);
    print("sbcLocalAuth: ${sbcLocalAuth.masterKeyEncryptedBytesB64}");

    var req = SbcRegisterRequest(email, "", sbcLocalAuth.masterKeyEncryptedBytesB64, sbcLocalAuth.privateKeyEncryptedBytesB64, sbcLocalAuth.publicKeyBytesB64);
    var resp = await _sbcAuthService.register(req);
    if (resp != null){
      print(prettyJson(resp.toJson()));
      var sandbarAuthInfo = await decryptSbcAuth(resp, password);
      _appConfig!.accountSettings.sandbarAuthInfo = sandbarAuthInfo;
      await _appConfigDb.write(_appConfig!);
      eventBus.fire(SbcRegisterSuccessEvent());
    }
  }

}
