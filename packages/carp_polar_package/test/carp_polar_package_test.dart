import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:test/test.dart';

import 'package:carp_serializable/carp_serializable.dart';
import 'package:carp_core/carp_core.dart';
import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';
import 'package:carp_polar_package/carp_polar_package.dart';

String _encode(Object object) =>
    const JsonEncoder.withIndent(' ').convert(object);

void main() {
  late StudyProtocol protocol;
  late Smartphone phone;
  late PolarDevice polar;
  String deviceId = 'G24R';

  setUp(() {
    WidgetsFlutterBinding.ensureInitialized();

    // register the eSense sampling package
    SamplingPackageRegistry().register(PolarSamplingPackage());

    // Initialization of serialization
    CarpMobileSensing();

    // Create a new study protocol.
    protocol = StudyProtocol(
      ownerId: 'alex@uni.dk',
      name: 'Context package test',
    );
    // Define which devices are used for data collection.
    phone = Smartphone(roleName: 'SM-A320FL');
    polar = PolarDevice(
      roleName: 'eSense earplug',
      identifier: deviceId,
      name: 'H10',
      polarDeviceType: PolarDeviceType.H10,
    );

    protocol
      ..addMasterDevice(phone)
      ..addConnectedDevice(polar);

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
        BackgroundTask(measures: [
          Measure(type: PolarSamplingPackage.POLAR_ACCELEROMETER),
          Measure(type: PolarSamplingPackage.POLAR_GYROSCOPE),
          Measure(type: PolarSamplingPackage.POLAR_MAGNETOMETER),
          Measure(type: PolarSamplingPackage.POLAR_ECG),
          Measure(type: PolarSamplingPackage.POLAR_HR),
          Measure(type: PolarSamplingPackage.POLAR_PPG),
          Measure(type: PolarSamplingPackage.POLAR_PPI),
        ]),
        polar);
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
    expect(protocol.connectedDevices.first.roleName, polar.roleName);
    print(toJsonString(protocol));
  });

  test('Data point -> JSON', () async {
    PolarPPISample ppi = PolarPPISample(1, 2, 3, true, true, true);
    PolarPPIDatum datum = PolarPPIDatum(deviceId, null, [ppi]);

    final DataPoint data = DataPoint.fromData(datum);
    expect(
        data.carpHeader.dataFormat.toString(), PolarSamplingPackage.POLAR_PPI);

    print(_encode(data.toJson()));
  });
}
