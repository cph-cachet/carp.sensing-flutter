/// Implements open standards which can describe a study protocol, i.e.,
/// defining how a study should be run. Essentially, this subsystem has no
/// technical dependencies on any particular sensor technology or application as
/// it merely describes why, when, and what data should be collected.
///
///
/// Contain the the core CARP domain classes like [StudyDeployment], [TaskDescriptor],
/// and [Measure].
///
/// See the [`carp.protocols`](https://github.com/cph-cachet/carp.core-kotlin/blob/develop/docs/carp-protocols.md)
/// definition in Kotlin.
library carp_core_protocols;

import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

import 'package:carp_core/carp_common/carp_core_common.dart';
import 'package:carp_core/carp_data/carp_core_data.dart';

export 'carp_core_protocols.dart';

part 'domain/device_descriptor.dart';
part 'domain/device_connection.dart';
part 'domain/measure.dart';
part 'domain/study_protocol.dart';
part 'domain/task_descriptor.dart';
part 'domain/triggered_task.dart';
part 'domain/trigger.dart';
part 'domain/sampling_configuration.dart';

part 'application/protocol_service.dart';
part 'application/protocol_classes.dart';
part 'infrastructure/protocol_requests.dart';

part 'carp_core_protocols.g.dart';

// auto generate json code (.g files) with:
//   flutter pub run build_runner build --delete-conflicting-outputs
