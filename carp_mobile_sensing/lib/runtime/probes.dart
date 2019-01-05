/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of runtime;

/// A [Probe] is responsible for collecting data.
/// This class is an interface class used for implementing specific
/// probes as sub-classes.
///
/// Probes return sensed data in a [Stream] as [events]. This is the main
/// usage of a probe. For example, to listens to events and print them;
///
///     probe.events.forEach(print);
///
abstract class Probe {
  /// A [Stream] generating sensor data events from this probe.
  Stream<Datum> get events;

  /// The [Measure] that configures this probe.
  Measure get measure;

  /// Is this probe running.
  bool get isRunning;

  /// Has this probe been stopped? If so, it cannot be started, restarted, or resumed.
  bool get isStopped;

  ///A printer-friendly name for this probe. Takes its name from [Measure.name] as default.
  String name;

  /// Initialize the probe with the specified [Measure].
  void initialize(Measure measure);

  ///Start the probe();
  Future start();

  /// Pause the probe. The probe is paused until [resume()] is called.
  void pause();

  /// Resume the probe.
  void resume();

  /// Restart the probe. This forces the probe to reload its configuration from
  /// the its [Measure] and restart sampling accordingly. If a new [measure] is
  /// specified, this new measure is used. Otherwise, the measure specified in the
  /// [initialize] method is used.
  ///
  /// This methods is used when sampling configuration is adapted, e.g. as
  /// part of the [PowerAwarenessState].
  void restart({Measure measure});

  /// Stop the probe. Once a probe is stopped, it cannot be started again.
  /// If you need to restart a probe, use the [restart] or [pause] and [resume] methods.
  void stop();
}

/// An abstract implementation of a [Probe] to extend from.
abstract class AbstractProbe implements Probe {
  Measure _measure;
  Measure get measure => _measure;

  bool _isRunning = false;
  bool get isRunning => _isRunning;

  bool _isStopped = false;
  bool get isStopped => _isStopped;

  String name;

  bool get enabled => (measure != null) ? measure.enabled : true;

  AbstractProbe({this.name});

  void initialize(Measure measure) {
    assert(measure != null, 'A Probe cannot be initialized with a null Measure.');
    _isRunning = false;
    _measure = measure;
    name ??= measure.name;
  }

  Future start() async {
    if (isStopped) throw SensingException('Probe has been stopped and cannot be (re)started.');
    if (!enabled) {
      print('$name probe not enabled - not starting');
      return;
    }

    _isRunning = true;
    print('$name probe started');
  }

  void pause() async {
    _isRunning = false;
    print('$name probe paused');
  }

  void resume() async {
    if (isStopped) throw SensingException('Probe has been stopped and cannot be resumed.');
    _isRunning = true;
    print('$name probe resumed');
  }

  void restart({Measure measure}) {
    if (isStopped) throw SensingException('Probe has been stopped and cannot be restarted.');
    if (enabled)
      resume();
    else
      pause();
  }

  void stop() async {
    _isRunning = false;
    _isStopped = true;
    print('$name probe stopped');
  }

  /// The stream of data events from this probe.
  Stream<Datum> get events;
}

/// An abstract class used to create a probe that listen to events from a [Stream].
///
/// Subclasses should implement the [get stream] method.
/// See [LocationProbe] for an example.
///
///
///
abstract class StreamProbe extends AbstractProbe {
  StreamSubscription<dynamic> subscription;
  StreamController<Datum> controller = StreamController<Datum>.broadcast();

  StreamProbe(Measure measure)
      : assert(measure != null),
        super.init(measure);

  Stream<Datum> get events => controller.stream;

  /// The a [Stream] of data items from this probe. Should be implemented by
  /// the specific probes implementing this [StreamProbe] class.
  Stream<Datum> get stream;

  Future start() async {
    super.start();
    if (stream != null) {
      subscription = stream.listen(onData, onError: onError, onDone: onDone);
      subscription.pause();
      restart();
    }
  }

  void pause() {
    super.pause();
    subscription.pause();
  }

  void resume() {
    super.resume();
    subscription.resume();
  }

  void stop() async {
    if (subscription != null) subscription.cancel();
    controller.close();
    super.stop();
  }

  void onData(Datum event) => controller.add(event);

  void onError(error) => controller.addError(error);

  void onDone() => controller.close();
}

/// A [DatumProbe] can collect one piece of [Datum], send its to its stream, and then stops.
///
/// The [Datum] to be collected is implemented in the [getDatum] method.
abstract class DatumProbe extends AbstractProbe {
  DatumProbe(Measure measure) : super.init(measure);

  Stream<Datum> get events => Stream.fromFuture(getDatum());

  /// Subclasses should implement this method to collect a [Datum].
  Future<Datum> getDatum();
}

