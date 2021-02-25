/// The core CARP domain classes like [StudyProtocol], [TaskDescriptor], and [Measure].
/// Also hold JSON serialization logic to serialize [Datum] objects
/// into a [DataPoint] as well as deseralization of [StudyProtocol] objects
/// obtained from a [StudyManager].
library carp_core_domain;

import 'dart:io';
import 'dart:convert';
import 'package:device_info/device_info.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';

part 'device_info.dart';

part 'carp_common/serialization.dart';

part 'carp_deployment/domain/device_deployment.dart';

part 'carp_data/domain/datapoint.dart';
part 'carp_data/domain/datum.dart';
part 'carp_data/domain/transformers.dart';

part 'carp_protocols/domain/app_task.dart';
part 'carp_protocols/domain/device_descriptor.dart';
part 'carp_protocols/domain/measures.dart';
part 'carp_protocols/domain/sampling_schema.dart';
part 'carp_protocols/domain/study_protocol.dart';
part 'carp_protocols/domain/task_descriptor.dart';
part 'carp_protocols/domain/trigger.dart';
part 'carp_protocols/domain/cams_triggers.dart';
part 'carp_protocols/domain/datatype.dart';

part 'domain.g.dart';
