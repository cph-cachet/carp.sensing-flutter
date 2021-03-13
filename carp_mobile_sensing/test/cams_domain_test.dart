import 'dart:convert';
import 'dart:io';

import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';
import 'package:test/test.dart';

String _encode(Object object) =>
    const JsonEncoder.withIndent(' ').convert(object);

void main() {
  CAMSStudyProtocol protocol;

  setUp(() {
    registerFromJsonFunctions();

    // Create a new study protocol.
    protocol = CAMSStudyProtocol()
      ..name = 'Track patient movement'
      ..owner = ProtocolOwner(
        id: 'jakba',
        name: 'Jakob E. Bardram',
        email: 'jakba@dtu.dk',
      );

    // Define which devices are used for data collection.
    Smartphone phone = Smartphone(
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
      phone, // a task with all measures
    );
  });

  test('CAMSStudyProtocol -> JSON', () async {
    print(protocol);
    print(_encode(protocol));
    expect(protocol.ownerId, 'jakba');
  });

  test('StudyProtocol -> JSON -> StudyProtocol :: deep assert', () async {
    print('#1 : $protocol');
    final studyJson = _encode(protocol);

    StudyProtocol protocolFromJson =
        StudyProtocol.fromJson(json.decode(studyJson) as Map<String, dynamic>);
    expect(_encode(protocolFromJson), equals(studyJson));
    print('#2 : $protocolFromJson');
  });

  test('JSON File -> StudyProtocol', () async {
    // Read the study protocol from json file
    String plainJson = File('test/json/study_1.json').readAsStringSync();

    CAMSStudyProtocol protocol = CAMSStudyProtocol.fromJson(
        json.decode(plainJson) as Map<String, dynamic>);

    expect(protocol.ownerId, 'jakba');
    expect(protocol.masterDevices.first.roleName,
        CAMSDeploymentService.DEFAULT_MASTER_DEVICE_ROLENAME);
    print(_encode(protocol));
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
    print(_encode(status_1));
    assert(status_1.studyDeploymentId != null);

    StudyDeploymentStatus status_2 = await CAMSDeploymentService()
        .registerDevice(
            status_1.studyDeploymentId, 'esense', DeviceRegistration());

    print(status_2);
    print(_encode(status_2));
    assert(status_2.studyDeploymentId == status_1.studyDeploymentId);

    CAMSMasterDeviceDeployment deployment = await CAMSDeploymentService()
        .getDeviceDeployment(status_1.studyDeploymentId);
    print(deployment);
    print(_encode(deployment));
    assert(deployment.studyDeploymentId == status_1.studyDeploymentId);

    StudyDeploymentStatus status_3 = await CAMSDeploymentService()
        .deploymentSuccessful(status_1.studyDeploymentId);
    assert(status_3.status == StudyDeploymentStatusTypes.DeploymentReady);
    assert(status_3.studyDeploymentId == status_1.studyDeploymentId);
    print(status_3);
  });
}
