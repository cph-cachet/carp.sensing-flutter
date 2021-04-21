/// This library contains the software architecture for the CARP Mobile Sensing (CAMS)
/// framework implemented in Flutter. Supports cross-platform (iOS and Android) sensing.
library carp_mobile_sensing;

export 'package:carp_core/carp_core.dart';

export 'data_managers/data_managers.dart';
export 'domain/domain.dart';
export 'runtime/runtime.dart';
export 'sampling_packages/device/device.dart';
export 'sampling_packages/sensors/sensors.dart';

// auto generate json code (.g files) with:
//   flutter pub run build_runner build --delete-conflicting-outputs
