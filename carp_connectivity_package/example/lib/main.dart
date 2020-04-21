import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';
import 'package:carp_connectivity_package/connectivity.dart';

/// This is a very simple example of how this sampling package is used with CARP Mobile Sensing (CAMS).
/// NOTE, however, that the code below will not run.
/// See the documentation on how to use CAMS: https://github.com/cph-cachet/carp.sensing-flutter/wiki
void main() async {
  SamplingPackageRegistry.register(ConnectivitySamplingPackage());

  Study study = Study("1234", "bardram", name: "bardram study");

  // adding all measure from the common schema to one one trigger and one task
  study.addTriggerTask(
      ImmediateTrigger(), // a simple trigger that starts immediately
      Task()
        ..measures = SamplingSchema.common().getMeasureList(
          namespace: NameSpace.CARP,
          types: [
            ConnectivitySamplingPackage.CONNECTIVITY,
            ConnectivitySamplingPackage.BLUETOOTH,
            ConnectivitySamplingPackage.WIFI,
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
