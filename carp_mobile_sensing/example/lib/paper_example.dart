import 'dart:convert';
import 'package:carp_core/carp_core.dart';
import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';

void sensing() async {
  // create a new CAMS study protocol with an owner
  StudyProtocol protocol = StudyProtocol(
    ownerId: 'AB',
    name: 'patient_tracking',
    description: 'Track patient movement',
  );

  // define which devices are used for data collection
  // in this case, its only this smartphone
  Smartphone phone = Smartphone();

  protocol.addMasterDevice(phone);

  // add selected measures from the sampling packages
  protocol.addTriggeredTask(
      ImmediateTrigger(),
      AutomaticTask()
        // ..addMeasure(Measure(type: SensorSamplingPackage.ACCELEROMETER))
        // ..addMeasure(Measure(type: SensorSamplingPackage.GYROSCOPE))
        ..addMeasure(Measure(type: DeviceSamplingPackage.MEMORY))
        ..addMeasure(Measure(type: DeviceSamplingPackage.BATTERY))
        ..addMeasure(Measure(type: DeviceSamplingPackage.SCREEN))
        ..addMeasure(Measure(type: SensorSamplingPackage.PEDOMETER))
        ..addMeasure(Measure(type: SensorSamplingPackage.LIGHT)),
      phone);

  // deploy this protocol using the on-phone deployment service
  StudyDeploymentStatus status =
      await SmartphoneDeploymentService().createStudyDeployment(protocol);

  // create and configure a client manager for this phone
  SmartPhoneClientManager client = SmartPhoneClientManager();
  await client.configure();

  Study study = Study(
    status.studyDeploymentId,
    status.masterDeviceStatus!.device.roleName,
  );

  // add the study and get the study runtime (controller)
  await client.addStudy(study);
  SmartphoneDeploymentController? controller = client.getStudyRuntime(study);
  // deploy the study on this phone
  await controller?.tryDeployment();

  // configure the controller and start the study
  await controller?.configure();
  controller?.start();

  // listening on the data stream and print them as json to the debug console
  controller?.data.listen((data) => print(toJsonString(data)));

  // subscribe to events
  controller?.data.listen((DataPoint dataPoint) {
    // do something w. the data, e.g. print the json
    print(JsonEncoder.withIndent(' ').convert(dataPoint));
  });

  // listening on events of a specific type
  controller?.dataByType(DeviceSamplingPackage.SCREEN).forEach(print);
}
