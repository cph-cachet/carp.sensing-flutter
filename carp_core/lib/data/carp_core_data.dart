/// Contains the core data classes like [Data], [DataPoint],
/// [DataFormat], and [DataType].
///
/// The the `carp.data` sub-system is not yet defined in the Kotlin implementation of
/// carp_core.
library carp_core_data;

import 'package:carp_core/common/carp_core_common.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:carp_serializable/carp_serializable.dart';

export 'carp_core_data.dart';

part 'application/datastream.dart';
part 'application/datastream_service.dart';

part 'carp_core_data.g.dart';
