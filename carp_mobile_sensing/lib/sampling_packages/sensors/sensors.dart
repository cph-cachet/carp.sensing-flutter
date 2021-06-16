/// Alibrary containing a sampling package for collecting data from the basic
/// device sensors:
/// - accelerometer
/// - gyroscope
/// - light
/// - pedometer
library sensors;

import 'dart:async';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:light/light.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:pedometer/pedometer.dart';
import 'package:stats/stats.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:carp_core/carp_core.dart';
import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';

part 'sensor_probes.dart';
part 'light_probe.dart';
part 'pedometer_probe.dart';
part 'sensor_datum.dart';
part 'sensor_package.dart';
part 'sensors.g.dart';
