/// This library contains the software architecture for the CARP Mobile Sensing (CAMS)
/// framework implemented in Flutter. Supports cross-platform (iOS and Android) sensing.
///
/// The CAMS software architecture is a domain-drive design (DDD) model using an
/// onion-based layout with the following onion layers:
///
///  * domain - contains the core domain model for CAMS which extends the domain
///             model of the [carp_core](https://pub.dev/packages/carp_core) domain model.
///  * runtime - contains the business logic for executing a sensing study (normally
///              called 'application services' in DDD).
///  * services - contains all services definitions used for sensing.
///  * infrastructure - contains specific implementation of the services used.
///
library carp_mobile_sensing;

import 'package:carp_serializable/carp_serializable.dart';
import 'package:carp_core/carp_core.dart';

import 'domain/domain.dart';
import 'runtime/runtime.dart';
import 'infrastructure/infrastructure.dart';

export 'domain/domain.dart';
export 'runtime/runtime.dart';
export 'services/services.dart';
export 'infrastructure/infrastructure.dart';

part 'carp_mobile_sensing.json.dart';

/// Base class for the carp_mobile_sensing library.
///
/// In order to ensure initialization of json serialization, call:
///
///    CarpMobileSensing.ensureInitialized();
///
class CarpMobileSensing {
  static final _instance = CarpMobileSensing._();

  CarpMobileSensing._() {
    Core.ensureInitialized();
    CAMSDataType();
    _registerFromJsonFunctions();
  }

  /// The singleton [CarpMobileSensing] instance.
  factory CarpMobileSensing() => _instance;

  /// Returns a the singleton instance of [CarpMobileSensing].
  /// If it has not yet been initialized, this call makes sure to create and
  /// initialize it.
  static CarpMobileSensing ensureInitialized() => _instance;
}

/// Generic sensing exception.
class SensingException implements Exception {
  dynamic message;
  SensingException([this.message]);

  @override
  String toString() => '$runtimeType - $message';
}
