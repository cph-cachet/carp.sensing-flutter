import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:movisens_flutter/movisens_flutter.dart';
import 'package:carp_movisens_package/carp_movisens_package.dart';
import 'package:test/test.dart';

import 'package:carp_serializable/carp_serializable.dart';
import 'package:carp_core/carp_core.dart';
import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';
import 'package:openmhealth_schemas/openmhealth_schemas.dart' as omh;

void main() {
  late StudyProtocol protocol;
  Smartphone phone;

  setUp(() {
    // Initialization of serialization
    CarpMobileSensing();

    // register the context sampling package
    SamplingPackageRegistry().register(MovisensSamplingPackage());

    // create a new study protocol
    protocol = StudyProtocol(
      ownerId: 'alex@uni.dk',
      name: 'Context package test',
    );

    // define the Movisens device used for data collection
    phone = Smartphone();
    MovisensDevice movisens = MovisensDevice(
      address: '88:6B:0F:CD:E7:F2',
      sensorLocation: SensorLocation.chest,
      gender: Gender.male,
      sensorName: 'Sensor 02655',
      height: 175,
      weight: 75,
      age: 25,
    );

    protocol
      ..addMasterDevice(phone)
      ..addConnectedDevice(movisens);

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

    // add a background task that immediately starts collecting Movisens events
    protocol.addTriggeredTask(
        ImmediateTrigger(),
        BackgroundTask()
          ..addMeasure(Measure(type: MovisensSamplingPackage.MOVISENS)),
        movisens);
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
    expect(protocol.connectedDevices.first.roleName,
        MovisensDevice.DEFAULT_ROLENAME);

    print(toJsonString(protocol));
  });

  test('Movisens HR -> OMH HeartRate', () {
    MovisensHRDatum hr = MovisensHRDatum()
      ..hr = '78'
      ..movisensDeviceName = 'unit_test_device_name';

    DataPoint dp_1 = DataPoint.fromData(hr);
    expect(dp_1.carpHeader.dataFormat.namespace,
        MovisensSamplingPackage.MOVISENS_NAMESPACE);
    print(toJsonString(dp_1));

    OMHHeartRateDataPoint omhHR = TransformerSchemaRegistry()
        .lookup(NameSpace.OMH)!
        .transform(hr) as OMHHeartRateDataPoint;
    DataPoint dp_2 = DataPoint.fromData(omhHR);
    print(toJsonString(dp_2));

    expect(dp_2.carpHeader.dataFormat.namespace, NameSpace.OMH);
    expect(omhHR.datapoint.body, isA<omh.HeartRate>());
    var hr_2 = omhHR.datapoint.body as omh.HeartRate;
    expect(hr_2.heartRate.value, double.tryParse(hr.hr!));
  });

  test('Movisens Step Count -> OMH StepCount', () {
    MovisensStepCountDatum steps = MovisensStepCountDatum()
      ..stepCount = '56'
      ..movisensDeviceName = 'unit_test_device_name';

    steps.movisensTimestamp = DateTime.now().toUtc().toString();

    DataPoint dp_1 = DataPoint.fromData(steps);
    expect(dp_1.carpHeader.dataFormat.namespace,
        MovisensSamplingPackage.MOVISENS_NAMESPACE);
    print(toJsonString(dp_1));

    OMHStepCountDataPoint omhSteps = TransformerSchemaRegistry()
        .lookup(NameSpace.OMH)!
        .transform(steps) as OMHStepCountDataPoint;
    DataPoint dp_2 = DataPoint.fromData(omhSteps);
    print(toJsonString(dp_2));

    expect(dp_2.carpHeader.dataFormat.namespace, NameSpace.OMH);
    expect(omhSteps.datapoint.body, isA<omh.StepCount>());
    var steps_2 = omhSteps.datapoint.body as omh.StepCount;
    expect(steps_2.stepCount, int.tryParse(steps.stepCount!));
  });

  test('Movisens HR -> FHIR Heart Rate Observation', () {
    MovisensHRDatum hr = MovisensHRDatum()
      ..hr = '118'
      ..movisensDeviceName = 'unit_test_device_name';

    DataPoint dp_1 = DataPoint.fromData(hr);
    expect(dp_1.carpHeader.dataFormat.namespace,
        MovisensSamplingPackage.MOVISENS_NAMESPACE);
    print(toJsonString(dp_1));

    FHIRHeartRateObservation fhirHR = TransformerSchemaRegistry()
        .lookup(NameSpace.FHIR)!
        .transform(hr) as FHIRHeartRateObservation;
    DataPoint dp_2 = DataPoint.fromData(fhirHR);
    print(toJsonString(dp_2));

    expect(dp_2.carpHeader.dataFormat.namespace, NameSpace.FHIR);
    expect(fhirHR.fhirJson["resourceType"], "Observation");
    expect(fhirHR.fhirJson["valueQuantity"]["value"], double.tryParse(hr.hr!));
  });

  test('Movisens HR -> OMH HR Data Point Example', () {
    var data = MovisensHRDatum()..hr = '118';

    var transformedData =
        TransformerSchemaRegistry().lookup(NameSpace.OMH)!.transform(data);

    Stream<Datum> dataStream = StreamController<Datum>().stream;

    Stream<Datum> transformedDataStream = dataStream.map((data) => data =
        TransformerSchemaRegistry().lookup(NameSpace.OMH)!.transform(data));

    Stream<Datum> transformedPrivateDataStream = dataStream.map((data) => data =
        TransformerSchemaRegistry().lookup(NameSpace.OMH)!.transform(
            TransformerSchemaRegistry()
                .lookup("privacySchemaName")!
                .transform(data)));
  });
}
