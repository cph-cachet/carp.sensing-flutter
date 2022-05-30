library mobile_sensing_app;

import 'package:flutter/material.dart' hide TimeOfDay;
import 'package:flutter/services.dart';
import 'dart:async';

import 'package:carp_core/carp_core.dart';
import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';
import 'package:carp_connectivity_package/connectivity.dart';
import 'package:carp_esense_package/esense.dart';
import 'package:carp_context_package/context.dart';
import 'package:carp_audio_package/media.dart';
import 'package:carp_communication_package/communication.dart';
import 'package:carp_apps_package/apps.dart';
// import 'package:movisens_flutter/movisens_flutter.dart';
// import 'package:carp_movisens_package/movisens.dart';
// import 'package:carp_health_package/health_package.dart';
// import 'package:health/health.dart';

import 'package:carp_webservices/carp_auth/carp_auth.dart';
import 'package:carp_webservices/carp_services/carp_services.dart';
import 'package:carp_backend/carp_backend.dart';

part 'src/app.dart';
part 'src/sensing/sensing.dart';
part 'src/sensing/study_deployment_manager.dart';
part 'src/models/probe_models.dart';
part 'src/models/device_models.dart';
part 'src/models/probe_description.dart';
part 'src/models/deployment_model.dart';
part 'src/models/data_models.dart';
part 'src/blocs/sensing_bloc.dart';
part 'src/blocs/carp_backend.dart';
part 'src/sensing/local_study_protocol_mananger.dart';
part 'src/ui/probe_list.dart';
part 'src/ui/device_list.dart';
part 'src/ui/data_viz.dart';
part 'src/ui/study_viz.dart';
part 'src/ui/cachet.dart';

void main() async {
  // makes sure to have an instance of the WidgetsBinding, which is required
  // to use platform channels to call native code
  // see also >> https://stackoverflow.com/questions/63873338/what-does-widgetsflutterbinding-ensureinitialized-do/63873689
  WidgetsFlutterBinding.ensureInitialized();

  // initialize the bloc, setting the deployment mode:
  //  * LOCAL
  //  * CARP_STAGGING
  //  * CARP_PRODUCTION
  await bloc.initialize(
    deploymentMode: DeploymentMode.LOCAL,
  );

  runApp(App());
}
