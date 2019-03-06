/// This library contains the software architecture for the CARP sensing framework implemented in Flutter.
/// Supports cross-platform (iOS and Android) sensing.
library carp_mobile_sensing;

// The core packages
export 'package:carp_mobile_sensing/datastore/datastore.dart';
export 'package:carp_mobile_sensing/runtime/runtime.dart';
export 'package:carp_mobile_sensing/core/core.dart';

// The built-in sensors
export 'package:carp_mobile_sensing/packages/device/device.dart';
export 'package:carp_mobile_sensing/packages/sensors/sensors.dart';
export 'package:carp_mobile_sensing/packages/connectivity/connectivity.dart';
export 'package:carp_mobile_sensing/packages/apps/apps.dart';
