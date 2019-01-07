/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of runtime;

//---------------------------------------------------------------------------------------
//                                 PROBE STATE MACHINE
//---------------------------------------------------------------------------------------

enum ProbeStateType { created, initialized, resumed, paused, stopped }

abstract class ProbeState {
  ProbeStateType get type;
  void initialize(Measure measure);
  Future start();
  void pause();
  void resume();
  void restart();
  void stop();
}

abstract class AbstractProbeState implements ProbeState {
  ProbeStateType type;
  AbstractProbe probe;
  AbstractProbeState(this.probe, this.type) : assert(probe != null);

  // A probe can be stopped in all states.
  void stop() {
    print('Stopping $probe');
    probe.onStop();
    probe._state = StoppedState(probe);
  }
}

class CreatedState extends AbstractProbeState implements ProbeState {
  CreatedState(Probe probe) : super(probe, ProbeStateType.created);

  void initialize(Measure measure) {
    assert(measure != null, 'A Probe cannot be initialized with a null Measure.');
    print('Initializing $probe');
    probe.onInitialize(measure);
    probe._state = InitializedState(probe);
  }

  Future start() {}
  void restart() {}
  void pause() {}
  void resume() {}
}

class InitializedState extends AbstractProbeState implements ProbeState {
  InitializedState(Probe probe) : super(probe, ProbeStateType.initialized);

  void initialize(Measure measure) {}

  Future start() {
    print('Starting $probe');
    probe._state = ResumedState(probe);
    return probe.onStart();
  }

  void restart() {}
  void pause() {}
  void resume() {}
}

class ResumedState extends AbstractProbeState implements ProbeState {
  ResumedState(Probe probe) : super(probe, ProbeStateType.resumed);

  void initialize(Measure measure) {}
  Future start() {}
  void restart() {
    print('Retarting $probe');
    probe._state = ResumedState(probe);
    probe.onRestart();
  }

  void pause() {
    print('Pausing $probe');
    probe.onPause();
    probe._state = PausedState(probe);
  }

  void resume() {}
}

class PausedState extends AbstractProbeState implements ProbeState {
  PausedState(Probe probe) : super(probe, ProbeStateType.paused);

  void initialize(Measure measure) {}
  Future start() {}
  void restart() {
    print('Retarting $probe');
    probe.onRestart();
    probe._state = ResumedState(probe);
  }

  void pause() {}

  void resume() {
    print('Resuming $probe');
    probe.onResume();
    probe._state = ResumedState(probe);
  }
}

class StoppedState extends AbstractProbeState implements ProbeState {
  StoppedState(Probe probe) : super(probe, ProbeStateType.stopped);

  // in a stopped state, a probe does not respond to any state changes.
  void initialize(Measure measure) {}
  Future start() {}
  void restart() {}
  void pause() {}
  void resume() {}
}

//---------------------------------------------------------------------------------------
//                                        PROBES
//---------------------------------------------------------------------------------------

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
  /// The runtime state of this probe.
  ProbeState get state;

  /// The [Measure] that configures this probe.
  Measure get measure;

  /// A [Stream] generating sensor data events from this probe.
  Stream<Datum> get events;

  /// A printer-friendly name for this probe. Takes its name from [Measure.name] as default.
  String get name;

  /// Initialize the probe with the specified [Measure].
  void initialize(Measure measure);

  /// Start the probe();
  Future start();

  /// Pause the probe. The probe is paused until [resume] or [restart] is called.
  void pause();

  /// Resume the probe.
  void resume();

  /// Restart the probe. This forces the probe to reload its configuration from
  /// its [Measure] and restart sampling accordingly. If a new [measure] is
  /// to be used, this new measure must be specified in the
  /// [initialize] method before calling restart.
  ///
  /// This methods is used when sampling configuration is adapted, e.g. as
  /// part of the power-awareness.
  void restart();

  /// Stop the probe. Once a probe is stopped, it cannot be started again.
  /// If you need to restart a probe, use the [restart] or [pause] and [resume] methods.
  void stop();
}

/// An abstract implementation of a [Probe] to extend from.
abstract class AbstractProbe with MeasureListener implements Probe {
  /// Is this probe enables, i.e. should it be resumed or paused.
  ///
  /// Reflects the [enabled] in [Measure] if measure has be set via the [initialize] method.
  /// Otherwise returns true.
  bool get enabled => (measure != null) ? measure.enabled : true;

