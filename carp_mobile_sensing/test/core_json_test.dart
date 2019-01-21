import 'package:test/test.dart';
import 'dart:convert';
import 'dart:io';

import 'package:carp_mobile_sensing/core/core.dart';
import 'package:carp_mobile_sensing/probes/sound/sound.dart';

String _encode(Object object) => const JsonEncoder.withIndent(' ').convert(object);

void main() {
  Study study;

  setUp(() {
    study = Study("1234", "bardram", name: "bardram study");
    study.dataEndPoint = DataEndPoint(DataEndPointType.PRINT);
//    study.dataEndPoint = FileDataEndPoint()
//      ..bufferSize = 50 * 1000
//      ..zip = true
//      ..encrypt = false;

//    study.addTask(Task('1st Taks')
//      ..addMeasure(Measure(DataFormat('carp', 'location')))
//      ..addMeasure(Measure(DataFormat('carp', 'noise'))));
//
//    study.addTask(ParallelTask('2nd Taks')
//      ..addMeasure(Measure(DataFormat('carp', 'accelerometer')))
//      ..addMeasure(Measure(DataFormat('carp', 'light'))));
//
//    study.addTask(SequentialTask('3rd Taks')
//      ..addMeasure(Measure(DataFormat('carp', 'apps'))
//        ..configuration['frequency'] = '2'
//        ..configuration['jakob'] = 'was here')
//      ..addMeasure(PeriodicMeasure(DataFormat('carp', 'weather'))));
//
//    study.addTask(SequentialTask('4rd Taks')
//      ..addMeasure(PeriodicMeasure(DataFormat('carp', 'apps'), frequency: 3, duration: 8))
//      ..addMeasure(Measure(DataFormat('carp', 'weather'))));

    study.addTask(Task('Location Task')..addMeasure(Measure(MeasureType(NameSpace.CARP, DataType.LOCATION))));

    study.addTask(ParallelTask('Sensor Task')
      ..addMeasure(PeriodicMeasure(MeasureType(NameSpace.CARP, DataType.ACCELEROMETER),
          frequency: 10 * 1000, // sample every 10 secs
          duration: 100 // for 100 ms
          ))
      ..addMeasure(PeriodicMeasure(MeasureType(NameSpace.CARP, DataType.GYROSCOPE),
          frequency: 20 * 1000, // sample every 20 secs
          duration: 100 // for 100 ms
          )));

    study.addTask(Task('Audio Recording Task')
      ..addMeasure(AudioMeasure(MeasureType(NameSpace.CARP, DataType.AUDIO),
          frequency: 10 * 60 * 1000, // sample sound every 10 min
          duration: 10 * 1000, // for 10 secs
          studyId: study.id))
      ..addMeasure(NoiseMeasure(MeasureType(NameSpace.CARP, DataType.NOISE),
          frequency: 10 * 60 * 1000, // sample sound every 10 min
          duration: 10 * 1000, // for 10 secs
          samplingRate: 500 // configure sampling rate to 500 ms
          )));

    study.addTask(SequentialTask('Sample Activity with Weather Task')
      ..addMeasure(Measure(MeasureType(NameSpace.CARP, DataType.ACTIVITY))..configuration['jakob'] = 'was here')
      ..addMeasure(PeriodicMeasure(MeasureType(NameSpace.CARP, DataType.WEATHER))));

    study.addTask(SequentialTask('Task collecting a list of all installed apps')
      ..addMeasure(Measure(MeasureType(NameSpace.CARP, DataType.APPS))));
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
        study.id, study.userId, MapDatum(map: {'latitude': '12.23423452345', 'longitude': '3.82375823475'}));
    print(_encode(dp));
  });
}
