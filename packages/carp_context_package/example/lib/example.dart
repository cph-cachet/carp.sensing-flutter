import 'package:carp_core/carp_core.dart';
import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';
import 'package:carp_context_package/context.dart';

/// This is a very simple example of how this sampling package is used with
/// CARP Mobile Sensing (CAMS).
/// NOTE, however, that the code below will not run.
/// See the documentation on how to use CAMS: https://github.com/cph-cachet/carp.sensing-flutter/wiki
void main() async {
  // register this sampling package before using its measures
  SamplingPackageRegistry().register(ContextSamplingPackage());

  // Create a study protocol using a local file to store data
  CAMSStudyProtocol protocol = CAMSStudyProtocol()
    ..name = 'Track patient movement'
    ..owner = ProtocolOwner(
      id: 'AB',
      name: 'Alex Boyon',
      email: 'alex@uni.dk',
    )
    ..dataEndPoint = FileDataEndPoint(
      bufferSize: 500 * 1000,
      zip: true,
      encrypt: false,
    );

  // define which devices are used for data collection
  // in this case, its only this smartphone
  Smartphone phone = Smartphone();
  protocol.addMasterDevice(phone);

  // Add an automatic task that immediately starts collecting weather and air_quality.
  protocol.addTriggeredTask(
      ImmediateTrigger(),
      AutomaticTask()
        ..addMeasures(SensorSamplingPackage().common.getMeasureList(
          types: [
            ContextSamplingPackage.WEATHER,
            ContextSamplingPackage.AIR_QUALITY,
          ],
        )),
      phone);

  // Add an automatic task that starts collecting location, geolocation,
  // activity, and a geofence after 5 minutes.
  protocol.addTriggeredTask(
      DelayedTrigger(delay: Duration(minutes: 5)),
      AutomaticTask()
        ..addMeasures(DeviceSamplingPackage().common.getMeasureList(
          types: [
            ContextSamplingPackage.LOCATION,
            ContextSamplingPackage.GEOLOCATION,
            ContextSamplingPackage.ACTIVITY,
            ContextSamplingPackage.GEOFENCE,
          ],
        )),
      phone);

  // deploy this protocol using the on-phone deployment service
  StudyDeploymentStatus status =
      await SmartphoneDeploymentService().createStudyDeployment(protocol);

  String studyDeploymentId = status.studyDeploymentId;
  String deviceRolename = status.masterDeviceStatus.device.roleName;

  // create and configure a client manager for this phone
  SmartPhoneClientManager client = SmartPhoneClientManager();
  await client.configure();

  // create a study runtime to control this deployment
  StudyDeploymentController controller =
      await client.addStudy(studyDeploymentId, deviceRolename);

  // configure the controller and resume sampling
  await controller.configure();
  controller.resume();

  // listening and print all data events from the study
  controller.data.forEach(print);
}
