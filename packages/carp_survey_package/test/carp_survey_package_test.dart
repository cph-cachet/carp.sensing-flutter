import 'dart:convert';
import 'dart:io';
import 'package:test/test.dart';

import 'package:carp_survey_package/survey.dart';
import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';

void main() {
  CAMSStudyProtocol protocol;
  Smartphone phone;

  setUp(() {
    // register the context sampling package
    SamplingPackageRegistry().register(SurveySamplingPackage());

    // Create a new study protocol.
    protocol = CAMSStudyProtocol()
      ..name = 'Context package test'
      ..owner = ProtocolOwner(
        id: 'AB',
        name: 'Alex Boyon',
        email: 'alex@uni.dk',
      );

    // Define which devices are used for data collection.
    phone = Smartphone();
    DeviceDescriptor eSense = DeviceDescriptor();

    protocol
      ..addMasterDevice(phone)
      ..addConnectedDevice(eSense);

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
    print(toJsonString(protocol));
    expect(protocol.ownerId, 'AB');
  });

  test('StudyProtocol -> JSON -> StudyProtocol :: deep assert', () async {
    print('#1 : $protocol');
    final studyJson = toJsonString(protocol);

    CAMSStudyProtocol protocolFromJson = CAMSStudyProtocol.fromJson(
        json.decode(studyJson) as Map<String, dynamic>);
    expect(toJsonString(protocolFromJson), equals(studyJson));
    print('#2 : $protocolFromJson');
  });

  test('JSON File -> StudyProtocol', () async {
    // Read the study protocol from json file
    String plainJson = File('test/json/study_protocol.json').readAsStringSync();

    CAMSStudyProtocol protocol = CAMSStudyProtocol.fromJson(
        json.decode(plainJson) as Map<String, dynamic>);

    expect(protocol.ownerId, 'AB');
    expect(protocol.masterDevices.first.roleName, Smartphone.DEFAULT_ROLENAME);
    expect(
        protocol.tasks.first.measures
            .firstWhere((measure) => measure is RPTaskMeasure)
            .type,
        "dk.cachet.carp.survey");
    print(toJsonString(protocol));
  });
  test('', () {});
}
