/*
 * Copyright 2019 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */
/// A library for collecting cardiovascular data from the Movisens Move4 and EcgMove4 device data on:
///
///  * tap marker
///  * heart rate
///  * heart rate variability
///  * metabolic level
///  * body position
///  * step count
///  * movement (accelerometer)
///  * battery level of device
///  * connectivity status to device
library movisens;

import 'dart:convert';
import 'dart:async';
import 'package:movisens_flutter/movisens_flutter.dart';
import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:openmhealth_schemas/openmhealth_schemas.dart' as omh;
import 'package:permission_handler/permission_handler.dart';

part 'movisens_measure.dart';
part 'movisens_datum.dart';
part 'movisens_device_probe.dart';
part 'movisens_package.dart';
part "movisens.g.dart";
part 'movisens_transformers.dart';
