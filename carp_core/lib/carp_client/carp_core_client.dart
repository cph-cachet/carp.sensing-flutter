/// The core client domain classes like [ClientManager] and [ConnectedDeviceManager].
library carp_core_client;

import 'dart:async';

import 'package:carp_core/carp_protocols/carp_core_protocols.dart';
import 'package:carp_core/carp_deployment/carp_core_deployment.dart';
import 'package:carp_core/carp_data/carp_core_data.dart';

export 'carp_core_client.dart';

part 'client_manager.dart';
part 'study_runtime.dart';
part 'data_collector.dart';
part 'device_manager.dart';
