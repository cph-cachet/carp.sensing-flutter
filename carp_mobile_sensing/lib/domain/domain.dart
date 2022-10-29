/// The CAMS implementation of the core CARP domain classes like
/// [StudyProtocol], [TaskDescriptor], and [Measure].
/// Also hold JSON serialization and deseralization logic to handle seraialization
/// of the domain objects.
library domain;

import 'dart:io';
import 'dart:convert';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

import 'package:carp_core/carp_core.dart';
import 'package:carp_serializable/carp_serializable.dart';
import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';

part 'study_protocol.dart';
part 'study_description.dart';
part 'data_endpoint.dart';
part 'sampling_schema.dart';
part 'sampling_configurations.dart';
part 'device_descriptor.dart';
part 'device_deployment.dart';
part 'app_task.dart';
part 'triggers.dart';
part 'datum.dart';
part 'device_info.dart';
part 'transformers.dart';

part 'domain.g.dart';
