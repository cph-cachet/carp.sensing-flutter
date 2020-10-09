import 'dart:convert';
import 'dart:io';

import 'package:carp_audio_package/audio.dart';
import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';
import 'package:test/test.dart';

String _encode(Object object) => const JsonEncoder.withIndent(' ').convert(object);

void main() {
  Study study;

  setUp(() {
    SamplingPackageRegistry().register(AudioSamplingPackage());

    study = Study("1234", "bardram", name: "bardram study")
      ..dataEndPoint = DataEndPoint(DataEndPointTypes.PRINT)
      ..addTriggerTask(
          ImmediateTrigger(), AutomaticTask(name: 'Task #1')..measures = SamplingSchema.common(namespace: NameSpace.CARP).measures.values.toList());
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
