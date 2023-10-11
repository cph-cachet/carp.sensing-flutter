import 'dart:convert';
import 'dart:io';
import 'package:carp_connectivity_package/connectivity.dart';
import 'package:test/test.dart';

import 'package:carp_serializable/carp_serializable.dart';
import 'package:carp_core/carp_core.dart';
import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';

void main() {
  late StudyProtocol protocol;
  Smartphone phone;

  setUp(() {
    // Initialization of serialization
    CarpMobileSensing();

    // register the context sampling package
    SamplingPackageRegistry().register(ConnectivitySamplingPackage());

    // Create a new study protocol.
    protocol = StudyProtocol(
      ownerId: 'alex@uni.dk',
      name: 'Connectivity package test',
    );

    // Define which devices are used for data collection.
    phone = Smartphone();

    protocol.addPrimaryDevice(phone);

    // adding all available measures to one one trigger and one task
    protocol.addTaskControl(
      ImmediateTrigger(),
      BackgroundTask()
        ..measures = SamplingPackageRegistry()
            .dataTypes
            .map((type) => Measure(type: type.type))
            .toList(),
      phone,
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
    expect(protocol.primaryDevice.roleName, Smartphone.DEFAULT_ROLENAME);
    print(toJsonString(protocol));
  });

  test('Bluetooth  -> JSON', () async {
    Bluetooth data = Bluetooth()
      ..addBluetoothDevice(BluetoothDevice(
        advertisementName: 'myPhone',
        bluetoothDeviceId: "weg",
        bluetoothDeviceName: "ksjbdf",
        connectable: true,
        txPowerLevel: 314,
        rssi: 567,
      ));

    final measurement = Measurement.fromData(data);

    print(toJsonString(measurement));
  });
  test('Connectivity  -> JSON', () async {
    Connectivity data = Connectivity()
      ..connectivityStatus = ConnectivityStatus.bluetooth;

    final measurement = Measurement.fromData(data);

    print(toJsonString(measurement));
  });
  test('Wifi  -> JSON', () async {
    Wifi data = Wifi()
      ..bssid = 'kj'
      ..ip = '127.0.0.1';

    final measurement = Measurement.fromData(data);

    print(toJsonString(measurement));
  });
}
