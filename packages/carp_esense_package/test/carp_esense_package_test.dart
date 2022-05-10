import 'dart:convert';
import 'dart:io';
import 'package:test/test.dart';

import 'package:carp_core/carp_core.dart';
import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';
import 'package:carp_esense_package/esense.dart';

String _encode(Object object) =>
    const JsonEncoder.withIndent(' ').convert(object);

void main() {
  late StudyProtocol protocol;
  late Smartphone phone;
  late ESenseDevice eSense;

  setUp(() {
    // register the eSense sampling package
    SamplingPackageRegistry().register(ESenseSamplingPackage());

    // make sure that the json functions are loaded
    DomainJsonFactory();

    // Create a new study protocol.
    protocol = StudyProtocol(
      ownerId: 'alex@uni.dk',
      name: 'Context package test',
    );
    // Define which devices are used for data collection.
    phone = Smartphone(roleName: 'SM-A320FL');
    eSense = ESenseDevice(
      roleName: 'eSense earplug',
      deviceName: 'eSense-0223',
      samplingRate: 10,
    );

    protocol
      ..addMasterDevice(phone)
      ..addConnectedDevice(eSense);

    // adding all available measures to one one trigger and one task
    protocol.addTriggeredTask(
      ImmediateTrigger(),
      BackgroundTask()
        ..measures = SamplingPackageRegistry()
            .dataTypes
            .map((type) => Measure(type: type))
            .toList(),
      phone,
    );

    // Add a background task that immediately starts collecting eSense button and
    // sensor events from the eSense device.
    protocol.addTriggeredTask(
        ImmediateTrigger(),
        BackgroundTask()
          ..addMeasure(Measure(type: ESenseSamplingPackage.ESENSE_BUTTON))
          ..addMeasure(Measure(type: ESenseSamplingPackage.ESENSE_SENSOR)),
        eSense);
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
    expect(protocol.masterDevices.first.roleName, phone.roleName);
    expect(protocol.connectedDevices.first.roleName, eSense.roleName);
    print(toJsonString(protocol));
  });

  test('Data point -> JSON', () async {
    ESenseButtonDatum datum =
        ESenseButtonDatum(pressed: true, deviceName: 'eSense-123');

    final DataPoint data = DataPoint.fromData(datum);
    expect(data.carpHeader.dataFormat.namespace,
        ESenseSamplingPackage.ESENSE_NAMESPACE);

    print(_encode(data.toJson()));
  });
}
