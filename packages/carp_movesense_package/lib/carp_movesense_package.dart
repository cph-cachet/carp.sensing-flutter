library carp_movesense_package;

import 'dart:async';
import 'dart:convert';

import 'package:carp_serializable/carp_serializable.dart';
import 'package:carp_core/carp_core.dart';
import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';
import 'package:mdsflutter/Mds.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:json_annotation/json_annotation.dart';

part 'carp_movesense_package.g.dart';

part 'movesense_data.dart';
part 'movesense_probes.dart';
part 'movesense_device_manager.dart';

// Identifiers for CACHET test devices:
//  - Movesense MD : 220330000122 : 0C:8C:DC:3F:B2:CD
//  - Movesense ?? : 233830000687 : 0C:8C:DC:1B:23:3E

class MovesenseSamplingPackage implements SamplingPackage {
  static const String MOVESENSE_NAMESPACE = "${NameSpace.CARP}.movesense";

  static const String STATE = "$MOVESENSE_NAMESPACE.state";
  static const String HR = "$MOVESENSE_NAMESPACE.hr";
  static const String ECG = "$MOVESENSE_NAMESPACE.ecg";
  static const String TEMPERATURE = "$MOVESENSE_NAMESPACE.temperature";
  static const String IMU = "$MOVESENSE_NAMESPACE.imu";

  final DeviceManager _deviceManager =
      MovesenseDeviceManager(MovesenseDevice.DEVICE_TYPE);

  @override
  Probe? create(String type) {
    switch (type) {
      case STATE:
        return MovesenseStateChangeProbe();
      case HR:
        return MovesenseHRProbe();
      case ECG:
        return MovesenseECGProbe();
      case TEMPERATURE:
        return MovesenseIMUProbe();
      case IMU:
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
    FromJsonFactory().registerAll([
      MovesenseDevice(),
      MovesenseStateChange(MovesenseDeviceState.unknown),
      MovesenseHR(55),
      MovesenseTemperature(0, 0),
      MovesenseIMU(0, [], [], []),
    ]);
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
            type: STATE,
            displayName: "Device State Changes",
            timeType: DataTimeType.POINT,
          ),
        ),
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
        DataTypeSamplingScheme(
          DataTypeMetaData(
            type: TEMPERATURE,
            displayName: "Device Temperature",
            timeType: DataTimeType.POINT,
          ),
        ),
        DataTypeSamplingScheme(
          DataTypeMetaData(
            type: IMU,
            displayName: "Inertial Movement Unit (IMU)",
            timeType: DataTimeType.POINT,
          ),
        ),
      ]);
}
