/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of runtime;

//---------------------------------------------------------------------------------------
//                                        PROBE
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
  /// Is this probe enabled, i.e. should run.
  bool get enabled;

  /// The type of this probe according to [DataType].
  String get type;

  /// The runtime state of this probe.
  ProbeState get state;

  /// The runtime state changes of this probe.
  Stream<ProbeStateType> get stateEvents;

  /// The [Measure] that configures this probe.
  Measure get measure;

  /// A printer-friendly name for this probe. Takes its name from [Measure.name] as default.
  String get name;

  /// A [Stream] generating sensor data events from this probe.
  Stream<Datum> get events;

  /// Initialize the probe before starting it.
  void initialize();

  /// Start the probe();
  void start();

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
  StreamController<ProbeStateType> _stateEventController = StreamController.broadcast();
  Stream<ProbeStateType> get stateEvents => _stateEventController.stream;

  bool get enabled => measure.enabled;
  String get type => measure.type.name;
  String get name => measure.name;

  ProbeState _state;
  ProbeState get state => _state;
  void _setState(ProbeState state) {
    _state = state;
    _stateEventController.add(state.type);
  }

  Measure _measure;
  Measure get measure => _measure;

  AbstractProbe(Measure measure) : assert(measure != null, 'Probe cannot be created with a null measure.') {
    _measure = measure;
    measure.addMeasureListener(this);
    _state = CreatedState(this);
  }

  // ProbeState handlers
  void initialize() => state.initialize();
  void start() => state.start();
  void restart() => state.restart();
  void pause() => state.pause();
  void resume() => state.resume();
  void stop() => state.stop();

  /// Callback for initialization of probe
  void onInitialize() {}

  /// Callback for starting probe
  void onStart();

  /// Callback for resuming probe
  void onResume();

  /// Callback for pausing probe
  void onPause();

  /// Callback for restarting probe
  void onRestart();

  /// Callback for stopping probe
  void onStop() {
    _stateEventController.close();
  }

  void hasChanged(Measure measure) {
    print('...measure $measure changed for $name probe.');
    restart();
  }
}

//---------------------------------------------------------------------------------------
//                                 PROBE STATE MACHINE
//
//         created -> initialized -> resumed <-> paused *-> stopped
//
//---------------------------------------------------------------------------------------

enum ProbeStateType { created, initialized, resumed, paused, stopped }

abstract class ProbeState {
  ProbeStateType get type;
  void initialize();
  void start();
  void pause();
  void resume();
  void restart();
  void stop();
}

abstract class AbstractProbeState implements ProbeState {
  ProbeStateType type;
  AbstractProbe probe;
  AbstractProbeState(this.probe, this.type) : assert(probe != null);

  // pr. default, a probe cannot be initialized while running -- only when created
  void initialize() {}

  // Default stop behavior. A probe can be stopped in all states.
  void stop() {
    print('Stopping $probe');
    probe.onStop();
    probe._setState(StoppedState(probe));
  }
}

class CreatedState extends AbstractProbeState implements ProbeState {
  CreatedState(Probe probe) : super(probe, ProbeStateType.created);

  void initialize() {
    print('Initializing $probe');
    probe.onInitialize();
    probe._setState(InitializedState(probe));
  }

  void start() {} // cannot be started
  void restart() {} // cannot be restarted
  void pause() {} // cannot be paused
  void resume() {} // cannot be resumed
}

class InitializedState extends AbstractProbeState implements ProbeState {
  InitializedState(Probe probe) : super(probe, ProbeStateType.initialized);

  void start() {
    print('Starting $probe');
    probe.onStart();
    if (probe.enabled) {
      probe.onResume();
      probe._setState(ResumedState(probe));
    } else {
      probe.onPause();
      probe._setState(PausedState(probe));
    }
  }

  void restart() {} // cannot be restarted before started
  void pause() {} // cannot be paused before started
  void resume() {} // cannot be resumed before started
}

class ResumedState extends AbstractProbeState implements ProbeState {
  ResumedState(Probe probe) : super(probe, ProbeStateType.resumed);

  void start() {} // cannot be started (again)

  void restart() {
    print('Restarting $probe');
    probe.pause(); // first pause probe, setting it in a paused state
    probe.onRestart();
    if (probe.enabled) // check if it has been enabled
      probe.resume();
  }

  void pause() {
    print('Pausing $probe');
    probe.onPause();
    probe._setState(PausedState(probe));
  }

  void resume() {} // resuming a resumed probe does nothing
}

class PausedState extends AbstractProbeState implements ProbeState {
  PausedState(Probe probe) : super(probe, ProbeStateType.paused);

  void start() {} // cannot be started (again)

  void restart() {
    print('Restarting $probe');
    probe.onRestart();
    if (probe.enabled) // check if it has been enabled
      probe.resume();
  }

  void pause() {} // pausing a paused probe does nothing

  void resume() {
    print('Resuming $probe');
    probe.onResume();
    probe._setState(ResumedState(probe));
  }
}

class StoppedState extends AbstractProbeState implements ProbeState {
  StoppedState(Probe probe) : super(probe, ProbeStateType.stopped);

