import 'package:carp_core/carp_core.dart';
import 'package:test/test.dart';
import 'dart:convert';
import 'dart:io';

String _encode(Object object) => const JsonEncoder.withIndent(' ').convert(object);

void main() {
  Study study;

  setUp(() {
    study = Study("1234", "bardram", name: "bardram study");
    study.dataEndPoint = FileDataEndPoint()
      ..bufferSize = 50 * 1000
      ..zip = true
      ..encrypt = false;

    study.addTask(TaskDescriptor('1st Taks')
      ..addMeasure(Measure(DataFormat('carp', 'location')))
      ..addMeasure(Measure(DataFormat('carp', 'noise'))));

    study.addTask(ParallelTask('2nd Taks')
      ..addMeasure(Measure(DataFormat('carp', 'accelerometer')))
      ..addMeasure(Measure(DataFormat('carp', 'light'))));

    study.addTask(SequentialTask('3rd Taks')
      ..addMeasure(Measure(DataFormat('carp', 'sound')))
      ..addMeasure(Measure(DataFormat('carp', 'weather'))));
  });

  test('Study -> JSON', () async {
    print(_encode(study));

    expect(study.id, "1234");
  });

  test('JSON -> Study, assert study id', () async {
    final study_json = _encode(study);

    Study study_2 = Study.fromJson(json.decode(study_json) as Map<String, dynamic>);
    expect(study_2.id, study.id);

    print(_encode(study_2));
  });

  test('JSON -> Study, deep assert', () async {
    final study_json = _encode(study);

    Study study_2 = Study.fromJson(json.decode(study_json) as Map<String, dynamic>);
    expect(_encode(study_2), equals(study_json));
  });

  test('Configuration -> JSON', () async {
    final study_json = _encode(study);

    Study study_2 = Study.fromJson(json.decode(study_json) as Map<String, dynamic>);
    //expect(study_2.tasks);
  });

  test('Plain JSON string -> Study object', () async {
    print(Directory.current.toString());
    String plain_study_json = File("test/study_1234.json").readAsStringSync();
    print(plain_study_json);

    Study plain_study = Study.fromJson(json.decode(plain_study_json) as Map<String, dynamic>);
    expect(plain_study.id, study.id);

    final study_json = _encode(study);

    Study study_2 = Study.fromJson(json.decode(plain_study_json) as Map<String, dynamic>);
    expect(_encode(study_2), equals(study_json));
  });

  test('Data point -> JSON', () async {
    var dp = CARPDataPoint.fromDatum(
        study.id,
        study.userId,
        MapDatum(Measure(DataFormat('carp', 'location')),
            map: {'latitude': '12.23423452345', 'longitude': '3.82375823475'}));
    print(_encode(dp));
  });
}
