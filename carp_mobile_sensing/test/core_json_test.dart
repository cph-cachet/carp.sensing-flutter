import 'package:test/test.dart';
import 'dart:convert';
import 'dart:io';
import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';

String _encode(Object object) => const JsonEncoder.withIndent(' ').convert(object);

void main() {
  Study study;

  setUp(() {
    //SamplingPackageRegistry.register(AudioSamplingPackage());
    //SamplingPackageRegistry.register(CommunicationSamplingPackage());
    //SamplingPackageRegistry.register(ContextSamplingPackage());

    study = Study("1234", "bardram", name: "bardram study");
    //study.dataEndPoint = DataEndPoint(DataEndPointType.PRINT);
    study.dataEndPoint = FileDataEndPoint()
      ..bufferSize = 50 * 1000
      ..zip = true
      ..encrypt = false;

    // adding all measure from the common schema to one overall 'Sampling' task
    study.addTask(Task('Sampling Task')..measures = SamplingSchema.common().measures.values.toList());
  });

  test('Study -> JSON', () async {
    print(_encode(study));

    expect(study.id, "1234");
  });

  test('JSON -> Study, assert study id', () async {
    final studyJson = _encode(study);

    Study study_2 = Study.fromJson(json.decode(studyJson) as Map<String, dynamic>);
    expect(study_2.id, study.id);

    print(_encode(study_2));
  });

  test('JSON -> Study, deep assert', () async {
    final studyJson = _encode(study);

    Study study_2 = Study.fromJson(json.decode(studyJson) as Map<String, dynamic>);
    expect(_encode(study_2), equals(studyJson));
  });

  test('Configuration -> JSON', () async {
    final studyJson = _encode(study);

    Study study_2 = Study.fromJson(json.decode(studyJson) as Map<String, dynamic>);
    expect(study_2.name, study.name);
  });

  test('Plain JSON string -> Study object', () async {
    print(Directory.current.toString());
    String plainStudyJson = File("test/study_1234.json").readAsStringSync();
    print(plainStudyJson);

    Study plainStudy = Study.fromJson(json.decode(plainStudyJson) as Map<String, dynamic>);
    expect(plainStudy.id, study.id);

    final studyJson = _encode(study);

    Study study_2 = Study.fromJson(json.decode(plainStudyJson) as Map<String, dynamic>);
    expect(_encode(study_2), equals(studyJson));
  });

  test('Data point -> JSON', () async {
    var dp = DataPoint.fromDatum(
        study.id, study.userId, MapDatum(map: {'latitude': '12.23423452345', 'longitude': '3.82375823475'}));
    print(_encode(dp));

    BluetoothDatum datum = BluetoothDatum()
      ..bluetoothDeviceId = "weg"
      ..bluetoothDeviceName = "ksjbdf"
      ..connectable = true
      ..txPowerLevel = 314
      ..rssi = 567
      ..bluetoothDeviceType = "classic";

    final DataPoint data = DataPoint.fromDatum(study.id, study.userId, datum);

    print(_encode(data.toJson()));
  });
}
