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
        ..measures = SamplingPackageRegistry().debug().getMeasureList(
          types: [
            //SensorSamplingPackage.ACCELEROMETER,
            //SensorSamplingPackage.GYROSCOPE,
            SensorSamplingPackage.PEDOMETER,
            SensorSamplingPackage.LIGHT,
            DeviceSamplingPackage.MEMORY,
            DeviceSamplingPackage.DEVICE,
            DeviceSamplingPackage.BATTERY,
            DeviceSamplingPackage.SCREEN,
          ],
        ),
      phone);

  // deploy this protocol using the on-phone deployment service
  StudyDeploymentStatus status =
      await SmartphoneDeploymentService().createStudyDeployment(protocol);

  String studyDeploymentId = status.studyDeploymentId;
  String deviceRolename = status.masterDeviceStatus.device.roleName;

  // create and configure a client manager for this phone
  SmartPhoneClientManager client = SmartPhoneClientManager();
  client.configure();

  StudyDeploymentController controller =
      await client.addStudy(studyDeploymentId, deviceRolename);

  // configure the controller and resume sampling
  await controller.configure(
    privacySchemaName: PrivacySchema.DEFAULT,
    transformer: ((datum) => datum),
  );
  controller.resume();

  // listening on the data stream and print them as json to the debug console
  controller.data.listen((data) => print(toJsonString(data)));

  // subscribe to events
  controller.data.listen((DataPoint dataPoint) {
    // do something w. the data, e.g. print the json
    print(JsonEncoder.withIndent(' ').convert(dataPoint));
  });

  // listening on events of a specific type
  ProbeRegistry().eventsByType(DeviceSamplingPackage.SCREEN).forEach(print);
}
