import 'dart:convert';
import 'dart:io';

import 'package:carp_core/carp_core.dart';
import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';

import 'package:test/test.dart';

void main() {
  CAMSStudyProtocol protocol;
  Smartphone phone;

  setUp(() {
    // Create a new study protocol.
    protocol = CAMSStudyProtocol()
      ..name = 'Track patient movement'
      ..owner = ProtocolOwner(
        id: 'AB',
        name: 'Alex Boyon',
        email: 'alex@uni.dk',
      );

    // Define which devices are used for data collection.
    phone = Smartphone(
      name: 'SM-A320FL',
      roleName: CAMSDeploymentService.DEFAULT_MASTER_DEVICE_ROLENAME,
    );
    DeviceDescriptor eSense = DeviceDescriptor(
      roleName: 'esense',
    );

    protocol
      ..addMasterDevice(phone)
      ..addConnectedDevice(eSense);

    // Define what needs to be measured, on which device, when.
    List<Measure> measures = [
      Measure(type: DataType(NameSpace.CARP, 'light').toString()),
      DataTypeMeasure(type: DataType(NameSpace.CARP, 'gps').toString()),
      PhoneSensorMeasure(
        type: DataType(NameSpace.CARP, 'steps').toString(),
        duration: 10,
      ),
    ];

    ConcurrentTask task = ConcurrentTask(name: "Start measures")
      ..addMeasures(measures);
    protocol.addTriggeredTask(Trigger(), task, phone);

    // adding all measure from the common schema to one one trigger and one task
    protocol.addTriggeredTask(
      ImmediateTrigger(), // a simple trigger that starts immediately
      AutomaticTask()
        ..measures =
            SamplingPackageRegistry().common().measures.values.toList(),
      eSense, // a task with all measures
    );
  });

  test('CAMSStudyProtocol -> JSON', () async {
    print(protocol);
    print(toJsonString(protocol));
    expect(protocol.ownerId, 'AB');
  });

  test('StudyProtocol -> JSON -> StudyProtocol :: deep assert', () async {
    print('#1 : $protocol');
    final studyJson = toJsonString(protocol);

    StudyProtocol protocolFromJson =
        StudyProtocol.fromJson(json.decode(studyJson) as Map<String, dynamic>);
    expect(toJsonString(protocolFromJson), equals(studyJson));
    print('#2 : $protocolFromJson');
  });

  test('JSON File -> StudyProtocol', () async {
    // Read the study protocol from json file
    String plainJson = File('test/json/study_1.json').readAsStringSync();

    CAMSStudyProtocol protocol = CAMSStudyProtocol.fromJson(
        json.decode(plainJson) as Map<String, dynamic>);

    expect(protocol.ownerId, 'AB');
    expect(protocol.masterDevices.first.roleName,
        CAMSDeploymentService.DEFAULT_MASTER_DEVICE_ROLENAME);
    print(toJsonString(protocol));
  });

  test('Triggers -> JSON -> Triggers', () async {
    protocol.addTriggeredTask(
        DelayedTrigger(delay: Duration(seconds: 10)),
        AutomaticTask()
          ..measures = SamplingPackageRegistry().common().getMeasureList(
              types: [
                SensorSamplingPackage.PEDOMETER,
                DeviceSamplingPackage.SCREEN
              ]),
        phone);

    protocol.addTriggeredTask(
        PeriodicTrigger(
            period: const Duration(minutes: 1)), // collect every min.
        AutomaticTask()
          ..measures = SamplingPackageRegistry().common().getMeasureList(
              types: [
                SensorSamplingPackage.LIGHT,
                DeviceSamplingPackage.DEVICE
              ]),
        phone);

    RecurrentScheduledTrigger t1, t2, t3, t4;

    // collect every day at 13:30.
    t1 = RecurrentScheduledTrigger(
        type: RecurrentType.daily, time: Time(hour: 21, minute: 30));
    print('$t1');
    protocol.addTriggeredTask(
        t1,
        AutomaticTask()
          ..measures = SamplingPackageRegistry()
              .common()
              .getMeasureList(types: [DeviceSamplingPackage.MEMORY]),
        phone);

    // collect every other day at 13:30.
    t2 = RecurrentScheduledTrigger(
        type: RecurrentType.daily,
        time: Time(hour: 13, minute: 30),
        separationCount: 1);
    print('$t2');
    protocol.addTriggeredTask(
        t2,
        AutomaticTask()
          ..measures = SamplingPackageRegistry().common().getMeasureList(
              types: [
                SensorSamplingPackage.LIGHT,
                DeviceSamplingPackage.MEMORY
              ]),
        phone);

    // collect every wednesday at 12:23.
    t3 = RecurrentScheduledTrigger(
        type: RecurrentType.weekly,
        time: Time(hour: 12, minute: 23),
        dayOfWeek: DateTime.wednesday);
    print('$t3');
    protocol.addTriggeredTask(
        t3,
        AutomaticTask()
          ..measures = SamplingPackageRegistry().common().getMeasureList(
              types: [
                SensorSamplingPackage.LIGHT,
                DeviceSamplingPackage.BATTERY
              ]),
        phone);

    // collect every 2nd monday at 12:23.
    t4 = RecurrentScheduledTrigger(
        type: RecurrentType.weekly,
        time: Time(hour: 12, minute: 23),
        dayOfWeek: DateTime.monday,
        separationCount: 1);
    print('$t4');
    protocol.addTriggeredTask(
        t4,
        AutomaticTask()
          ..measures = DeviceSamplingPackage().common.getMeasureList(types: [
            DeviceSamplingPackage.SCREEN,
            DeviceSamplingPackage.MEMORY
          ]),
        phone);

    ConditionalEvent({
      'name': 'DTU',
      'type': 'ENTER',
    });

    // when battery level is 10% then sample light
    protocol.addTriggeredTask(
        SamplingEventTrigger(
            measureType: DeviceSamplingPackage.BATTERY,
            resumeCondition: ConditionalEvent({'batteryLevel': 10})),
        AutomaticTask()
          ..measures = SensorSamplingPackage()
              .common
              .getMeasureList(types: [SensorSamplingPackage.LIGHT]),
        phone);

    protocol.addTriggeredTask(
        ConditionalSamplingEventTrigger(
            measureType: DeviceSamplingPackage.BATTERY,
            resumeCondition: (dataPoint) =>
                (dataPoint.carpBody as BatteryDatum).batteryLevel == 10),
        AutomaticTask()
          ..measures = SensorSamplingPackage()
              .common
              .getMeasureList(types: [SensorSamplingPackage.LIGHT]),
        phone);

    final studyJson = toJsonString(protocol);

    print(studyJson);

    StudyProtocol protocol_2 =
        StudyProtocol.fromJson(json.decode(studyJson) as Map<String, dynamic>);
    expect(protocol_2.owner.id, protocol.ownerId);

    print('#1 : $protocol');

    StudyProtocol protocolFromJson =
        StudyProtocol.fromJson(json.decode(studyJson) as Map<String, dynamic>);
    expect(toJsonString(protocolFromJson), equals(studyJson));
    print('#2 : $protocolFromJson');
  });

  test('Register Device', () async {
    StudyDeploymentStatus status_1 =
        await CAMSDeploymentService().createStudyDeployment(protocol);
    print(status_1);
    assert(status_1.studyDeploymentId != null);
    assert(status_1.status == StudyDeploymentStatusTypes.Invited);

    StudyDeploymentStatus status_2 = await CAMSDeploymentService()
        .registerDevice(
            status_1.studyDeploymentId, 'esense', DeviceRegistration());
    print(status_2);
    assert(status_2.studyDeploymentId == status_1.studyDeploymentId);
    assert(status_2.status == StudyDeploymentStatusTypes.DeployingDevices);
    assert(status_2 == status_1);

    StudyDeploymentStatus status_3 = await CAMSDeploymentService()
        .registerDevice(
            status_1.studyDeploymentId, 'nonsense', DeviceRegistration());
    assert(status_3.status == StudyDeploymentStatusTypes.DeployingDevices);
    assert(status_3.studyDeploymentId == status_1.studyDeploymentId);
    print(status_3);
  });

  test('Study Deployment', () async {
    StudyDeploymentStatus status_1 =
        await CAMSDeploymentService().createStudyDeployment(protocol);

    print(status_1);
    print(toJsonString(status_1));
    assert(status_1.studyDeploymentId != null);

    StudyDeploymentStatus status_2 = await CAMSDeploymentService()
        .registerDevice(
            status_1.studyDeploymentId, 'esense', DeviceRegistration());

    print(status_2);
    print(toJsonString(status_2));
    assert(status_2.studyDeploymentId == status_1.studyDeploymentId);

    CAMSMasterDeviceDeployment deployment = await CAMSDeploymentService()
        .getDeviceDeployment(status_1.studyDeploymentId);
    print(deployment);
    print(toJsonString(deployment));
    assert(deployment.studyDeploymentId == status_1.studyDeploymentId);

    StudyDeploymentStatus status_3 = await CAMSDeploymentService()
        .deploymentSuccessful(status_1.studyDeploymentId);
    assert(status_3.status == StudyDeploymentStatusTypes.DeploymentReady);
    assert(status_3.studyDeploymentId == status_1.studyDeploymentId);
    print(status_3);
  });
}
