/// The core CARP domain classes like [StudyProtocol], [TaskDescriptor], and [Measure].
/// Also hold JSON serialization logic to serialize [Datum] objects
/// into a [DataPoint] as well as deseralization of [StudyProtocol] objects
/// obtained from a [StudyManager].
library carp_core_domain;

import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';

export 'carp_core_domain.dart';

part 'carp_common/serialization.dart';

part 'carp_deployment/domain/device_deployment.dart';
part 'carp_deployment/domain/study_deployment.dart';
part 'carp_deployment/domain/users.dart';

part 'carp_data/domain/datapoint.dart';
part 'carp_data/domain/datatype.dart';
part 'carp_data/domain/data.dart';

part 'carp_protocols/domain/device_descriptor.dart';
part 'carp_protocols/domain/measures.dart';
part 'carp_protocols/domain/study_protocol.dart';
part 'carp_protocols/domain/task_descriptor.dart';
part 'carp_protocols/domain/trigger.dart';

part 'carp_core_domain.g.dart';
