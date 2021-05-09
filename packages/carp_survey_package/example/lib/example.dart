import 'package:carp_survey_package/survey.dart';
import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';

/// This is a very simple example of how this sampling package is used with
/// CARP Mobile Sensing (CAMS).
/// NOTE, however, that the code below will not run.
/// See the documentation on how to use CAMS: https://github.com/cph-cachet/carp.sensing-flutter/wiki
void main() async {
  // register this sampling package before using its measures
  SamplingPackageRegistry().register(SurveySamplingPackage());

  // Create a study protocol using a local file to store data
  CAMSStudyProtocol protocol = CAMSStudyProtocol()
    ..name = 'Track patient movement'
    ..owner = ProtocolOwner(
      id: 'AB',
      name: 'Alex Boyon',
      email: 'alex@uni.dk',
    );

  // define which devices are used for data collection
  // in this case, its only this smartphone
  Smartphone phone = Smartphone();
  protocol.addMasterDevice(phone);

// add a WHO-5 survey to an app task for this protocol
  protocol.addTriggeredTask(
      DelayedTrigger(delay: Duration(seconds: 30)),
      AppTask(type: 'survey', name: 'WHO-5 Survey')
        ..measures.add(RPTaskMeasure(
          type: SurveySamplingPackage.SURVEY,
          name: 'WHO-5',
          description: "The WHO well-being survey",
          enabled: true,
          surveyTask: who5Task,
        )),
      phone);
}
