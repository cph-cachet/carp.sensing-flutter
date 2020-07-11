/// A library for collecting context information on:
///  * location
///  * activity
///  * weather
///  * air quality
library context;

import 'dart:async';
import 'dart:math' as math;
import 'dart:io' show Platform;
import 'package:json_annotation/json_annotation.dart';
import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';
import 'package:activity_recognition_flutter/activity_recognition_flutter.dart';
import 'package:weather/weather_library.dart';
import 'package:openmhealth_schemas/openmhealth_schemas.dart' as omh;
import 'package:permission_handler/permission_handler.dart';
import 'package:air_quality/air_quality.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mobility_features/mobility_features.dart';

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
part 'air_quality_datum.dart';
part 'air_quality_measure.dart';
part 'air_quality_probe.dart';
part 'package:carp_context_package/mobility_datum.dart';
part 'package:carp_context_package/mobility_probe.dart';
part 'package:carp_context_package/mobility_measure.dart';
part 'context.g.dart';

/// auto generate code with:
/// flutter pub run build_runner build --delete-conflicting-outputs
