import 'dart:convert';
import 'dart:io';

import 'package:carp_movisens_package/movisens.dart';
import 'package:test/test.dart';

import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';

String _encode(Object object) =>
    const JsonEncoder.withIndent(' ').convert(object);

void main() {
  CAMSStudyProtocol protocol;
  Smartphone phone;

  setUp(() {
    // register the context sampling package
    SamplingPackageRegistry().register(MovisensSamplingPackage());

    // Create a new study protocol.
    protocol = CAMSStudyProtocol()
      ..name = 'Context package test'
      ..owner = ProtocolOwner(
        id: 'jakba',
        name: 'Jakob E. Bardram',
        email: 'jakba@dtu.dk',
      );

    // Define which devices are used for data collection.
    phone = Smartphone();
    MovisensDevice movisens = MovisensDevice();

    protocol
      ..addMasterDevice(phone)
      ..addConnectedDevice(movisens);

    // adding all measure from the common schema to one one trigger and one task
    protocol.addTriggeredTask(
      ImmediateTrigger(), // a simple trigger that starts immediately
      AutomaticTask()
        ..measures =
            SamplingPackageRegistry().common().measures.values.toList(),
      phone, // a task with all measures
    );

    // add an automatic task that immediately starts collecting Movisens events
    protocol.addTriggeredTask(
        ImmediateTrigger(),
        AutomaticTask()
          ..addMeasures(MovisensSamplingPackage().debug.getMeasureList(
            types: [
              MovisensSamplingPackage.MOVISENS,
            ],
          )),
        movisens);
  });

  test('CAMSStudyProtocol -> JSON', () async {
    print(protocol);
    print(toJsonString(protocol));
    expect(protocol.ownerId, 'jakba');
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

    expect(protocol.ownerId, 'jakba');
    expect(protocol.masterDevices.first.roleName, Smartphone.DEFAULT_ROLENAME);
    expect(protocol.connectedDevices.first.roleName,
        MovisensDevice.DEFAULT_ROLENAME);

    print(toJsonString(protocol));
  });

  test('Movisens HR -> OMH HeartRate', () {
    MovisensHRDatum hr = MovisensHRDatum()..hr = '78';

    DataPoint dp_1 = DataPoint.fromData(hr);
    expect(dp_1.carpHeader.dataFormat.namespace,
        MovisensSamplingPackage.MOVISENS_NAMESPACE);
    print(_encode(dp_1));

    OMHHeartRateDatum omhSteps =
        TransformerSchemaRegistry().lookup(NameSpace.OMH).transform(hr);
    DataPoint dp_2 = DataPoint.fromData(omhSteps);
    expect(dp_2.carpHeader.dataFormat.namespace, NameSpace.OMH);
    expect(omhSteps.hr.heartRate.value, double.tryParse(hr.hr));
    print(_encode(dp_2));
  });

  test('Movisens Step Count -> OMH StepCount', () {
    MovisensStepCountDatum steps = MovisensStepCountDatum()..stepCount = '56';
    steps..movisensTimestamp = DateTime.now().toUtc().toString();

    DataPoint dp_1 = DataPoint.fromData(steps);
    expect(dp_1.carpHeader.dataFormat.namespace,
        MovisensSamplingPackage.MOVISENS_NAMESPACE);
    print(_encode(dp_1));

    OMHStepCountDatum omhSteps =
        TransformerSchemaRegistry().lookup(NameSpace.OMH).transform(steps);
    DataPoint dp_2 = DataPoint.fromData(omhSteps);
    expect(dp_2.carpHeader.dataFormat.namespace, NameSpace.OMH);
    expect(omhSteps.stepCount.stepCount, int.tryParse(steps.stepCount));
    print(_encode(dp_2));
  });
}
