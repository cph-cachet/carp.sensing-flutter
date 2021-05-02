import 'dart:convert';
import 'dart:io';
import 'package:test/test.dart';
import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';
import 'package:carp_mobile_sensing/runtime/runtime.dart';

void main() {
  CAMSStudyProtocol protocol;

  setUp(() {
    protocol = CAMSStudyProtocol(
        owner: ProtocolOwner(id: 'xyz@dtu.dk'), name: 'Track patient movement');

    // Define which devices are used for data collection.
    Smartphone phone = Smartphone(roleName: 'masterphone');
    DeviceDescriptor eSense = DeviceDescriptor(
      roleName: 'eSense',
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
  });

  test('JSON File -> StudyProtocol', () async {
    // Read the study protocol from json file
    String plainJson = File('test/json/study_protocol.json').readAsStringSync();

    CAMSStudyProtocol protocol = CAMSStudyProtocol.fromJson(
        json.decode(plainJson) as Map<String, dynamic>);

    expect(protocol.ownerId, 'AB');
    expect(protocol.masterDevices.first.roleName,
        SmartphoneDeploymentService().thisPhone.roleName);
    print(toJsonString(protocol));
  });

  test('Deploy protocol -> CAMSDeploymentService()', () async {
    // Read the study protocol from json file
    String plainJson = File('test/json/study_protocol.json').readAsStringSync();

    CAMSStudyProtocol protocol = CAMSStudyProtocol.fromJson(
        json.decode(plainJson) as Map<String, dynamic>);

    expect(protocol.ownerId, 'AB');
    expect(protocol.masterDevices.first.roleName,
        SmartphoneDeploymentService().thisPhone.roleName);

    StudyDeploymentStatus status =
        await SmartphoneDeploymentService().createStudyDeployment(protocol);
    print(toJsonString(status));
  });

  test('Get deployment <- CAMSDeploymentService()', () async {
    // Read the study protocol from json file
    String plainJson = File('test/json/study_protocol.json').readAsStringSync();

    CAMSStudyProtocol protocol = CAMSStudyProtocol.fromJson(
        json.decode(plainJson) as Map<String, dynamic>);

    StudyDeploymentStatus status =
        await SmartphoneDeploymentService().createStudyDeployment(protocol);
    CAMSMasterDeviceDeployment deployment = await SmartphoneDeploymentService()
        .getDeviceDeployment(status.studyDeploymentId);

    expect(status.studyDeploymentId, deployment.studyDeploymentId);
    print(toJsonString(deployment));
  });
}
