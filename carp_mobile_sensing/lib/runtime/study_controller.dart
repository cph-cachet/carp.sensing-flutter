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
  PowerAwarenessState powerAwarenessState = NormalSamplingState.instance;

  /// Create a new [StudyController] to control the [study].
  ///
  /// A custom study executor can be specified in [executor]. If null, the default [StudyExecutor] is used.
  /// If [samplingSchema] is null, [SamplingSchema.normal()] with power-awareness is used.
  /// If [dataManager] is null, a [DataManager] will be looked up in the [DataManagerRegistry] based on
  /// the type of the study's [DataEndPoint].
  /// If [transformer] is null, a 1:1 mapping is done, i.e. no transformation.
  StudyController(this.study, {this.executor, this.samplingSchema, this.dataManager, this.transformer})
      : assert(study != null),
        super() {
    executor ??= StudyExecutor(study);
    samplingSchema ??= SamplingSchema.normal(powerAware: true);
    dataManager ??= DataManagerRegistry.lookup(study.dataEndPoint.type);
    transformer ??= ((events) => events);
    events = transformer(executor.events);
  }

  /// Initialize this controller. Must be called only once, and before [start] is called.
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

  BatteryProbe _battery =
      BatteryProbe(Measure(MeasureType(NameSpace.CARP, DataType.BATTERY), name: 'PowerAwarenessProbe'));

  /// Enable power-aware sensing in this study. See [PowerAwarenessState].
  Future<void> enablePowerAwareness() async {
    if (samplingSchema.powerAware) {
      _battery.events.listen((datum) {
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
      _battery.initialize();
      _battery.start();
    }
  }

  /// Disable power-aware sensing.
  void disablePowerAwareness() {
    _battery.stop();
  }

  /// Start this controller, i.e. start collecting data according to the specified [study] and [samplingSchema].
  Future<void> start() async {
    enablePowerAwareness();
    executor.start();
  }

  /// Stop the sampling.
  ///
  /// Once a controller is stopped it **cannot** be (re)started.
  /// If a controller should be restarted, use the [pause] and [resume] methods.
  void stop() {
    disablePowerAwareness();
    dataManager.close();
    executor.stop();
  }

  /// Pause the controller, which will pause data collection.
  void pause() {
    executor.pause();
  }

  /// Resume the controller, i.e. resume data collection.
  void resume() {
    executor.resume();
  }
}

/// This default power-awareness schema operates with four power states:
///
///
///       0%   10%        30%        50%                         100%
///       +-----+----------+----------+----------------------------+
///        none   minimum     light              normal
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
