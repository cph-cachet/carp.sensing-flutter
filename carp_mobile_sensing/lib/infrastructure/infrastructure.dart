/*
 * Copyright 2024 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

/// This library holds the implementation of various CAMS services.
///
/// The infrastructure provide as part of this [carp_mobile_sensing](https://pub.dev/packages/carp_mobile_sensing)
/// package contains on-phone infrastructure like [SmartphoneDeploymentService]
/// deployment service and the [SQLiteDataManager] data manager.
library infrastructure;

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:archive/archive_io.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'package:carp_core/carp_core.dart';
import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';

export 'sampling_packages/device/device.dart';
export 'sampling_packages/sensors/sensors.dart';

part 'data_managers/console_data_manager.dart';
part 'data_managers/file_data_manager.dart';
part 'data_managers/sqlite_data_manager.dart';

part 'file_study_manager.dart';
part 'local_notification_controller.dart';
part 'deployment_service.dart';
part 'persistence.dart';
