import 'package:test/test.dart';
import 'dart:convert';
import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';

String _encode(Object object) => const JsonEncoder.withIndent(' ').convert(object);

void main() {
  Study study;

  setUp(() {
    //SamplingPackageRegistry.register(AudioSamplingPackage());
    //SamplingPackageRegistry.register(CommunicationSamplingPackage());
    //SamplingPackageRegistry.register(ContextSamplingPackage());

    study = Study("1234", "bardram", name: "bardram study");
    study.dataEndPoint = DataEndPoint(DataEndPointTypes.PRINT);

    study.addTriggerTask(
      ImmediateTrigger(),
      Task()
        ..measures = SamplingSchema.common().getMeasureList(
          namespace: NameSpace.CARP,
          types: [
            AppsSamplingPackage.APPS,
            AppsSamplingPackage.APP_USAGE,
            DeviceSamplingPackage.SCREEN,
            DeviceSamplingPackage.BATTERY,
            DeviceSamplingPackage.DEVICE,
            DeviceSamplingPackage.MEMORY,
            ConnectivitySamplingPackage.BLUETOOTH,
            ConnectivitySamplingPackage.WIFI,
            ConnectivitySamplingPackage.CONNECTIVITY,
          ],
        ),
    );

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

    study.addTriggerTask(
        ImmediateTrigger(),
        Task('Sensor Task')
          ..addMeasure(PeriodicMeasure(MeasureType(NameSpace.CARP, SensorSamplingPackage.ACCELEROMETER),
              frequency: 10 * 1000, // sample every 10 secs
              duration: 100 // for 100 ms
              ))
          ..addMeasure(PeriodicMeasure(MeasureType(NameSpace.CARP, SensorSamplingPackage.GYROSCOPE),
              frequency: 20 * 1000, // sample every 20 secs
              duration: 100 // for 100 ms
              )));

//    study.addTask(Task('Audio Recording Task')
//      ..addMeasure(AudioMeasure(MeasureType(NameSpace.CARP, DataType.AUDIO),
//          frequency: 10 * 60 * 1000, // sample sound every 10 min
//          duration: 10 * 1000, // for 10 secs
//          studyId: study.id))
//      ..addMeasure(NoiseMeasure(MeasureType(NameSpace.CARP, DataType.NOISE),
//          frequency: 10 * 60 * 1000, // sample sound every 10 min
//          duration: 10 * 1000, // for 10 secs
//          samplingRate: 500 // configure sampling rate to 500 ms
//          )));

//    study.addTask(SequentialTask('Sample Activity with Weather Task')
//      ..addMeasure(Measure(MeasureType(NameSpace.CARP, DataType.ACTIVITY))..configuration['jakob'] = 'was here')
//      ..addMeasure(PeriodicMeasure(MeasureType(NameSpace.CARP, DataType.WEATHER))));

    study.addTriggerTask(
        ImmediateTrigger(),
        Task('Task collecting a list of all installed apps')
          ..addMeasure(Measure(MeasureType(NameSpace.CARP, AppsSamplingPackage.APPS))));
  });

  String _stringSnapshot;
  void _snapshot() {
    _stringSnapshot = json.encode(study);
  }

  void _restore() {
    study = Study.fromJson(json.decode(_stringSnapshot));
  }

  test('json.encode study', () {
    print(JsonEncoder.withIndent('  ').convert(study));
  });

  /// Test if we can take a snapshot of a Study and restore it using JSON.
  test('Study snapshot / restore', () async {
    print(_encode(study));
    _snapshot();

    _restore();
    print(_encode(study));

    expect(study.id, "1234");
  });

  /// Test template.
  test('...', () {
    // test template
  });
}
