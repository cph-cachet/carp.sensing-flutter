import 'dart:convert';
import 'dart:io';
import 'package:carp_connectivity_package/connectivity.dart';
import 'package:test/test.dart';

import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';

String _encode(Object object) =>
    const JsonEncoder.withIndent(' ').convert(object);

void main() {
  CAMSStudyProtocol protocol;
  Smartphone phone;

  setUp(() {
    // register the context sampling package
    SamplingPackageRegistry().register(ConnectivitySamplingPackage());

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

    CAMSStudyProtocol protocolFromJson = CAMSStudyProtocol
        .fromJson(json.decode(studyJson) as Map<String, dynamic>);
    expect(toJsonString(protocolFromJson), equals(studyJson));
    print('#2 : $protocolFromJson');
  });

  test('JSON File -> StudyProtocol', () async {
    // Read the study protocol from json file
    String plainJson = File('test/json/study_protocol.json').readAsStringSync();

    CAMSStudyProtocol protocol = CAMSStudyProtocol
        .fromJson(json.decode(plainJson) as Map<String, dynamic>);

    expect(protocol.ownerId, 'AB');
    expect(protocol.masterDevices.first.roleName, Smartphone.DEFAULT_ROLENAME);
    print(toJsonString(protocol));
  });

  test('Data point -> JSON', () async {
    var dp = DataPoint.fromData(
        MapDatum({'item_1': '12.23423452345', 'item_2': '3.82375823475'}));
    print(_encode(dp));

    BluetoothDatum datum = BluetoothDatum()
      ..scanResult.add(BluetoothDevice()
        ..bluetoothDeviceId = "weg"
        ..bluetoothDeviceName = "ksjbdf"
        ..connectable = true
        ..txPowerLevel = 314
        ..rssi = 567
        ..bluetoothDeviceType = "classic");

    final DataPoint data = DataPoint.fromData(datum);

    print(_encode(data.toJson()));
  });
}
