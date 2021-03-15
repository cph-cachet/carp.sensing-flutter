/// The core CARP domain classes like [StudyProtocol], [TaskDescriptor], and [Measure].
/// Also hold JSON serialization logic to serialize [Datum] objects
/// into a [DataPoint] as well as deseralization of [StudyProtocol] objects
/// obtained from a [StudyManager].
library carp_core;

import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';
import 'dart:convert';

export 'carp_core.dart';

part 'carp_common/serialization.dart';

part 'carp_data/domain/datapoint.dart';
part 'carp_data/domain/datatype.dart';
part 'carp_data/domain/data.dart';

part 'carp_deployment/domain/device_deployment.dart';
part 'carp_deployment/domain/study_deployment.dart';
part 'carp_deployment/domain/users.dart';
part 'carp_deployment/infrastructure/deployment_request.dart';

part 'carp_protocols/domain/device_descriptor.dart';
part 'carp_protocols/domain/measure.dart';
part 'carp_protocols/domain/study_protocol.dart';
part 'carp_protocols/domain/task_descriptor.dart';
part 'carp_protocols/domain/triggered_task.dart';
part 'carp_protocols/domain/trigger.dart';
part 'carp_protocols/domain/sampling_configuration.dart';

part 'carp_deployment/application/deployment_service.dart';
part 'carp_deployment/application/participation_service.dart';

part 'carp_core.g.dart';

/// A convient function to convert a Dart object into a JSON string.
String toJsonString(Object object) =>
    const JsonEncoder.withIndent(' ').convert(object);
