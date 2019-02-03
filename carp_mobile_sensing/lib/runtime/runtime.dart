/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

/// Contains classes for running the sensing framework incl.
/// the [StudyExecutor], [TaskExecutor] and different types of
/// abstract [Probe]s.
library runtime;

import 'dart:async';
import 'package:async/async.dart';
import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';
import 'package:carp_mobile_sensing/probes/sensors/sensors.dart';
import 'package:carp_mobile_sensing/core/core.dart';

part 'probes.dart';
part 'probe_registry.dart';
part 'executors.dart';
part 'study_controller.dart';
part 'probe_controller.dart';
part 'sampling_package.dart';

class SensingException implements Exception {
  dynamic message;
  SensingException([this.message]);
}
