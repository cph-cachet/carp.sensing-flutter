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

  // Create a study protocol
  StudyProtocol protocol = StudyProtocol(
    ownerId: 'owner@dtu.dk',
    name: 'Context Sensing Example',
  );

  // define which devices are used for data collection - both phone and MoviSens
  Smartphone phone = Smartphone();
  DeviceDescriptor movisens = DeviceDescriptor(roleName: 'main_ecg');

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
      await SmartphoneDeploymentService().createStudyDeployment(protocol);

  String studyDeploymentId = status.studyDeploymentId;
  String deviceRolename = status.masterDeviceStatus!.device.roleName;

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
