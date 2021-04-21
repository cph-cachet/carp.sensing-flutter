/// The core CARP domain classes like [StudyProtocol], [TaskDescriptor], [Measure],
/// and [DataPoint].
///
/// Also hold serialization logic to (de)serialize Dart classes to/from
/// JSON including support for polymorphic.
/// See the [Serializable] class, which contains the logic for polymorphic serialization.
library carp_core_data;

import 'package:json_annotation/json_annotation.dart';

export 'carp_core_data.dart';

part 'datapoint.dart';
part 'datatype.dart';
part 'data.dart';

part 'carp_core_data.g.dart';

// auto generate json code (.g files) with:
//   flutter pub run build_runner build --delete-conflicting-outputs
