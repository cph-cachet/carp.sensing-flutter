part of runtime;

class StudyManager {
  static const int NO_SAMPLING_LEVEL = 10;
  static const int MINIMUM_SAMPLING_LEVEL = 30;
  static const int LIGHT_SAMPLING_LEVEL = 50;

  Study study;
  StudyExecutor executor;
  DataManager manager;
  DatumStreamTransformer transformer;
  SamplingSchema samplingSchema;

  Stream<Datum> events;
  bool get isRunning => executor.isRunning;
  BatteryProbe battery =
      BatteryProbe(Measure(MeasureType(NameSpace.CARP, DataType.BATTERY))..name = "PowerAwarenessProbe");

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
      study.adapt(samplingSchema);
    }

    manager.initialize(study, events);
  }

  Future enablePowerAwareness() async {
    if (samplingSchema.powerAware) {
      battery.events.listen((datum) {
        BatteryDatum state = (datum as BatteryDatum);
        print('PowerAware - ${state}');
        bool adapted = false;
        if (state.batteryStatus == BatteryDatum.STATE_DISCHARGING) {
          if (state.batteryLevel < NO_SAMPLING_LEVEL) {
            // disable all sensing
            print('PowerAware: Disabling all sampling, level ${state.batteryLevel}%');
            study.adapt(SamplingSchema.none());
            adapted = true;
          } else if (state.batteryLevel < LIGHT_SAMPLING_LEVEL) {
            // go to light sensing mode
            print('PowerAware: Going to light sampling mode, level ${state.batteryLevel}%');
            study.adapt(SamplingSchema.light());
            adapted = true;
          } else {
            // if we have adapted the sampling schema, go back to the original
          }
          if (adapted) {
            executor.reset();
          }
        }
      });
      battery.initialize();
      await battery.start();
    }
  }

  void disablePowerAwareness() {
    battery.stop();
  }

  void start() async {
    await enablePowerAwareness();
    executor.start();
  }

  void stop() {
    disablePowerAwareness();
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
