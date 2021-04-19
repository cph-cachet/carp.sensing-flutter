/// The core CARP domain classes like [StudyProtocol], [TaskDescriptor], [Measure],
/// and [DataPoint].
///
/// Also hold serialization logic to (de)serialize Dart classes to/from
/// JSON including support for polymorphic.
/// See the [Serializable] class, which contains the logic for polymorphic serialization.
library carp_core;

import 'carp_common/carp_core_common.dart';
import 'carp_client/carp_core_client.dart';
import 'carp_protocols/carp_core_protocols.dart';
import 'carp_deployment/carp_core_deployment.dart';
import 'carp_data/carp_core_data.dart';

export 'carp_core.dart';
export 'carp_common/carp_core_common.dart';
export 'carp_client/carp_core_client.dart';
export 'carp_protocols/carp_core_protocols.dart';
export 'carp_deployment/carp_core_deployment.dart';
export 'carp_data/carp_core_data.dart';

// auto generate json code (.g files) with:
//   flutter pub run build_runner build --delete-conflicting-outputs
