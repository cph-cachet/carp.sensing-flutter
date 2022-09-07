/*
 * Copyright 2022 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of runtime;

/// A [Probe] is a specialized [Executor] responsible for collecting data from
/// the device sensors as configured in a [Measure].
abstract class Probe extends AbstractExecutor<Measure> {
  /// A stream controller to add [Datum]s to.
  StreamController<Datum> controller = StreamController.broadcast();

  @override
  Stream<DataPoint> get data =>
      controller.stream.map((datum) => DataPoint.fromData(datum));

  /// The device that this probes uses to collect data.
  late DeviceManager deviceManager;

  /// Is this probe enabled, i.e. available for collection of data using the
  /// [resume] method.
  bool enabled = true;

  /// The data type this probe is collecting.
  String? get type => measure?.type;

  /// The [Measure] that configures this probe.
  Measure? get measure => configuration;

  /// The sampling configuration for this probe.
  ///
  /// Configuration is obtained in the following order:
  ///  * as [Measure.overrideSamplingConfiguration]
  ///  * from the [DeviceDescriptor.samplingConfiguration] of the [deployment]
  ///  * from the [SamplingSchema.configurations] of the sampling packages
  ///
  /// Returns `null` in case no configuration is found.
  SamplingConfiguration? get samplingConfiguration =>
      measure?.overrideSamplingConfiguration ??
      deployment?.deviceDescriptor.samplingConfiguration[measure?.type] ??
      SamplingPackageRegistry().samplingSchema.configurations[measure?.type];

  /// Add a data point to the [data] stream.
  @protected
  void addData(Datum datum) {
    // timestamp this sampling
    if (samplingConfiguration is PersistentSamplingConfiguration) {
      (samplingConfiguration as PersistentSamplingConfiguration).lastTime =
          DateTime.now().toUtc();
    }
    controller.add(datum);
  }

  /// Add an error to the [data] stream.
  @protected
  void addError(Object error) => controller.addError(error);

  // default no-op implementation of callback methods

  @override
  bool onInitialize() => true;

  @override
  Future<bool> onResume() async => true;

  @override
  Future<bool> onPause() async => true;

  @override
  Future<bool> onRestart() async => true;

  @override
  Future<bool> onStop() async => true;
}

//---------------------------------------------------------------------------------------
//                                SPECIALIZED PROBES
//---------------------------------------------------------------------------------------

/// This probe collects one piece of [Datum] when resumed, send its to the
/// [data] stream, and then pauses.
///
/// The [Datum] to be collected should be implemented in the [getDatum] method.
///
/// See [DeviceProbe] for an example.
abstract class DatumProbe extends Probe {
  @override
  Future<bool> onResume() async {
    Datum? datum;
    try {
      datum = await getDatum();
    } catch (error) {
      addError(error);
    }
    if (datum != null) addData(datum);
    pause();
    return true;
  }

  /// Subclasses should implement this method to collect a [Datum].
  ///
  /// Can return `null` if no data is available.
  /// Can return an [ErrorDatum] if an error occurs.
  Future<Datum?> getDatum();
}

/// A probe which is triggered at regular intervals, specified by the interval
/// property in an [IntervalSamplingConfiguration].
/// When triggered, the probe collect a piece of data using the [getDatum] method.
///
/// See [MemoryProbe] for an example.
abstract class IntervalDatumProbe extends DatumProbe {
  Timer? timer;

  @override
  IntervalSamplingConfiguration? get samplingConfiguration =>
      super.samplingConfiguration as IntervalSamplingConfiguration;

  @override
  Future<bool> onResume() async {
    Duration? interval = samplingConfiguration?.interval;
    if (interval != null) {
      // create a recurrent timer that gets the data point every [frequency].
      timer = Timer.periodic(interval, (Timer t) async {
        try {
          Datum? datum = await getDatum();
          if (datum != null) addData(datum);
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
  Future<bool> onPause() async {
    timer?.cancel();
    return true;
  }

  @override
  Future<bool> onStop() async {
    timer?.cancel();
    await controller.close();
    return true;
  }
}

/// An abstract class used to create a probe that listen continously to events
/// from the [stream] of [Datum] objects.
///
/// Sub-classes must implement the
///
///     Stream<Datum>? get stream => ...
///
/// method in order to provide the stream to collect data from.
///
/// See [BatteryProbe] for an example.
abstract class StreamProbe extends Probe {
  StreamSubscription<dynamic>? subscription;

  /// The stream of [Datum] objects for this [StreamProbe].
  /// Must be implemented by sub-classes.
  Stream<Datum>? get stream;

  @override
  Future<bool> onResume() async {
    if (stream == null) {
      warning(
          "Trying to resume the stream probe '$runtimeType' which does not provide a Datum stream. "
          'Have you initialized this probe correctly?');
      return false;
    } else {
      subscription = stream!.listen(onData, onError: onError, onDone: onDone);
    }
    return true;
  }

  @override
  bool onInitialize() => true;

  @override
  Future<bool> onPause() async {
    await subscription?.cancel();
    return true;
  }

  @override
  Future<bool> onRestart() async {
    await subscription?.cancel();
    await onResume();
    return true;
  }

  @override
  Future<bool> onStop() async {
    await subscription?.cancel();
    await controller.close();
    subscription = null;
    return true;
  }

  // just forwarding to the controller
  void onData(Datum datum) => addData(datum);
  void onError(Object error) => addError(error);
  void onDone() => controller.close();
}

// /// An abstract class used to create a probe that listen continously to events
// /// from the [futureStream] of [Datum] objects.
// /// In contrast to the [StreamProbe], this probes waits until the [futureStream]
// /// is available.
// ///
// /// Sub-classes must implement the
// ///
// ///     Future<Stream<Datum>>? get futureStream => ...
// ///
// /// method in order to provide the stream to collect data from.
// abstract class FutureStreamProbe extends StreamProbe {
//   Stream<Datum>? _stream;

//   @override
//   Stream<Datum>? get stream => _stream;

//   /// The stream of [Datum] objects for this [FutureStreamProbe].
//   /// Must be implemented by sub-classes.
//   Future<Stream<Datum>>? get futureStream;

//   @override
//   Future<void> onResume() async {
//     _stream = await futureStream;
//     super.onResume();
//   }
// }

/// A periodic probe listening on a stream. Listening is done periodically as
/// specified in a [PeriodicSamplingConfiguration] listening on intervals every
/// [interval] for a period of [duration].
/// During this period, all data are forwarded to this probes [data] stream.
///
/// Just like in [StreamProbe], sub-classes must implement the
///
///     Stream<DataPoint>? get stream => ...
///
/// method in order to provide the stream to collect data from.
///
/// Note that this probe will finish its collection period even if it is paused.
/// Hence, data can still be generated from this probe, even if paused.
/// Pausing will pause the creation of new collection periods.
abstract class PeriodicStreamProbe extends StreamProbe {
  Timer? timer;

  @override
  PeriodicSamplingConfiguration? get samplingConfiguration =>
      super.samplingConfiguration as PeriodicSamplingConfiguration;

  @override
  Future<bool> onResume() async {
    if (stream == null) {
      warning(
          "Trying to resume the stream probe '$runtimeType' which does not provide a Datum stream. "
          'Have you initialized this probe correctly?');
      return false;
    } else {
      Duration? interval = samplingConfiguration?.interval;
      Duration? duration = samplingConfiguration?.duration;
      if (interval != null && duration != null) {
        // create a recurrent timer that resume sampling
        timer = Timer.periodic(interval, (timer) {
          final StreamSubscription<Datum> newSubscription =
              stream!.listen(onData, onError: onError, onDone: onDone);
          // create a timer that pause the sampling after the specified duration.
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
  Future<bool> onPause() async {
    timer?.cancel();
    await super.onPause();
    return true;
  }

  @override
  Future<bool> onStop() async {
    timer?.cancel();
    await super.onStop();
    return true;
  }
}

/// An abstract probe which can be used to sample data into a buffer,
/// every [frequency] for a period of [duration]. These events are buffered, and
/// once collected for the [duration], are collected from the [getDatum] method and
/// send to the main [data] stream.
///
/// When sampling starts, the [onSamplingStart] handle is called.
/// When the sampling window ends, the [onSamplingEnd] handle is called.
///
/// See [AudioProbe] for an example.
abstract class BufferingPeriodicProbe extends DatumProbe {
  Timer? timer;

  @override
  PeriodicSamplingConfiguration? get samplingConfiguration =>
      super.samplingConfiguration as PeriodicSamplingConfiguration;

  @override
  Future<bool> onResume() async {
    Duration? interval = samplingConfiguration?.interval;
    Duration? duration = samplingConfiguration?.duration;
    if (interval != null && duration != null) {
      // create a recurrent timer that every [frequency] resumes the buffering.
      timer = Timer.periodic(interval, (Timer t) {
        onSamplingStart();
        // create a timer that stops the buffering after the specified [duration].
        Timer(duration, () async {
          onSamplingEnd();
          // collect the datum
          try {
            Datum? datum = await getDatum();
            if (datum != null) addData(datum);
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
  Future<bool> onPause() async {
    if (timer != null) timer!.cancel();
    // check if there are some buffered data that needs to be collected before pausing
    try {
      Datum? datum = await getDatum();
      if (datum != null) addData(datum);
    } catch (error) {
      addError(error);
    }
    return true;
  }

  @override
  Future<bool> onStop() async {
    timer?.cancel();
    await controller.close();
    return true;
  }

  /// Handler called when sampling period starts.
  void onSamplingStart();

  /// Handler called when sampling period ends.
  void onSamplingEnd();

  /// Subclasses should implement / override this method to collect the [Datum].
  /// This method will be called every time data has been buffered for a
  /// [duration] and should return the final [Datum] for the buffered data.
  ///
  /// Can return `null` if no data is available.
  /// Can return an [ErrorDatum] if an error occurs.
  @override
  Future<Datum?> getDatum();
}

/// An abstract probe which can be used to sample data from a buffering stream,
/// every [interval] for a period of [duration]. These events are buffered
/// for the specified [duration], and then collected from the [getDatum]
/// method and send to the main [data] stream.
///
/// Sub-classes must implement the
///
///     Stream<dynamic> get bufferingStream => ...
///
/// method in order to provide the stream to be buffered.
///
/// When sampling starts, the [onSamplingStart] handle is called.
/// When the sampling window ends, the [onSamplingEnd] handle is called.
///
/// See [LightProbe] for an example.
abstract class BufferingPeriodicStreamProbe extends PeriodicStreamProbe {
  // we don't use the stream in the super class so we give it an empty non-null stream
  @override
  Stream<Datum> get stream => Stream.empty();

  @override
  Future<bool> onResume() async {
    Duration? interval = samplingConfiguration?.interval;
    Duration? duration = samplingConfiguration?.duration;
    if (interval != null && duration != null) {
      timer = Timer.periodic(interval, (Timer t) {
        onSamplingStart();
        subscription = bufferingStream.listen(onSamplingData,
            onError: onError, onDone: onDone);
        Timer(duration, () async {
          await subscription?.cancel();
          onSamplingEnd();
          try {
            Datum? datum = await getDatum();
            if (datum != null) addData(datum);
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
  Future<bool> onPause() async {
    await super.onPause();
    onSamplingEnd();
    try {
      Datum? datum = await getDatum();
      if (datum != null) addData(datum);
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

  /// Subclasses should implement / override this method to collect the [Datum].
  /// This method will be called every time data has been buffered for a [duration]
  /// and should return the final [Datum] for the buffered data.
  ///
  /// Can return `null` if no data is available.
  /// Can return an [ErrorDatum] if an error occurs.
  Future<Datum?> getDatum();
}

/// An abstract probe which can be used to buffer data from a stream and collect data
/// every [interval]. All events from the [bufferingStream] are buffered, and
/// collected from the [getDatum] method every [interval] and send to the
/// main [data] stream.
///
/// Sub-classes must implement the
///
///     Stream<dynamic> get bufferingStream => ...
///
/// method in order to provide the stream to be buffered.
///
/// When the sampling window ends, the [getDatum] method is called.
abstract class BufferingIntervalStreamProbe extends StreamProbe {
  Timer? timer;

  @override
  IntervalSamplingConfiguration? get samplingConfiguration =>
      super.samplingConfiguration as IntervalSamplingConfiguration;

  @override
  Future<bool> onResume() async {
    Duration? interval = samplingConfiguration?.interval;
    if (interval != null) {
      subscription = bufferingStream.listen(
        onSamplingData,
        onError: onError,
        onDone: onDone,
      );
      timer = Timer.periodic(interval, (_) async {
        try {
          Datum? datum = await getDatum();
          if (datum != null) addData(datum);
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
  Future<bool> onPause() async {
    await super.onPause();
    await subscription?.cancel();
    return true;
  }

  @override
  Future<bool> onStop() async {
    timer?.cancel();
    await subscription?.cancel();
    await super.onStop();
    return true;
  }

  /// The stream of events to be buffered. Must be specified by sub-classes.
  Stream<dynamic> get bufferingStream;

  /// Handler for handling onData events from the buffering stream.
  void onSamplingData(dynamic event);

  /// Subclasses should implement / override this method to collect the [Datum].
  /// This method will be called every time data has been buffered for a [duration]
  /// and should return the final [Datum] for the buffered data.
  ///
  /// Can return `null` if no data is available.
  /// Can return an [ErrorDatum] if an error occurs.
  Future<Datum?> getDatum();
}
