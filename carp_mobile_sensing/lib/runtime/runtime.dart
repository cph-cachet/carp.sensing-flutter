/*
 * Copyright 2018-2022 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

/// Contains classes for running the sensing framework incl.
/// the [StudyDeploymentExecutor], [TaskExecutor] and different types of
/// [Probe]s.
library runtime;

import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

import 'package:carp_serializable/carp_serializable.dart';
import 'package:carp_core/carp_core.dart';
import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';

import 'package:path_provider/path_provider.dart';
import 'package:async/async.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart'
    as notifications;
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:uuid/uuid.dart';
import 'package:cron/cron.dart' as cron;
import 'package:battery_plus/battery_plus.dart';

import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_native_timezone/flutter_native_timezone.dart';

part 'data_manager.dart';
part 'device_manager.dart';
part 'device_controller.dart';
part 'executors/study_executors.dart';
part 'executors/executors.dart';
part 'executors/trigger_executors.dart';
part 'executors/task_executors.dart';
part 'app_task_controller.dart';
part 'user_tasks.dart';
part 'executors/probes.dart';
part 'sampling_package.dart';
part 'settings.dart';
part 'study_controller.dart';
part 'study_manager.dart';
part 'deployment_service.dart';
part 'client_manager.dart';
part 'notification/notification_controller.dart';
part 'notification/local_notification_controller.dart';
part 'notification/awesome_notification_controller.dart';
part 'util/cron_parser.dart';
part 'runtime.g.dart';

/// Generic sensing exception.
class SensingException implements Exception {
  dynamic message;
  SensingException([this.message]);

  @override
  String toString() => '$runtimeType - $message';
}

/// A simple method for printing warning messages to the console.
void info(String message) =>
    (Settings().debugLevel.index >= DebugLevel.INFO.index)
        ? print('[CAMS INFO] $message')
        : 0;

/// A simple method for printing warning messages to the console.
void warning(String message) =>
    (Settings().debugLevel.index >= DebugLevel.WARNING.index)
        ? print('[CAMS WARNING]  $message')
        : 0;

/// A simple method for printing debug messages to the console.
void debug(String message) =>
    (Settings().debugLevel.index >= DebugLevel.DEBUG.index)
        ? print('[CAMS DEBUG] $message')
        : 0;
