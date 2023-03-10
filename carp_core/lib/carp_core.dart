/// This library contains the entire carp_core API the CARP Mobile Sensing (CAMS)
/// framework implemented in Flutter.
library carp_core;

import 'package:carp_serializable/carp_serializable.dart';
import 'package:iso_duration_parser/iso_duration_parser.dart';
import 'package:carp_core/deployment/carp_core_deployment.dart';
import 'package:carp_core/common/carp_core_common.dart';
import 'package:carp_core/protocols/carp_core_protocols.dart';
import 'package:carp_core/data/carp_core_data.dart';

export 'client/carp_core_client.dart';
export 'common/carp_core_common.dart';
export 'data/carp_core_data.dart';
export 'deployment/carp_core_deployment.dart';
export 'protocols/carp_core_protocols.dart';

part 'carp_core.json.dart';

/// Base class for the carp_core library.
///
/// In order to ensure initialization of json serialization, call:
///
///    Core.ensureInitialized();
///
class Core {
  static final _instance = Core._();
  factory Core() => _instance;
  Core._() {
    _registerFromJsonFunctions();
  }

  /// Returns a the singleton instance of [CarpMobileSensing].
  /// If it has not yet been initialized, this call makes sure to create and
  /// initialize it.
  static Core ensureInitialized() => _instance;
}
