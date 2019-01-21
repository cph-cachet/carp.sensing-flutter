/// The core CARP domain classes like [Study], [TaskDescriptor], and [Measure].
/// Also hold JSON serialization logic to serialize [Datum] objects
/// into a [CARPDataPoint] as well as deseralization of [Study] objects
/// obtained from a [StudyManager].
library carp_core;

import 'dart:io';
import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/services.dart';

part 'serialization.dart';
part 'study.dart';
part 'tasks.dart';
part 'carp_datapoint.dart';
part 'datum.dart';
part 'measures.dart';
part 'carp_core.g.dart';
part 'device_info.dart';
part 'managers.dart';
