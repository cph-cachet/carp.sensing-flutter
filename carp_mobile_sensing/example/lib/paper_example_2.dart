import 'dart:convert';
import 'package:carp_core/carp_core.dart';
import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';
import 'package:movisens_flutter/movisens_flutter.dart';
import 'package:carp_movisens_package/movisens.dart';
import 'package:carp_health_package/health_package.dart';
import 'package:health/health.dart';

void sensing() async {
  // create a new study protocol
  SmartphoneStudyProtocol protocol = SmartphoneStudyProtocol(
    ownerId: 'user@dtu.dk',
    name: 'Track patient movement',
    dataEndPoint: FileDataEndPoint(
      bufferSize: 50 * 1000,
      dataFormat: NameSpace.OMH,
    ),
  );

  // define which devices are used for data collection
  // in this case, its only a smartphone
  Smartphone phone = Smartphone();
  protocol.addMasterDevice(phone);

  // add the measure to be taken
  protocol.addTriggeredTask(
    ImmediateTrigger(),
    AutomaticTask()
      ..addMeasures([
        Measure(type: DeviceSamplingPackage.SCREEN),
        Measure(type: DeviceSamplingPackage.BATTERY),
        Measure(type: SensorSamplingPackage.ACCELEROMETER),
        Measure(type: SensorSamplingPackage.PEDOMETER),
        PeriodicMeasure(
          type: SensorSamplingPackage.LIGHT,
          frequency: const Duration(minutes: 1),
          duration: const Duration(seconds: 1),
        ),
      ]),
    phone,
  );

  // add a measure for ECG monitoring using the Movisens device
  protocol.addTriggeredTask(
    ImmediateTrigger(),
    AutomaticTask()
      ..addMeasure(MovisensMeasure(
        type: MovisensSamplingPackage.MOVISENS_NAMESPACE,
        name: 'Movisens ECG device',
        address: '88:6B:0F:CD:E7:F2',
        sensorLocation: SensorLocation.chest,
        gender: Gender.male,
        deviceName: 'Sensor 02655',
        height: 175,
        weight: 75,
        age: 25,
      )),
    phone,
  );

  // add measures to collect data from Apple Health / Google Fit
  protocol.addTriggeredTask(
      PeriodicTrigger(
        period: Duration(minutes: 60),
        duration: Duration(minutes: 10),
      ),
      AutomaticTask()
        ..addMeasures([
          HealthMeasure(
              type: HealthSamplingPackage.HEALTH,
              healthDataType: HealthDataType.BLOOD_GLUCOSE),
          HealthMeasure(
              type: HealthSamplingPackage.HEALTH,
              healthDataType: HealthDataType.STEPS)
        ]),
      phone);

  // add selected measures from the sampling packages
  protocol.addTriggeredTask(
      ImmediateTrigger(),
      AutomaticTask()
        ..measures = SamplingPackageRegistry().common().getMeasureList(
          types: [
            SensorSamplingPackage.ACCELEROMETER,
            SensorSamplingPackage.GYROSCOPE,
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
  String deviceRolename = status.masterDeviceStatus!.device.roleName;

  // create and configure a client manager for this phone
  SmartPhoneClientManager client = SmartPhoneClientManager();
  await client.configure();

  // create a controller by deploying a study
  SmartphoneDeploymentController controller =
      await client.addStudy(studyDeploymentId, deviceRolename);

  // configure the controller and resume sampling
  // await controller.configure(
  //   privacySchemaName: PrivacySchema.DEFAULT,
  // );
  await controller.configure();
  controller.resume();

  // listening on the data stream and print them
  controller.data.listen((DataPoint dataPoint) => print(dataPoint));

  // subscribe to events
  controller.data.listen((DataPoint dataPoint) {
    // do something w. the data, e.g. print the json
    print(JsonEncoder.withIndent(' ').convert(dataPoint));
  });

  // listening on events of a specific type
  ProbeRegistry()
      .eventsByType(DeviceSamplingPackage.SCREEN)
      .listen((DataPoint dataPoint) => print(dataPoint));

  // pause sensing
  controller.pause();
}
