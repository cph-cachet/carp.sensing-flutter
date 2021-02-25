/// The core CARP domain classes like [StudyProtocol], [TaskDescriptor], and [Measure].
/// Also hold JSON serialization logic to serialize [Datum] objects
/// into a [DataPoint] as well as deseralization of [StudyProtocol] objects
/// obtained from a [StudyManager].
library carp_core_application;

import 'domain.dart';

part 'carp_deployment/application/deployment_service.dart';
