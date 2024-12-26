// This file is automatically generated, so please do not edit it.
// @generated by `flutter_rust_bridge`@ 2.5.1.

// ignore_for_file: invalid_use_of_internal_member, unused_import, unnecessary_import

import '../frb_generated.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated.dart';

List<DiskPartition> getDiskPartitions() =>
    RustLib.instance.api.crateApiLldiskGetDiskPartitions();

class DiskPartition {
  final String name;
  final String mountPoint;

  const DiskPartition({
    required this.name,
    required this.mountPoint,
  });

  @override
  int get hashCode => name.hashCode ^ mountPoint.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DiskPartition &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          mountPoint == other.mountPoint;
}



