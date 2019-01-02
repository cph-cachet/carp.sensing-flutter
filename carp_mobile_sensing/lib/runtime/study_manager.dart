part of runtime;

/// Signature of a data stream transformer.
typedef DatumStreamTransformer = Stream<Datum> Function(Stream<Datum>);

class StudyManager {
  Study study;
  StudyExecutor executor;
  Stream<Datum> events;
  DataManager manager;
  DatumStreamTransformer transformer;
  bool get isRunning => executor.isRunning;

  StudyManager(this.study, {this.executor, this.manager, this.transformer})
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
  PrivacySchema();

  factory PrivacySchema.none() => PrivacySchema();
  factory PrivacySchema.none() => PrivacySchema();
  factory PrivacySchema.none() => PrivacySchema();
}

class SamplingSchema {}

class DatumTransformer {}
