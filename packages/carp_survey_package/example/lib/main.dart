import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';
import 'package:carp_survey_package/survey.dart';
import 'package:research_package/research_package.dart';

/// This is a very simple example of how this sampling package is used with CARP Mobile Sensing (CAMS).
/// NOTE, however, that the code below will not run.
/// See the documentation on how to use CAMS: https://github.com/cph-cachet/carp.sensing-flutter/wiki
///
/// Also take a look at the [CAMS Example app](https://github.com/cph-cachet/carp.sensing-flutter/tree/master/carp_mobile_sensing_app) for use of the Survey Package.
void main() async {
  SamplingPackageRegistry.register(SurveySamplingPackage());

  Study study = Study("1234", "bardram", name: "bardram study");

  // adding all measure from the common schema to one one trigger and one task
  study.addTriggerTask(
          DelayedTrigger(delay: Duration(seconds: 30)),
          Task(name: 'WHO-5 Survey')
            ..measures.add(RPTaskMeasure(
              MeasureType(NameSpace.CARP, SurveySamplingPackage.SURVEY),
              name: 'WHO5',
              enabled: true,
              surveyTask: who5Task,
//              onSurveyTriggered: onSurveyTriggered,
//              onSurveySubmit: onSurveySubmit,
            )))
      //
      ;
  // Create a Study Controller that can manage this study, initialize it, and start it.
  StudyController controller = StudyController(study);

  // await initialization before starting
  await controller.initialize();
  controller.resume();

  // listening on all data events from the study
  controller.events.forEach(print);
}

void onSurveyTriggered(SurveyPage surveyPage) {
  //@TODO handle a callback when the survey is triggered.
}

void onSurveySubmit(RPTaskResult result) {
  //@TODO handle a callback when the survey is done.
}
