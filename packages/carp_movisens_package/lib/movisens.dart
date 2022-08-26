/*
 * Copyright 2019-2022 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */
/// A [CARP Mobile Sensing](https://pub.dev/packages/carp_mobile_sensing)
/// sampling package for collecting cardiovascular data from the
/// Movisens Move4 and EcgMove4 devices on:
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
library carp_movisens_package;

import 'dart:convert';
import 'dart:async';
import 'package:movisens_flutter/movisens_flutter.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:openmhealth_schemas/openmhealth_schemas.dart' as omh;
import 'package:permission_handler/permission_handler.dart';

import 'package:carp_serializable/carp_serializable.dart';
import 'package:carp_core/carp_core.dart';
import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';

part 'movisens_datum.dart';
part 'movisens_probe.dart';
part 'movisens_package.dart';
part "movisens.g.dart";
part 'movisens_transformers.dart';
part 'movisens_device_manager.dart';
