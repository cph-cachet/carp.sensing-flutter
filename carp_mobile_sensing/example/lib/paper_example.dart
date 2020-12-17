import 'dart:convert';

import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';

void sensing() async {
  // create the study
  Study study = Study(
      id: '2',
      userId: 'user@gmail.com',
      name: 'A simple example study',
      dataEndPoint: FileDataEndPoint()
        ..bufferSize = 500 * 1000
        ..zip = true
        ..encrypt = false)
    ..dataFormat = NameSpace.OMH
    ..addTriggerTask(
        ImmediateTrigger(),
        Task(name: 'One Common Sensing Task')
          ..measures = SamplingSchema.common().getMeasureList(types: [
            SensorSamplingPackage.ACCELEROMETER,
            SensorSamplingPackage.GYROSCOPE,
            DeviceSamplingPackage.SCREEN,
            // ContextSamplingPackage.LOCATION,
            // ContextSamplingPackage.ACTIVITY,
            // ConnectivitySamplingPackage.BLUETOOTH,
          ]));

  // setup and start the sampling runtime
  StudyController controller = StudyController(study);
  await controller.initialize();
  controller.resume();

  // subscribe to events
  controller.events.listen((Datum datum) {
    // do something w. the datum, e.g. print the json
    print(JsonEncoder.withIndent(' ').convert(datum));
  });

  // listening on events of a specific type
  ProbeRegistry().eventsByType(DeviceSamplingPackage.SCREEN).forEach(print);
}
