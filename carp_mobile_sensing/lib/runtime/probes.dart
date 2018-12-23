/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of runtime;

/// An enumeration of different probe types.
enum ProbeType {
  unknown,
  manager, // a [StudyManager] working as a probe
  executor, // the [TaskExecutor] which is also a probe
  datum, // a probe of type [DatumProbe]
  listening, // probe of type [ListeningProbe]
  polling, // probe of type [PollingProbe]
}

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

  Measure get measure;
  ProbeType get probeType;
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
  Stream<Datum> _events;

  ProbeType get probeType => ProbeType.unknown;

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
  AbstractProbe.init(this._measure);

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

  Stream<Datum> get events {
    if (_events == null) {
      _events = stream;
    }
    return _events;
  }

  /// The a [Stream] of data items from this probe. Should be implemented by
  /// the specific probes implementing this [AbstractProbe] class.
  Stream<Datum> get stream;
}

/// A [DatumProbe] can collect one piece of data and then returns.
/// Used to collect a single piece of information, which may take a while to collect.
/// For example, network dependent sensors.
abstract class DatumProbe extends AbstractProbe {
  DatumProbe(_measure) : super.init(_measure);

  @override
  ProbeType get probeType => ProbeType.datum;

  @override
  Future start() async {
    super.start();
    Datum datum = await this.getDatum();

    this.notifyAllListeners(datum);
    super.stop();
  }

  /// Subclasses should implement this method to collect a [Datum].
  Future<Datum> getDatum();
}

/// Listening Probes are triggered by a change in state within the underlying device or sensor.
/// For example, the [LocationProbe] register itself as a listener on the location API
/// and collects location data via a callback method.
///
/// Listening probes should (at least) implement / override the initialize() and start()
/// methods. In the initialize() method, listening to sensors are set up and listening is
/// started in the start() method. When the probe receives callbacks from the sensor,
/// [ProbeListener]s are notified via the [this.notifyAllListeners(datum)] method whenever a
/// new [Datum] is available.
abstract class ListeningProbe extends AbstractProbe {
  ListeningProbe(Measure measure)
      : assert(measure != null),
        super.init(measure);

  @override
  ProbeType get probeType => ProbeType.listening;
}

/// An abstract super class implementation useful for listening on
/// Flutter platform StreamSubscription events.
///
/// See [BatteryProbe] for an example of how to extend this class.
abstract class StreamSubscriptionListeningProbe extends ListeningProbe {
  StreamSubscription<dynamic> subscription;

  StreamSubscriptionListeningProbe(Measure measure) : super(measure);

  @override
  void initialize() {
    super.initialize();
  }

  @override
  Future start() async {
    super.start();
  }

  @override
  void stop() {
    subscription.cancel();
    subscription = null;
  }

  @override
  void pause() {
    subscription.pause();
  }

  @override
  void resume() {
    subscription.resume();
  }

  void onData(dynamic event);

  void onDone() {}

  void onError(error) {
    ErrorDatum _ed = new ErrorDatum(measure: measure, message: error.toString());
    this.notifyAllListeners(_ed);
  }
}

/// Polling Probes are triggered at regular intervals, specified by its [frequency] property
/// in a [PeriodicMeasure].
///
///When triggered, Polling Probes ask the device (and perhaps the user)
///for some type of information and then notifies its [ProbeListener]s
abstract class PollingProbe extends AbstractProbe {
  Duration _pollingFrequency;
  Timer _timer;

  PollingProbe(PeriodicMeasure measure) : super.init(measure);

  @override
  ProbeType get probeType => ProbeType.polling;

  Future start() async {
    // need to make sure we have a [PollingProbeMeasure] measure, containing a frequency configuration.
    assert(measure is PeriodicMeasure);
    int _frequency = (measure as PeriodicMeasure).frequency;
    _pollingFrequency = new Duration(milliseconds: _frequency);

    super.start();

    _timer = new Timer.periodic(_pollingFrequency, (Timer timer) async {
      Datum datum = await this.getDatum();
      this.notifyAllListeners(datum);
    });
  }

  @override
  void stop() async {
    if (_timer != null) _timer.cancel();
    super.stop();
  }

  /// Subclasses should implement / override this method to collect the [Datum].
  /// This method will be called every time the polling is scheduled as specified
  /// in the [Measure] interval.
  Future<Datum> getDatum();
}

/// An abstract super class implementation useful for implementing probes that
/// use a [PeriodicMeasure].
///
/// See [AccelerometerProbe] for an example of how to use this class.
abstract class PeriodicMeasureProbe extends StreamSubscriptionListeningProbe {
  MultiDatum data;

  PeriodicMeasureProbe(PeriodicMeasure measure) : super(measure);

  /// This has to be overwritten in the sub-class to return the [Stream] producing the events.
  Stream getStream();

  @override
  Future start() async {
    super.start();

    // starting the subscription to the accelerometer events
    subscription = getStream().listen(onData, onError: onError, onDone: onDone, cancelOnError: true);

    // pause it for now.
    subscription.pause();

    int _frequency = (measure as PeriodicMeasure).frequency;
    Duration _pause = new Duration(milliseconds: _frequency);
    int _duration = (measure as PeriodicMeasure).duration;
    Duration _samplingDuration = new Duration(milliseconds: _duration);

    // create a recurrent timer that wait (pause) and then resume the sampling.
    Timer.periodic(_pause, (Timer timer) {
      this.resume();

      // create a timer that stops the sampling after the specified duration.
      Timer(_samplingDuration, () {
        this.pause();
      });
    });
  }

  @override
  void stop() {
    if (data != null) this.notifyAllListeners(data);
    subscription.cancel();
    subscription = null;
    data = null;
  }

  @override
  void resume() {
    data = new MultiDatum(measure: measure);
    subscription.resume();
  }

  @override
  void pause() {
    if (data != null) this.notifyAllListeners(data);
    data = null;
    subscription.pause();
  }

  void onDone() {
    if (data != null) this.notifyAllListeners(data);
  }

  void onError(error) {
    ErrorDatum ed = new ErrorDatum(measure: measure, message: error.toString());
    this.notifyAllListeners(ed);
  }
}
