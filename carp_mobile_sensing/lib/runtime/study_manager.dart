/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */
part of runtime;

class StudyManager {
  Study study;
  StudyExecutor executor;
  DataManager manager;
  DatumStreamTransformer transformer;
  SamplingSchema samplingSchema;

  Stream<Datum> events;
  BatteryProbe battery =
      BatteryProbe(Measure(MeasureType(NameSpace.CARP, DataType.BATTERY), name: 'PowerAwarenessProbe'));
  PowerAwarenessState powerAwarenessState = NormalSamplingState.instance;

  StudyManager(this.study, {this.executor, this.samplingSchema, this.manager, this.transformer})
      : assert(study != null),
        super() {
    // if no executor is specified, use the default one
    executor ??= StudyExecutor(study);
    // if no sampling schema is specified, use the normal one with no power-awareness
    samplingSchema ??= SamplingSchema.normal(powerAware: false);
    // if the data manager hasn't been set, then try to look it up in the [DataManagerRegistry]
    manager ??= DataManagerRegistry.lookup(study.dataEndPoint.type);
    // if no transform function is specified, create a 1:1 mapping
    transformer ??= ((events) => events);
    events = transformer(executor.events);
  }

  Future initialize() async {
    await Device.getDeviceInfo();
    print('Initializing Study Manager for study: ' + study.name);
    print(' platform     : ' + Device.platform.toString());
    print(' device ID    : ' + Device.deviceID.toString());
    print(' data manager : ' + manager.toString());

    if (samplingSchema != null) {
      //study.adapt(samplingSchema);
    }

    executor.initialize();
    manager.initialize(study, events);
  }

  Future enablePowerAwareness() async {
    if (samplingSchema.powerAware) {
      //take a snapshot of the study before adapting it
      //_snapshot();
      battery.events.listen((datum) {
        BatteryDatum battery_state = (datum as BatteryDatum);
        print('PowerAware - ${battery_state}');
        if (battery_state.batteryStatus == BatteryDatum.STATE_DISCHARGING) {
          // only apply power-awareness if not charging.
          PowerAwarenessState new_state = powerAwarenessState.adapt(battery_state.batteryLevel);
          if (new_state != powerAwarenessState) {
            powerAwarenessState = new_state;
            print('PowerAware: Going to $powerAwarenessState, level ${battery_state.batteryLevel}%');
            // restore to original before adapting
            //_restore();
            study.adapt(powerAwarenessState.schema);
            //executor.restart(_adapted_measures);
          }
        }
      });
      battery.initialize();
      battery.start();
    }
  }

  void disablePowerAwareness() {
    battery.stop();
  }

  Future start() async {
    //enablePowerAwareness();
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

/// This default power-awarenes schema operates with four power states:
///
///   * Normal [100% - 50%]
///   * Light  [49%-30%]
///   * Minimum [29%-10%]
///   * None [9%-0%]
abstract class PowerAwarenessState {
  static const int LIGHT_SAMPLING_LEVEL = 50;
  static const int MINIMUM_SAMPLING_LEVEL = 30;
  static const int NO_SAMPLING_LEVEL = 10;

  static PowerAwarenessState instance;

  PowerAwarenessState adapt(int level);
  SamplingSchema get schema;
}

class NoSamplingState implements PowerAwarenessState {
  static NoSamplingState instance = NoSamplingState();

  PowerAwarenessState adapt(int level) {
    if (level > PowerAwarenessState.NO_SAMPLING_LEVEL)
      return MinimumSamplingState.instance;
    else
      return NoSamplingState.instance;
  }

  SamplingSchema get schema => SamplingSchema.none();

  String toString() => "Disabled Sampling Mode";
}

class MinimumSamplingState implements PowerAwarenessState {
  static MinimumSamplingState instance = MinimumSamplingState();

  PowerAwarenessState adapt(int level) {
    if (level < PowerAwarenessState.NO_SAMPLING_LEVEL)
      return NoSamplingState.instance;
    else if (level > PowerAwarenessState.MINIMUM_SAMPLING_LEVEL)
      return LightSamplingState.instance;
    else
      return MinimumSamplingState.instance;
  }

  SamplingSchema get schema => SamplingSchema.minimum();

  String toString() => "Minimun Sampling Mode";
}

class LightSamplingState implements PowerAwarenessState {
  static LightSamplingState instance = LightSamplingState();

  PowerAwarenessState adapt(int level) {
    if (level < PowerAwarenessState.MINIMUM_SAMPLING_LEVEL)
      return MinimumSamplingState.instance;
    else if (level > PowerAwarenessState.LIGHT_SAMPLING_LEVEL)
      return NormalSamplingState.instance;
    else
      return LightSamplingState.instance;
  }

  SamplingSchema get schema => SamplingSchema.light();

  String toString() => "Light Sampling Mode";
}

class NormalSamplingState implements PowerAwarenessState {
  static NormalSamplingState instance = NormalSamplingState();

  PowerAwarenessState adapt(int level) {
    if (level < PowerAwarenessState.LIGHT_SAMPLING_LEVEL)
      return LightSamplingState.instance;
    else
      return NormalSamplingState.instance;
  }

  SamplingSchema get schema => SamplingSchema.normal();

  String toString() => "Normal Sampling Mode";
}
