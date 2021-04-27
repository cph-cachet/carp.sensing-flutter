/*
 * Copyright 2021 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

/// A library for handling data managers.
library managers;

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:path_provider/path_provider.dart';

import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';

part 'local/console_data_manager.dart';
part 'local/file_data_manager.dart';
part 'local/file_study_manager.dart';
