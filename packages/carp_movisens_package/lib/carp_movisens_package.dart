/*
 * Copyright 2019-2022 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

/// A [CARP Mobile Sensing](https://pub.dev/packages/carp_mobile_sensing)
/// sampling package for collecting data from [Movisens](https://www.movisens.com/en/)
/// sensors. This package supports the following sensors:
///
///  * [Move4](https://www.movisens.com/en/products/activity-sensor/) Activity Sensor.
///  * [EcgMove4](https://www.movisens.com/en/products/ecg-sensor/) ECG and Activity Sensor.
///  * [EdaMove4](https://www.movisens.com/en/products/eda-and-activity-sensor/) EDA and Activity Sensor
///  * [LightMove4](https://www.movisens.com/en/products/light-and-activity-sensor/) Light and Activity Sensor.
///
/// This package uses the [movisens_flutter](https://pub.dev/packages/movisens_flutter) Flutter plugin,
/// which again builds upon the [official Movisens BLE Protocol](https://docs.movisens.com/BluetoothLowEnergy/#introduction).
/// Please consult the Movisens [technical documentation](https://docs.movisens.com/BluetoothLowEnergy/#communication-with-the-sensor)
/// on the details on how to interpret the collected data.
library carp_movisens_package;

import 'dart:convert';
import 'dart:async';
import 'dart:io' show Platform;
import 'package:async/async.dart';
import 'package:movisens_flutter/movisens_flutter.dart' as movisens;
import 'package:json_annotation/json_annotation.dart';
import 'package:openmhealth_schemas/openmhealth_schemas.dart' as omh;
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import 'package:carp_serializable/carp_serializable.dart';
import 'package:carp_core/carp_core.dart';
import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';

part 'movisens_data.dart';
part 'movisens_probes.dart';
part "carp_movisens_package.g.dart";
part 'movisens_transformers.dart';
part 'movisens_device_manager.dart';

/// The Movisens sampling package supporting the following measures each coming from
/// different Movisens Services:
///
///  * dk.cachet.carp.movisens.activity – Physical activity like body positions, step count, inclination, acceleration, and metabolic (MET) levels.
///  * dk.cachet.carp.movisens.hr - Heart Rate (HR), HR Variability (HRV), Mean HR
///  * dk.cachet.carp.movisens.tap_marker - Markers of user tapping on the sensor.
///  * dk.cachet.carp.movisens.eda - Elecrodermal Activity
///  * dk.cachet.carp.movisens.skin_temperature - Skin temperature.
///
/// Note, however, that not all these measures are supported by all Movisens devices.
/// For example, you need an EdaMove4 to measure EDA and an EcgMove4 to measure HR.
///
/// All measure types are continuos collection of Movisens data from a Movisens device,
/// which are:
///
///  * Event-based measures.
///  * Uses the [MovisensDevice] connected device for data collection.
///  * No sampling configuration needed.
///
/// An example of a study protocol configuration is:
///
/// ```dart
///  // Create a study protocol
///     StudyProtocol protocol = StudyProtocol(
///    ownerId: 'owner@dtu.dk',
///    name: 'Movisens Example',
///  );
///
///  // define which devices are used for data collection - both phone and Movisens
///  Smartphone phone = Smartphone();
///  MovisensDevice movisens = MovisensDevice(
///    deviceName: 'MOVISENS Sensor 02655',
///    sensorLocation: SensorLocation.Chest,
///    sex: Sex.Male,
///    height: 175,
///    weight: 75,
///    age: 25,
///  );
///
///  protocol
///    ..addPrimaryDevice(phone)
///    ..addConnectedDevice(movisens);
///
///  // adding a movisens measure
///  protocol.addTaskControl(
///      ImmediateTrigger(),
///      BackgroundTask(name: 'Movisens Task', measures: [
///        Measure(type: MovisensSamplingPackage.ACTIVITY),
///      ]),
///      movisens);
/// ```
///
/// To use this package, register it in the [carp_mobile_sensing] package using
///
/// ```
///   SamplingPackageRegistry.register(MovisensSamplingPackage());
/// ```
class MovisensSamplingPackage implements SamplingPackage {
  static const String MOVISENS_NAMESPACE = "${NameSpace.CARP}.movisens";

  static const String ACTIVITY = "$MOVISENS_NAMESPACE.activity";
  static const String HR = "$MOVISENS_NAMESPACE.hr";
  static const String EDA = "$MOVISENS_NAMESPACE.eda";
  static const String SKIN_TEMPERATURE = "$MOVISENS_NAMESPACE.skin_temperature";
  static const String TAP_MARKER = "$MOVISENS_NAMESPACE.tap_marker";

  // // EdaService
  // static const String EDA = "$MOVISENS_NAMESPACE.eda";

  // // HrvService
  // static const String HR = "$MOVISENS_NAMESPACE.hr";
  // static const String HRV = "$MOVISENS_NAMESPACE.hrv";
  // static const String IS_HRV_VALID = "$MOVISENS_NAMESPACE.is_hrv_valid";
  // static const String HR_MEAN = "$MOVISENS_NAMESPACE.hr_mean";
  // static const String HR_RMSSD = "$MOVISENS_NAMESPACE.hr_rmssd";

  // // MarkerService
  // static const String TAP_MARKER = "$MOVISENS_NAMESPACE.tap_marker";

  // // PhysicalActivityService
  // static const String BODY_POSITION = "$MOVISENS_NAMESPACE.body_position";
  // static const String STEPS = "$MOVISENS_NAMESPACE.steps";
  // static const String INCLINATION = "$MOVISENS_NAMESPACE.inclination";
  // static const String MOVEMENT_ACCELERATION =
  //     "$MOVISENS_NAMESPACE.movement_acceleration";
  // static const String MET = "$MOVISENS_NAMESPACE.met";
  // static const String MET_LEVEL = "$MOVISENS_NAMESPACE.met_level";

  // // RespirationService
  // static const String EDR = "$MOVISENS_NAMESPACE.edr";

  // // SkinTemperatureService
  // static const String SKIN_TEMPERATURE = "$MOVISENS_NAMESPACE.skin_temperature";

  final DeviceManager _deviceManager = MovisensDeviceManager();

  @override
  void onRegister() {
    FromJsonFactory().register(MovisensDevice(deviceName: ''));

    // registering the transformers from CARP to OMH and FHIR for heart rate and step count.
    // we assume that there are OMH and FHIR schemas created and registered already...
    TransformerSchemaRegistry().lookup(NameSpace.OMH)?.add(
          MovisensData.HR_MEAN,
          OMHHeartRateDataPoint.transformer,
        );
    TransformerSchemaRegistry().lookup(NameSpace.OMH)?.add(
          MovisensData.STEPS,
          OMHStepCountDataPoint.transformer,
        );
    TransformerSchemaRegistry().lookup(NameSpace.FHIR)?.add(
          MovisensData.HR_MEAN,
          FHIRHeartRateObservation.transformer,
        );
  }

  @override
  String get deviceType => MovisensDevice.DEVICE_TYPE;

  @override
  DeviceManager get deviceManager => _deviceManager;

  @override
  List<Permission> get permissions => []; // no special permissions needed

  /// Create a [MovisensProbe].
  @override
  Probe? create(String type) {
    switch (type) {
      case ACTIVITY:
        return MovisensActivityProbe();
      case HR:
        return MovisensHRProbe();
      case EDA:
        return MovisensEDAProbe();
      case SKIN_TEMPERATURE:
        return MovisensSkinTemperatureProbe();
      case TAP_MARKER:
        return MovisensTapMarkerProbe();
      default:
        return null;
    }
  }

  @override
  List<DataTypeMetaData> get dataTypes => [
        DataTypeMetaData(
          type: ACTIVITY,
          displayName: "Physical Activity",
          timeType: DataTimeType.POINT,
        ),
        DataTypeMetaData(
          type: HR,
          displayName: "Heart Rate (HR) data",
          timeType: DataTimeType.POINT,
        ),
        DataTypeMetaData(
          type: EDA,
          displayName: "Elecrodermal Activity (EDA)",
          timeType: DataTimeType.POINT,
        ),
        DataTypeMetaData(
          type: SKIN_TEMPERATURE,
          displayName: "Skin Temperature",
          timeType: DataTimeType.POINT,
        ),
        DataTypeMetaData(
          type: TAP_MARKER,
          displayName: "Tap markers by the user.",
          timeType: DataTimeType.POINT,
        ),
      ];

  @override
  SamplingSchema get samplingSchema => SamplingSchema();
}

/// The location on the body where the Movisens device is placed.
enum SensorLocation {
  RightSideHip,
  Chest,
  RightWrist,
  LeftWrist,
  LeftAnkle,
  RightAnkle,
  RightThigh,
  LeftThigh,
  RightUpperArm,
  LeftUpperArm,
  LeftSideHip,
}
