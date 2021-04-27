/// The common CARP core domain classes.
///
/// Hold serialization logic to (de)serialize Dart classes to/from
/// JSON including support for polymorphic.
/// See the [Serializable] class, which contains the logic for polymorphic serialization.
library carp_core_common;

import 'dart:convert';
import 'package:carp_core/carp_protocols/carp_core_protocols.dart';
import 'package:carp_core/carp_deployment/carp_core_deployment.dart';

export 'carp_core_common.dart';

part 'serialization.dart';

// auto generate json code (.g files) with:
//   flutter pub run build_runner build --delete-conflicting-outputs
