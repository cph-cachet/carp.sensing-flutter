import 'package:carp_core/carp_core.dart';
import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';
import 'package:carp_health_package/health_package.dart';
import 'package:health/health.dart';

/// This is a very simple example of how this sampling package is used with
/// CARP Mobile Sensing (CAMS).
/// NOTE, however, that the code below will not run.
/// See the documentation on how to use CAMS: https://github.com/cph-cachet/carp.sensing-flutter/wiki
void main() async {
  // register this sampling package before using its measures
  SamplingPackageRegistry().register(HealthSamplingPackage());

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
  Smartphone phone = Smartphone(
    name: 'SM-A320FL',
    roleName: CAMSDeploymentService.DEFAULT_MASTER_DEVICE_ROLENAME,
  );
  protocol.addMasterDevice(phone);

  protocol.addTriggeredTask(
      // collect every hour
      PeriodicTrigger(period: Duration(minutes: 60)),
      AutomaticTask()
        ..measures.add(HealthMeasure(
          type: HealthSamplingPackage.HEALTH,
          healthDataType: HealthDataType.BLOOD_GLUCOSE,
        ))
        ..measures.add(HealthMeasure(
          type: HealthSamplingPackage.HEALTH,
          healthDataType: HealthDataType.BLOOD_PRESSURE_DIASTOLIC,
        ))
        ..measures.add(HealthMeasure(
          type: HealthSamplingPackage.HEALTH,
          healthDataType: HealthDataType.BLOOD_PRESSURE_SYSTOLIC,
        ))
        ..measures.add(HealthMeasure(
          type: HealthSamplingPackage.HEALTH,
          healthDataType: HealthDataType.HEART_RATE,
        ))
        ..measures.add(HealthMeasure(
          type: HealthSamplingPackage.HEALTH,
          name: 'Steps',
          healthDataType: HealthDataType.STEPS,
        )),
      phone);

  protocol.addTriggeredTask(
      // collect every day at 23:00
      RecurrentScheduledTrigger(
          type: RecurrentType.daily, time: Time(hour: 23, minute: 00)),
      AutomaticTask()
        ..measures.add(HealthMeasure(
          type: HealthSamplingPackage.HEALTH,
          healthDataType: HealthDataType.WEIGHT,
        )),
      phone);

  // deploy this protocol using the on-phone deployment service
  StudyDeploymentStatus status =
      await CAMSDeploymentService().createStudyDeployment(protocol);

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
