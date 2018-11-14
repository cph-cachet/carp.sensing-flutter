/// A library for collecting an audio recording from the phone's microphone.
library audio;

import 'dart:async';
import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:carp_mobile_sensing/domain/domain.dart';
import 'package:carp_mobile_sensing/runtime/runtime.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:noise_level/noise_level.dart';
import 'package:stats/stats.dart';

part 'sound_probe.dart';
part 'noise_probe.dart';
part 'sound_datum.dart';
part 'sound.g.dart';
part 'sound_measure.dart';

