import 'package:carp_esense_package/esense.dart';
import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';

/// This is a very simple example of how this sampling package is used with CARP Mobile Sensing (CAMS).
/// NOTE, however, that the code below will not run.
/// See the documentation on how to use CAMS: https://github.com/cph-cachet/carp.sensing-flutter/wiki
void main() async {
  SamplingPackageRegistry().register(ESenseSamplingPackage());

  Study study = Study(id: "1234", userId: "bardram", name: "bardram study");

  // creating a task collecting step counts and blood pressure data for the last two days
  study
    ..addTriggerTask(
        ImmediateTrigger(),
        Task()
          ..measures = SamplingSchema.debug().getMeasureList(
            namespace: NameSpace.CARP,
            types: [
              ESenseSamplingPackage.BUTTON,
              ESenseSamplingPackage.SENSOR,
            ],
          ));

  // Create a Study Controller that can manage this study, initialize it, and start it.
  StudyController controller = StudyController(study);

  // await initialization before starting
  await controller.initialize();
  controller.resume();

  // listening on all data events from the study
  controller.events.forEach(print);
}
