/// This library contains the software architecture for the CARP Mobile Sensing (CAMS)
/// framework implemented in Flutter. Supports cross-platform (iOS and Android) sensing.
library carp_mobile_sensing;

import 'package:carp_serializable/carp_serializable.dart';
import 'package:carp_core/carp_core.dart';
import 'package:carp_mobile_sensing/domain/domain.dart';
import 'package:carp_mobile_sensing/runtime/runtime.dart';

export 'data_managers/data_managers.dart';
export 'domain/domain.dart';
export 'runtime/runtime.dart';
export 'sampling_packages/device/device.dart';
export 'sampling_packages/sensors/sensors.dart';

part 'carp_mobile_sensing.json.dart';

class CarpMobileSensing {
  static final _instance = CarpMobileSensing._();

  CarpMobileSensing._() {
    Core();
    CAMSDataType();
    _registerFromJsonFunctions();
  }

  /// The singleton [CarpMobileSensing] instance.
  factory CarpMobileSensing() => _instance;

  /// Returns a the singleton instance of [CarpMobileSensing].
  /// If it has not yet been initialized, this call makes sure to create and
  /// initialize it.
  CarpMobileSensing ensureInitialized() => _instance;
}
