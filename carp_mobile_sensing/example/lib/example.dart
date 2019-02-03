import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';

/// This is the code for the very minimal example used in the README.md file.
void example() {
  // Create a study using a File Backend
  Study study = Study("1234", "bardram", name: "bardram study");
  study.dataEndPoint = FileDataEndPoint()
    ..bufferSize = 500 * 1000
    ..zip = true
    ..encrypt = false;

  // add a task to collect location, activity, and weather information
  study.addTask(SequentialTask('Location, Activity, and Weather Task')
    ..addMeasure(Measure(MeasureType(NameSpace.CARP, DataType.LOCATION)))
    ..addMeasure(Measure(MeasureType(NameSpace.CARP, DataType.ACTIVITY)))
    ..addMeasure(WeatherMeasure(MeasureType(NameSpace.CARP, DataType.WEATHER))
      ..enabled = true
      ..frequency = 2 * 60 * 60 * 1000));

  // add sensor collection from accelerometer and gyroscope
  // careful - these sensors generate a lot of data!
  study.addTask(ParallelTask('Sensor Task')
    ..addMeasure(PeriodicMeasure(MeasureType(NameSpace.CARP, DataType.ACCELEROMETER),
        frequency: 10 * 1000, // sample every 10 secs)
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

  // Create a Study Controller that can manage this study, initialize it, and start it.
  StudyController controller = StudyController(study);

//  StudyManager manager =
//  StudyManager(study, transformer: ((events) => events.where((event) => (event is BatteryDatum))));
//

//  StudyController controller = StudyController(
//    study,
//    transformer: ((events) => events.map((datum) {
//          PrivacySchema.full().protect(datum);
//        })),
//    samplingSchema: SamplingSchema.common(),
//  );

  //manager = StudyManager(study, transformer: ((events) => events.transform(streamTransformer)));
  controller.initialize();
  controller.start();

  // listening on all data events from the study
  controller.events.forEach(print);

  controller.events.where((datum) => datum.format.namepace == NameSpace.CARP);

  // listening on a specific probe
  ProbeRegistry.probes[DataType.LOCATION].events.forEach(print);
}

/// An example of how to use the [SamplingSchema] model.
void samplingSchemaExample() async {
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

  study.addTask(Task('One Common Sensing Task')
    ..measures = SamplingSchema.common().getMeasureList([
      DataType.LOCATION,
      DataType.ACTIVITY,
      DataType.WEATHER,
      DataType.ACCELEROMETER,
      DataType.GYROSCOPE,
      DataType.APPS
    ]));

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

  StudyController controller = StudyController(study, samplingSchema: activitySchema);

//    SamplingSchema.common()
//        .getMeasureList([DataType.LOCATION, DataType.WEATHER, DataType.ACTIVITY], namepace: NameSpace.CARP);

  controller = StudyController(study);
  await controller.initialize();
  await controller.start();
  print("Sensing started ...");

  // listening on all data events from the study
  controller.events.forEach(print);

  // listening on a specific probe
  ProbeRegistry.probes[DataType.LOCATION].events.forEach(print);
}

/// This is an example of how to set up a study in a very simple way using [SamplingSchema.common()].
void example_2() {
  Study study = Study('DF#4dD', 'user@cachet.dk',
      name: 'A outdoor activity study',
      dataEndPoint: FileDataEndPoint()
        ..bufferSize = 500 * 1000
        ..zip = true
        ..encrypt = false)
    ..addTask(Task()..measures = SamplingSchema.common(namespace: NameSpace.CARP).measures.values.toList());

  // adding a set of specific measures from the `common` sampling schema to one no-name task
  study.addTask(Task()
    ..measures = SamplingSchema.common().getMeasureList(
        [DataType.PEDOMETER, DataType.LOCATION, DataType.ACTIVITY, DataType.WEATHER],
        namespace: NameSpace.CARP));

  StudyController controller = StudyController(study,
      samplingSchema: SamplingSchema.common()
        ..addSamplingSchema(PhoneSamplingSchema.phone())
        ..addSamplingSchema(PhoneSamplingSchema.phone()));
}

void scratchPad() {
  Measure mLoc = Measure(MeasureType(NameSpace.CARP, DataType.LOCATION));

  Measure mBT = PeriodicMeasure(MeasureType(NameSpace.CARP, DataType.BLUETOOTH))
    ..enabled = true
    ..frequency = 60 * 60 * 1000
    ..duration = 2 * 1000;
}

class PhoneSamplingSchema extends SamplingSchema {
  factory PhoneSamplingSchema.phone({String namespace}) => SamplingSchema.common(namespace: namespace);
}

void samplingPackageExample() {
  SamplingPackageRegistry.register(SensorSamplingPackage());
}
