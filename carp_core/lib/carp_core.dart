/// This library contains the entire carp_core API the CARP Mobile Sensing (CAMS)
/// framework implemented in Flutter.
library carp_core;

import 'package:carp_serializable/carp_serializable.dart';
import 'package:carp_core/carp_protocols/carp_core_protocols.dart';
import 'package:carp_core/carp_deployment/carp_core_deployment.dart';

export 'carp_client/carp_core_client.dart';
export 'carp_common/carp_core_common.dart';
export 'carp_data/carp_core_data.dart';
export 'carp_deployment/carp_core_deployment.dart';
export 'carp_protocols/carp_core_protocols.dart';

part 'carp_core.json.dart';

class Core {
  static final _instance = Core._();
  factory Core() => _instance;
  Core._() {
    _registerFromJsonFunctions();
  }
}
