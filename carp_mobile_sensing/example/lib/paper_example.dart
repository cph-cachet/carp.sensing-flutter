import 'dart:convert';
import 'package:carp_serializable/carp_serializable.dart';
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
      BackgroundTask()
        // ..addMeasure(Measure(type: SensorSamplingPackage.ACCELEROMETER))
        // ..addMeasure(Measure(type: SensorSamplingPackage.GYROSCOPE))
        ..addMeasure(Measure(type: DeviceSamplingPackage.FREE_MEMORY_TYPE_NAME))
        ..addMeasure(
            Measure(type: DeviceSamplingPackage.BATTERY_STATE_TYPE_NAME))
        ..addMeasure(
            Measure(type: DeviceSamplingPackage.SCREEN_EVENT_TYPE_NAME))
        ..addMeasure(Measure(type: SensorSamplingPackage.PEDOMETER))
        ..addMeasure(
            Measure(type: SensorSamplingPackage.AMBIENT_LIGHT_TYPE_NAME)),
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
  controller
      ?.dataByType(DeviceSamplingPackage.SCREEN_EVENT_TYPE_NAME)
      .forEach(print);
}
