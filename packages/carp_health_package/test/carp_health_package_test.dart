import 'dart:convert';
import 'dart:io';

import 'package:carp_core/carp_core.dart';
import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';
import 'package:carp_health_package/health_package.dart';
import 'package:health/health.dart';
import 'package:test/test.dart';

String _encode(Object object) =>
    const JsonEncoder.withIndent(' ').convert(object);

void main() {
  late StudyProtocol protocol;
  Smartphone phone;

  setUp(() {
    // make sure that the json functions are loaded
    DomainJsonFactory();
    // register the context sampling package
    SamplingPackageRegistry().register(HealthSamplingPackage());

    // Create a new study protocol.
    protocol = StudyProtocol(
      ownerId: 'alex@uni.dk',
      name: 'Context package test',
    );

    // Define which devices are used for data collection.
    phone = Smartphone();

    protocol..addMasterDevice(phone);

    // adding all measure from the common schema to one one trigger and one task
    protocol.addTriggeredTask(
      ImmediateTrigger(), // a simple trigger that starts immediately
      AutomaticTask()
        ..measures =
            SamplingPackageRegistry().common().measures.values.toList(),
      phone, // a task with all measures
    );

    protocol.addTriggeredTask(
        // collect every hour
        PeriodicTrigger(period: Duration(minutes: 60)),
        AutomaticTask()
          ..measures.add(HealthMeasure(
            type: HealthSamplingPackage.HEALTH,
            healthDataType: HealthDataType.BLOOD_GLUCOSE,
          ))
          ..measures.add(HealthMeasure(
            type: HealthSamplingPackage.HEALTH,
            healthDataType: HealthDataType.BLOOD_PRESSURE_DIASTOLIC,
          ))
          ..measures.add(HealthMeasure(
            type: HealthSamplingPackage.HEALTH,
            healthDataType: HealthDataType.BLOOD_PRESSURE_SYSTOLIC,
          ))
          ..measures.add(HealthMeasure(
            type: HealthSamplingPackage.HEALTH,
            healthDataType: HealthDataType.HEART_RATE,
          ))
          ..measures.add(HealthMeasure(
            type: HealthSamplingPackage.HEALTH,
            healthDataType: HealthDataType.STEPS,
            name: 'Step Counts',
            description:
                "Collects the step counts from Apple Health / Google Fit",
          )),
        phone);

    protocol.addTriggeredTask(
        // collect every day at 23:00
        RecurrentScheduledTrigger(
            type: RecurrentType.daily, time: Time(hour: 23, minute: 00)),
        AutomaticTask()
          ..measures.add(HealthMeasure(
            type: HealthSamplingPackage.HEALTH,
            healthDataType: HealthDataType.WEIGHT,
          )),
        phone);
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

  test(' - measure -> json', () async {
    HealthMeasure mh = HealthMeasure(
      type: HealthSamplingPackage.HEALTH,
      healthDataType: HealthDataType.STEPS,
    );
    print(mh.toJson());
    print(_encode(mh));
  });

  group("DASES Data Types", () {
    test(' - CALORIES_INTAKE', () {
      DateTime to = DateTime.now();
      DateTime from = to.subtract(Duration(milliseconds: 10000));
      double value = 500;
      String unit = enumToString(
          dasesDataTypeToUnit[DasesHealthDataType.CALORIES_INTAKE]);
      String type = enumToString(DasesHealthDataType.CALORIES_INTAKE);
      String platform = enumToString(PlatformType.ANDROID);
      String deviceId = '1234';
      String uuid = "4321";

      HealthDatum hd =
          HealthDatum(value, unit, type, from, to, platform, deviceId, uuid);

      DataPoint dp_1 = DataPoint.fromData(hd);
      expect(dp_1.carpHeader.dataFormat.namespace,
          HealthSamplingPackage.HEALTH_NAMESPACE);
      expect(dp_1.carpHeader.dataFormat.name, "calories_intake");
      print(_encode(dp_1));
    });

    test(' - ALCOHOL', () {
      DateTime to = DateTime.now();
      DateTime from = to.subtract(Duration(milliseconds: 10000));
      HealthDatum hd = HealthDatum(
          6,
          enumToString(dasesDataTypeToUnit[DasesHealthDataType.ALCOHOL]),
          enumToString(DasesHealthDataType.ALCOHOL),
          from,
          to,
          enumToString(PlatformType.IOS),
          '1234',
          '4321');

      DataPoint dp_1 = DataPoint.fromData(hd);
      expect(dp_1.carpHeader.dataFormat.namespace,
          HealthSamplingPackage.HEALTH_NAMESPACE);
      expect(dp_1.carpHeader.dataFormat.name, "alcohol");
      print(_encode(dp_1));
    });

    test(' - SLEEP', () {
      DateTime to = DateTime.now();
      DateTime from = to.subtract(Duration(hours: 8));
      HealthDatum hd = HealthDatum(
          6,
          enumToString(dasesDataTypeToUnit[DasesHealthDataType.SLEEP]),
          enumToString(DasesHealthDataType.SLEEP),
          from,
          to,
          enumToString(PlatformType.IOS),
          '1234',
          '4321');

      DataPoint dp_1 = DataPoint.fromData(hd);
      expect(dp_1.carpHeader.dataFormat.namespace,
          HealthSamplingPackage.HEALTH_NAMESPACE);
      expect(dp_1.carpHeader.dataFormat.name, "sleep");
      print(_encode(dp_1));
    });

    test(' - SMOKING', () {
      DateTime to = DateTime.now();
      DateTime from = to.subtract(Duration(hours: 8));

      HealthDatum smoking = HealthDatum(
          12,
          enumToString(
              dasesDataTypeToUnit[DasesHealthDataType.SMOKED_CIGARETTES]),
          enumToString(DasesHealthDataType.SMOKED_CIGARETTES),
          from,
          to,
          (Platform.isAndroid)
              ? enumToString(PlatformType.ANDROID)
              : enumToString(PlatformType.IOS),
          '1234',
          '4321');

      DataPoint dp_1 = DataPoint.fromData(smoking);
      expect(dp_1.carpHeader.dataFormat.namespace,
          HealthSamplingPackage.HEALTH_NAMESPACE);
      expect(dp_1.carpHeader.dataFormat.name, "smoked_cigarettes");
      print(_encode(dp_1));
    });
  });
}
