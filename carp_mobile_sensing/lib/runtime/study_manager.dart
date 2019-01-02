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
    if (executor == null) executor = StudyExecutor(study);
    // if the data manager hasn't been set, then try to look it up in the [DataManagerRegistry]
    if (manager == null) manager = DataManagerRegistry.lookup(study.dataEndPoint.type);
    // if no transform function is specified, create a 1:1 mapping
    if (transformer == null) transformer = ((events) => events);
    events = transformer(executor.events);
  }

  void initialize() async {
    await Device.getDeviceInfo();
    print('Initializing Study Manager for study: ' + study.name);
    print(' platform     : ' + Device.platform.toString());
    print(' device ID    : ' + Device.deviceID.toString());
    print(' data manager : ' + manager.toString());

    manager.initialize(study, events);
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
  /// Is this sampling schema power-aware, i.e. adapting its sampling strategy to
  /// the battery power status.
  bool powerAware = false;

  SamplingSchema() : super();

  /// A default light sampling schema.
  ///
  /// This theme is intended for sampling on a daily basis with recharging
  /// at least once pr. day. This scheme is not power-aware.
  ///
  /// Settings:
  /// -
  factory SamplingSchema.light() => SamplingSchema();

  factory SamplingSchema.maximum() => SamplingSchema();

  factory SamplingSchema.powerFriendly() => SamplingSchema();
}
