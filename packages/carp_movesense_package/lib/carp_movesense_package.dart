library carp_movesense_package;

import 'dart:async';

import 'package:carp_serializable/carp_serializable.dart';
import 'package:carp_core/carp_core.dart';
import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';
import 'package:mdsflutter/Mds.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'carp_movesense_package.g.dart';

part 'movesense_data.dart';
part 'movesense_probes.dart';
part 'movesense_device_manager.dart';
part 'mds_facade.dart';

class MovesenseSamplingPackage implements SamplingPackage {
  static const String MOVESENSE_NAMESPACE = "${NameSpace.CARP}.movesense";

  static const String HR = "$MOVESENSE_NAMESPACE.hr";
  static const String ECG = "$MOVESENSE_NAMESPACE.ecg";

  final DeviceManager _deviceManager =
      MovesenseDeviceManager(MovesenseDevice.DEVICE_TYPE);

  @override
  Probe? create(String type) {
    switch (type) {
      case HR:
        return MovesenseHRProbe();
      case ECG:
        return MovesenseECGProbe();
      default:
        return null;
    }
  }

  @override
  List<DataTypeMetaData> get dataTypes => samplingSchemes.dataTypes;

  @override
  DeviceManager get deviceManager => _deviceManager;
  @override
  String get deviceType => MovesenseDevice.DEVICE_TYPE;

  @override
  void onRegister() {
    // register all data types
    FromJsonFactory()
        .registerAll([MovesenseHR(samples: []), MovesenseECG(samples: [])]);
  }

  @override
  List<Permission> get permissions => [
        Permission.location,
        Permission.bluetooth,
        Permission.bluetoothConnect,
        Permission.bluetoothScan,
      ];

  @override
  DataTypeSamplingSchemeMap get samplingSchemes =>
      DataTypeSamplingSchemeMap.from([
        DataTypeSamplingScheme(
          DataTypeMetaData(
            type: HR,
            displayName: "Heart Rate (HR)",
            timeType: DataTimeType.POINT,
          ),
        ),
        DataTypeSamplingScheme(
          DataTypeMetaData(
            type: ECG,
            displayName: "Electrocardiography (ECG)",
            timeType: DataTimeType.POINT,
          ),
        ),
      ]);
}
