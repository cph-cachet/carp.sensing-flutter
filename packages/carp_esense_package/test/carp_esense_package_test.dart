import 'dart:convert';
import 'dart:io';
import 'package:test/test.dart';

import 'package:carp_esense_package/esense.dart';
import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';

String _encode(Object object) =>
    const JsonEncoder.withIndent(' ').convert(object);

void main() {
  CAMSStudyProtocol protocol;
  Smartphone phone;
  ESenseDevice eSense;

  setUp(() {
    // register the context sampling package
    SamplingPackageRegistry().register(ESenseSamplingPackage());

    // Create a new study protocol.
    protocol = CAMSStudyProtocol()
      ..name = 'Context package test'
      ..owner = ProtocolOwner(
        id: 'AB',
        name: 'Alex Boyon',
        email: 'alex@uni.dk',
      );

    // Define which devices are used for data collection.
    phone = Smartphone(roleName: 'SM-A320FL');
    eSense = ESenseDevice(roleName: 'esense');

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

    // add an automatic task that immediately starts collecting eSense button and sensor events
    protocol.addTriggeredTask(
        ImmediateTrigger(),
        AutomaticTask()
          ..addMeasures(ESenseSamplingPackage().debug.getMeasureList(
            types: [
              ESenseSamplingPackage.ESENSE_BUTTON,
              ESenseSamplingPackage.ESENSE_SENSOR,
            ],
          )),
        eSense);
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
    expect(protocol.masterDevices.first.roleName, phone.roleName);
    expect(protocol.connectedDevices.first.roleName, eSense.roleName);
    print(toJsonString(protocol));
  });

  test('Data point -> JSON', () async {
    ESenseButtonDatum datum = ESenseButtonDatum()
      ..pressed = true
      ..deviceName = 'eSense-123';

    final DataPoint data = DataPoint.fromData(datum);
    expect(data.carpHeader.dataFormat.namespace,
        ESenseSamplingPackage.ESENSE_NAMESPACE);

    print(_encode(data.toJson()));
  });
}
