import 'dart:convert';
import 'dart:io';
import 'package:test/test.dart';

import 'package:carp_audio_package/audio.dart';
import 'package:carp_core/carp_core.dart';
import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';

void main() {
  CAMSStudyProtocol protocol;
  Smartphone phone;

  setUp(() {
    // register the context sampling package
    SamplingPackageRegistry().register(AudioSamplingPackage());

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
    protocol.addMasterDevice(phone);

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

    StudyProtocol protocolFromJson =
        StudyProtocol.fromJson(json.decode(studyJson) as Map<String, dynamic>);
    expect(toJsonString(protocolFromJson), equals(studyJson));
    print('#2 : $protocolFromJson');
  });
  test('JSON File -> StudyProtocol', () async {
    // Read the study protocol from json file
    String plainJson = File('test/json/study_1.json').readAsStringSync();

    CAMSStudyProtocol protocol = CAMSStudyProtocol
        .fromJson(json.decode(plainJson) as Map<String, dynamic>);

    expect(protocol.ownerId, 'AB');
    expect(protocol.masterDevices.first.roleName, Smartphone.DEFAULT_ROLENAME);
    print(toJsonString(protocol));
  });
  test('Audio Data Point', () async {
    AudioDatum datum = AudioDatum(
      filename: "filename.mp3",
      startRecordingTime: DateTime.now().subtract(Duration(days: 1)),
      endRecordingTime: DateTime.now(),
    );

    DataPoint dataPoint = DataPoint.fromData(datum);

    print(dataPoint);
    print(toJsonString(dataPoint));
    assert(dataPoint.carpBody != null);
  });
}
