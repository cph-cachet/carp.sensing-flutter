/// This library contains the software architecture for the CARP sensing framework implemented in Flutter.
/// Supports cross-platform (iOS and Android) sensing.
library carp_mobile_sensing;

// The core packages
export 'package:carp_mobile_sensing/data_managers/data_managers.dart';
export 'package:carp_mobile_sensing/runtime/runtime.dart';
export 'package:carp_mobile_sensing/domain/domain.dart';
export 'package:carp_mobile_sensing/transformer_schemas/omh/omh_schemas.dart';
export 'package:carp_mobile_sensing/transformer_schemas/privacy/privacy_schemas.dart';

// The built-in sampling packages
export 'package:carp_mobile_sensing/sampling_packages/device/device.dart';
export 'package:carp_mobile_sensing/sampling_packages/sensors/sensors.dart';
export 'package:carp_mobile_sensing/sampling_packages/connectivity/connectivity.dart';
export 'package:carp_mobile_sensing/sampling_packages/apps/apps.dart';
