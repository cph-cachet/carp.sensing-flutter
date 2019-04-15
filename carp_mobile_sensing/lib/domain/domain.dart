/// The core CARP domain classes like [Study], [Task], and [Measure].
/// Also hold JSON serialization logic to serialize [Datum] objects
/// into a [DataPoint] as well as deseralization of [Study] objects
/// obtained from a [StudyManager].
library domain;

import 'dart:io';
import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/services.dart';

import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';

part 'serialization.dart';
part 'study.dart';
part 'tasks.dart';
part 'datapoint.dart';
part 'datum.dart';
part 'measures.dart';
part 'device_info.dart';
part 'managers.dart';
part 'sampling_schema.dart';
part 'transformers.dart';
part 'domain.g.dart';
