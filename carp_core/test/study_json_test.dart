import 'package:carp_core/carp_core.dart';
import 'package:test/test.dart';
import 'dart:convert';
import 'dart:io';

String _encode(Object object) => const JsonEncoder.withIndent(' ').convert(object);

void main() {
  Study study;

  setUp(() {
    study = new Study("1234", "bardram", name: "bardram study");
    study.dataEndPoint = new FileDataEndPoint(DataEndPointType.FILE);

    Task task = new Task("Generic task");
    final Measure m = new Measure(Measure.GENERIC_MEASURE, name: 'Generic measure');
    m.setConfiguration("generic_1", "8000");
    m.setConfiguration("generic_2", "abc");
    task.addMeasure(m);
    study.addTask(task);

    Task _sensorTask = new ParallelTask("Sensor task");
    final ProbeMeasure am = new ProbeMeasure(Measure.PROBE_MEASURE);
    am.name = 'Accelerometer';
    am.setConfiguration("frequency", "8000");
    am.setConfiguration("duration", "500");
    _sensorTask.addMeasure(am);

    ListeningProbeMeasure gm = new ListeningProbeMeasure(Measure.LISTENING_MEASURE);
    gm.name = 'Gyroscope';
    gm.setConfiguration("frequency", "8000");
    _sensorTask.addMeasure(gm);

    study.addTask(_sensorTask);

    Task _pedometerTask = new SequentialTask("Pedometer task");

    PollingProbeMeasure pm = new PollingProbeMeasure(Measure.POLLING_MEASURE);
    pm.name = 'Pedometer';
    pm.frequency = 8 * 1000; // once every 8 second
    _pedometerTask.addMeasure(pm);

    study.addTask(_pedometerTask);

    study.addTask(ParallelTask("Connectivity task"));
  });

  test('Study -> JSON', () async {
    print("Study : " + study.name);
    print(_encode(study));

    expect(study.id, "1234");
  });

  test('JSON -> Study, assert study id', () async {
    final study_json = _encode(study);

    Study study_2 = Study.fromJson(json.decode(study_json) as Map<String, dynamic>);
    expect(study_2.id, study.id);

    print("\nSTUDY_2\n" + _encode(study_2));
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
}
