library mobile_sensing_app;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

import 'package:carp_core/carp_core.dart';
import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';
import 'package:carp_connectivity_package/connectivity.dart';
import 'package:carp_esense_package/esense.dart';
import 'package:carp_context_package/context.dart';
import 'package:carp_audio_package/audio.dart';
//import 'package:carp_communication_package/communication.dart';
//import 'package:carp_apps_package/apps.dart';

part 'src/app.dart';
part 'src/sensing/sensing.dart';
part 'src/models/probe_models.dart';
part 'src/models/device_models.dart';
part 'src/models/probe_description.dart';
part 'src/models/deployment_model.dart';
part 'src/models/data_models.dart';
part 'src/blocs/sensing_bloc.dart';
part 'src/sensing/study_protocol_mananger.dart';
part 'src/ui/probe_list.dart';
part 'src/ui/device_list.dart';
part 'src/ui/data_viz.dart';
part 'src/ui/study_viz.dart';
part 'src/ui/cachet.dart';

void main() {
  runApp(App());
}
