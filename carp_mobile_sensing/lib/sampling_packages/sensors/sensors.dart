/// A library containing a sampling package for collecting data from the basic
/// device sensors:
///  - accelerometer
///  - gyroscope
///  - magnetometer
///  - acceleration features
///  - ambient light
///  - pedometer (step events)
library sensors;

import 'dart:async';
import 'dart:io' show Platform;
import 'dart:math' as math;

import 'package:sensors_plus/sensors_plus.dart';
import 'package:light/light.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:pedometer/pedometer.dart' as pedometer;
import 'package:statistics/statistics.dart';
import 'package:sample_statistics/sample_statistics.dart';

import 'package:carp_serializable/carp_serializable.dart';
import 'package:carp_core/carp_core.dart';
import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';

part 'sensor_probes.dart';
part 'light_probe.dart';
part 'pedometer_probe.dart';
part 'sensor_data.dart';
part 'sensor_package.dart';
part 'sensors.g.dart';
