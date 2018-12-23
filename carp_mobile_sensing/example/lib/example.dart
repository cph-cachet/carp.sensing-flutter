import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';

/// This is the code for the very minimal example used in the README.md file.
void example() {
  Study study = Study("1234", "bardram", name: "bardram study");
  study.dataEndPoint = FileDataEndPoint()
    ..bufferSize = 50 * 1000
    ..zip = true
    ..encrypt = false;

  study.addTask(Task('Location Task')..addMeasure(Measure(DataType(NameSpace.CARP_NAMESPACE, MeasureType.LOCATION))));

  study.addTask(ParallelTask('Sensor Task')
    ..addMeasure(PeriodicMeasure(DataType(NameSpace.CARP_NAMESPACE, MeasureType.ACCELEROMETER),
        frequency: 10 * 1000, // sample every 10 secs
        duration: 100 // for 100 ms
        ))
    ..addMeasure(PeriodicMeasure(DataType(NameSpace.CARP_NAMESPACE, MeasureType.GYROSCOPE),
        frequency: 20 * 1000, // sample every 20 secs
        duration: 100 // for 100 ms
        )));

  study.addTask(Task('Audio Recording Task')
    ..addMeasure(AudioMeasure(DataType(NameSpace.CARP_NAMESPACE, MeasureType.AUDIO),
        frequency: 10 * 60 * 1000, // sample sound every 10 min
        duration: 10 * 1000, // for 10 secs
        studyId: study.id))
    ..addMeasure(NoiseMeasure(DataType(NameSpace.CARP_NAMESPACE, MeasureType.NOISE),
        frequency: 10 * 60 * 1000, // sample sound every 10 min
        duration: 10 * 1000, // for 10 secs
        samplingRate: 500 // configure sampling rate to 500 ms
        )));

  study.addTask(SequentialTask('Sample Activity with Weather Task')
    ..addMeasure(Measure(DataType(NameSpace.CARP_NAMESPACE, MeasureType.ACTIVITY))..configuration['jakob'] = 'was here')
    ..addMeasure(PeriodicMeasure(DataType(NameSpace.CARP_NAMESPACE, MeasureType.WEATHER))));

  study.addTask(SequentialTask('Task collecting a list of all installed apps')
    ..addMeasure(Measure(DataType(NameSpace.CARP_NAMESPACE, MeasureType.APPS))));

  // Create an executor that can execute this study, initialize it, and start it.
  StudyExecutor executor = new StudyExecutor(study);
  executor.initialize();
  executor.start();
}
