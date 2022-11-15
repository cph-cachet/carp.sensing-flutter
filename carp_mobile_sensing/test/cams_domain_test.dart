import 'dart:convert';
import 'dart:io';
import 'package:carp_core/carp_core.dart';
import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';
import 'package:carp_serializable/carp_serializable.dart';

import 'package:test/test.dart';

void main() {
  late StudyProtocol masterProtocol;
  late Smartphone masterPhone;
  DeviceConfiguration eSense;

  setUp(() {
    // Initialization of serialization
    CarpMobileSensing();

    // Create a new study protocol.
    masterProtocol = SmartphoneStudyProtocol(
      ownerId: 'user@dtu.dk',
      name: 'patient_tracking',
    );

    // Define which devices are used for data collection.
    masterPhone = Smartphone();
    eSense = DeviceConfiguration(roleName: 'esense');

    masterProtocol
      ..addMasterDevice(masterPhone)
      ..addConnectedDevice(eSense);

    // Define what needs to be measured, on which device, when.
    List<Measure> measures = [
      Measure(type: DataType(NameSpace.CARP, 'light').toString()),
      Measure(type: DataType(NameSpace.CARP, 'gps').toString()),
      Measure(type: DataType(NameSpace.CARP, 'steps').toString()),
    ];

    var task = BackgroundTask(name: 'Start measures')..addMeasures(measures);
    masterProtocol.addTaskControl(
      TriggerConfiguration(),
      task,
      masterPhone,
      Control.Start,
    );

    // adding all measure from the sampling packages to one one trigger and one task
    masterProtocol.addTaskControl(
      ImmediateTrigger(), // a simple trigger that starts immediately
      BackgroundTask()
        ..measures = SamplingPackageRegistry()
            .dataTypes
            .map((type) => Measure(type: type.type))
            .toList(),
      masterPhone, Control.Start,
    );

    // collect device info only once
    masterProtocol.addTaskControl(
      OneTimeTrigger(),
      BackgroundTask()
        ..addMeasure(
            Measure(type: DeviceSamplingPackage.DEVICE_INFORMATION_TYPE_NAME)),
      masterPhone,
      Control.Start,
    );

    var sensingAppTask = AppTask(
      type: BackgroundSensingUserTask.ONE_TIME_SENSING_TYPE,
      title: "Location, Weather & Air Quality",
      description: "Collect location, weather and air quality",
    )..addMeasures([
        Measure(type: SensorSamplingPackage.AMBIENT_LIGHT_TYPE_NAME),
        Measure(type: CarpDataTypes.STEP_COUNT_TYPE_NAME),
      ]);

    masterProtocol.addTaskControl(
      ImmediateTrigger(),
      sensingAppTask,
      masterPhone,
      Control.Start,
    );

    masterProtocol.addTaskControl(
      UserTaskTrigger(
        taskName: sensingAppTask.name,
        resumeCondition: UserTaskState.done,
      ),
      sensingAppTask,
      masterPhone,
      Control.Start,
    );

    // adding two measures to another device
    masterProtocol.addTaskControl(
      ImmediateTrigger(),
      BackgroundTask()
        ..addMeasure(Measure(type: DeviceSamplingPackage.FREE_MEMORY_TYPE_NAME))
        ..addMeasure(
            Measure(type: SensorSamplingPackage.AMBIENT_LIGHT_TYPE_NAME)),
      eSense,
      Control.Start,
    );
  });

  test('DataPoints -> JSON', () async {
    final device = DataPoint.fromData(DeviceInformation('iOS', '1234abcd'));
    print(toJsonString(device));
  });

  test('SmartphoneStudyProtocol -> JSON', () async {
    print(masterProtocol);
    print(toJsonString(masterProtocol));
    expect(masterProtocol.ownerId, 'user@dtu.dk');
    expect(masterProtocol.primaryDevices.length, 1);
    expect(masterProtocol.connectedDevices?.length, 1);
    expect(masterProtocol.triggers.length, 6);
    expect(masterProtocol.triggers.keys.first, '0');
    expect(masterProtocol.tasks.length, 5);
    expect(masterProtocol.taskControls.length, 6);
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
    expect(protocol.primaryDevices.first.roleName,
        SmartphoneDeploymentService().thisPhone.roleName);
    print(toJsonString(protocol));
  });

  test('Triggers -> JSON -> Triggers', () async {
    masterProtocol.addTaskControl(
      DelayedTrigger(delay: Duration(seconds: 10)),
      BackgroundTask()
        ..addMeasure(Measure(type: CarpDataTypes.STEP_COUNT_TYPE_NAME))
        ..addMeasure(
            Measure(type: DeviceSamplingPackage.SCREEN_EVENT_TYPE_NAME)),
      masterPhone,
      Control.Start,
    );

    masterProtocol.addTaskControl(
      PeriodicTrigger(
        period: const Duration(minutes: 1),
        duration: Duration(seconds: 1),
      ), // collect every min.
      BackgroundTask()
        ..addMeasure(
            Measure(type: SensorSamplingPackage.AMBIENT_LIGHT_TYPE_NAME))
        ..addMeasure(
            Measure(type: DeviceSamplingPackage.DEVICE_INFORMATION_TYPE_NAME)),
      masterPhone,
      Control.Start,
    );

    RecurrentScheduledTrigger t1, t2, t3, t4;

    // collect every day at 13:30.
    t1 = RecurrentScheduledTrigger(
      type: RecurrentType.daily,
      time: TimeOfDay(hour: 21, minute: 30),
      duration: Duration(seconds: 1),
    );
    print('$t1');
    masterProtocol.addTaskControl(
      t1,
      BackgroundTask()
        ..addMeasure(
            Measure(type: DeviceSamplingPackage.FREE_MEMORY_TYPE_NAME)),
      masterPhone,
      Control.Start,
    );

    // collect every other day at 13:30.
    t2 = RecurrentScheduledTrigger(
      type: RecurrentType.daily,
      time: TimeOfDay(hour: 13, minute: 30),
      separationCount: 1,
      duration: Duration(seconds: 1),
    );
    print('$t2');
    masterProtocol.addTaskControl(
      t2,
      BackgroundTask()
        ..addMeasure(
            Measure(type: SensorSamplingPackage.AMBIENT_LIGHT_TYPE_NAME))
        ..addMeasure(
            Measure(type: DeviceSamplingPackage.FREE_MEMORY_TYPE_NAME)),
      masterPhone,
      Control.Start,
    );

    // collect every wednesday at 12:23.
    t3 = RecurrentScheduledTrigger(
      type: RecurrentType.weekly,
      time: TimeOfDay(hour: 12, minute: 23),
      dayOfWeek: DateTime.wednesday,
      duration: Duration(seconds: 1),
    );
    print('$t3');
    masterProtocol.addTaskControl(
      t3,
      BackgroundTask()
        ..addMeasure(
            Measure(type: SensorSamplingPackage.AMBIENT_LIGHT_TYPE_NAME))
        ..addMeasure(
            Measure(type: DeviceSamplingPackage.BATTERY_STATE_TYPE_NAME)),
      masterPhone,
      Control.Start,
    );

    // collect every 2nd monday at 12:23.
    t4 = RecurrentScheduledTrigger(
      type: RecurrentType.weekly,
      time: TimeOfDay(hour: 12, minute: 23),
      dayOfWeek: DateTime.monday,
      separationCount: 1,
      duration: Duration(seconds: 1),
    );
    print('$t4');
    masterProtocol.addTaskControl(
      t4,
      BackgroundTask()
        ..addMeasure(
            Measure(type: SensorSamplingPackage.AMBIENT_LIGHT_TYPE_NAME))
        ..addMeasure(
            Measure(type: DeviceSamplingPackage.SCREEN_EVENT_TYPE_NAME)),
      masterPhone,
      Control.Start,
    );

    // when battery level is 10% then sample light
    masterProtocol.addTaskControl(
      SamplingEventTrigger(
          measureType: DeviceSamplingPackage.BATTERY_STATE_TYPE_NAME,
          resumeCondition: BatteryState(10)),
      BackgroundTask()
        ..addMeasure(
            Measure(type: SensorSamplingPackage.AMBIENT_LIGHT_TYPE_NAME)),
      masterPhone,
      Control.Start,
    );

    masterProtocol.addTaskControl(
      ConditionalSamplingEventTrigger(
          measureType: DeviceSamplingPackage.BATTERY_STATE_TYPE_NAME,
          resumeCondition: (measurement) =>
              (measurement.data as BatteryState).batteryLevel == 10),
      BackgroundTask()
        ..addMeasure(
            Measure(type: SensorSamplingPackage.AMBIENT_LIGHT_TYPE_NAME)),
      masterPhone,
      Control.Start,
    );

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

  test('Sampling configurations', () async {
    SmartphoneStudyProtocol protocol = SmartphoneStudyProtocol(
      ownerId: 'user@dtu.dk',
      name: 'sampling_configurations',
    );

    Smartphone phone = Smartphone();

    phone.defaultSamplingConfiguration!
      ..addAll(DeviceSamplingPackage().samplingSchema.configurations)
      ..addAll(SensorSamplingPackage().samplingSchema.configurations);

    protocol.addMasterDevice(phone);

    expect(
        protocol.primaryDevice.defaultSamplingConfiguration?.keys.contains(
            DeviceSamplingPackage().samplingSchema.configurations.keys.first),
        true);
    expect(
        protocol.primaryDevice.defaultSamplingConfiguration?.keys.contains(
            SensorSamplingPackage().samplingSchema.configurations.keys.first),
        true);
    print(toJsonString(protocol));
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
    expect(status_1.deviceStatusList.length, 2);
    expect(status_1.status, StudyDeploymentStatusTypes.Invited);
    expect(status_1.deviceStatusList[0].device.roleName,
        Smartphone.DEFAULT_ROLENAME);
    // the phone as a master device is always registred by the CAMSDeploymentService
    expect(status_1.deviceStatusList[0].status,
        DeviceDeploymentStatusTypes.Registered);
    // but we do not expect the esense device to be registrered (yet)
    expect(status_1.deviceStatusList[1].device.roleName, 'esense');
    expect(status_1.deviceStatusList[1].status,
        DeviceDeploymentStatusTypes.Unregistered);

    StudyDeploymentStatus status_2 = await SmartphoneDeploymentService()
        .registerDevice(
            status_1.studyDeploymentId, 'esense', DeviceRegistration());

    print(status_2);
    print(toJsonString(status_2));
    expect(status_2.studyDeploymentId, status_1.studyDeploymentId);
    expect(status_1.deviceStatusList[1].device.roleName, 'esense');
    // now we expect the esense device to be registred
    expect(status_1.deviceStatusList[1].status,
        DeviceDeploymentStatusTypes.Registered);

    SmartphoneDeployment deployment = await SmartphoneDeploymentService()
        .getDeviceDeployment(status_1.studyDeploymentId);
    print(deployment);
    print(toJsonString(deployment));
    expect(deployment.studyDeploymentId, status_1.studyDeploymentId);
    expect(deployment.tasks.length, masterProtocol.tasks.length);
    expect(deployment.triggers.length, masterProtocol.triggers.length);
    expect(deployment.taskControls.length, masterProtocol.taskControls.length);

    StudyDeploymentStatus status_3 = await SmartphoneDeploymentService()
        .deploymentSuccessful(status_1.studyDeploymentId);
    expect(status_3.status, StudyDeploymentStatusTypes.DeploymentReady);
    expect(status_3.studyDeploymentId, status_1.studyDeploymentId);
    print(status_3);
    print(toJsonString(status_3));
    expect(
      status_3.deviceStatusList[0].status,
      DeviceDeploymentStatusTypes.Deployed,
    );
    expect(
      status_3.deviceStatusList[1].status,
      DeviceDeploymentStatusTypes.Deployed,
    );
  });
}