/// A periodic probe is triggered at regular intervals, specified by its [frequency] property
/// in a [PeriodicMeasure].
///
/// When triggered, a periodic probe collect a piece of data ([Datum]) using the [getDatum] method.
abstract class PeriodicDatumProbe extends DatumProbe {
  Timer timer;
  StreamController<Datum> controller = StreamController<Datum>.broadcast();
  Duration frequency, duration;

  PeriodicDatumProbe(PeriodicMeasure measure)
      : assert(measure != null),
        assert(measure.frequency != null, 'Measure frequency cannot be null for a PeriodicProbe.'),
        super(measure);

  Stream<Datum> get events => controller.stream;

  Future start() async {
    super.start();
    this.restart();
  }

  void resume() {
    super.resume();
    // create a recurrent timer that resumes sampling every [frequency].
    timer = Timer.periodic(frequency, (Timer t) async {
      try {
        getDatum().then((Datum data) {
          controller.add(data);
        });
      } catch (e, s) {
        controller.addError(e, s);
        return;
      }
    });
  }

  void pause() {
    timer.cancel();
    super.pause();
  }

  void restart() {
    PeriodicMeasure _measure = measure as PeriodicMeasure;
    frequency = Duration(milliseconds: _measure.frequency);
    duration = (_measure.duration != null) ? Duration(milliseconds: _measure.duration) : null;
    super.restart();
  }

  void stop() async {
    if (timer != null) timer.cancel();
    controller.close();
    super.stop();
  }
}

/// A periodic probe listening on a stream. Listening is done periodically as specified in a
/// [PeriodicMeasure] listening on intervals every [frequency] for a period of [duration]. During this
/// period, all events are forwarded to this probes [events] stream.
abstract class PeriodicStreamProbe extends StreamProbe {
  Timer timer;
  Duration frequency, duration;

  PeriodicStreamProbe(PeriodicMeasure measure)
      : assert(measure != null),
        assert(measure.frequency != null, 'Measure frequency cannot be null for a PeriodicProbe.'),
//        frequency = Duration(milliseconds: measure.frequency),
//        duration = (measure.duration != null) ? Duration(milliseconds: measure.duration) : null,
        super(measure);

  Future start() async {
    super.start();
    PeriodicMeasure _measure = measure as PeriodicMeasure;
    frequency = Duration(milliseconds: _measure.frequency);
    duration = (_measure.duration != null) ? Duration(milliseconds: _measure.duration) : null;
    if (subscription != null) {
      // pause events for now.
      subscription.pause();
      // create a recurrent timer that wait (pause) and then resume the sampling.
      timer = Timer.periodic(frequency, (Timer t) {
        this.resume();

        // create a timer that stops the sampling after the specified duration.
        Timer(duration, () {
          this.pause();
        });
      });
    }
  }

  void restart() {
    PeriodicMeasure _measure = measure as PeriodicMeasure;
    frequency = Duration(milliseconds: _measure.frequency);
    duration = (_measure.duration != null) ? Duration(milliseconds: _measure.duration) : null;
    super.restart();
  }

  void stop() async {
    if (timer != null) timer.cancel();
    controller.close();
    super.stop();
  }
}

/// An abstract probe which can be used to collect data from a [bufferingEvents] stream,
/// every [frequency] for a period of [duration]. These events are buffered, and
/// once collected for the [duration], are collected from the [getDatum] method and
/// send to the main [events] stream.
///
/// See [LightProbe] for an example.
///
abstract class BufferingPeriodicStreamProbe extends PeriodicStreamProbe {
  /// The stream of events to be buffered.
  Stream<dynamic> get bufferingEvents;
  Stream<Datum> get stream => null; // Not used

  BufferingPeriodicStreamProbe(PeriodicMeasure measure) : super(measure);

  Future start() async {
    if (bufferingEvents != null) {
      super.start();

      // subscribing to the buffering events
      subscription = bufferingEvents.listen(onData, onError: onError, onDone: onDone);
      subscription.pause();
      restart();
    }
  }

  @override
  void resume() {
    super.resume();
    // create a recurrent timer that every [frequency] resumes the buffering.
    timer = Timer.periodic(frequency, (Timer t) {
      onPeriodStart();
      subscription.resume();
      // create a timer that stops the buffering after the specified [duration].
      Timer(duration, () {
        subscription.pause();
        onPeriodEnd();
        // collect the datum
        getDatum().then((datum) {
          if (datum != null) controller.add(datum);
        });
      });
    });
  }

  @override
  void pause() {
    super.pause();
    timer.cancel();
    // check if there are some buffered data that needs to be collected before pausing
    getDatum().then((datum) {
      if (datum != null) controller.add(datum);
    });
  }

  /// Handler called when sampling period starts.
  void onPeriodStart();

  /// Handler called when sampling period ends.
  void onPeriodEnd();

  /// Handler for handling onData events.
  void onData(dynamic event);

  /// Subclasses should implement / override this method to collect the [Datum].
  /// This method will be called every time data has been buffered for a [duration]
  /// and should return the final [Datum] for the buffered data.
  Future<Datum> getDatum();
}
