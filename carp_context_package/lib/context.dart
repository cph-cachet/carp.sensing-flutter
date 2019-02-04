/// A library for collecting context information on:
///  * location
///  * activity
///  * weather
library context;

import 'dart:async';
import 'package:json_annotation/json_annotation.dart';
import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';
import 'package:activity_recognition/activity_recognition.dart';
import 'package:carp_mobile_sensing/core/core.dart';
import 'package:location/location.dart';
import 'package:weather/weather.dart';

part 'activity_datum.dart';
part 'activity_probe.dart';
part 'location_datum.dart';
part 'location_probe.dart';
part 'weather_datum.dart';
part 'weather_measures.dart';
part 'weather_probe.dart';
part 'context_package.dart';
part 'context.g.dart';
