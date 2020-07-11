import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';
import 'package:carp_movisens_package/movisens.dart';
import 'package:movisens_flutter/movisens_flutter.dart';

/// This is a very simple example of how this sampling package is used with CARP Mobile Sensing (CAMS).
/// NOTE, however, that the code below will not run.
/// See the documentation on how to use CAMS: https://github.com/cph-cachet/carp.sensing-flutter/wiki
void main() async {
  SamplingPackageRegistry.register(MovisensSamplingPackage());

  Study study = Study("1234", "bardram", name: "bardram study");

  // adding a movisens measure
  study.addTriggerTask(
      ImmediateTrigger(), // a simple trigger that starts immediately
      Task(name: 'Movisens Task')
        ..addMeasure(MovisensMeasure(MeasureType(NameSpace.CARP, MovisensSamplingPackage.MOVISENS),
            name: "movisens",
            enabled: true,
            address: '06-00-00-00-00-00',
            deviceName: "ECG-223",
            height: 178,
            weight: 77,
            age: 32,
            gender: Gender.male,
            sensorLocation: SensorLocation.chest)));

  // Create a Study Controller that can manage this study, initialize it, and start it.
  StudyController controller = StudyController(study);

  // await initialization before starting
  await controller.initialize();
  controller.resume();

  // listening on all data events from the study
  controller.events.forEach(print);
}
