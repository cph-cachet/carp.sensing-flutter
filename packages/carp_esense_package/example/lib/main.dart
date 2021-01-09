import 'package:carp_esense_package/esense.dart';
import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';

/// This is a very simple example of how this sampling package is used with
/// CARP Mobile Sensing (CAMS).
/// NOTE, however, that the code below will not run.
/// See the documentation on how to use CAMS at:
///   https://github.com/cph-cachet/carp.sensing-flutter/wiki
void main() async {
  SamplingPackageRegistry().register(ESenseSamplingPackage());

  Study study = Study(id: "1234", userId: "bardram", name: "bardram study");

  // creating a eSense task collecting the inertial measurement unit (IMU)
  // sensor events and button press/release events from the eSense device.
  study
    ..addTriggerTask(
        ImmediateTrigger(),
        Task(name: 'eSense Sampling')
          ..addMeasure(ESenseMeasure(
            type: MeasureType(
              NameSpace.CARP,
              ESenseSamplingPackage.ESENSE_SENSOR,
            ),
            name: 'eSense - Sensors',
            enabled: true,
            deviceName: 'eSense-0332',
            samplingRate: 10,
          ))
          ..addMeasure(ESenseMeasure(
            type: MeasureType(
              NameSpace.CARP,
              ESenseSamplingPackage.ESENSE_BUTTON,
            ),
            name: 'eSense - Button',
            enabled: true,
            deviceName: 'eSense-0332',
          )));

  // Create a Study Controller that can manage this study, initialize it, and start it.
  StudyController controller = StudyController(study);

  // await initialization before starting
  await controller.initialize();
  controller.resume();

  // listening on all data events from the study
  controller.events.forEach(print);
}
