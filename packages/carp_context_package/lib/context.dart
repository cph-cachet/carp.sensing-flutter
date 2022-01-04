/// A library for collecting context information on:
///  * location
///  * activity
///  * weather
///  * air quality
///  * mobility features
library context;

import 'dart:async';
import 'dart:math' as math;
import 'package:json_annotation/json_annotation.dart';
import 'package:activity_recognition_flutter/activity_recognition_flutter.dart';
import 'package:weather/weather.dart';
import 'package:openmhealth_schemas/openmhealth_schemas.dart' as omh;
import 'package:permission_handler/permission_handler.dart';
import 'package:air_quality/air_quality.dart';
import 'package:mobility_features/mobility_features.dart';
// import 'package:carp_background_location/carp_background_location.dart';
// import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart' as location;

import 'package:carp_core/carp_core.dart';
import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';

part 'src/location_manager.dart';
part 'src/activity/activity_datum.dart';
part 'src/activity/activity_probe.dart';
part 'src/location/location_datum.dart';
part 'src/location/location_probes.dart';
part 'src/location/location_measure.dart';
part 'src/weather/weather_datum.dart';
part 'src/weather/weather_measure.dart';
part 'src/weather/weather_probe.dart';
part 'src/context_transformers.dart';
part 'src/context_package.dart';
part 'src/geofence/geofence_measure.dart';
part 'src/geofence/geofence_datum.dart';
part 'src/geofence/geofence_probe.dart';
part 'src/air_quality/air_quality_datum.dart';
part 'src/air_quality/air_quality_measure.dart';
part 'src/air_quality/air_quality_probe.dart';
part 'package:carp_context_package/src/mobility/mobility_datum.dart';
part 'package:carp_context_package/src/mobility/mobility_probe.dart';
part 'package:carp_context_package/src/mobility/mobility_measure.dart';
part 'context.g.dart';

// auto generate json code (.g files) with:
//   flutter pub run build_runner build --delete-conflicting-outputs
