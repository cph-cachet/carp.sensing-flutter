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
import 'dart:convert';

import 'package:async/async.dart';
import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:permission_handler_platform_interface/permission_handler_platform_interface.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:cron/cron.dart' as cron;

part 'data_manager.dart';
part 'executors.dart';
part 'app_task_executor.dart';
part 'permission_handler.dart';
part 'probe_controller.dart';
part 'probe_registry.dart';
part 'probes.dart';
part 'sampling_package.dart';
part 'settings.dart';
part 'study_controller.dart';
part 'sampling_schema.dart';

/// Generic sensing exception.
class SensingException implements Exception {
  dynamic message;
  SensingException([this.message]);
}

class DebugLevel {
  static const int NONE = 0;
  static const int INFO = 1;
  static const int WARNING = 2;
  static const int DEBUG = 3;
}

/// The global debug level setting.
///
/// Typically set when instantiating a [StudyController].
/// See [DebugLevel] for valid debug level settings.
/// Can be changed on runtime.
int globalDebugLevel = DebugLevel.WARNING;

/// A simple method for printing warning messages to the console.
void info(String message) =>
    (globalDebugLevel >= DebugLevel.INFO) ? print('CAMS INFO - $message') : 0;

/// A simple method for printing warning messages to the console.
void warning(String message) => (globalDebugLevel >= DebugLevel.WARNING)
    ? print('CAMS WARNING - $message')
    : 0;

/// A simple method for printing debug messages to the console.
void debug(String message) =>
    (globalDebugLevel >= DebugLevel.DEBUG) ? print('CAMS DEBUG - $message') : 0;
