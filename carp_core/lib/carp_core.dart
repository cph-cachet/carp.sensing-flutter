/// This library contains the entire carp_core API the CARP Mobile Sensing (CAMS)
/// framework implemented in Flutter.
library carp_core;

import 'package:carp_serializable/carp_serializable.dart';
import 'package:carp_core/protocols/carp_core_protocols.dart';
import 'package:carp_core/deployment/carp_core_deployment.dart';
import 'package:carp_core/common/carp_core_common.dart';

export 'client/carp_core_client.dart';
export 'common/carp_core_common.dart';
export 'data/carp_core_data.dart';
export 'deployment/carp_core_deployment.dart';
export 'protocols/carp_core_protocols.dart';

part 'carp_core.json.dart';

/// Start class for this carp_core library. Just create a singleton instance:
///
///    Core();
///
class Core {
  static final _instance = Core._();
  factory Core() => _instance;
  Core._() {
    _registerFromJsonFunctions();
  }
}
