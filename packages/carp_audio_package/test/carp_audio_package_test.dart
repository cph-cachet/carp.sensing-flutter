import 'dart:convert';
import 'dart:io';
import 'package:test/test.dart';

import 'package:carp_core/carp_core.dart';
import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';
import 'package:carp_audio_package/audio.dart';

void main() {
  late StudyProtocol protocol;
  Smartphone phone;

  setUp(() {
    // make sure that the json functions are loaded
    DomainJsonFactory();

    // register the context sampling package
    SamplingPackageRegistry().register(AudioVideoSamplingPackage());

    // Create a new study protocol.
    protocol = StudyProtocol(
      ownerId: 'alex@uni.dk',
      name: 'Audio package test',
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
    expect(protocol.ownerId, 'alex@uni.dk');
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
    String plainJson = File('test/json/study_protocol.json').readAsStringSync();

    StudyProtocol protocol =
        StudyProtocol.fromJson(json.decode(plainJson) as Map<String, dynamic>);

    expect(protocol.ownerId, 'alex@uni.dk');
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

  test('Video Data Point', () async {
    VideoDatum datum = VideoDatum(
      filename: "filename.mp3",
      videoType: VideoType.video,
      startRecordingTime: DateTime.now().subtract(Duration(days: 1)),
      endRecordingTime: DateTime.now(),
    );

    DataPoint dataPoint = DataPoint.fromData(datum);

    print(dataPoint);
    print(toJsonString(dataPoint));
    assert(dataPoint.carpBody != null);
  });
}
