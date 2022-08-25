/// A library for collecting context information from the [eSense](http://www.esense.io) device.
library esense;

import 'dart:async';
import 'package:json_annotation/json_annotation.dart';
import 'package:esense_flutter/esense.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:carp_serializable/carp_serializable.dart';
import 'package:carp_core/carp_core.dart';
import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';

part 'esense_package.dart';
part 'esense_domain.dart';
part 'esense_runtime.dart';
part 'esense_device_manager.dart';
part 'esense.g.dart';

// auto generate json code (.g files) with:
//   flutter pub run build_runner build --delete-conflicting-outputs
