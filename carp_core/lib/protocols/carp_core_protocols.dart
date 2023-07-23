/// Implements open standards which can describe a study protocol, i.e.,
/// defining how a study should be run. Essentially, this subsystem has no
/// technical dependencies on any particular sensor technology or application as
/// it merely describes why, when, and what data should be collected.
///
///
/// Contain the the core CARP domain classes like [StudyProtocol], [TaskConfiguration],
/// and [Measure].
///
/// See the [`carp.protocols`](https://github.com/cph-cachet/carp.core-kotlin/blob/develop/docs/carp-protocols.md)
/// definition in Kotlin.
library carp_core_protocols;

import 'package:json_annotation/json_annotation.dart';
import 'package:carp_serializable/carp_serializable.dart';
import 'package:carp_core/common/carp_core_common.dart';

part 'domain/study_protocol.dart';
part 'application/protocol_classes.dart';
part 'application/protocol_service.dart';
part 'infrastructure/protocol_requests.dart';

part 'carp_core_protocols.g.dart';

// auto generate json code (.g files) with:
//   flutter pub run build_runner build --delete-conflicting-outputs
