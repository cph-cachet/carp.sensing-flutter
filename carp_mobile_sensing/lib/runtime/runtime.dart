/*
 * Copyright 2018-2022 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

/// Contains classes for running the sensing framework incl.
/// the [SmartphoneDeploymentExecutor], [TaskExecutor] and different types of
/// [Probe]s.
library runtime;

import 'dart:async';
import 'dart:math';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

import 'package:carp_serializable/carp_serializable.dart';
import 'package:carp_core/carp_core.dart';
import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';

import 'package:async/async.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:cron/cron.dart' as cron;
import 'package:battery_plus/battery_plus.dart';

import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

part 'executors/deployment_executor.dart';
part 'executors/executor_factory.dart';
part 'executors/executors.dart';
part 'executors/trigger_executors.dart';
part 'executors/task_executors.dart';
part 'executors/task_control_executors.dart';
part 'executors/probes.dart';
part 'util/cron_parser.dart';

part 'app_task_controller.dart';
part 'client_manager.dart';
part 'deployment_controller.dart';
part 'device_manager.dart';
part 'sampling_package.dart';
part 'user_tasks.dart';

part 'runtime.g.dart';
