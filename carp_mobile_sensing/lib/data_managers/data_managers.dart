/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

/// A library for handling data stores.
library data_managers;

import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:archive/archive_io.dart';
import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';

part 'local/console_data_manager.dart';
part 'local/file_data_manager.dart';
part 'data_managers.g.dart';