  // in a stopped state, a probe does not respond to any state changes.
  void start() {}
  void restart() {}
  void pause() {}
  void resume() {}
}

//---------------------------------------------------------------------------------------
//                                SPECIALIZED PROBES
//---------------------------------------------------------------------------------------

/// A [DatumProbe] can collect one piece of [Datum], send its to its stream, and then stops.
///
/// The [Datum] to be collected is implemented in the [getDatum] method.
abstract class DatumProbe extends AbstractProbe {
  DatumProbe(Measure measure) : super(measure);

  Stream<Datum> get events => Stream.fromFuture(getDatum());

  void onStart() {}
  void onRestart() {}
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

  PeriodicDatumProbe(PeriodicMeasure measure) : super(measure) {
    frequency = Duration(milliseconds: (measure as PeriodicMeasure).frequency);
    duration = ((measure as PeriodicMeasure).duration != null)
        ? Duration(milliseconds: (measure as PeriodicMeasure).duration)
        : null;
  }

  Stream<Datum> get events => controller.stream;

  void onRestart() {
    print('...restart() in $this, measure: $measure');
    frequency = Duration(milliseconds: (measure as PeriodicMeasure).frequency);
    duration = ((measure as PeriodicMeasure).duration != null)
        ? Duration(milliseconds: (measure as PeriodicMeasure).duration)
        : null;
  }

  void onResume() {
    super.onResume();
    print('...resume() in $this, measure: $measure');
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

  void onStop() {
    if (timer != null) timer.cancel();
    controller.close();
    super.onStop();
  }
}

/// An abstract class used to create a probe that listen to events from a [Stream].
///
/// Subclasses should implement the [get stream] method.
/// See [LocationProbe] for an example.
abstract class StreamProbe extends AbstractProbe {
  Stream<Datum> _stream;
  StreamSubscription<dynamic> subscription;
  StreamController<Datum> controller = StreamController<Datum>.broadcast();
  Stream<Datum> get events => controller.stream;

  /// Creates a [StreamProbe] handling the [stream].
  StreamProbe(Measure measure, Stream<Datum> stream)
      : assert(stream != null, 'Stream cannot be null in a StreamProbe'),
        super(measure) {
    this._stream = stream;
  }

  void onStart() {
    subscription = _stream.listen(onData, onError: onError, onDone: onDone);
  }

  void onRestart() {}

  void onPause() {
    if (subscription != null) subscription.pause();
  }

  void onResume() {
    if (subscription != null) subscription.resume();
  }

  void onStop() {
    if (subscription != null) subscription.cancel();
    controller.close();
  }

  void onData(Datum event) => controller.add(event);

  void onError(error) => controller.addError(error);

  void onDone() => controller.close();
}

/// A periodic probe listening on a stream. Listening is done periodically as specified in a
/// [PeriodicMeasure] listening on intervals every [frequency] for a period of [duration]. During this
/// period, all events are forwarded to this probes [events] stream.
abstract class PeriodicStreamProbe extends StreamProbe {
  Timer timer;
  Duration frequency, duration;

  /// Creates a [PeriodicStreamProbe] handling the [stream] in a periodic manner.
  PeriodicStreamProbe(PeriodicMeasure measure, Stream<Datum> stream) : super(measure, stream) {
    frequency = Duration(milliseconds: measure.frequency);
    duration = (measure.duration != null) ? Duration(milliseconds: measure.duration) : null;
  }

  void onInitialize() {
    super.onInitialize();
  }

  void onRestart() {
    print('...restart() in $this, measure: $measure');
    frequency = Duration(milliseconds: (measure as PeriodicMeasure).frequency);
    duration = ((measure as PeriodicMeasure).duration != null)
        ? Duration(milliseconds: (measure as PeriodicMeasure).duration)
        : null;
  }

  void onResume() {
    if (subscription != null) {
      // create a recurrent timer that wait (pause) and then resume the sampling.
      timer = Timer.periodic(frequency, (Timer t) {
        subscription.resume();
        // create a timer that pause the sampling after the specified duration.
        Timer(duration, () {
          subscription.pause();
        });
      });
    }
  }

  void onPause() {
    timer.cancel();
    super.onPause();
  }

  void onStop() async {
    if (timer != null) timer.cancel();
    controller.close();
    super.onStop();
  }
}

/// An abstract probe which can be used to sample data from a [_bufferingStream] stream,
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
  Stream<dynamic> _bufferingStream;

  BufferingPeriodicStreamProbe(PeriodicMeasure measure, Stream<dynamic> bufferingStream)
      : assert(bufferingStream != null, 'Buffering event stream must not be null'),
        super(measure,
            Stream<Datum>.empty()) // we don't use the stream in the super class so we give it an empty non-null stream
  {
    _bufferingStream = bufferingStream;
  }

  void onStart() async {
    // subscribing to the buffering stream events
    subscription = _bufferingStream.listen(onData, onError: onError, onDone: onDone);
  }

  void onResume() {
    subscription.resume();
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

  void onPause() {
    timer.cancel();
    subscription.pause();
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
