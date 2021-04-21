/// The core CARP domain classes like [StudyProtocol], [TaskDescriptor], and [Measure].
library carp_core_protocols;

import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

import 'package:carp_core/carp_common/carp_core_common.dart';
import 'package:carp_core/carp_data/carp_core_data.dart';

export 'carp_core_protocols.dart';

part 'device_descriptor.dart';
part 'measure.dart';
part 'study_protocol.dart';
part 'protocol_owner.dart';
part 'task_descriptor.dart';
part 'triggered_task.dart';
part 'trigger.dart';
part 'sampling_configuration.dart';

part 'carp_core_protocols.g.dart';

// auto generate json code (.g files) with:
//   flutter pub run build_runner build --delete-conflicting-outputs
