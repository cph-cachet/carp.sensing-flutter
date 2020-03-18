/// A library for collecting health information from Apple Health or Google Fit.
/// Is using the [health](https://pub.dev/packages/health) plugin.
/// Can be configured to collect the different [HealthDataType](https://pub.dev/documentation/health/latest/health/HealthDataType-class.html).
///
/// The measure type is `health`.
library health_lib;

import 'dart:async';
import 'dart:math' as math;
import 'dart:io' show Platform;
import 'package:json_annotation/json_annotation.dart';
import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';
import 'package:health/health.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:carp_mobile_sensing/domain/domain.dart';

part 'health_package.dart';
part 'health_probe.dart';
part 'health_domain.dart';
part 'health.g.dart';