  ProbeState _state;
  ProbeState get state => _state;

  String name;

  Measure _measure;
  Measure get measure => _measure;

  AbstractProbe({this.name}) {
    _state = CreatedState(this);
  }

  void initialize_old(Measure measure) {
    assert(measure != null, 'A Probe cannot be initialized with a null Measure.');
    //_state = ProbeState.initialized;
    _measure = measure;
    name ??= measure.name;
    //measure.adapt(measure);
    measure.addMeasureListener(this);
  }

  void initialize(Measure measure) => state.initialize(measure);
  Future start() => state.start();
  void restart() => state.restart();
  void pause() => state.pause();
  void resume() => state.resume();
  void stop() => state.stop();

  void onInitialize(Measure measure) {
    _measure = measure;
    name ??= measure.name;
    measure.addMeasureListener(this);
  }

  Future onStart();
  void onResume();
  void onPause();

  void onRestart() {
    if (enabled)
      resume();
    else
      pause();
  }

  void onStop() {}

  Future start_old() async {
    restart();
    print('$name probe started');
  }

  void pause_old() async {
//    _state = ProbeState.paused;
//    print('$name probe paused');
  }

  void resume_old() async {
//    if (state == ProbeState.stopped) throw SensingException('Probe has been stopped and cannot be resumed.');
//    _state = ProbeState.resumed;
//    print('$name probe resumed');
  }

  void restart_old() {
//    if (state == ProbeState.stopped) throw SensingException('Probe has been stopped and cannot be (re-)started.');
//    if (enabled)
//      resume();
//    else
//      pause();
  }

  void stop_old() async {
//    _state = ProbeState.stopped;
//    print('$name probe stopped');
  }

  void hasChanged(Measure measure) {
    print('...measure $measure changed for $name probe.');
    restart();
  }
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

  StreamProbe({String name}) : super(name: name);

  Stream<Datum> get events => controller.stream;

  /// The a [Stream] of data items from this probe. Should be implemented by
  /// the specific probes implementing this [StreamProbe] class.
  Stream<Datum> get stream;

  Future onStart() async {
    if (stream != null) {
      subscription = stream.listen(onData, onError: onError, onDone: onDone);
      //subscription.pause();
    }
  }

  void onPause() {
    if (subscription != null) subscription.pause();
  }

  void onResume() {
    if (subscription != null) subscription.resume();
  }

  void onStop() async {
    if (subscription != null) subscription.cancel();
    controller.close();
  }

  void onData(Datum event) => controller.add(event);

  void onError(error) => controller.addError(error);

  void onDone() => controller.close();
}

/// A [DatumProbe] can collect one piece of [Datum], send its to its stream, and then stops.
///
/// The [Datum] to be collected is implemented in the [getDatum] method.
abstract class DatumProbe extends AbstractProbe {
  DatumProbe({String name}) : super(name: name);

  Stream<Datum> get events => Stream.fromFuture(getDatum());

  Future onStart() {}
  void onResume() {}
  void onPause() {}

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

  PeriodicDatumProbe({String name}) : super(name: name);

  Stream<Datum> get events => controller.stream;

//  void initialize(Measure measure) {
//    assert(measure is PeriodicMeasure, "PeriodicDatumProbe must be initiaized with PeriodicMeasure");
//    super.initialize(measure);
//  }

  // TODO - can be removed if this works.
//  Future start() async {
//    super.start();
//  }

  void onInitialize(Measure measure) {
    assert(measure is PeriodicMeasure, 'A PeriodicDatumProbe must be intialized with a PeriodicMeasure');
    super.onInitialize(measure);
    frequency = Duration(milliseconds: (measure as NoiseMeasure).frequency);
    duration = ((measure as NoiseMeasure).duration != null)
        ? Duration(milliseconds: (measure as NoiseMeasure).duration)
        : null;
  }

  Future onStart() async {
    onResume();
  }

  void onResume() {
    super.onResume();
    // create a recurrent timer that resumes sampling every [frequency].
    timer = Timer.periodic(frequency, (Timer t) async {
      try {
        getDatum().then((Datum data) {
          controller.add(data);
        });
      } catch (e, s) {
        controller.addError(e, s);
      }
    });
  }

