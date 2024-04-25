/*
 * Copyright 2018-2022 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of '../runtime.dart';

/// A [Probe] is a specialized [Executor] responsible for collecting data from
/// the device sensors as configured in a [Measure].
abstract class Probe extends AbstractExecutor<Measure> {
  /// A stream controller to add [Measurement]s to.
  StreamController<Measurement> controller = StreamController.broadcast();

  @override
  Stream<Measurement> get measurements => controller.stream;

  /// The device that this probes uses to collect data.
  late DeviceManager deviceManager;

  /// Is this probe enabled, i.e. available for collection of data using the
  /// [start] method.
  bool enabled = true;

  /// The data type this probe is collecting.
  String? get type => measure?.type;

  /// The [Measure] that configures this probe.
  Measure? get measure => configuration;

  /// The sampling configuration for this probe.
  ///
  /// Configuration is obtained in the following order:
  ///  * from the [Measure.overrideSamplingConfiguration]
  ///  * from the [DeviceConfiguration.defaultSamplingConfiguration] of the [deployment]
  ///  * from the [DeviceConfiguration.dataTypeSamplingSchemes] of the static device configuration
  ///  * from the [SamplingPackage.samplingSchemes] of the sampling packages
  ///
  /// Returns `null` in case no configuration is found.
  ///
  /// See also the section on [Sampling schemes and configurations](https://github.com/cph-cachet/carp.core-kotlin/blob/develop/docs/carp-common.md#sampling-schemes-and-configurations)
  /// in the CARP Core Framework. In addition to CARP Core, CARP Mobile Sensing
  /// also supports sampling schemes in the sampling packages, which are used
  /// as the 4th possible configuration in the list above.
  SamplingConfiguration? get samplingConfiguration =>
      measure?.overrideSamplingConfiguration ??
      deployment
          ?.deviceConfiguration.defaultSamplingConfiguration?[measure?.type] ??
      deployment?.deviceConfiguration.dataTypeSamplingSchemes?[measure?.type]
          ?.defaultSamplingConfiguration ??
      SamplingPackageRegistry()
          .samplingSchemes[measure?.type]
          ?.defaultSamplingConfiguration;

  /// Add a data point to the [measurements] stream.
  @protected
  void addMeasurement(Measurement measurement) {
    // timestamp this sampling
    if (samplingConfiguration is PersistentSamplingConfiguration) {
      (samplingConfiguration as PersistentSamplingConfiguration).lastTime =
          DateTime.now().toUtc();
    }
    controller.add(measurement);
  }

  /// Add an error to the [measurements] stream.
  @protected
  void addError(Object error) => controller.addError(error);

  // default no-op implementation of callback methods below

  @override
  bool onInitialize() => true;

  @override
  Future<bool> onStart() async => true;

  @override
  Future<bool> onRestart() async => true;

  @override
  Future<bool> onStop() async => true;
}

//---------------------------------------------------------------------------------------
//                                SPECIALIZED PROBES
//---------------------------------------------------------------------------------------

/// A simple no-op probe that does nothing.
class StubProbe extends Probe {}

/// This probe collects a single [Measurement] when started, send its to the
/// [measurements] stream, and then stops.
///
/// The [Measurement] to be collected should be implemented in the [getMeasurement] method.
///
/// See [DeviceProbe] for an example.
abstract class MeasurementProbe extends Probe {
  @override
  Future<bool> onStart() async {
    getMeasurement().then((measurement) {
      if (measurement != null) addMeasurement(measurement);
      // automatically stop this probe after it is done collecting the measurement
      Future.delayed(const Duration(seconds: 1), () => stop());
    }, onError: (Object error) => addError(error));

    return true;
  }

  /// Subclasses should implement this method to collect a [Measurement].
  ///
  /// Can return `null` if no data is available.
  /// Can return an [Error] measurement if an error occurs.
  Future<Measurement?> getMeasurement();
}

/// A probe which is triggered at regular intervals, specified by the interval
/// property in an [IntervalSamplingConfiguration].
/// When triggered, the probe collect a measurement using the [getMeasurement] method.
///
/// See [MemoryProbe] for an example.
abstract class IntervalProbe extends MeasurementProbe {
  Timer? _timer;

  @override
  IntervalSamplingConfiguration? get samplingConfiguration =>
      super.samplingConfiguration as IntervalSamplingConfiguration;

  @override
  Future<bool> onStart() async {
    Duration? interval = samplingConfiguration?.interval;
    if (interval != null) {
      // create a recurrent timer that gets the data point every [frequency].
      _timer ??= Timer.periodic(interval, (Timer t) async {
        try {
          var measurement = await getMeasurement();
          if (measurement != null) addMeasurement(measurement);
        } catch (error) {
          addError(error);
        }
      });
    } else {
      warning(
          '$runtimeType - no valid interval found in sampling configuration: $samplingConfiguration. '
          'Is a valid IntervalSamplingConfiguration provided?');
      return false;
    }
    return true;
  }

  @override
  Future<bool> onStop() async {
    _timer?.cancel();
    _timer = null;
    return true;
  }
}

/// An abstract class used to create a probe that listen continuously to events
/// from the [stream] of [Measurement] objects.
///
/// Sub-classes must implement the
///
///     Stream<Measurement>? get stream => ...
///
/// method in order to provide the stream of measurements.
///
/// See [BatteryProbe] for an example.
abstract class StreamProbe extends Probe {
  StreamSubscription<dynamic>? _subscription;
  Stream<Measurement>? _stream;

  /// The stream of [Measurement] objects for this [StreamProbe].
  /// Must be implemented by sub-classes.
  Stream<Measurement>? get stream;

  @override
  Future<bool> onStart() async {
    _stream ??= stream;
    if (_stream == null) {
      warning(
          "Trying to start the stream probe '$runtimeType' which does not provide a measurement stream. "
          'Have you initialized this probe correctly or is the device connected?');
      return false;
    } else {
      _subscription = _stream!.listen(onData, onError: onError, onDone: onDone);
    }
    return true;
  }

  @override
  Future<bool> onStop() async {
    await _subscription?.cancel();
    _stream = null;
    return true;
  }

  @override
  Future<bool> onRestart() async {
    await _subscription?.cancel();
    _stream = null;
    return true;
  }

  // just forwarding to the controller
  void onData(Measurement measurement) => addMeasurement(measurement);
  void onError(Object error) => addError(error);
  void onDone() => controller.close();
}

/// A periodic probe listening on a stream. Listening is done periodically as
/// specified in a [PeriodicSamplingConfiguration] listening on intervals every
/// [interval] for a period of [duration].
/// During this period, all data are forwarded to this probes [measurements] stream.
///
/// Just like in [StreamProbe], sub-classes must implement the
///
///     Stream<Measurement>? get stream => ...
///
/// method in order to provide the stream to collect data from.
///
/// Note that this probe will finish its collection period even if it is stopped.
/// Hence, data can still be generated from this probe, even if stopped.
/// Stopping this probe will stop the creation of new collection periods.
abstract class PeriodicStreamProbe extends StreamProbe {
  Timer? timer;

  @override
  PeriodicSamplingConfiguration? get samplingConfiguration =>
      super.samplingConfiguration as PeriodicSamplingConfiguration;

  @override
  Future<bool> onStart() async {
    if (stream == null) {
      warning(
          "Trying to start the stream probe '$runtimeType' which does not provide a measurement stream. "
          'Have you initialized this probe correctly?');
      return false;
    } else {
      Duration? interval = samplingConfiguration?.interval;
      Duration? duration = samplingConfiguration?.duration;
      if (interval != null && duration != null) {
        // create a recurrent timer that starts sampling
        timer = Timer.periodic(interval, (timer) {
          final StreamSubscription<Measurement> newSubscription =
              stream!.listen(onData, onError: onError, onDone: onDone);
          // create a timer that stops the sampling after the specified duration.
          Timer(duration, () async {
            await newSubscription.cancel();
          });
        });
      } else {
        warning(
            '$runtimeType - no valid interval and duration found in sampling configuration: $samplingConfiguration. '
            'Is a valid PeriodicSamplingConfiguration provided?');
      }
    }
    return true;
  }

  @override
  Future<bool> onStop() async {
    timer?.cancel();
    await super.onStop();
    return true;
  }
}

/// An type of probe which collects data for a period of time and then return
/// a measurement from this collected data.
///
/// Probes of this type uses a [PeriodicSamplingConfiguration] that specify
/// the [interval] of starting sampling, and the [duration] of the sampling window.
/// Once this sampling window is over, the final measurement is collected from
/// the [getMeasurement] method and send to the main [measurements] stream.
///
/// When sampling starts, the [onSamplingStart] handle is called.
/// When the sampling window ends, the [onSamplingEnd] handle is called.
abstract class BufferingPeriodicProbe extends MeasurementProbe {
  Timer? timer;

  @override
  PeriodicSamplingConfiguration? get samplingConfiguration =>
      super.samplingConfiguration as PeriodicSamplingConfiguration;

  @override
  Future<bool> onStart() async {
    Duration? interval = samplingConfiguration?.interval;
    Duration? duration = samplingConfiguration?.duration;
    if (interval != null && duration != null) {
      // create a recurrent timer that every [interval] starts the buffering
      timer = Timer.periodic(interval, (Timer t) {
        onSamplingStart();
        // create a timer that stops the buffering after the specified [duration].
        Timer(duration, () async {
          onSamplingEnd();
          // collect the measurement
          try {
            Measurement? measurement = await getMeasurement();
            if (measurement != null) addMeasurement(measurement);
          } catch (error) {
            addError(error);
          }
        });
      });
    } else {
      warning(
          '$runtimeType - no valid interval and duration found in sampling configuration: $samplingConfiguration. '
          'Is a valid PeriodicSamplingConfiguration provided?');
      return false;
    }
    return true;
  }

  @override
  Future<bool> onStop() async {
    if (timer != null) timer!.cancel();
    // check if there are some buffered data that needs to be collected before pausing
    try {
      Measurement? measurement = await getMeasurement();
      if (measurement != null) addMeasurement(measurement);
    } catch (error) {
      addError(error);
    }
    return true;
  }

  /// Handler called when sampling period starts.
  void onSamplingStart();

  /// Handler called when sampling period ends.
  void onSamplingEnd();

  /// Subclasses should implement / override this method to collect the [Measurement].
  /// This method will be called every time data has been buffered for a
  /// [duration] and should return the final [Measurement] for the buffered data.
  ///
  /// Can return `null` if no data is available.
  /// Can return an [Error] if an error occurs.
  @override
  Future<Measurement?> getMeasurement();
}

/// A type of probe which buffers data from an underlying stream and on a regular
/// interval return a measurement based on this collected data.
///
/// Probes of this type uses a [PeriodicSamplingConfiguration] that specify
/// the [interval] of sampling. The [duration] is not used.
/// Every [interval] the measurement is collected from the [getMeasurement]
/// method and send to the main [measurements] stream.
///
/// Sub-classes must implement the
///
///     Stream<dynamic> get bufferingStream => ...
///
/// method in order to provide the stream to be buffered.
///
/// The difference between this [BufferingIntervalStreamProbe] and the
/// [BufferingPeriodicStreamProbe] is that this type of probe keeps the
/// underlying [bufferingStream] running continuously, while the latter
/// starts and stop the underlying [bufferingStream] in the sampling
/// windows specified by the [interval] and [duration] parameters of the
/// [samplingConfiguration].
abstract class BufferingIntervalStreamProbe extends StreamProbe {
  Timer? timer;

  @override
  IntervalSamplingConfiguration? get samplingConfiguration =>
      super.samplingConfiguration as IntervalSamplingConfiguration;

  @override
  Future<bool> onStart() async {
    Duration? interval = samplingConfiguration?.interval;
    if (interval != null) {
      _subscription = bufferingStream.listen(
        onSamplingData,
        onError: onError,
        onDone: onDone,
      );
      timer = Timer.periodic(interval, (_) async {
        try {
          Measurement? measurement = await getMeasurement();
          if (measurement != null) addMeasurement(measurement);
        } catch (error) {
          addError(error);
        }
      });
    } else {
      warning(
          '$runtimeType - no valid interval found in sampling configuration: $samplingConfiguration. '
          'Is a valid IntervalSamplingConfiguration provided?');
      return false;
    }
    return true;
  }

  @override
  Future<bool> onStop() async {
    await super.onStop();
    await _subscription?.cancel();
    return true;
  }

  /// The stream of events to be buffered. Must be specified by sub-classes.
  Stream<dynamic> get bufferingStream;

  /// Handler for handling onData events from the buffering stream.
  void onSamplingData(dynamic event);

  /// Subclasses should implement / override this method to collect the [Measurement].
  /// This method will be called every time data has been buffered for a [duration]
  /// and should return the final measurement for the buffered data.
  ///
  /// Can return `null` if no data is available.
  /// Can return an [Error] if an error occurs.
  Future<Measurement?> getMeasurement();
}

/// A type of probe which buffers data from an underlying stream for a period
/// of time and then return a measurement from this collected data.
///
/// Probes of this type uses a [PeriodicSamplingConfiguration] that specify
/// the [interval] of starting sampling, and the [duration] of the sampling window.
/// Once this sampling window is over, the final measurement is collected from
/// the [getMeasurement] method and send to the main [measurements] stream.
///
/// Sub-classes must implement the
///
///     Stream<dynamic> get bufferingStream => ...
///
/// method in order to provide the stream to be buffered from.
///
/// When sampling starts, the [onSamplingStart] handle is called.
/// When the sampling window ends, the [onSamplingEnd] handle is called.
///
/// The difference between this [BufferingPeriodicStreamProbe] and the
/// [BufferingIntervalStreamProbe] is that this type of probe starts and stops
/// the underlying [bufferingStream] in the sampling windows specified by the
/// [interval] and [duration] parameters of the [samplingConfiguration],
/// whereas the latter [BufferingIntervalStreamProbe] keeps the
/// underlying [bufferingStream] running continuously.
///
/// See [LightProbe] for an example. This probe listens to the light sensor
/// every [interval] for [duration] and buffers the reading during this period
/// into an overall measurement for light, calculated in the [getMeasurement]
/// method.
abstract class BufferingPeriodicStreamProbe extends PeriodicStreamProbe {
  // we don't use the stream in the super class so we give it an empty non-null stream
  @override
  Stream<Measurement> get stream => const Stream.empty();

  @override
  Future<bool> onStart() async {
    Duration? interval = samplingConfiguration?.interval;
    Duration? duration = samplingConfiguration?.duration;
    if (interval != null && duration != null) {
      timer = Timer.periodic(interval, (Timer t) {
        onSamplingStart();
        _subscription = bufferingStream.listen(onSamplingData,
            onError: onError, onDone: onDone);
        Timer(duration, () async {
          await _subscription?.cancel();
          onSamplingEnd();
          try {
            Measurement? measurement = await getMeasurement();
            if (measurement != null) addMeasurement(measurement);
          } catch (error) {
            addError(error);
          }
        });
      });
    } else {
      warning(
          '$runtimeType - no valid interval and duration found in sampling configuration: $samplingConfiguration. '
          'Is a valid PeriodicSamplingConfiguration provided?');
      return false;
    }
    return true;
  }

  @override
  Future<bool> onStop() async {
    await super.onStop();
    onSamplingEnd();
    try {
      Measurement? measurement = await getMeasurement();
      if (measurement != null) addMeasurement(measurement);
    } catch (error) {
      addError(error);
    }
    return true;
  }

  // Sub-classes should implement the following handler methods.

  /// The stream of events to be buffered. Must be specified by sub-classes.
  Stream<dynamic> get bufferingStream;

  /// Handler called when sampling period starts.
  void onSamplingStart();

  /// Handler called when sampling period ends.
  void onSamplingEnd();

  /// Handler for handling onData events from the buffering stream.
  void onSamplingData(dynamic event);

  /// Subclasses should implement / override this method to collect the [Measurement].
  /// This method will be called every time data has been buffered for a [duration]
  /// and should return the final measurement for the buffered data.
  ///
  /// Can return `null` if no data is available.
  /// Can return an [Error] if an error occurs.
  Future<Measurement?> getMeasurement();
}
