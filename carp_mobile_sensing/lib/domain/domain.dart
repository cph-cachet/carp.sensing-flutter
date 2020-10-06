/// The core CARP domain classes like [Study], [Task], and [Measure].
/// Also hold JSON serialization logic to serialize [Datum] objects
/// into a [DataPoint] as well as deseralization of [Study] objects
/// obtained from a [StudyManager].
library domain;

import 'dart:convert';
import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/services.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';
import 'package:cron/cron.dart' as cron;

import '../carp_mobile_sensing.dart';

part 'datapoint.dart';
part 'datum.dart';
part 'device_info.dart';
part 'domain.g.dart';
part 'measures.dart';
part 'sampling_schema.dart';
part 'serialization.dart';
part 'study.dart';
part 'tasks.dart';
part 'transformers.dart';
part 'triggers.dart';
