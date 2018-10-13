/// This library contains the software architecture for the CARP sensing framework implemented in Flutter.
/// Supports cross-platform (iOS and Android) sensing.
library carp_mobile_sensing;

// Services
export 'package:carp_mobile_sensing/datastore/data_manager.dart';
export 'package:carp_mobile_sensing/datastore/study_manager.dart';
export 'package:carp_mobile_sensing/datastore/local/console_data_manager.dart';
export 'package:carp_mobile_sensing/datastore/local/file_data_manager.dart';

// Util
export 'package:carp_mobile_sensing/util/device_info.dart';

// Domain model
export 'package:carp_mobile_sensing/domain/measures/measures.dart';
export 'package:carp_mobile_sensing/domain/measures/measures.dart';
export 'package:carp_mobile_sensing/domain/study.dart';
export 'package:carp_mobile_sensing/domain/tasks.dart';
export 'package:carp_mobile_sensing/domain/datum/datum.dart';
export 'package:carp_mobile_sensing/domain/carp_datapoint.dart';

// Study Manager, Task Executor, and Probes
export 'package:carp_mobile_sensing/runtime/executors.dart';
export 'package:carp_mobile_sensing/runtime/probes.dart';
export 'package:carp_mobile_sensing/runtime/probe_registry.dart';

export 'package:carp_mobile_sensing/runtime/probes/movement/pedometer_probe.dart';
export 'package:carp_mobile_sensing/domain/measures/pedometer_measure.dart';
export 'package:carp_mobile_sensing/domain/datum/pedometer_datum.dart';

export 'package:carp_mobile_sensing/runtime/probes/movement/accelerometer_probe.dart';
export 'package:carp_mobile_sensing/runtime/probes/movement/gyroscope_probe.dart';
export 'package:carp_mobile_sensing/domain/measures/sensor_measure.dart';
export 'package:carp_mobile_sensing/domain/datum/sensor_datum.dart';

export 'package:carp_mobile_sensing/runtime/probes/hardware/battery_probe.dart';
export 'package:carp_mobile_sensing/runtime/probes/hardware/sysinfo_probe.dart';
export 'package:carp_mobile_sensing/domain/measures/hardware_measures.dart';
export 'package:carp_mobile_sensing/domain/datum/hardware_datum.dart';

export 'package:carp_mobile_sensing/runtime/probes/connectivity/bluetooth_probe.dart';
export 'package:carp_mobile_sensing/domain/measures/location_measure.dart';

export 'package:carp_mobile_sensing/runtime/probes/connectivity/connectivity_probe.dart';
export 'package:carp_mobile_sensing/domain/measures/connectivity_measures.dart';
export 'package:carp_mobile_sensing/domain/datum/connectivity_datum.dart';

export 'package:carp_mobile_sensing/runtime/probes/communication/text_messages_probe.dart';
export 'package:carp_mobile_sensing/runtime/probes/communication/phone_log_probe.dart';
export 'package:carp_mobile_sensing/domain/measures/communication_measures.dart';
export 'package:carp_mobile_sensing/domain/datum/communication_datum.dart';
