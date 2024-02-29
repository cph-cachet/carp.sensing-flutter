/*
 * Copyright 2024 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

// Identifiers for CACHET test devices:
//  - Movesense MD : 220330000122 : 0C:8C:DC:3F:B2:CD
//  - Movesense ?? : 233830000687 : 0C:8C:DC:1B:23:3E

/// A [CARP Mobile Sensing](https://pub.dev/packages/carp_mobile_sensing)
/// sampling package for collecting data from the Movesense MD, HR+, and HR2 heart
/// rate sensors. From these sensors, this package can collect the following
/// measures:
///
/// * `dk.cachet.carp.movesense.state` : State changes (like moving, tapping, etc.)
/// * `dk.cachet.carp.movesense.hr` : Heart rate
/// * `dk.cachet.carp.movesense.ecg` : Electrocardiogram (ECG)
/// * `dk.cachet.carp.movesense.temperature` : Device temperature
/// * `dk.cachet.carp.movesense.imu` : 9-axis Inertial Movement Unit (IMU)
///
/// **H10 Heart rate sensor**
///
///  * Heart rate as beats per minute. RR Interval in ms and 1/1024 format.
///  * Electrocardiography (ECG) data in µV with sample rate 130Hz. Default epoch for timestamp is 1.1.2000.
///  * Accelerometer data with sample rates of 25Hz, 50Hz, 100Hz and 200Hz and range of 2G, 4G and 8G. Axis specific acceleration data in mG. Default epoch for timestamp is 1.1.2000
///  * Start and stop of internal recording and request for internal recording status. Recording supports RR, HR with one second sample time or HR with five second sample time.
///
/// **Polar Verity Sense optical heart rate sensor**
///
///  * Heart rate (HR) as beats per minute.
///  * Photoplethysmograpy (PPG) values with a sampling rate of 55Hz (see [Polar SDK issue #202](https://github.com/polarofficial/polar-ble-sdk/issues/202#issuecomment-940645360)).
///  * PP interval (milliseconds) representing cardiac pulse-to-pulse interval extracted from PPG signal.
///  * Accelerometer data with sample rate of 52Hz and range of 8G. Axis specific acceleration data in mG.
///  * Gyroscope data with sample rate of 52Hz and ranges of 250dps, 500dps, 1000dps and 2000dps. Axis specific gyroscope data in dps.
///  * Magnetometer data with sample rates of 10Hz, 20Hz, 50HZ and 100Hz and range of +/-50 Gauss. Axis specific magnetometer data in Gauss.
///
/// **H9 Heart rate sensor**
///
///  * Heart rate as beats per minute. RR Interval in ms and 1/1024 format.
///  * Heart rate broadcast.
///
/// This package uses the Flutter [mdsflutter](https://pub.dev/packages/mdsflutter) plugin,
/// which again is based on the official [Movesense Mobile API](https://www.movesense.com/docs/mobile/mobile_sw_overview/).
library carp_movesense_package;

import 'dart:async';
import 'dart:convert';
import 'dart:core';

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

class MovesenseSamplingPackage implements SamplingPackage {
  static const String MOVESENSE_NAMESPACE = "${NameSpace.CARP}.movesense";

  static const String STATE = "$MOVESENSE_NAMESPACE.state";
  static const String HR = "$MOVESENSE_NAMESPACE.hr";
  static const String ECG = "$MOVESENSE_NAMESPACE.ecg";
  static const String TEMPERATURE = "$MOVESENSE_NAMESPACE.temperature";
  static const String IMU = "$MOVESENSE_NAMESPACE.imu";

  final MovesenseDeviceManager _deviceManager =
      MovesenseDeviceManager(MovesenseDevice.DEVICE_TYPE);

  @override
  List<DataTypeMetaData> get dataTypes => samplingSchemes.dataTypes;

  @override
  MovesenseDeviceManager get deviceManager => _deviceManager;

  @override
  String get deviceType => MovesenseDevice.DEVICE_TYPE;

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
        // only the MD device supports temperature
        return deviceManager.configuration?.deviceType == MovesenseDeviceType.MD
            ? MovesenseTemperatureProbe()
            : null;
      case IMU:
        return MovesenseIMUProbe();
      default:
        return null;
    }
  }

  @override
  void onRegister() {
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
