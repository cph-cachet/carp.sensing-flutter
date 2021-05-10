/// This library contains the software architecture for the CARP Mobile Sensing (CAMS)
/// framework implemented in Flutter. Supports cross-platform (iOS and Android) sensing.
library carp_mobile_sensing;

export 'package:carp_core/carp_common/carp_core_common.dart';
export 'package:carp_core/carp_protocols/carp_core_protocols.dart';
export 'package:carp_core/carp_deployment/carp_core_deployment.dart';
export 'package:carp_core/carp_client/carp_core_client.dart';
export 'package:carp_core/carp_data/carp_core_data.dart';

export 'data_managers/data_managers.dart';
export 'domain/domain.dart';
export 'runtime/runtime.dart';
export 'sampling_packages/device/device.dart';
export 'sampling_packages/sensors/sensors.dart';

// auto generate json code (.g files) with:
//   flutter pub run build_runner build --delete-conflicting-outputs
