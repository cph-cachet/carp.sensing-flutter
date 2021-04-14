import 'package:carp_core/carp_core.dart';
import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';
import 'package:carp_movisens_package/movisens.dart';
import 'package:movisens_flutter/movisens_flutter.dart';

/// This is a very simple example of how this sampling package is used with
/// CARP Mobile Sensing (CAMS).
/// NOTE, however, that the code below will not run.
/// See the documentation on how to use CAMS: https://github.com/cph-cachet/carp.sensing-flutter/wiki
void main() async {
  // register this sampling package before using its measures
  SamplingPackageRegistry().register(MovisensSamplingPackage());

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

  // define which devices are used for data collection - both phone and MoviSens
  Smartphone phone = Smartphone();
  DeviceDescriptor movisens = DeviceDescriptor();

  protocol
    ..addMasterDevice(phone)
    ..addConnectedDevice(movisens);

  // adding a movisens measure
  protocol.addTriggeredTask(
      ImmediateTrigger(), // a simple trigger that starts immediately
      AutomaticTask(name: 'Movisens Task')
        ..addMeasure(MovisensMeasure(
            type: MovisensSamplingPackage.MOVISENS,
            name: 'Movisens ECG device',
            description:
                "Collects heart rythm data from the Movisens EcgMove4 sensor",
            enabled: true,
            address: '06-00-00-00-00-00',
            deviceName: "ECG-223",
            height: 178,
            weight: 77,
            age: 32,
            gender: Gender.male,
            sensorLocation: SensorLocation.chest)),
      movisens);

  // deploy this protocol using the on-phone deployment service
  StudyDeploymentStatus status =
      await CAMSDeploymentService().createStudyDeployment(protocol);

  // at this time we can register an eSensee device which are connected to this phone (master device)
  CAMSDeploymentService().registerDevice(
    status.studyDeploymentId,
    MovisensDevice.DEFAULT_ROLENAME,
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
