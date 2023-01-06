/*
 * Copyright 2020 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

/// A CAMS sampling package for collecting health information from Apple Health
/// or Google Fit.
/// Is using the [health](https://pub.dev/packages/health) plugin.
/// Can be configured to collect the different [HealthDataType](https://pub.dev/documentation/health/latest/health/HealthDataType-class.html).
library health_package;

import 'dart:async';
import 'package:json_annotation/json_annotation.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uuid/uuid.dart';

import 'package:carp_serializable/carp_serializable.dart';
import 'package:carp_core/carp_core.dart';
import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';
import 'package:health/health.dart';

part 'health_domain.dart';
part 'health_package.g.dart';
part 'health_probe.dart';

HealthFactory _healthFactory = HealthFactory();

/// The health sampling package supports the following overall measure type:
///
///  * `dk.cachet.carp.health`
///
/// In order to specify which health data to collect, a `HealthSamplingConfiguration`
/// needs to specified.
/// An example of a configuration of collection of health data once pr. hours is:
///
/// ```dart
///   protocol.addTriggeredTask(
///         IntervalTrigger(period: Duration(minutes: 60)),
///         BackgroundTask()
///           ..addMeasure(Measure(type: HealthSamplingPackage.HEALTH)
///             ..overrideSamplingConfiguration =
///                 HealthSamplingConfiguration(healthDataTypes: [
///               HealthDataType.BLOOD_GLUCOSE,
///               HealthDataType.BLOOD_PRESSURE_DIASTOLIC,
///               HealthDataType.BLOOD_PRESSURE_SYSTOLIC,
///               HealthDataType.BLOOD_PRESSURE_DIASTOLIC,
///               HealthDataType.HEART_RATE,
///               HealthDataType.STEPS,
///             ])),
///         phone);
/// ```
///
/// To use this package, register it in the [carp_mobile_sensing] package using
///
/// ```
///   SamplingPackageRegistry.register(HealthSamplingPackage());
/// ```
class HealthSamplingPackage extends SmartphoneSamplingPackage {
  static const String HEALTH_NAMESPACE = "${NameSpace.CARP}.health";

  /// Measure type for collection of health data from Apple Health or Google Fit.
  ///  * One-time measure.
  ///  * Uses the [Smartphone] master device for data collection.
  ///  * Use a [HealthSamplingConfiguration] for sampling configuration.
  static const String HEALTH = "${NameSpace.CARP}.health";

  @override
  List<DataTypeMetaData> get dataTypes => [
        DataTypeMetaData(
          type: HEALTH,
          displayName: "Health Data",
          timeType: DataTimeType.TIME_SPAN,
        ),
      ];

  @override
  Probe? create(String type) => type == HEALTH ? HealthProbe() : null;

  @override
  void onRegister() {
    FromJsonFactory()
        .register(HealthSamplingConfiguration(healthDataTypes: []));
  }

  @override
  List<Permission> get permissions => [];

  /// Request access to Google Fit or Apple HealthKit.
  /// This method can be used from the app to request access at a 'convenient'
  /// time and will typically be done before sampling is started for
  /// all [types] that are needed.
  Future<bool> requestAuthorization(List<HealthDataType> types) async =>
      _healthFactory.requestAuthorization(types);

  /// Default samplings schema for sampling of health data which only collects
  /// step count.
  @override
  SamplingSchema get samplingSchema => SamplingSchema()
    ..addConfiguration(HEALTH,
        HealthSamplingConfiguration(healthDataTypes: [HealthDataType.STEPS]));
}
