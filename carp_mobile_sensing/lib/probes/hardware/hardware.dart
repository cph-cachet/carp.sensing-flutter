/// A library for collecting information from the device hardware:
/// - battery
/// - screen
/// - free memory
library hardware;

import 'dart:async';
import 'package:battery/battery.dart';
import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:screen_state/screen_state.dart';
import 'package:system_info/system_info.dart';
import 'package:carp_mobile_sensing/core/core.dart';

part 'battery_probe.dart';
part 'hardware_datum.dart';
part 'screen_probe.dart';
part 'sysinfo_probe.dart';
part 'hardware.g.dart';
