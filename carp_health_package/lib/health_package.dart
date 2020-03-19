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
import 'package:json_annotation/json_annotation.dart';
import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';
import 'package:health/health.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:carp_mobile_sensing/domain/domain.dart';

part 'health_probe.dart';
part 'health_domain.dart';
part 'health_package.g.dart';

/// This is the base class for this health sampling package.
///
/// To use this package, register it in the [carp_mobile_sensing] package using
///
/// ```
///   SamplingPackageRegistry.register(HealthSamplingPackage());
/// ```
class HealthSamplingPackage implements SamplingPackage {
  static const String HEALTH = "health";

  List<String> get dataTypes => [
        HEALTH,
      ];

  Probe create(String type) => type == HEALTH ? HealthProbe(type) : null;

  void onRegister() {
    FromJsonFactory.registerFromJsonFunction("HealthMeasure", HealthMeasure.fromJsonFunction);
  }

  List<PermissionGroup> get permissions => [];

  SamplingSchema get common => SamplingSchema()
    ..type = SamplingSchemaType.COMMON
    ..name = 'Common (default) health sampling schema'
    ..powerAware = true
    ..measures.addEntries([
      MapEntry(
          HEALTH,
          HealthMeasure(MeasureType(NameSpace.CARP, HEALTH), HealthDataType.STEPS, Duration(days: 2),
              name: 'Health Data')),
    ]);

  SamplingSchema get normal => common;
  SamplingSchema get light => common;
  SamplingSchema get minimum => common;
  SamplingSchema get debug => common;
}
