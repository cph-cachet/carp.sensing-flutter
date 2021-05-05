/// Contains the core data classes like [Data], [DataPoint],
/// [DataFormat], and [DataType].
///
/// The the `carp.data` sub-system is not yet defined in the Kotlin implementation of
/// carp_core.
library carp_core_data;

import 'package:json_annotation/json_annotation.dart';
import 'package:carp_core/carp_common/carp_core_common.dart';

export 'carp_core_data.dart';

part 'datapoint.dart';
part 'datatype.dart';
part 'data.dart';

part 'carp_core_data.g.dart';

// auto generate json code (.g files) with:
//   flutter pub run build_runner build --delete-conflicting-outputs
