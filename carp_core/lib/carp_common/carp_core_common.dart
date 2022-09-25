/// The common CARP core domain classes.
///
/// Hold serialization logic to (de)serialize Dart classes to/from
/// JSON including support for polymorphic.
/// See the [Serializable] class, which contains the logic for polymorphic serialization.
library carp_core_common;

import 'package:carp_serializable/carp_serializable.dart';

export 'carp_core_common.dart';

part 'service_request.dart';
