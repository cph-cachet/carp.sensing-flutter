import 'package:carp_core/carp_core.dart';
import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';
import 'package:carp_esense_package/esense.dart';

/// This is a very simple example of how this sampling package is used with
/// CARP Mobile Sensing (CAMS).
/// NOTE, however, that the code below will not run.
/// See the documentation on how to use CAMS:
/// https://github.com/cph-cachet/carp.sensing-flutter/wiki
void main() async {
  // register this sampling package before using its measures
  SamplingPackageRegistry().register(ESenseSamplingPackage());

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

  // define which devices are used for data collection - both phone and eSense
  Smartphone phone = Smartphone(
    name: 'SM-A320FL',
    roleName: CAMSDeploymentService.DEFAULT_MASTER_DEVICE_ROLENAME,
  );
  DeviceDescriptor eSense = DeviceDescriptor(
    roleName: ESenseSamplingPackage.ESENSE_DEVICE_TYPE,
    isMasterDevice: false,
  );

  protocol
    ..addMasterDevice(phone)
    ..addConnectedDevice(eSense);

  // Add an automatic task that immediately starts collecting eSense button and sensor events.
  protocol.addTriggeredTask(
      ImmediateTrigger(),
      AutomaticTask()
        ..addMeasures([
          ESenseMeasure(
              type: ESenseSamplingPackage.ESENSE_BUTTON,
              measureDescription: {
                'en': MeasureDescription(
                  name: 'eSense - Button',
                  description: "Collects button event from the eSense device",
                )
              },
              deviceName: 'eSense-0332'),
          ESenseMeasure(
              type: ESenseSamplingPackage.ESENSE_SENSOR,
              measureDescription: {
                'en': MeasureDescription(
                  name: 'eSense - Sensor',
                  description:
                      "Collects movement data from the eSense inertial measurement unit (IMU) sensor",
                )
              },
              deviceName: 'eSense-0332',
              samplingRate: 5),
        ]),
      phone);

  // deploy this protocol using the on-phone deployment service
  StudyDeploymentStatus status =
      await CAMSDeploymentService().createStudyDeployment(protocol);

  // at this time we can register an eSensee device which are connected to this phone (master device)
  CAMSDeploymentService().registerDevice(
    status.studyDeploymentId,
    ESenseSamplingPackage.ESENSE_DEVICE_TYPE,
    DeviceRegistration('some device id'),
  );

  // now ready to get the device deployment configuration for this phone
  CAMSMasterDeviceDeployment deployment = await CAMSDeploymentService()
      .getDeviceDeployment(status.studyDeploymentId);

  // Create a study deployment controller that can manage this deployment
  StudyDeploymentController controller = StudyDeploymentController(deployment);

  // initialize the controller and resume sampling
  await controller.initialize();
  controller.resume();

  // listening and print all data events from the study
  controller.data.forEach(print);
}
