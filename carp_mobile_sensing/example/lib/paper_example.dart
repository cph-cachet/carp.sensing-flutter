import 'dart:convert';

import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';

void sensing() async {
  // create a new CAMS study protocol with an owner
  CAMSStudyProtocol protocol = CAMSStudyProtocol()
    ..name = 'Track patient movement'
    ..owner = ProtocolOwner(
      id: 'jakba',
      name: 'Jakob E. Bardram',
      email: 'jakba@dtu.dk',
    )
    ..dataEndPoint = FileDataEndPoint(
      bufferSize: 500 * 1000,
      zip: true,
      encrypt: false,
    );

  // define which devices are used for data collection
  // in this case, its only this smartphone
  Smartphone phone = Smartphone(
    name: 'SM-A320FL',
    roleName: CAMSDeploymentService.DEFAULT_MASTER_DEVICE_ROLENAME,
  );

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
      await CAMSDeploymentService().createStudyDeployment(protocol);

  // at this time we can register this phone as a master device like this
  CAMSDeploymentService().registerDevice(
    status.studyDeploymentId,
    CAMSDeploymentService.DEFAULT_MASTER_DEVICE_ROLENAME,
    DeviceRegistration(),
  );
  // but this is actually not needed, since a phone is always registrered
  // automatically in the CAMSDeploymentService.
  // But - you should register devices connected to this phone, if applicable

  // now ready to get the device deployment configuration for this phone
  CAMSMasterDeviceDeployment deployment = await CAMSDeploymentService()
      .getDeviceDeployment(status.studyDeploymentId);

  // Create a study deployment controller that can manage this deployment
  StudyDeploymentController controller = StudyDeploymentController(
    deployment,
    debugLevel: DebugLevel.DEBUG,
    privacySchemaName: PrivacySchema.DEFAULT,
  );

  // initialize the controller
  await controller.initialize();

  // resume sampling
  controller.resume();

  // subscribe to events
  controller.events.listen((DataPoint dataPoint) {
    // do something w. the data, e.g. print the json
    print(JsonEncoder.withIndent(' ').convert(dataPoint));
  });

  // listening on events of a specific type
  ProbeRegistry().eventsByType(DeviceSamplingPackage.SCREEN).forEach(print);
}