  void onPause() {
    super.onPause();
    print('...pause() in $this, measure: $measure');
    timer.cancel();
    print('... timer: ${timer.isActive}');
  }

  void onRestart() {
    print('...restart() in $this, measure: $measure');
    frequency = Duration(milliseconds: (measure as PeriodicMeasure).frequency);
    duration = ((measure as PeriodicMeasure).duration != null)
        ? Duration(milliseconds: (measure as PeriodicMeasure).duration)
        : null;
    super.onRestart();
  }

  void onStop() async {
    if (timer != null) timer.cancel();
    controller.close();
    super.onStop();
  }
}

/// A periodic probe listening on a stream. Listening is done periodically as specified in a
/// [PeriodicMeasure] listening on intervals every [frequency] for a period of [duration]. During this
/// period, all events are forwarded to this probes [events] stream.
abstract class PeriodicStreamProbe extends StreamProbe {
  Timer timer;
  Duration frequency, duration;

  PeriodicStreamProbe({String name}) : super(name: name);

//  void initialize(Measure measure) {
//    assert(measure is PeriodicMeasure, "PeriodicStreamProbe must be initiaized with PeriodicMeasure");
//    super.initialize(measure);
//  }

  // TODO - can be removed if this works.
//  Future start() async {
//    super.start();
//  }

  void onResume() {
    super.onResume();
    if (subscription != null) {
      // pause events for now.
      subscription.pause();
      // create a recurrent timer that wait (pause) and then resume the sampling.
      timer = Timer.periodic(frequency, (Timer t) {
        // TODO - is this right?
        this.resume();
        // create a timer that stops the sampling after the specified duration.
        Timer(duration, () {
          // TODO - is this right?
          this.pause();
        });
      });
    }
  }

  void onPause() {
    timer.cancel();
    super.onPause();
  }

  void onRestart() {
    frequency = Duration(milliseconds: (measure as PeriodicMeasure).frequency);
    duration = ((measure as PeriodicMeasure).duration != null)
        ? Duration(milliseconds: (measure as PeriodicMeasure).duration)
        : null;
    super.onRestart();
  }

  void onStop() async {
    if (timer != null) timer.cancel();
    controller.close();
    super.onStop();
  }
}

/// An abstract probe which can be used to sample data from a [bufferingEvents] stream,
/// every [frequency] for a period of [duration]. These events are buffered, and
/// once collected for the [duration], are collected from the [getDatum] method and
/// send to the main [events] stream.
///
/// When sampling starts, the [onSamplingStart] handle is called.
/// When the sampling window ends, the [onSamplingEnd] handle is called.
///
/// See [LightProbe] for an example.
///
abstract class BufferingPeriodicStreamProbe extends PeriodicStreamProbe {
  /// The stream of events to be buffered.
  Stream<dynamic> get bufferingEvents;
  Stream<Datum> get stream => null; // Not used

  BufferingPeriodicStreamProbe({String name}) : super(name: name);

  Future onStart() async {
    if (bufferingEvents != null) {
      // subscribing to the buffering events
      subscription = bufferingEvents.listen(onData, onError: onError, onDone: onDone);
      subscription.pause();
      //super.start();
    } else {
      throw SensingException('Buffering event stream must not be null');
    }
  }

  void onResume() {
    //super.onResume();
    // create a recurrent timer that every [frequency] resumes the buffering.
    timer = Timer.periodic(frequency, (Timer t) {
      onSamplingStart();
      subscription.resume();
      // create a timer that stops the buffering after the specified [duration].
      Timer(duration, () {
        subscription.pause();
        onSamplingEnd();
        // collect the datum
        getDatum().then((datum) {
          if (datum != null) controller.add(datum);
        });
      });
    });
  }

  @override
  void onPause() {
    super.onPause();
    // check if there are some buffered data that needs to be collected before pausing
    getDatum().then((datum) {
      if (datum != null) controller.add(datum);
    });
  }

  /// Handler called when sampling period starts.
  void onSamplingStart();

  /// Handler called when sampling period ends.
  void onSamplingEnd();

  /// Handler for handling onData events.
  void onData(dynamic event);

  /// Subclasses should implement / override this method to collect the [Datum].
  /// This method will be called every time data has been buffered for a [duration]
  /// and should return the final [Datum] for the buffered data.
  Future<Datum> getDatum();
}
