import 'package:carp_context_package/context.dart';
import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';

/// This is a very simple example of how this sampling package is used with CARP Mobile Sensing (CAMS).
/// NOTE, however, that the code below will not run.
/// See the documentation on how to use CAMS: https://github.com/cph-cachet/carp.sensing-flutter/wiki
void main() async {
  SamplingPackageRegistry().register(ContextSamplingPackage());

  Study study = Study("1234", "bardram", name: "bardram study");

  // creating a task collecting step counts and blood pressure data for the last two days
  study
    ..addTriggerTask(
        PeriodicTrigger(period: Duration(seconds: 20)),
        Task()
          ..measures = SamplingSchema.debug().getMeasureList(
            namespace: NameSpace.CARP,
            types: [
              ContextSamplingPackage.WEATHER,
              ContextSamplingPackage.AIR_QUALITY,
            ],
          ))
    ..addTriggerTask(
        ImmediateTrigger(),
        Task()
          ..measures = SamplingSchema.debug().getMeasureList(
            namespace: NameSpace.CARP,
            types: [
              ContextSamplingPackage.LOCATION,
              ContextSamplingPackage.GEOLOCATION,
              ContextSamplingPackage.ACTIVITY,
              ContextSamplingPackage.GEOFENCE,
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
