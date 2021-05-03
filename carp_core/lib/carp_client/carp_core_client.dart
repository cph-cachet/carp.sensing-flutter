/// This is the runtime which performs the actual data collection on a device (e.g.,
/// desktop computer or smartphone). This subsystem contains reusable components
/// which understand the runtime configuration derived from a study protocol by
/// the ‘deployment’ subsystem. Integrations with sensors are loaded through a
/// 'device data collector' plug-in system to decouple sensing — not part of core —
/// from sensing logic.
///
/// [ClientManager] is the main entry point into this subsystem.
/// Concrete devices extend on it, e.g., the SmartphoneClient manages data collection on
/// a smartphone and is implemented in [CARP Mobile Sensing](https://pub.dev/packages/carp_mobile_sensing).
///
/// Contains the core client classes like [ClientManager], [DeviceRegistry],
/// [DeviceDataCollector], and [StudyRuntime].
///
/// See the [`carp.clients`](https://github.com/cph-cachet/carp.core-kotlin/blob/develop/docs/carp-clients.md)
/// definition in Kotlin.
library carp_core_client;

import 'dart:async';
import 'package:meta/meta.dart';

import 'package:carp_core/carp_protocols/carp_core_protocols.dart';
import 'package:carp_core/carp_deployment/carp_core_deployment.dart';
import 'package:carp_core/carp_data/carp_core_data.dart';
import 'package:flutter/material.dart';

export 'carp_core_client.dart';

part 'client_manager.dart';
part 'study_runtime.dart';
part 'device_manager.dart';
