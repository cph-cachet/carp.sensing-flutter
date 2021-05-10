/*
 * Copyright 2020 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

/// A CAMS sampling package for collecting health information from Apple Health or Google Fit.
/// Is using the [health](https://pub.dev/packages/health) plugin.
/// Can be configured to collect the different [HealthDataType](https://pub.dev/documentation/health/latest/health/HealthDataType-class.html).
///
/// The measure type is `health`.
library health_package;

import 'dart:async';

import 'package:carp_mobile_sensing/domain/domain.dart';
import 'package:health/health.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uuid/uuid.dart';

import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';

part 'health_domain.dart';
part 'health_package.g.dart';
part 'health_probe.dart';

HealthFactory _healthFactory = HealthFactory();

/// This is the base class for this health sampling package.
///
/// To use this package, register it in the [carp_mobile_sensing] package using
///
/// ```
///   SamplingPackageRegistry.register(HealthSamplingPackage());
/// ```
class HealthSamplingPackage extends SmartphoneSamplingPackage {
  static const String HEALTH_NAMESPACE = "${NameSpace.CARP}.health";
  static const String HEALTH = "${NameSpace.CARP}.health";

  List<String> get dataTypes => [
        HEALTH,
      ];

  Probe create(String type) => type == HEALTH ? HealthProbe() : null;

  void onRegister() {
    FromJsonFactory().register(HealthMeasure());
  }

  List<Permission> get permissions => [];

  /// Request access to GoogleFit/Apple HealthKit.
  /// This method can be used from the app to request access at a 'convinient'
  /// time and will typically be done before sampling is started for
  /// all [types] that are needed.
  Future<bool> requestAuthorization(List<HealthDataType> types) async =>
      _healthFactory.requestAuthorization(types);

  /// The `common` sampling schema for health.
  /// Mainly returns a sampling schema collecting step counts.
  SamplingSchema get common => SamplingSchema()
    ..type = SamplingSchemaType.common
    ..name = 'Common (default) health sampling schema'
    ..powerAware = true
    ..measures.addEntries([
      MapEntry(
          HEALTH,
          HealthMeasure(
            type: HEALTH,
            name: 'Step Counts',
            description:
                "Collects the step counts from Apple Health / Google Fit",
            healthDataType: HealthDataType.STEPS,
          )),
    ]);

  SamplingSchema get normal => common;
  SamplingSchema get light => common;
  SamplingSchema get minimum => common;
  SamplingSchema get debug => common;
}
