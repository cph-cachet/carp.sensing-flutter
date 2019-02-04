import 'package:test/test.dart';
import 'dart:convert';
import 'dart:io';
import 'package:carp_communication_package/communication.dart' as communication;
import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';

String _encode(Object object) => const JsonEncoder.withIndent(' ').convert(object);
communication.CommunicationSamplingPackage CommunicationSamplingPackage = communication.CommunicationSamplingPackage();

void main() {
  Study study;

  setUp(() {
    SamplingPackageRegistry.register(CommunicationSamplingPackage);

    study = Study("1234", "bardram", name: "bardram study");
    study.dataEndPoint = DataEndPoint(DataEndPointType.PRINT);

    // adding all measure from the communication package common schema to one overall 'communication' task
    study.addTask(Task('Communication Task')..measures = CommunicationSamplingPackage.common.measures.values.toList());
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

  test('', () {});
}
