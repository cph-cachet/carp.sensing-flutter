/// Contain classes for collecting data from the basic device sensors:
/// - accelerometer
/// - gyroscope
/// - light
/// - pedometer
library audio;

import 'dart:async';
import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'audio_datum.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

part 'audio_probes.dart';
