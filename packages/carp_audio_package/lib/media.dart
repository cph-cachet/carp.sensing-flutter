/// A library for collecting an audio recording from the phone's microphone.
/// Support the following measures:
///  * audio recording
///  * noise sampling
library media;

import 'dart:async';
import 'dart:io';

import 'package:flutter_sound/flutter_sound.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:noise_meter/noise_meter.dart';
import 'package:stats/stats.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:carp_core/carp_core.dart';
import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';

part 'audio_probe.dart';
part 'video_probe.dart';
part 'noise_probe.dart';
part 'datums.dart';
part 'media_package.dart';
part 'media.g.dart';

// auto generate json code (.g files) with:
//   flutter pub run build_runner build --delete-conflicting-outputs
