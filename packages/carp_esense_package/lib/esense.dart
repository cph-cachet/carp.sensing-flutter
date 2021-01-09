/// A library for collecting context information from the [eSense](http://www.esense.io) device.
library esense;

import 'dart:async';
import 'package:json_annotation/json_annotation.dart';
import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';
import 'package:esense_flutter/esense.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:meta/meta.dart';

part 'esense_package.dart';
part 'esense_domain.dart';
part 'esense_runtime.dart';
part 'esense.g.dart';
