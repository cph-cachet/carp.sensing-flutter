/// A library for collecting context information on:
///  * location
///  * activity
///  * weather
library context;

import 'dart:async';
import 'dart:math' as math;
import 'dart:io' show Platform;
import 'package:json_annotation/json_annotation.dart';
import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';
import 'package:activity_recognition_alt/activity_recognition_alt.dart';
import 'package:location/location.dart';
import 'package:weather/weather.dart';
import 'package:openmhealth_schemas/openmhealth_schemas.dart' as omh;
import 'package:permission_handler/permission_handler.dart';

part 'activity_datum.dart';
part 'activity_probe.dart';
part 'location_datum.dart';
part 'location_probe.dart';
part 'location_measure.dart';
part 'weather_datum.dart';
part 'weather_measure.dart';
part 'weather_probe.dart';
part 'context_transformers.dart';
part 'context_package.dart';
part 'geofence_measure.dart';
part 'geofence_datum.dart';
part 'geofence_probe.dart';
part 'context.g.dart';
