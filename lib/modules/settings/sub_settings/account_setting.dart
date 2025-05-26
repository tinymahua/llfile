import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:llfile/events/events.dart';
import 'package:llfile/events/sbc_auth_events.dart';
import 'package:llfile/events/sbn_events.dart';
import 'package:llfile/isolates/sandbar_node_worker.dart';
import 'package:llfile/models/app_config_model.dart';
import 'package:llfile/models/sbc_api_model.dart';
import 'package:llfile/models/sbc_object_model.dart';
import 'package:llfile/modules/settings/settings_values.dart';
import 'package:llfile/service/sbc_device_service.dart';
import 'package:llfile/src/rust/api/sandbar_node.dart';
import 'package:llfile/utils/db.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:llfile/utils/fs.dart';
import 'package:llfile/widgets/partials/login_or_register_widget.dart';
import 'package:pretty_json/pretty_json.dart';
import 'package:path/path.dart' as p;
import 'package:easy_isolate/easy_isolate.dart' as easy_isolate;

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
  bool _viewAllSbcDevices = false;
  bool _viewCreateSandbarClientNode = false;

  TextEditingController _sandbarNodeDataLocationController = TextEditingController();
  TextEditingController _sbrNodesB64Controller = TextEditingController();
  
  SbcDeviceService sbcDeviceService = Get.find<SbcDeviceService>();

  SandbarNodeStat? _sandbarNodeStat;

  easy_isolate.Worker _worker = easy_isolate.Worker();

  bool get _loggedIn => _appConfig != null && _appConfig!.accountSettings.sandbarAuthInfo != null;

  bool get _currentDeviceUnregistered => _currentDeviceInfo != null && _sbcDevices.indexWhere((d)=>d.publicKey == _currentDeviceInfo!.cbPublicKey) < 0;

  bool get _sandbarClientNodeEnabled => _appConfig != null && _appConfig!.advancedSettings.sandbarClientNodeEnabled;

  bool get _sandbarClientNodeExists => _appConfig != null && _appConfig!.advancedSettings.sandbarClientNodeConfig != null;

  @override
  void initState() {
    super.initState();
    setupEvents();
  }

  setupEvents() async {
    AppConfigDb _appConfigDb = Get.find<AppConfigDb>();

    var _readAppConfig = await _appConfigDb.read<AppConfig>();
    setState(() {
      _appConfig = _readAppConfig;
      _currentDeviceInfo = _readAppConfig.accountSettings.sandbarAuthInfo;
      _sbcDevices = _readAppConfig.accountSettings.sandbarDevices;
    });

    if (_appConfig != null){
      var sandbarNodeConfigInfo = _appConfig!.advancedSettings.sandbarClientNodeConfig;
      if (sandbarNodeConfigInfo != null){
        setState(() {
          _sandbarNodeDataLocationController.text = sandbarNodeConfigInfo.dataLocation;
        });
      }else{
        var appDocDir = await getAppDocDir();
        setState(() {
          _sandbarNodeDataLocationController.text = p.join(appDocDir, 'sandbar');
        });
      }
    }

    await loadSbcDeviceList();

    await _worker.init(sandbarNodeWorkerMainMessageHandler,
        sandbarNodeWorkerIsolateMessageHandler);
    print('sandbar node is ready to start');

    await refreshSandbarNodeStatus(Duration(milliseconds: 200));

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

  Widget makeSandbarNodeStatus(SandbarNodeStat sandbarNodeStat) {
    var btnText = sandbarNodeStat.running? AppLocalizations.of(context)!
        .settingsAdvancedSandbarClientStopService: AppLocalizations.of(context)!.settingsAdvancedSandbarClientStartService;
    return Column(
      children: [
        Row(
          children: [
            SizedBox(
              width: 100,
              child: Text(
                  "${AppLocalizations.of(context)!.settingsAdvancedSandbarClientRunningStatus}:"),
            ),
            sandbarNodeStat.running
                ? Text(
                "${AppLocalizations.of(context)!.settingsAdvancedSandbarClientRunningStatusIng}")
                : Text(
                "${AppLocalizations.of(context)!.settingsAdvancedSandbarClientRunningStatusStopped}")
          ],
        ),
        Row(
          children: [
            ElevatedButton(
                onPressed: () {
                  sandbarNodeStat.running? onStopSandbarNodeService(): onStartSandbarNodeService();
                },
                child: Text(btnText)),
          ],
        ),
      ],
    );
  }

  Widget makeSandbarClientNodeControl(){
    if (_sandbarClientNodeEnabled){
      if (_sandbarClientNodeExists){
        var _sandbarClientNodeConfig = _appConfig!.advancedSettings.sandbarClientNodeConfig;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          Text("${AppLocalizations.of(context)!.sandbarClientNodeDataLocation}: ${_sandbarClientNodeConfig!.dataLocation}"),
          Text("${AppLocalizations.of(context)!.sandbarClientNodeConfigPath}: ${_sandbarClientNodeConfig.configLocation}"),
        ],);
      }else{
        return Column(
          children: [
            Row(
              children: [
                Text(AppLocalizations.of(context)!.sandbarClientNodeNotExists),
                TextButton(onPressed: (){
                  setState(() {
                    _viewCreateSandbarClientNode = !_viewCreateSandbarClientNode;
                  });
                }, child: Text(AppLocalizations.of(context)!.sandbarClientNodeCreate)
                ),
              ],
            ),
            if (_viewCreateSandbarClientNode) Column(
              children: [
                Row(children: [
                  Expanded(child: TextField(
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.sandbarClientNodeDataLocation
                    ),
                    controller: _sandbarNodeDataLocationController, readOnly: true,)),
                  IconButton(onPressed: (
                    () async {
                      String? selectedDirectory =
                      await FilePicker.platform.getDirectoryPath();

                      if (selectedDirectory == null) {
                        // User canceled the picker
                        return;
                      }
                      print('Selected dir: ${selectedDirectory}');
                      setState(() {
                        _sandbarNodeDataLocationController.text = selectedDirectory;
                        _appConfig!.advancedSettings.sandbarClientNodeConfig =
                            SandbarClientNodeConfig(selectedDirectory);
                      });
                    }
                  ), icon: Icon(Icons.open_in_new)),
                ],),
                Row(children: [
                  Expanded(child: TextField(
                    decoration: InputDecoration(labelText: ""),
                    controller: _sbrNodesB64Controller,
                    onChanged: (val){
                      setState(() {
                        _sbrNodesB64Controller.text = val;
                      });
                    },
                  ))
                ]),
                Row(children: [
                  ElevatedButton(onPressed: ()async{
                    String sbrNodesStr = String.fromCharCodes(base64Decode(_sbrNodesB64Controller.text.trim()));
                    List<dynamic> sbrNodesTmp = jsonDecode(sbrNodesStr);
                    print(sbrNodesTmp);
                    var sbrNodes = sbrNodesTmp.map((e)=>Map.castFrom(e)).toList();
                    print("data: ${sbrNodes[0]['stun_only']}");

                    var createdSandbarNodeConfig = await createSandbarNode(
                        configFilePath: p.join(_sandbarNodeDataLocationController.text, 'config.toml'),
                        parentDirAutoCreate: true,
                        palCbPrivateKeyB64: _appConfig!.accountSettings.sandbarAuthInfo!.cbPrivateKey,
                        palCbPublicKeyB64: _appConfig!.accountSettings.sandbarAuthInfo!.cbPublicKey,
                        relayNodes: sbrNodes.map((e)=>jsonEncode(e)).toList(), sbcApiHost: _appConfig!.sbcApiHost);

                    setState(() {
                      _appConfig!.advancedSettings.sandbarClientNodeConfig = SandbarClientNodeConfig(_sandbarNodeDataLocationController.text.trim());
                    });
                    await _appConfigDb.write(_appConfig);
                    print("createdSandbarNodeConfig: ${createdSandbarNodeConfig}");

                  }, child: Text(AppLocalizations.of(context)!.okLabel)),
                  ElevatedButton(onPressed: (){
                    setState(() {
                      _viewCreateSandbarClientNode = false;
                    });
                  }, child: Text(AppLocalizations.of(context)!.cancelLabel)),
                ],)
              ],
            ) 
          ],
        );
      }
    }
    return Container();
  }

  Widget _buildLoggedInContent() {
    String _viewSbcDevicesLabel = _viewAllSbcDevices ? AppLocalizations.of(context)!.sbcDevicesHideLabel : AppLocalizations.of(context)!.sbcDevicesViewLabel;
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Container(child: Center(child: Text(AppLocalizations.of(context)!.loggedInLabel)),),
        Expanded(child: Container(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 6,),
              if (_currentDeviceInfo!=null) Row(children: [
                Text("${AppLocalizations.of(context)!.sbcCurrentDeviceLabel}ID: ${_currentDeviceInfo!.cbPublicKey}"),
                // Text("${AppLocalizations.of(context)!.sbcCurrentDeviceLabel}"),
              ],),
              Row(
                children: [
                  Text("${AppLocalizations.of(context)!.sbcDevicesNumLabel}: "),
                  Text(_appConfig!.accountSettings.sandbarDevices.length.toString()),
                  TextButton(onPressed: (){
                    setState(() {
                      _viewAllSbcDevices = !_viewAllSbcDevices;
                    });
                  }, child: Text(_viewSbcDevicesLabel))
                ],
              ),
              SizedBox(height: 6,),
              if (_currentDeviceUnregistered) Row(
                children: [
                  ElevatedButton(onPressed: (){
                    sbcRegisterNewDevice();
                  }, child: Text(" (${AppLocalizations.of(context)!.sbcRegisterNewDeviceLabel})"))
                ],
              ),
              if (_viewAllSbcDevices) Column( mainAxisSize: MainAxisSize.max,children: List.generate(_sbcDevices.length, (int idx){
                var d = _sbcDevices[idx];
                return Row(children: [
                  Text("${d.publicKey}"),
                  SizedBox(width: 6,),
                  Text("${d.label}"),
                  SizedBox(width: 6,),
                  Text("${_currentDeviceInfo != null && d.publicKey == _currentDeviceInfo!.cbPublicKey ? AppLocalizations.of(context)!.sbcCurrentDeviceLabel : ""}")
                ],);
              })),
              SizedBox(height: 6,),
              makeSandbarClientNodeControl(),
              SizedBox(height: 3,),
              if (_sandbarClientNodeEnabled && _sandbarClientNodeExists && _sandbarNodeStat != null) makeSandbarNodeStatus(_sandbarNodeStat!),
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

  refreshSandbarNodeStatus(Duration duration) async {
    var sandbarClientNodeConfig = _appConfig!.advancedSettings.sandbarClientNodeConfig;
    var configFile = sandbarClientNodeConfig!.configLocation;
    if (File(configFile).existsSync()){
      Future.delayed(duration, ()async {
        var sandbarStatus = await getSandbarNodeStat(
            configFilePath:configFile);
        setState(() {
          _sandbarNodeStat = sandbarStatus;
        });
        print('_sandbarNodeStat1: ${_sandbarNodeStat}');

        eventBus.fire(SbnReadyEvent(sandbarStatus.running));
      });

    }else{
      setState(() {
        _sandbarNodeStat = SandbarNodeStat(rpcPort: BigInt.from(0), sbRpcPort: BigInt.from(0), running: false);
      });
      print('_sandbarNodeStat2: ${_sandbarNodeStat}');

    }

  }

  onStartSandbarNodeService() async {
    var sandbarClientNodeConfig = _appConfig!.advancedSettings.sandbarClientNodeConfig;
    _worker.sendMessage(SandbarNodeOperateEvent(
        Operate.start, sandbarClientNodeConfig!.configLocation));
    await refreshSandbarNodeStatus(Duration(seconds: 3));
  }

  onStopSandbarNodeService() async {
    var sandbarClientNodeConfig = _appConfig!.advancedSettings.sandbarClientNodeConfig;
    _worker.sendMessage(SandbarNodeOperateEvent(
        Operate.stop, sandbarClientNodeConfig!.configLocation));
    await refreshSandbarNodeStatus(Duration(seconds: 3));
  }
}
