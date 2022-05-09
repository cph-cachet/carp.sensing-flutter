import 'package:carp_core/carp_core.dart';
import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';
import 'package:carp_survey_package/survey.dart';

/// This is a very simple example of how this sampling package is used with
/// CARP Mobile Sensing (CAMS).
/// NOTE, however, that the code below will not run.
/// See the documentation on how to use CAMS: https://github.com/cph-cachet/carp.sensing-flutter/wiki
void main() async {
  // register this sampling package before using its measures
  SamplingPackageRegistry().register(SurveySamplingPackage());

  // Create a study protocol
  StudyProtocol protocol = StudyProtocol(
    ownerId: 'owner@dtu.dk',
    name: 'Survey Example',
  );

  // define which devices are used for data collection
  // in this case, its only this smartphone
  Smartphone phone = Smartphone();
  protocol.addMasterDevice(phone);

  // add a WHO-5 survey to an app task for this protocol
  protocol.addTriggeredTask(
      DelayedTrigger(delay: Duration(seconds: 30)),
      AppTask(type: 'survey', name: 'WHO-5 Survey')
        ..measures.add(Measure(type: SurveySamplingPackage.SURVEY)
          ..overrideSamplingConfiguration =
              RPTaskSamplingConfiguration(surveyTask: who5Task)),
      phone);
}
