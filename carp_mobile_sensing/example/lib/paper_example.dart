import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';
import 'dart:convert';

/// A simple example of how to set up sampling.
void sensing() async {
  // create the study
  Study study = Study('DF#4dD-1', 'user@gmail.com',
      name: 'A simple example study',
      dataEndPoint: FileDataEndPoint()
        ..bufferSize = 500 * 1000
        ..zip = true
        ..encrypt = false)
    ..addTriggerTask(
        ImmediateTrigger(),
        Task('One Common Sensing Task')
          ..measures = SamplingSchema.common().getMeasureList(types: [
            ConnectivitySamplingPackage.BLUETOOTH,
            ConnectivitySamplingPackage.CONNECTIVITY,
            SensorSamplingPackage.ACCELEROMETER,
            SensorSamplingPackage.GYROSCOPE
          ]));

  // setup and start the sampling runtime
  StudyController controller = StudyController(study);
  await controller.initialize();
  controller.start();

  // subscribe to events
  controller.events.listen((Datum datum) {
    // do something w. the datum, e.g. print the json
    print(JsonEncoder.withIndent(' ').convert(datum));
  });

  // listening on events from a specific probe
  ProbeRegistry.lookup(DeviceSamplingPackage.SCREEN).events.forEach(print);
}
