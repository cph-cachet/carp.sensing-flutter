import 'dart:convert';
import 'dart:io';
import 'package:carp_core/carp_core.dart';
import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';

import 'package:test/test.dart';

void main() {
  late StudyProtocol masterProtocol;
  late Smartphone masterPhone;
  DeviceDescriptor eSense;

  setUp(() {
    // Create a new study protocol.
    masterProtocol = SmartphoneStudyProtocol(
      ownerId: 'user@dtu.dk',
      name: 'patient_tracking',
    );

    // Define which devices are used for data collection.
    masterPhone = Smartphone();
    eSense = DeviceDescriptor(roleName: 'esense');

    masterProtocol
      ..addMasterDevice(masterPhone)
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

    ConcurrentTask task = ConcurrentTask(name: 'Start measures')
      ..addMeasures(measures);
    masterProtocol.addTriggeredTask(Trigger(), task, masterPhone);

    // adding all measure from the common schema to one one trigger and one task
    masterProtocol.addTriggeredTask(
      ImmediateTrigger(), // a simple trigger that starts immediately
      AutomaticTask()
        ..measures =
            SamplingPackageRegistry().common().measures.values.toList(),
      masterPhone, // a task with all measures
    );

    // collect device info only once
    masterProtocol.addTriggeredTask(
        OneTimeTrigger('device'),
        AutomaticTask()
          ..measures = SamplingPackageRegistry().debug().getMeasureList(
            types: [
              DeviceSamplingPackage.DEVICE,
            ],
          ),
        masterPhone);

    // adding two measures to another device
    masterProtocol.addTriggeredTask(
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

  test('SmartphoneStudyProtocol -> JSON', () async {
    print(masterProtocol);
    print(toJsonString(masterProtocol));
    expect(masterProtocol.ownerId, 'user@dtu.dk');
    expect(masterProtocol.masterDevices.length, 1);
    expect(masterProtocol.connectedDevices.length, 1);
    expect(masterProtocol.triggers.length, 4);
    expect(masterProtocol.triggers.keys.first, '0');
    expect(masterProtocol.tasks.length, 4);
    expect(masterProtocol.triggeredTasks.length, 4);
  });

  test(
      'SmartphoneStudyProtocol -> JSON -> SmartphoneStudyProtocol :: deep assert',
      () async {
    print('#1 : $masterProtocol');
    final studyJson = toJsonString(masterProtocol);

    SmartphoneStudyProtocol protocolFromJson = SmartphoneStudyProtocol.fromJson(
        json.decode(studyJson) as Map<String, dynamic>);
    expect(toJsonString(protocolFromJson), equals(studyJson));
    print('#2 : $protocolFromJson');
  });

  test('JSON File -> SmartphoneStudyProtocol', () async {
    // Read the study protocol from json file
    String plainJson = File('test/json/study_protocol.json').readAsStringSync();

    SmartphoneStudyProtocol protocol = SmartphoneStudyProtocol.fromJson(
        json.decode(plainJson) as Map<String, dynamic>);

    expect(protocol.ownerId, masterProtocol.ownerId);
    expect(protocol.masterDevices.first.roleName,
        SmartphoneDeploymentService().thisPhone.roleName);
    print(toJsonString(protocol));
  });

  test('Triggers -> JSON -> Triggers', () async {
    masterProtocol.addTriggeredTask(
        DelayedTrigger(delay: Duration(seconds: 10)),
        AutomaticTask()
          ..measures = SamplingPackageRegistry().common().getMeasureList(
              types: [
                SensorSamplingPackage.PEDOMETER,
                DeviceSamplingPackage.SCREEN
              ]),
        masterPhone);

    masterProtocol.addTriggeredTask(
        PeriodicTrigger(
          period: const Duration(minutes: 1),
          duration: Duration(seconds: 1),
        ), // collect every min.
        AutomaticTask()
          ..measures = SamplingPackageRegistry().common().getMeasureList(
              types: [
                SensorSamplingPackage.LIGHT,
                DeviceSamplingPackage.DEVICE
              ]),
        masterPhone);

    RecurrentScheduledTrigger t1, t2, t3, t4;

    // collect every day at 13:30.
    t1 = RecurrentScheduledTrigger(
      type: RecurrentType.daily,
      time: Time(hour: 21, minute: 30),
      duration: Duration(seconds: 1),
    );
    print('$t1');
    masterProtocol.addTriggeredTask(
        t1,
        AutomaticTask()
          ..measures = SamplingPackageRegistry()
              .common()
              .getMeasureList(types: [DeviceSamplingPackage.MEMORY]),
        masterPhone);

    // collect every other day at 13:30.
    t2 = RecurrentScheduledTrigger(
      type: RecurrentType.daily,
      time: Time(hour: 13, minute: 30),
      separationCount: 1,
      duration: Duration(seconds: 1),
    );
    print('$t2');
    masterProtocol.addTriggeredTask(
        t2,
        AutomaticTask()
          ..measures = SamplingPackageRegistry().common().getMeasureList(
              types: [
                SensorSamplingPackage.LIGHT,
                DeviceSamplingPackage.MEMORY
              ]),
        masterPhone);

    // collect every wednesday at 12:23.
    t3 = RecurrentScheduledTrigger(
      type: RecurrentType.weekly,
      time: Time(hour: 12, minute: 23),
      dayOfWeek: DateTime.wednesday,
      duration: Duration(seconds: 1),
    );
    print('$t3');
    masterProtocol.addTriggeredTask(
        t3,
        AutomaticTask()
          ..measures = SamplingPackageRegistry().common().getMeasureList(
              types: [
                SensorSamplingPackage.LIGHT,
                DeviceSamplingPackage.BATTERY
              ]),
        masterPhone);

    // collect every 2nd monday at 12:23.
    t4 = RecurrentScheduledTrigger(
      type: RecurrentType.weekly,
      time: Time(hour: 12, minute: 23),
      dayOfWeek: DateTime.monday,
      separationCount: 1,
      duration: Duration(seconds: 1),
    );
    print('$t4');
    masterProtocol.addTriggeredTask(
        t4,
        AutomaticTask()
          ..measures = DeviceSamplingPackage().common.getMeasureList(types: [
            DeviceSamplingPackage.SCREEN,
            DeviceSamplingPackage.MEMORY
          ]),
        masterPhone);

    ConditionalEvent({
      'name': 'DTU',
      'type': 'ENTER',
    });

    // when battery level is 10% then sample light
    masterProtocol.addTriggeredTask(
        SamplingEventTrigger(
            measureType: DeviceSamplingPackage.BATTERY,
            resumeCondition: ConditionalEvent({'batteryLevel': 10})),
        AutomaticTask()
          ..measures = SensorSamplingPackage()
              .common
              .getMeasureList(types: [SensorSamplingPackage.LIGHT]),
        masterPhone);

    masterProtocol.addTriggeredTask(
        ConditionalSamplingEventTrigger(
            measureType: DeviceSamplingPackage.BATTERY,
            resumeCondition: (dataPoint) =>
                (dataPoint.carpBody as BatteryDatum).batteryLevel == 10),
        AutomaticTask()
          ..measures = SensorSamplingPackage()
              .common
              .getMeasureList(types: [SensorSamplingPackage.LIGHT]),
        masterPhone);

    final studyJson = toJsonString(masterProtocol);

    print(studyJson);

    SmartphoneStudyProtocol protocol_2 = SmartphoneStudyProtocol.fromJson(
        json.decode(studyJson) as Map<String, dynamic>);
    expect(protocol_2.ownerId, masterProtocol.ownerId);

    print('#1 : $masterProtocol');

    SmartphoneStudyProtocol protocolFromJson = SmartphoneStudyProtocol.fromJson(
        json.decode(studyJson) as Map<String, dynamic>);
    expect(toJsonString(protocolFromJson), equals(studyJson));
    print('#2 : $protocolFromJson');
  });

  test('Register Device', () async {
    StudyDeploymentStatus status_1 = await (SmartphoneDeploymentService()
        .createStudyDeployment(masterProtocol));
    print(status_1);
    assert(status_1.status == StudyDeploymentStatusTypes.Invited);

    StudyDeploymentStatus status_2 = await (SmartphoneDeploymentService()
        .registerDevice(
            status_1.studyDeploymentId, 'esense', DeviceRegistration()));
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
    StudyDeploymentStatus status_1 = await SmartphoneDeploymentService()
        .createStudyDeployment(masterProtocol);

    print(status_1);
    print(toJsonString(status_1));
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

    SmartphoneDeployment deployment = await SmartphoneDeploymentService()
        .getDeviceDeployment(status_1.studyDeploymentId);
    print(deployment);
    print(toJsonString(deployment));
    expect(deployment.studyDeploymentId, status_1.studyDeploymentId);
    expect(deployment.tasks.length, masterProtocol.tasks.length);
    expect(deployment.triggers.length, masterProtocol.triggers.length);
    expect(
        deployment.triggeredTasks.length, masterProtocol.triggeredTasks.length);

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
