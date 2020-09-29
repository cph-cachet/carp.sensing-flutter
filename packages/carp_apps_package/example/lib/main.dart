import 'package:carp_apps_package/apps.dart';
import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';

/// This is a very simple example of how this sampling package is used with CARP Mobile Sensing (CAMS).
/// NOTE, however, that the code below will not run.
/// See the documentation on how to use CAMS: https://github.com/cph-cachet/carp.sensing-flutter/wiki
void main() async {
  SamplingPackageRegistry.instance.register(AppsSamplingPackage());

  Study study = Study("1234", "xyz", name: "apps study");

  // creating a task collecting a list of installed apps and app usage
  study.addTriggerTask(
      ImmediateTrigger(), // a simple trigger that starts immediately
      Task(name: 'Step and blood pressure')
        ..addMeasure(
          Measure(
            MeasureType(NameSpace.CARP, AppsSamplingPackage.APP_USAGE),
            name: 'App usage',
          ),
        )
        ..addMeasure(
          Measure(
            MeasureType(NameSpace.CARP, AppsSamplingPackage.APPS),
            name: 'Installed apps',
          ),
        ));

  // Create a Study Controller that can manage this study, initialize it, and start it.
  StudyController controller = StudyController(study);

  // await initialization before starting
  await controller.initialize();
  controller.resume();

  // listening on all data events from the study
  controller.events.forEach(print);
}
