/*
 * Copyright 2018-2022 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

/// The CAMS implementation of the core CARP domain classes like
/// [StudyProtocol], [TaskConfiguration], and [Measure].
/// Also hold JSON logic to handle de/serialization of the domain objects.
library domain;

import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:json_annotation/json_annotation.dart';

import 'package:carp_core/carp_core.dart';
import 'package:carp_serializable/carp_serializable.dart';
import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';

part 'study_protocol.dart';
part 'study_description.dart';
part 'data_endpoint.dart';
part 'sampling_configurations.dart';
part 'device_configurations.dart';
part 'smartphone_deployment.dart';
part 'app_task.dart';
part 'tasks.dart';
part 'triggers.dart';
part 'data.dart';
part 'data_types.dart';
part 'device_info.dart';
part 'transformers.dart';

part 'domain.g.dart';
