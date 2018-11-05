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

part 'audio_probe.dart';
part 'audio_datum.dart';
part 'audio.g.dart';
part 'audio_measure.dart';
