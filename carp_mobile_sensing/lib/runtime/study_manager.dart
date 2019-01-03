part of runtime;

/// Signature of a data transformer.
typedef DatumTransformer = Datum Function(Datum);

/// Signature of a data stream transformer.
typedef DatumStreamTransformer = Stream<Datum> Function(Stream<Datum>);

class StudyManager {
  Study study;
  StudyExecutor executor;
  DataManager manager;
  DatumStreamTransformer transformer;
  SamplingSchema samplingSchema;

  Stream<Datum> events;
  bool get isRunning => executor.isRunning;

  StudyManager(this.study, {this.executor, this.samplingSchema, this.manager, this.transformer})
      : assert(study != null),
        super() {
    // if no executor is specified, use the default one
    executor ??= StudyExecutor(study);
    // if the data manager hasn't been set, then try to look it up in the [DataManagerRegistry]
    manager ??= DataManagerRegistry.lookup(study.dataEndPoint.type);
    // if no transform function is specified, create a 1:1 mapping
    transformer ??= ((events) => events);
    events = transformer(executor.events);
  }

  void initialize() async {
    await Device.getDeviceInfo();
    print('Initializing Study Manager for study: ' + study.name);
    print(' platform     : ' + Device.platform.toString());
    print(' device ID    : ' + Device.deviceID.toString());
    print(' data manager : ' + manager.toString());

    if (samplingSchema != null) {
      samplingSchema.adapt(study);
      powerAware();
    }

    manager.initialize(study, events);
  }

  void powerAware() {
    //_powerAware = value;
    if (samplingSchema.powerAware) {
      // TODO - start timing to check battery status.
    } else {
      // TODO - stop timing
    }
  }

  void start() {
    executor.start();
  }

  void stop() {
    manager.close();
    executor.stop();
  }

  void pause() {
    executor.pause();
  }

  void resume() {
    executor.resume();
  }
}

class PrivacySchema {
  Map<String, DatumTransformer> transformers = Map();

  PrivacySchema() : super();

  factory PrivacySchema.none() => PrivacySchema();
  factory PrivacySchema.full() => PrivacySchema();

  addProtector(String type, DatumTransformer protector) => transformers[type] = protector;

  /// Returns a privacy protected version of [data].
  ///
  /// If a transformer for this data type exists, the data is transformed.
  /// Otherwise, the same data is returned unchanged.
  Datum protect(Datum data) {
    Function transformer = transformers[data.format.name];
    return (transformer != null) ? transformer(data) : data;
  }
}

class SamplingSchema {
  /// The default [NameSpace] for sampling schemas.
  //static const String DEFAULT_NAMESPACE = NameSpace.CARP;

  //Study study;

  /// A printer-friendly name of this [SamplingSchema].
  String name;

  /// The [NameSpace] to be used for this [SamplingSchema].
  //String namespace;

  /// A map of default [Measure] for this sampling schema.
  ///
  /// These default measures can be manually populated by
  /// adding [Measure]s to this map.
  Map<String, Measure> measures = Map<String, Measure>();

  /// Is this sampling schema power-aware, i.e. adapting its sampling strategy to
  /// the battery power status.
  bool powerAware = false;

  SamplingSchema({this.name, this.powerAware}) : super();

  /// A default light sampling schema.
  ///
  /// This theme is intended for sampling on a daily basis with recharging
  /// at least once pr. day. This scheme is not power-aware.
  ///
  /// Settings:
  ///  - accelerometer
  ///  - gyroscope
  ///  - pedometer
  ///  - light
  ///  - hardware (battery, memory)
  ///  - connectivity
  ///  - location
  ///  - app usage
  ///  - phone usage
  ///  - text messaging
  ///  - screen activity
  ///  - activity recognition
  ///  - environment (weather)
  factory SamplingSchema.light() {
    //namespace ??= DEFAULT_NAMESPACE;
    return SamplingSchema(name: 'Light sampling', powerAware: false)
      ..measures.addEntries([MapEntry('a', Measure(MeasureType(NameSpace.UNKNOWN, 'a')))]);
  }

  factory SamplingSchema.maximum() => SamplingSchema();

  factory SamplingSchema.powerFriendly() => SamplingSchema();

  /// Adapts the [Measure]s in a [Study] to this [SamplingSchema].
  ///
  /// The following parameters are adapted
  ///   * [enabled] - a measure can be enabled / disabled based on this schema
  ///   * [frequency] - the sampling frequency can be adjusted based on this schema
  ///   * [duration] - the sampling duration can be adjusted based on this schema
  void adapt(Study study) {
    //this.study = study;
    study.tasks.forEach((task) {
      task.measures.forEach((measure) {
        if (measures.containsKey(measure.type.name)) {
          Measure default_measure = measures[measure.type.name];
          // adapting to the default measure settings
          measure.enabled = default_measure.enabled;
          if ((measure is PeriodicMeasure) && (default_measure is PeriodicMeasure)) {
            measure.frequency = default_measure.frequency;
            measure.duration = default_measure.duration;
          }
        }
      });
    });
  }
}
