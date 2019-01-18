/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */
part of runtime;

/// A [StudyController] controls the execution of a [Study].
class StudyController {
  Study study;
  StudyExecutor executor;
  DataManager dataManager;
  DatumStreamTransformer transformer;
  SamplingSchema samplingSchema;

  Stream<Datum> events;
  BatteryProbe battery =
      BatteryProbe(Measure(MeasureType(NameSpace.CARP, DataType.BATTERY), name: 'PowerAwarenessProbe'));
  PowerAwarenessState powerAwarenessState = NormalSamplingState.instance;

  StudyController(this.study, {this.executor, this.samplingSchema, this.dataManager, this.transformer})
      : assert(study != null),
        super() {
    // if no executor is specified, use the default one
    executor ??= StudyExecutor(study);
    // if no sampling schema is specified, use the normal one with power-awareness
    samplingSchema ??= SamplingSchema.normal(powerAware: true);
    // if the data manager hasn't been set, then try to look it up in the [DataManagerRegistry]
    dataManager ??= DataManagerRegistry.lookup(study.dataEndPoint.type);
    // if no transform function is specified, create a 1:1 mapping
    transformer ??= ((events) => events);
    events = transformer(executor.events);
  }

  Future<void> initialize() async {
    await Device.getDeviceInfo();
    print('Initializing Study Manager for study: ' + study.name);
    print(' platform     : ' + Device.platform.toString());
    print(' device ID    : ' + Device.deviceID.toString());
    print(' data manager : ' + dataManager.toString());

    if (samplingSchema != null) {
      // doing two adaptation is a bit of a hack; used to ensure that
      // restoration values are set to the specified sampling schema
      study.adapt(samplingSchema, restore: false);
      study.adapt(samplingSchema, restore: false);
    }

    executor.initialize();
    dataManager.initialize(study, events);
  }

  Future<void> enablePowerAwareness() async {
    if (samplingSchema.powerAware) {
      battery.events.listen((datum) {
        BatteryDatum battery_state = (datum as BatteryDatum);
        if (battery_state.batteryStatus == BatteryDatum.STATE_DISCHARGING) {
          // only apply power-awareness if not charging.
          PowerAwarenessState new_state = powerAwarenessState.adapt(battery_state.batteryLevel);
          if (new_state != powerAwarenessState) {
            powerAwarenessState = new_state;
            print('PowerAware: Going to $powerAwarenessState, level ${battery_state.batteryLevel}%');
            study.adapt(powerAwarenessState.schema);
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

  Future<void> start() async {
    enablePowerAwareness();
    executor.start();
  }

  void stop() {
    disablePowerAwareness();
    dataManager.close();
    executor.stop();
  }

  void pause() {
    executor.pause();
  }

  void resume() {
    executor.resume();
  }
}

/// This default power-awareness schema operates with four power states:
///
///
///       0%     10%            30%           50%                           1000%
///       +-------+--------------+-------------+------------------------------+
///         none      minimum         light                normal
///
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
