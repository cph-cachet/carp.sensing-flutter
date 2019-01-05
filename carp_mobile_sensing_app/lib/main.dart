library mobile_sensing_app;

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';
import 'package:carp_mobile_sensing/core/core.dart';
import 'package:carp_backend/carp_backend.dart';

part 'src/app.dart';
part 'src/sensing/sensing.dart';
part 'src/models/probe_models.dart';
part 'src/blocs/probe_blocs.dart';
part 'src/ui/probe_list.dart';
part 'src/ui/data_viz.dart';
part 'src/ui/study_viz.dart';
part 'src/ui/cachet.dart';
part 'src/models/probe_description.dart';

void main() {
  runApp(App());
}
