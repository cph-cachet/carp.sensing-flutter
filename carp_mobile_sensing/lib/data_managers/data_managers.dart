/*
 * Copyright 2021 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

/// A library for data managers. Contains implementation of the
///
///  * [DataManager] interface
///  * [StudyProtocolManager] interface
library managers;

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:sqflite/sqflite.dart';

import 'package:carp_core/carp_core.dart';
import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';

part 'local/console_data_manager.dart';
part 'local/file_data_manager.dart';
part 'local/file_study_manager.dart';
part 'local/sqlite_dat_manager.dart';
