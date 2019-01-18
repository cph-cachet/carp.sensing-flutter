import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';

/// This is the code for the very minimal example used in the README.md file.
void example() {
  Study study = Study("1234", "bardram", name: "bardram study");
  study.dataEndPoint = FileDataEndPoint()
    ..bufferSize = 500 * 1000
    ..zip = true
    ..encrypt = false;

  // Create a task that take a a battery and location measures.
  // Both are listening on events from changes from battery and location
  study.addTask(Task('Location and Battery Task')
    ..addMeasure(Measure(MeasureType(NameSpace.CARP, DataType.BATTERY)))
    ..addMeasure(Measure(MeasureType(NameSpace.CARP, DataType.LOCATION))));

  // Create another task to collect activity and weather information
  study.addTask(SequentialTask('Sample Activity with Weather Task')
    ..addMeasure(Measure(MeasureType(NameSpace.CARP, DataType.ACTIVITY))..configuration['jakob'] = 'was here')
    ..addMeasure(PeriodicMeasure(MeasureType(NameSpace.CARP, DataType.WEATHER))));

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

  study.addTask(SequentialTask('Task collecting a list of all installed apps')
    ..addMeasure(Measure(MeasureType(NameSpace.CARP, DataType.APPS))));

  // Create a Study Manager that can manage this study, initialize it, and start it.
  //StudyManager manager = StudyManager(study);

//  StudyManager manager =
//  StudyManager(study, transformer: ((events) => events.where((event) => (event is BatteryDatum))));
//

  StudyController controller = StudyController(
    study,
    transformer: ((events) => events.map((datum) {
          PrivacySchema.full().protect(datum);
        })),
    samplingSchema: SamplingSchema.common(),
  );

  //manager = StudyManager(study, transformer: ((events) => events.transform(streamTransformer)));
  controller.initialize();
  controller.start();

  // listening on all data events from the study
  controller.events.forEach(print);

  // listening on a specific probe
  ProbeRegistry.probes[DataType.LOCATION].events.forEach(print);
}

void sampling_schema_stuff() {
  SamplingSchema.common().getMeasureList([DataType.LOCATION, DataType.WEATHER, DataType.ACTIVITY]);

  // creating a sampling schema focused on connectivity
  SamplingSchema connectivitySchema = SamplingSchema(name: 'Connectivity Sampling Schema', powerAware: true)
    ..measures.addEntries([
      MapEntry(DataType.CONNECTIVITY, Measure(MeasureType(NameSpace.CARP, DataType.CONNECTIVITY), enabled: true)),
      MapEntry(
          DataType.BLUETOOTH,
          PeriodicMeasure(MeasureType(NameSpace.CARP, DataType.BLUETOOTH),
              enabled: true, frequency: 60 * 60 * 1000, duration: 2 * 1000)),
      MapEntry(DataType.PHONE_LOG,
          PhoneLogMeasure(MeasureType(NameSpace.CARP, DataType.PHONE_LOG), enabled: true, days: 30)),
      MapEntry(
          DataType.TEXT_MESSAGE_LOG, Measure(MeasureType(NameSpace.CARP, DataType.TEXT_MESSAGE_LOG), enabled: true)),
      MapEntry(DataType.TEXT_MESSAGE, Measure(MeasureType(NameSpace.CARP, DataType.TEXT_MESSAGE), enabled: true)),
    ]);

  // creating a sampling schema focused on activity and outdoor context (weather)
  SamplingSchema activitySchema = SamplingSchema(name: 'Connectivity Sampling Schema', powerAware: true)
    ..measures.addEntries([
      MapEntry(DataType.PEDOMETER,
          PeriodicMeasure(MeasureType(NameSpace.CARP, DataType.PEDOMETER), enabled: true, frequency: 60 * 60 * 1000)),
      MapEntry(DataType.SCREEN, Measure(MeasureType(NameSpace.CARP, DataType.SCREEN), enabled: true)),
      MapEntry(DataType.LOCATION, Measure(MeasureType(NameSpace.CARP, DataType.LOCATION), enabled: true)),
      MapEntry(
          DataType.NOISE,
          PeriodicMeasure(MeasureType(NameSpace.CARP, DataType.NOISE),
              enabled: true, frequency: 60 * 1000, duration: 2 * 1000)),
      MapEntry(DataType.ACTIVITY, Measure(MeasureType(NameSpace.CARP, DataType.ACTIVITY), enabled: true)),
      MapEntry(DataType.WEATHER,
          WeatherMeasure(MeasureType(NameSpace.CARP, DataType.WEATHER), enabled: true, frequency: 2 * 60 * 60 * 1000))
    ]);

  //creating a study
  Study study = Study('DF#4dD', 'user@cachet.dk',
      name: 'A outdoor activity study',
      dataEndPoint: FileDataEndPoint()
        ..bufferSize = 500 * 1000
        ..zip = true
        ..encrypt = false);

  // adding a set of specific measures from the `common` sampling schema to one overall task
  study.addTask(Task('Sensing Task #1')
    ..measures = SamplingSchema.common()
        .getMeasureList([DataType.PEDOMETER, DataType.LOCATION, DataType.ACTIVITY, DataType.WEATHER]));

  // adding all measure from the activity schema to one overall 'sensing' task
  study.addTask(Task('Sensing Task')..measures = activitySchema.measures.values);

  // adding the measures to two separate tasks, while also adding a new light measure to the 2nd task
  study.addTask(Task('Activity Sensing Task #1')
    ..measures =
        activitySchema.getMeasureList([DataType.PEDOMETER, DataType.LOCATION, DataType.ACTIVITY, DataType.WEATHER]));
  study.addTask(Task('Phone Sensing Task #2')
    ..measures = activitySchema.getMeasureList([DataType.SCREEN, DataType.NOISE])
    ..addMeasure(PeriodicMeasure(MeasureType(NameSpace.CARP, DataType.LIGHT),
        name: "Ambient Light", frequency: 11 * 1000, duration: 700)));

  StudyController manager = StudyController(study, samplingSchema: activitySchema);
}
