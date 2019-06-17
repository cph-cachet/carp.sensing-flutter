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

    // adding all measure from the common schema to one one trigger and one task
    study.addTriggerTask(
        ImmediateTrigger(), // a simple trigger that starts immediately
        Task('Sampling Task')
          ..measures =
              SamplingSchema.common(namespace: NameSpace.CARP).measures.values.toList() // a task with all measures
        );
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
    var dp =
        DataPoint.fromDatum(study.id, study.userId, MapDatum({'item_1': '12.23423452345', 'item_2': '3.82375823475'}));
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

  test('Triggers -> JSON', () async {
    Study study_3 = Study("jh-sgadDF#jkdhf", "bardram", name: "Multi Trigger Study");
    study_3.dataEndPoint = FileDataEndPoint()
      ..bufferSize = 50 * 1000
      ..zip = true
      ..encrypt = false;

    study_3.addTriggerTask(
        DelayedTrigger(10 * 1000), // delay for 10 secs.
        Task('Sensing Task #1')
          ..measures =
              SamplingSchema.common().getMeasureList([SensorSamplingPackage.PEDOMETER, DeviceSamplingPackage.SCREEN]));

    study_3.addTriggerTask(
        PeriodicTrigger(60 * 1000), // collect every min.
        Task('Sensing Task #1')
          ..measures =
              SamplingSchema.common().getMeasureList([SensorSamplingPackage.LIGHT, DeviceSamplingPackage.DEVICE]));

    study_3.addTriggerTask(
        ScheduledTrigger(DateTime(2019, 12, 24)), // collect date on Xmas.
        Task('Sensing Task #1')
          ..measures = SamplingSchema.common()
              .getMeasureList([AppsSamplingPackage.APP_USAGE, ConnectivitySamplingPackage.BLUETOOTH]));

    study_3.addTriggerTask(
        RecurrentScheduledTrigger(RecurrentType.daily)
          ..start = DateTime(0, 1, 1, 13, 30), // collect every day at 13:30.
        Task('Sensing Task #1')..measures = SamplingSchema.common().getMeasureList([DeviceSamplingPackage.MEMORY]));

    study_3.addTriggerTask(
        RecurrentScheduledTrigger(RecurrentType.daily)
          ..start = DateTime(0, 1, 1, 13, 30)
          ..separationCount = 1, // collect every other day at 13:30.
        Task('Sensing Task #1')
          ..measures = SamplingSchema.common()
              .getMeasureList([AppsSamplingPackage.APPS, ConnectivitySamplingPackage.CONNECTIVITY]));

    study_3.addTriggerTask(
        RecurrentScheduledTrigger(RecurrentType.monthly)
          ..start = DateTime(0, 1, 1, 13, 30)
          ..weekOfMonth = 2
          ..dayOfWeek = DateTime.monday, // collect every monday in the 2nd week of the month at 13:30.
        Task('Sensing Task #1')
          ..measures = SamplingSchema.common()
              .getMeasureList([AppsSamplingPackage.APPS, ConnectivitySamplingPackage.CONNECTIVITY]));

    study_3.addTriggerTask(
        RecurrentScheduledTrigger(RecurrentType.monthly)
          ..start = DateTime(0, 1, 1, 15, 00)
          ..separationCount = 1
          ..dayOfMonth = 24, // collect every second month at the 24th at 15:00.
        Task('Sensing Task #1')
          ..measures = SamplingSchema.common()
              .getMeasureList([AppsSamplingPackage.APPS, ConnectivitySamplingPackage.CONNECTIVITY]));

    final studyJson = _encode(study_3);

    print(studyJson);

    Study study_4 = Study.fromJson(json.decode(studyJson) as Map<String, dynamic>);
    expect(study_4.id, study_3.id);
  });
}
