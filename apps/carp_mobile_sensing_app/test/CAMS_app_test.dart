import 'dart:convert';
import 'dart:io';
import 'package:test/test.dart';

import 'package:carp_esense_package/esense.dart';
import 'package:carp_core/carp_core.dart';
import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';
import '../lib/main.dart';

String _encode(Object object) =>
    const JsonEncoder.withIndent(' ').convert(object);

void main() {
  CAMSStudyProtocol protocol;
  Smartphone phone;
  ESenseDevice eSense;

  setUp(() async {
    // initialize a file manager, since we're using a file data endpoint
    FileDataManager();
    // register the eSense sampling package
    SamplingPackageRegistry().register(ESenseSamplingPackage());

    // Define which devices are used for data collection.
    phone = Smartphone();
    eSense = ESenseDevice();

    // Create a new study protocol.
    protocol = await LocalStudyProtocolManager().getStudyProtocol('1234');
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
    String plainJson = File('test/json/study_1234.json').readAsStringSync();

    CAMSStudyProtocol protocol = CAMSStudyProtocol.fromJson(
        json.decode(plainJson) as Map<String, dynamic>);

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
