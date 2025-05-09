// This file is automatically generated, so please do not edit it.
// @generated by `flutter_rust_bridge`@ 2.9.0.

// ignore_for_file: invalid_use_of_internal_member, unused_import, unnecessary_import

import '../frb_generated.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated.dart';

Future<BigInt> getRpcPort() =>
    RustLib.instance.api.crateApiSandbarNodeGetRpcPort();

Future<void> startSandbarNodeService({required String configFilePath}) =>
    RustLib.instance.api.crateApiSandbarNodeStartSandbarNodeService(
        configFilePath: configFilePath);

Future<void> stopSandbarNodeService({required String configFilePath}) => RustLib
    .instance.api
    .crateApiSandbarNodeStopSandbarNodeService(configFilePath: configFilePath);

Future<SandbarNodeConfig> getSandbarNodeConfig(
        {required String configFilePath}) =>
    RustLib.instance.api.crateApiSandbarNodeGetSandbarNodeConfig(
        configFilePath: configFilePath);

class SandbarNodeConfig {
  final BigInt rpcPort;
  final BigInt sbRpcPort;

  const SandbarNodeConfig({
    required this.rpcPort,
    required this.sbRpcPort,
  });

  @override
  int get hashCode => rpcPort.hashCode ^ sbRpcPort.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SandbarNodeConfig &&
          runtimeType == other.runtimeType &&
          rpcPort == other.rpcPort &&
          sbRpcPort == other.sbRpcPort;
}
