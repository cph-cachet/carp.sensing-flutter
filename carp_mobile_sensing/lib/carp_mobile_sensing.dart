/// This library contains the software architecture for the CARP sensing framework implemented in Flutter.
/// Supports cross-platform (iOS and Android) sensing.
library carp_mobile_sensing;

// The core packages
export 'package:carp_mobile_sensing/datastore/datastore.dart';
export 'package:carp_mobile_sensing/runtime/runtime.dart';
export 'package:carp_mobile_sensing/core/core.dart';

// The list of built-in sensors
export 'package:carp_mobile_sensing/probes/audio/audio.dart';
export 'package:carp_mobile_sensing/probes/sensors/sensors.dart';
export 'package:carp_mobile_sensing/probes/device/device.dart';
export 'package:carp_mobile_sensing/probes/apps/apps.dart';
export 'package:carp_mobile_sensing/probes/communication/communication.dart';
export 'package:carp_mobile_sensing/probes/connectivity/connectivity.dart';
export 'package:carp_mobile_sensing/probes/context/context.dart';
