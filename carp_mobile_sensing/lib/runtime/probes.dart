/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of runtime;

/// An interface for classes that can listen on [Probe]s.
abstract class ProbeListener {
  /// Is called when a [Probe] has collected a piece of [Datum].
  void notify(Datum datum);
}

/// A [Probe] is responsible for collecting data.
/// This class is an interface class used for implementing specific
/// probes as sub-classes.
///
/// Probes return sensed data in a [Stream] as [events]. This is the main
/// usage of a probe. For example, to listens to events and print them;
///
/// `````dart
///  probe.events.forEach(print);
/// ````
abstract class Probe {
  /// A [Stream] generating sensor data events from this probe.
  Stream<Datum> get events;

  /// The [Measure] that configures this probe.
  Measure get measure;
  bool get isRunning;

  ///A printer-friendly name for this probe. Takes its name from [Measure.name] as default.
  String name;

  void addProbeListener(ProbeListener listener);
  void removeProbeListener(ProbeListener listener);
  Future notifyAllListeners(Datum datum);

  /// Initialize the probe.
  void initialize();

  ///Start the probe();
  Future start();

  /// Pause the probe. The probe is paused until [resume()] is called.
  void pause();

  /// Resume the probe.
  void resume();

  /// Reset the probe.
  void reset();

  /// Stop the probe. Once a probe is stopped, it cannot be started again.
  ///If you need to stop/restart a probe, use the [pause()] and [resume()] methods.
  void stop();
}

/// An abstract implementation of a [Probe] to extend from.
abstract class AbstractProbe implements Probe {
  Measure _measure;
  Measure get measure => _measure;

  bool _isRunning = false;
  bool get isRunning => _isRunning;

  String name;

  bool _isEnabled = false;
  bool get isEnabled => _isEnabled;
  void enable() {
    _isEnabled = true;
  }

  void disable() {
    _isEnabled = true;
  }

  AbstractProbe();
  AbstractProbe.init(Measure measure)
      : assert(measure != null, 'A Probe cannot be initialized with a null Measure.'),
        this._measure = measure;

  List<ProbeListener> _listener = new List<ProbeListener>();
  void addProbeListener(ProbeListener listener) {
    _listener.add(listener);
  }

  void removeProbeListener(ProbeListener listener) {
    _listener.remove(listener);
  }

  Future notifyAllListeners(Datum datum) async {
    for (ProbeListener l in _listener) {
      l.notify(datum);
    }
  }

  void initialize() {
    _isRunning = false;
  }

  Future start() async {
    _isRunning = true;
    print(name.toString() + ' probe started');
  }

  void pause() async {
    _isRunning = false;
  }

  void resume() async {
    _isRunning = true;
  }

  void reset() async {
    _isRunning = false;
  }

  void stop() async {
    _isRunning = false;
  }

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
  StreamController<Datum> controller = StreamController<Datum>();

  StreamProbe(Measure measure)
      : assert(measure != null),
        super.init(measure);

  Stream<Datum> get events => controller.stream;

  /// The a [Stream] of data items from this probe. Should be implemented by
  /// the specific probes implementing this [StreamProbe] class.
  Stream<Datum> get stream;

  Future start() async {
    super.start();
    print('>> in ${this.runtimeType}, subscribing to $stream');
    if (stream != null) subscription = stream.listen(onData, onError: onError, onDone: onDone);
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
    subscription.cancel();
    controller.close();
    super.stop();
  }

  void onData(Datum event) async {
    if (_isRunning) controller.add(event);
  }

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
  StreamController<Datum> controller = StreamController<Datum>();
  Duration frequency, duration;

  PeriodicDatumProbe(PeriodicMeasure measure)
      : assert(measure != null),
        assert(measure.frequency != null, 'Measure frequency cannot be null for a PeriodicProbe.'),
        frequency = Duration(milliseconds: measure.frequency),
        duration = (measure.duration != null) ? Duration(milliseconds: measure.duration) : null,
        super(measure);

  Stream<Datum> get events => controller.stream;

  Future start() async {
    super.start();
    this.resume();
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
        frequency = Duration(milliseconds: measure.frequency),
        duration = (measure.duration != null) ? Duration(milliseconds: measure.duration) : null,
        super(measure);

  Future start() async {
    super.start();
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

  void stop() async {
    if (timer != null) timer.cancel();
    controller.close();
    super.stop();
  }
}

/// An abstract probe which can be used to collect data from a [bufferEvents] stream,
/// every [frequency] for a period of [duration]. These events are buffered, and
/// once collected for the [duration], are collected from the [getDatum] method and
/// send to the main [events] stream.
///
/// See [LightProbe] for an example.
///
abstract class BufferingPeriodicStreamProbe extends PeriodicStreamProbe {
  /// The stream of events to be buffered.
  Stream<dynamic> get bufferEvents;
  Stream<Datum> get stream => null; // is not used for this probe.

  BufferingPeriodicStreamProbe(PeriodicMeasure measure) : super(measure);

  Future start() async {
    _isRunning = true;

    // starting the subscription to the buffered events
    subscription = bufferEvents.listen(onData, onError: onError, onDone: onDone, cancelOnError: true);
    subscription.pause();
    // create a recurrent timer that wait (pause) and then resume the buffering.
    timer = Timer.periodic(frequency, (Timer t) {
      this.resume();
      // create a timer that stops the buffering after the specified duration.
      Timer(duration, () {
        this.pause();
      });
    });
  }

  @override
  void pause() {
    super.pause();
    getDatum().then((datum) => controller.add(datum));
  }

  /// Handler for handling onData events.
  void onData(dynamic event);

  /// Subclasses should implement / override this method to collect the [Datum].
  /// This method will be called every time data has been buffered for a [duration]
  /// and should return the final [Datum] for the buffered data.
  Future<Datum> getDatum();
}
