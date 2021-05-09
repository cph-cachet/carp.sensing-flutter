import 'dart:convert';
import 'dart:io';
import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';

import 'package:test/test.dart';

void main() {
  CAMSStudyProtocol protocol;
  Smartphone phone;
  DeviceDescriptor eSense;

  setUp(() {
    // Create a new study protocol.
    protocol = CAMSStudyProtocol()
      ..name = 'Track patient movement'
      ..owner = ProtocolOwner(
        id: 'AB',
        name: 'Alex Boyon',
        email: 'alex@uni.dk',
      )
      ..protocolDescription = StudyProtocolDescription(
          title: 'Test Study',
          purpose: 'For testing purposes',
          description: 'Testing');

    // Define which devices are used for data collection.
    phone = Smartphone();
    eSense = DeviceDescriptor(roleName: 'esense');

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
      phone, // a task with all measures
    );

    // adding two measures to another device
    protocol.addTriggeredTask(
        ImmediateTrigger(),
        AutomaticTask()
          ..measures = SamplingPackageRegistry().debug().getMeasureList(
            types: [
              SensorSamplingPackage.LIGHT, // 10 s
              DeviceSamplingPackage.MEMORY, // 60 s
            ],
          ),
        eSense);
  });

  test('CAMSStudyProtocol -> JSON', () async {
    print(protocol);
    print(toJsonString(protocol));
    expect(protocol.ownerId, 'AB');
    expect(protocol.owner.id, 'AB');
    expect(protocol.masterDevices.length, 1);
    expect(protocol.connectedDevices.length, 1);
    expect(protocol.triggers.length, 3);
    expect(protocol.triggers.keys.first, "0");
    expect(protocol.tasks.length, 3);
    expect(protocol.triggeredTasks.length, 3);
  });

  test('CAMSStudyProtocol -> JSON -> CAMSStudyProtocol :: deep assert',
      () async {
    print('#1 : $protocol');
    final studyJson = toJsonString(protocol);

    CAMSStudyProtocol protocolFromJson = CAMSStudyProtocol
        .fromJson(json.decode(studyJson) as Map<String, dynamic>);
    expect(toJsonString(protocolFromJson), equals(studyJson));
    print('#2 : $protocolFromJson');
  });

  test('JSON File -> StudyProtocol', () async {
    // Read the study protocol from json file
    String plainJson = File('test/json/study_protocol.json').readAsStringSync();

    CAMSStudyProtocol protocol = CAMSStudyProtocol
        .fromJson(json.decode(plainJson) as Map<String, dynamic>);

    expect(protocol.ownerId, 'AB');
    expect(protocol.masterDevices.first.roleName,
        SmartphoneDeploymentService().thisPhone.roleName);
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

    CAMSStudyProtocol protocol_2 = CAMSStudyProtocol
        .fromJson(json.decode(studyJson) as Map<String, dynamic>);
    expect(protocol_2.ownerId, protocol.ownerId);

    print('#1 : $protocol');

    CAMSStudyProtocol protocolFromJson = CAMSStudyProtocol
        .fromJson(json.decode(studyJson) as Map<String, dynamic>);
    expect(toJsonString(protocolFromJson), equals(studyJson));
    print('#2 : $protocolFromJson');
  });

  test('Register Device', () async {
    StudyDeploymentStatus status_1 =
        await SmartphoneDeploymentService().createStudyDeployment(protocol);
    print(status_1);
    assert(status_1.studyDeploymentId != null);
    assert(status_1.status == StudyDeploymentStatusTypes.Invited);

    StudyDeploymentStatus status_2 = await SmartphoneDeploymentService()
        .registerDevice(
            status_1.studyDeploymentId, 'esense', DeviceRegistration());
    print(status_2);
    assert(status_2.studyDeploymentId == status_1.studyDeploymentId);
    assert(status_2.status == StudyDeploymentStatusTypes.DeployingDevices);
    assert(status_2 == status_1);

    StudyDeploymentStatus status_3 = await SmartphoneDeploymentService()
        .registerDevice(
            status_1.studyDeploymentId, 'nonsense', DeviceRegistration());
    assert(status_3.status == StudyDeploymentStatusTypes.DeployingDevices);
    assert(status_3.studyDeploymentId == status_1.studyDeploymentId);
    print(status_3);
  });

  test('Study Deployment', () async {
    StudyDeploymentStatus status_1 =
        await SmartphoneDeploymentService().createStudyDeployment(protocol);

    print(status_1);
    print(toJsonString(status_1));
    assert(status_1.studyDeploymentId != null);
    // we expect the phone and esense devices
    expect(status_1.devicesStatus.length, 2);
    expect(status_1.status, StudyDeploymentStatusTypes.Invited);
    expect(
        status_1.devicesStatus[0].device.roleName, Smartphone.DEFAULT_ROLENAME);
    // the phone as a master device is always registred by the CAMSDeploymentService
    expect(status_1.devicesStatus[0].status,
        DeviceDeploymentStatusTypes.Registered);
    // but we do not expect the esense device to be registrered (yet)
    expect(status_1.devicesStatus[1].device.roleName, 'esense');
    expect(status_1.devicesStatus[1].status,
        DeviceDeploymentStatusTypes.Unregistered);

    StudyDeploymentStatus status_2 = await SmartphoneDeploymentService()
        .registerDevice(
            status_1.studyDeploymentId, 'esense', DeviceRegistration());

    print(status_2);
    print(toJsonString(status_2));
    expect(status_2.studyDeploymentId, status_1.studyDeploymentId);
    expect(status_1.devicesStatus[1].device.roleName, 'esense');
    // now we expect the esense device to be registred
    expect(status_1.devicesStatus[1].status,
        DeviceDeploymentStatusTypes.Registered);

    CAMSMasterDeviceDeployment deployment = await SmartphoneDeploymentService()
        .getDeviceDeployment(status_1.studyDeploymentId);
    print(deployment);
    print(toJsonString(deployment));
    expect(deployment.studyDeploymentId, status_1.studyDeploymentId);
    expect(deployment.tasks.length, protocol.tasks.length);
    expect(deployment.triggers.length, protocol.triggers.length);
    expect(deployment.triggeredTasks.length, protocol.triggeredTasks.length);

    StudyDeploymentStatus status_3 = await SmartphoneDeploymentService()
        .deploymentSuccessful(status_1.studyDeploymentId);
    expect(status_3.status, StudyDeploymentStatusTypes.DeploymentReady);
    expect(status_3.studyDeploymentId, status_1.studyDeploymentId);
    print(status_3);
    print(toJsonString(status_3));
    expect(
      status_3.devicesStatus[0].status,
      DeviceDeploymentStatusTypes.Deployed,
    );
    expect(
      status_3.devicesStatus[1].status,
      DeviceDeploymentStatusTypes.Deployed,
    );
  });
}
