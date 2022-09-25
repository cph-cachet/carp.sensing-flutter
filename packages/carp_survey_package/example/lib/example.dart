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

  // add a WHO-5 survey as an app task
  // plus collect device and ambient light information when survey is done
  protocol.addTriggeredTask(
      DelayedTrigger(delay: Duration(seconds: 30)),
      RPAppTask(
          type: SurveyUserTask.WHO5_SURVEY_TYPE,
          name: 'WHO-5 Survey',
          rpTask: who5Task)
        ..measures.add(Measure(type: DeviceSamplingPackage.DEVICE))
        ..measures.add(Measure(type: SensorSamplingPackage.LIGHT)),
      phone);
}
