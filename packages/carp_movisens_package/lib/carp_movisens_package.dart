/*
 * Copyright 2019-2022 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

/// A [CARP Mobile Sensing](https://pub.dev/packages/carp_mobile_sensing)
/// sampling package for collecting cardiovascular data from the
/// Movisens Move4 and EcgMove4 devices on:
///
///  * tap marker
///  * heart rate
///  * heart rate variability
///  * metabolic level
///  * body position
///  * step count
///  * movement (accelerometer)
///  * battery level of device
///  * connectivity status to device
library carp_movisens_package;

import 'dart:convert';
import 'dart:async';
import 'dart:io' show Platform;
import 'package:movisens_flutter/movisens_flutter.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:openmhealth_schemas/openmhealth_schemas.dart' as omh;
import 'package:permission_handler/permission_handler.dart';

import 'package:carp_serializable/carp_serializable.dart';
import 'package:carp_core/carp_core.dart';
import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';

part 'movisens_data.dart';
part 'movisens_probe.dart';
part "carp_movisens_package.g.dart";
part 'movisens_transformers.dart';
part 'movisens_device_manager.dart';

/// The Movisens sampling package
///
/// To use this package, register it in the [carp_mobile_sensing] package using
///
/// ```
///   SamplingPackageRegistry.register(MovisensSamplingPackage());
/// ```
class MovisensSamplingPackage implements SamplingPackage {
  /// Measure type for continous collection of Movisens data from a Movisens device.
  ///  * Event-based measure.
  ///  * Uses the [MovisensDevice] connected device for data collection.
  ///  * No sampling configuration needed.
  static const String MOVISENS = "${NameSpace.CARP}.movisens";

  static const String MOVISENS_NAMESPACE = "${NameSpace.CARP}.movisens";
  static const String MET_LEVEL = "$MOVISENS_NAMESPACE.met_level";
  static const String MET = "$MOVISENS_NAMESPACE.met";
  static const String HR = "$MOVISENS_NAMESPACE.hr";
  static const String HRV = "$MOVISENS_NAMESPACE.hrv";
  static const String IS_HRV_VALID = "$MOVISENS_NAMESPACE.is_hrv_valid";
  static const String BODY_POSITION = "$MOVISENS_NAMESPACE.body_position";
  static const String STEP_COUNT = "$MOVISENS_NAMESPACE.step_count";
  static const String MOVEMENT_ACCELERATION =
      "$MOVISENS_NAMESPACE.movement_acceleration";
  static const String TAP_MARKER = "$MOVISENS_NAMESPACE.tap_marker";
  static const String BATTERY_LEVEL = "$MOVISENS_NAMESPACE.battery_level";
  static const String CONNECTION_STATUS =
      "$MOVISENS_NAMESPACE.connection_status";

  final DeviceManager _deviceManager = MovisensDeviceManager();

  @override
  void onRegister() {
    FromJsonFactory().register(MovisensDevice(address: '', sensorName: ''));

    // registering the transformers from CARP to OMH and FHIR for heart rate and step count.
    // we assume that there are OMH and FHIR schemas created and registrered already...
    TransformerSchemaRegistry().lookup(NameSpace.OMH)!.add(
          HR,
          OMHHeartRateDataPoint.transformer,
        );
    TransformerSchemaRegistry().lookup(NameSpace.OMH)!.add(
          STEP_COUNT,
          OMHStepCountDataPoint.transformer,
        );
    TransformerSchemaRegistry().lookup(NameSpace.FHIR)!.add(
          HR,
          FHIRHeartRateObservation.transformer,
        );
  }

  @override
  String get deviceType => MovisensDevice.DEVICE_TYPE;

  @override
  DeviceManager get deviceManager => _deviceManager;

  @override
  List<Permission> get permissions => []; // no special permissions needed

  /// Create a [MovisensProbe]. Only available on Android.
  @override
  Probe? create(String type) => (Platform.isAndroid)
      ? (type == MOVISENS)
          ? MovisensProbe()
          : null
      : null;

  @override
  List<String> get dataTypes => [MOVISENS];

  @override
  SamplingSchema get samplingSchema => SamplingSchema();
}
