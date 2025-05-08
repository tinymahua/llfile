import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:llfile/events/events.dart';
import 'package:llfile/events/sbc_auth_events.dart';
import 'package:llfile/models/app_config_model.dart';
import 'package:llfile/models/sbc_api_model.dart';
import 'package:llfile/models/sbc_object_model.dart';
import 'package:llfile/modules/settings/settings_values.dart';
import 'package:llfile/service/sbc_device_service.dart';
import 'package:llfile/utils/db.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:llfile/widgets/partials/login_or_register_widget.dart';
import 'package:pretty_json/pretty_json.dart';

class LlAccountSetting extends SettingsContentPageBaseWidget{

  const LlAccountSetting({super.key, }): super(pageName: SettingsContentPage.account);

  @override
  State<LlAccountSetting> createState() => _LlAccountSettingState();
}

class _LlAccountSettingState extends State<LlAccountSetting> {
  AppConfigDb _appConfigDb = Get.find<AppConfigDb>();
  AppConfig? _appConfig;
  SandbarAuthInfo? _currentDeviceInfo;
  List<SbcDevice> _sbcDevices = [];

  SbcDeviceService sbcDeviceService = Get.find<SbcDeviceService>();

  bool get _loggedIn => _appConfig != null && _appConfig!.accountSettings.sandbarAuthInfo != null;

  bool get _currentDeviceUnregistered => _currentDeviceInfo != null && _sbcDevices.indexWhere((d)=>d.publicKey == _currentDeviceInfo!.cbPublicKey) < 0;

  @override
  void initState() {
    super.initState();
    setupEvents();
  }

  setupEvents() async {
    var _readAppConfig = await _appConfigDb.read<AppConfig>();
    setState(() {
      _appConfig = _readAppConfig;
      _currentDeviceInfo = _readAppConfig.accountSettings.sandbarAuthInfo;
      _sbcDevices = _readAppConfig.accountSettings.sandbarDevices;
    });

    await loadSbcDeviceList();

    eventBus.on<SbcRegisterSuccessEvent>().listen((evt)async{
      if (mounted){
        var _readAppConfig = await _appConfigDb.read<AppConfig>();
        setState(() {
          _appConfig = _readAppConfig;
        });
        await _appConfigDb.write(_appConfig);
      }
    });
    eventBus.on<SbcLoginSuccessEvent>().listen((evt)async{
      if (mounted){
        var _readAppConfig = await _appConfigDb.read<AppConfig>();
        setState(() {
          _appConfig = _readAppConfig;
          _currentDeviceInfo = evt.sandbarAuthInfo;
        });
        await loadSbcDeviceList();
      }
    });
  }

  loadSbcDeviceList()async{
    if (_loggedIn){
      var resp = await sbcDeviceService.list(SbcDeviceListRequest(1, 100));
      if (resp != null){
        print(prettyJson(resp.toJson()));
        if (mounted){
          setState(() {
            _appConfig!.accountSettings.sandbarDevices = resp.results;
            _sbcDevices = resp.results;
          });
        }
        await _appConfigDb.write(_appConfig);
      }
    }
  }

  Widget _buildLoggedInContent() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Container(child: Center(child: Text(AppLocalizations.of(context)!.loggedInLabel)),),
        Expanded(child: Container(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Row(
                children: [
                  Text("${AppLocalizations.of(context)!.sbcDevicesNumLabel}: "),
                  Text(_appConfig!.accountSettings.sandbarDevices.length.toString()),
                ],
              ),
              if (_currentDeviceInfo!=null) Row(children: [
                Text("${AppLocalizations.of(context)!.sbcCurrentDeviceLabel}ID: ${_currentDeviceInfo!.cbPublicKey}"),
                // Text("${AppLocalizations.of(context)!.sbcCurrentDeviceLabel}"),
              ],),
              if (_currentDeviceUnregistered) Row(
                children: [
                  ElevatedButton(onPressed: (){
                    sbcRegisterNewDevice();
                  }, child: Text(" (${AppLocalizations.of(context)!.sbcRegisterNewDeviceLabel})"))
                ],
              ),
              Column( mainAxisSize: MainAxisSize.max,children: List.generate(_sbcDevices.length, (int idx){
                var d = _sbcDevices[idx];
                return Row(children: [
                  Text("${d.publicKey}"),
                  SizedBox(width: 6,),
                  Text("${d.label}"),
                  SizedBox(width: 6,),
                  Text("${_currentDeviceInfo != null && d.publicKey == _currentDeviceInfo!.cbPublicKey ? AppLocalizations.of(context)!.sbcCurrentDeviceLabel : ""}")
                ],);
              }))
            ]
          ),
        )),
        Row(
          children: [
            ElevatedButton(onPressed: (){
              sbcLogout();
            }, child: Text(" (${AppLocalizations.of(context)!.logoutLabel})"))
          ],
        )
      ],
    );
  }

  Widget _buildNotLoggedInContent() {
    return LoginOrRegisterWidget();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(child: Container(child: _loggedIn ? _buildLoggedInContent() : _buildNotLoggedInContent(),))
    ],);
  }

  sbcRegisterNewDevice()async{
    // List<SbcDevice> devices = _appConfig!.accountSettings.sandbarDevices;
    // if (devices.indexWhere((d)=>d.publicKey == sandbarPublicKey) > -1){
    //
    // }
    var resp = await sbcDeviceService.register(SbcDeviceRegisterRequest(
        _currentDeviceInfo!.cbPublicKey, {}, -1, -1, "Lvluo"));
    if (resp != null){
      print(prettyJson(resp.toJson()));
    }
  }

  sbcLogout()async{
    var _readAppConfig = await _appConfigDb.read<AppConfig>();
    _readAppConfig.accountSettings.sandbarAuthInfo = null;
    await _appConfigDb.write(_readAppConfig);
    setState(() {
      _appConfig = _readAppConfig;
      // _currentDeviceInfo = _readAppConfig.accountSettings.sandbarAuthInfo;
      // _sbcDevices = _readAppConfig.accountSettings.sandbarDevices;
    });

  }
}
