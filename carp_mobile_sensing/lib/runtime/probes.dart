/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of runtime;

//---------------------------------------------------------------------------------------
//                                        PROBES
//---------------------------------------------------------------------------------------

/// The state of a [Probe].
///
/// The runtime state has the following state machine:
///
///    +----------------------------------------------------------------+     +-----------+
///    |   +---------+    +-------------+    +---------+     +--------+ |  -> | undefined |
///    |   | created | -> | initialized | -> | resumed | <-> | paused | |     +-----------+
///    |   +---------+    +-------------+    +---------+     +--------+ |  -> | stopped   |
///    +----------------------------------------------------------------+     +-----------+
///
enum ProbeState {
  /// Created and ready to be initialized.
  created,

  /// Initialized and ready to be resumed (i.e., started).
  initialized,

  /// Resumed and active in data collection.
  resumed,

  /// Paused and not collecting data.
  paused,

  /// Stopped and can no longer collect data.
  stopped,

  /// Undefined state.
  ///
  /// Typically the probe becomes undefined if it cannot be initialized
  /// or if this probe is not supported on the specific phone / OS.
  undefined
}

/// A [Probe] is responsible for collecting data.
///
/// A probe's [state] can be set using the [initialize], [resume], [pause], and [stop] methods.
/// A [restart] can be used to restart a probe when its [measure] has changed (e.g. disabling the probe).
/// A probe can be stoped at any time.
/// If an error occurs the state of a probe becomes [undefined]. This is, for example, used when an exception
/// is caught or when a probe is not available (e.g. on iOS).
///
/// The [state] property reveals the probe's current runtime state.
/// The [stateEvents] is a stream of state changes which can be listen to as a broadcast stream.
///
/// Probes return sensed data in a [Stream] as [events]. This is the main
/// usage of a probe. For example, to listens to events and print them;
///
///     probe.events.forEach(print);
///
abstract class Probe {
  /// Is this probe enabled, i.e. available for collection of data using the [resume] method.
  bool get enabled;

  /// The type of this probe according to [DataType].
  String get type;

  /// The runtime state of this probe.
  ProbeState get state;

  /// The runtime state changes of this probe.
  ///
  /// This is useful for listening on state changes as specified in [ProbeState].
  /// Can e.g. be used in a [StreamBuilder] when showing the UI of a probe.
  /// The following example is taken from the CARP Mobile Sensing App
  ///
  ///       Widget buildProbeListTile(BuildContext context, ProbeModel probe) {
  ///           return StreamBuilder<ProbeStateType>(
  ///             stream: probe.stateEvents,
  ///             initialData: ProbeState.created,
  ///             builder: (context, AsyncSnapshot<ProbeState> snapshot) {
  ///               if (snapshot.hasData) {
  ///                 return ListTile(
  ///                   isThreeLine: true,
  ///                   leading: Icon(
  ///                     probe.icon.icon,
  ///                     size: 50,
  ///                     color: probe.icon.color,
  ///                   ),
  ///                   title: Text(probe.name),
  ///                   subtitle: Text(probe.description),
  ///                   trailing: probe.stateIcon,
  ///                 );
  ///               } else if (snapshot.hasError) {
  ///                 return Text('Error in probe state - ${snapshot.error}');
  ///              }
  ///              return Text('Unknown');
  ///           },
  ///         );
  ///       }
  /// This will update the trailing icon of the probe every time the probe change
  /// state (e.g. from `resumed` to `paused`).
  Stream<ProbeState> get stateEvents;

  /// The [Measure] that configures this probe.
  Measure get measure;

  /// A printer-friendly name for this probe. Takes its name from [Measure.name] as default.
  String get name;

  /// A [Stream] generating sensor data events from this probe.
  Stream<Datum> get events;

  /// Initialize the probe before starting it.
  ///
  /// The configuration of the probe is specified in the [measure].
  Future<void> initialize(Measure measure);

  /// Resume the probe.
  void resume();

  /// Pause the probe. The probe is paused until [resume] or [restart] is called.
  void pause();

  /// Restart the probe.
  ///
  /// This forces the probe to reload its configuration from
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
  StreamController<ProbeState> _stateEventController = StreamController.broadcast();
  Stream<ProbeState> get stateEvents => _stateEventController.stream;

  bool get enabled => measure.enabled ?? true;
  String get type => measure.type.name;
  String get name => measure.name ?? 'NO_NAME';

  ProbeState get state => _stateMachine.state;

  _ProbeStateMachine _stateMachine;
  void _setState(_ProbeStateMachine state) {
    _stateMachine = state;
    _stateEventController.add(state.state);
  }

  Measure _measure;
  Measure get measure => _measure;

  AbstractProbe() : super() {
    _stateMachine = _CreatedState(this);
  }

  // ProbeState handlers
  Future<void> initialize(Measure measure) async {
    assert(measure != null, 'Probe cannot be initialized with a null measure.');
    _measure = measure;
    measure.addMeasureListener(this);
    _stateMachine.initialize(measure);
  }

  void restart() => _stateMachine.restart();
  void pause() => _stateMachine.pause();
  void resume() => _stateMachine.resume();
  void stop() {
    _stateMachine.stop();
    _stateEventController.close();
  }

  void error() => _stateMachine.error();

  /// Callback for initialization of probe.
  Future<void> onInitialize(Measure measure);

  /// Callback for resuming probe
  Future<void> onResume();

  /// Callback for pausing probe
  Future<void> onPause();

  /// Callback for restarting probe
  Future<void> onRestart();

  /// Callback for stopping probe
  Future<void> onStop();

  /// Callback when this probe's [measure] has changed.
  void hasChanged(Measure measure) => restart();
}

//---------------------------------------------------------------------------------------
//                                 PROBE STATE MACHINE
//
//         created -> initialized -> resumed <-> paused *-> stopped/undefined
//
//---------------------------------------------------------------------------------------

// all of the below probe state machine classes are private and only used internally
// hence, they are not documented

abstract class _ProbeStateMachine {
  ProbeState get state;
  void initialize(Measure measure);
  void pause();
  void resume();
  void restart();
  void stop();
  void error();
}

abstract class _AbstractProbeState implements _ProbeStateMachine {
  ProbeState state;
  AbstractProbe probe;
  _AbstractProbeState(this.probe, this.state) : assert(probe != null);

  // Default behavior is to print a warning.
  // If a state supports this method, this behavior is overwritten in
  // the state implementation classes below.
  Future<void> initialize(Measure measure) async {
    warning("Trying to initialize a probe in a state where this can't be done - state : $state");
  }

  void restart() {
    warning("Trying to restart a probe in a state where this can't be done - state : $state");
  }

  void resume() {
    warning("Trying to resume a probe in a state where this can't be done - state : $state");
  }

  void pause() {
    warning("Trying to pause a probe in a state where this can't be done - state : $state");
  }

  // Default stop behavior. A probe can be stopped in all states.
  void stop() {
    print('Stopping ${probe.runtimeType}');
    probe._setState(_StoppedState(probe));
    probe.onStop();
  }

  // Default error behavior. A probe can become undefined in all states.
  void error() {
    print('Error in ${probe.runtimeType}');
    probe._setState(_UndefinedState(probe));
  }
}

class _CreatedState extends _AbstractProbeState implements _ProbeStateMachine {
  _CreatedState(Probe probe) : super(probe, ProbeState.created);

  Future<void> initialize(Measure measure) async {
    print('Initializing ${probe.runtimeType} - $measure');
    try {
      await probe.onInitialize(measure);
      probe._setState(_InitializedState(probe));
    } catch (error) {
      warning('Error initializing ${probe.runtimeType}. Probe is now in an undefined state.');
      probe._setState(_UndefinedState(probe));
    }
  }
}

class _InitializedState extends _AbstractProbeState implements _ProbeStateMachine {
  _InitializedState(Probe probe) : super(probe, ProbeState.initialized);

  void resume() {
    print('Resuming ${probe.runtimeType}');
    probe.onResume();
    probe._setState(_ResumedState(probe));
  }
}

class _ResumedState extends _AbstractProbeState implements _ProbeStateMachine {
  _ResumedState(Probe probe) : super(probe, ProbeState.resumed);

  void restart() {
    print('Restarting ${probe.runtimeType}');
    probe.pause(); // first pause probe, setting it in a paused state
    probe.onRestart();
    if (probe.enabled) // check if it has been enabled
      probe.resume();
  }

  void pause() {
    print('Pausing ${probe.runtimeType}');
    probe.onPause();
    probe._setState(_PausedState(probe));
  }
}

class _PausedState extends _AbstractProbeState implements _ProbeStateMachine {
  _PausedState(Probe probe) : super(probe, ProbeState.paused);

  void restart() {
    print('Restarting ${probe.runtimeType}');
    probe.onRestart();
    if (probe.enabled) // check if probe is enabled
      probe.resume();
  }

  void resume() {
    if (probe.enabled) {
      print('Resuming ${probe.runtimeType}');
      probe.onResume();
      probe._setState(_ResumedState(probe));
    }
  }
}

class _StoppedState extends _AbstractProbeState implements _ProbeStateMachine {
  _StoppedState(Probe probe) : super(probe, ProbeState.stopped);
}

class _UndefinedState extends _AbstractProbeState implements _ProbeStateMachine {
  _UndefinedState(Probe probe) : super(probe, ProbeState.undefined);
}

//---------------------------------------------------------------------------------------
//                                SPECIALIZED PROBES
//---------------------------------------------------------------------------------------

/// When resumed collects one piece of [Datum], send its to its [events] stream, and then pause.
///
/// The [Datum] to be collected should be implemented in the [getDatum] method.
abstract class DatumProbe extends AbstractProbe {
  StreamController<Datum> controller = StreamController<Datum>.broadcast();
  Stream<Datum> get events => controller.stream;

  Future<void> onInitialize(Measure measure) async {}

  Future<void> onRestart() async {}

  Future<void> onResume() async {
    Datum data = await getDatum().catchError((err) => controller.addError(err));
    if (data != null) controller.add(data);
  }

  Future<void> onPause() async {}
  Future<void> onStop() async {}

  /// Subclasses should implement this method to collect a [Datum].
  Future<Datum> getDatum();
}

/// A periodic probe is triggered at regular intervals, specified by its [frequency] property
/// in a [PeriodicMeasure].
///
/// When triggered, a periodic probe collect a piece of data ([Datum]) using the [getDatum] method.
/// Note that the [duration] parameter in a [PeriodicMeasure] is **not** used.
///
/// See [MemoryProbe] for an example.
abstract class PeriodicDatumProbe extends DatumProbe {
  Timer timer;
  StreamController<Datum> controller = StreamController<Datum>.broadcast();
  Duration frequency, duration;

  Stream<Datum> get events => controller.stream;

  Future<void> onInitialize(Measure measure) async {
    assert(measure is PeriodicMeasure);
    frequency = Duration(milliseconds: (measure as PeriodicMeasure).frequency);
    duration = ((measure as PeriodicMeasure).duration != null)
        ? Duration(milliseconds: (measure as PeriodicMeasure).duration)
        : null;
  }

  Future<void> onRestart() async {
    frequency = Duration(milliseconds: (measure as PeriodicMeasure).frequency);
    duration = ((measure as PeriodicMeasure).duration != null)
        ? Duration(milliseconds: (measure as PeriodicMeasure).duration)
        : null;
  }

  Future<void> onResume() async {
    // create a recurrent timer that gets the datum every [frequency].
    timer = Timer.periodic(frequency, (Timer t) async {
      getDatum().then((Datum data) {
        if (data != null) controller.add(data);
      }).catchError((error, stacktrace) => controller.addError(error, stacktrace));
    });
  }

  Future<void> onPause() async {
    timer?.cancel();
  }

  Future<void> onStop() async {
    timer?.cancel();
    controller.close();
  }
}

/// An abstract class used to create a probe that listen to events from a [Stream].
///
/// Sub-classes must implement the
///
///     Stream<Datum> get stream => ...
///
/// method in order to provide the stream to collect data from.
/// See [ConnectivityProbe] for a simple example or [BatteryProbe] for a more
/// sophisticated example.
abstract class StreamProbe extends AbstractProbe {
  StreamSubscription<dynamic> subscription;
  StreamController<Datum> controller = StreamController<Datum>.broadcast();
  Stream<Datum> get events => controller.stream;

  /// The stream for this [StreamProbe]. Must be implemented by sub-classes.
  Stream<Datum> get stream;

  // Do nothing here. Can be overwritten in subclasses.
  Future<void> onInitialize(Measure measure) async {}

  Future<void> onRestart() async {
    // if we don't have a subscription yet, try to get one
    if (subscription == null && stream != null) subscription = stream.listen(onData, onError: onError, onDone: onDone);
  }

  Future<void> onPause() async {
    // if the stream has disappeared, remove the subscription also
    if (stream == null) subscription = null;
    if (subscription != null) {
      if (stream.isBroadcast) {
        // If the underlying stream is gone or is a broadcast stream, it is better to cancel and later resume the
        // subscription. See https://api.dart.dev/stable/2.4.0/dart-async/StreamSubscription/pause.html
        // Most streams from platform channels are broadcast (e.g. activity, location, eSense, ...).
        subscription?.cancel();
        subscription = null;
        //print('${this.runtimeType} - onPause() - isBroadcast - subscription = null');
      } else {
        subscription?.pause();
      }
    }
  }

  Future<void> onResume() async {
    // if we don't have a subscription yet, or it has been canceled, try to get one
    if (subscription == null && stream != null)
      subscription = stream.listen(onData, onError: onError, onDone: onDone);
    else if (stream != null && !stream.isBroadcast) subscription.resume();
  }

  Future<void> onStop() async {
    subscription?.cancel();
    controller?.close();
    subscription = null;
  }

  // just forwarding to the controller
  void onData(Datum event) => controller.add(event);
  void onError(error) => controller.addError(error);
  void onDone() => controller.close();
}

/// A periodic probe listening on a stream. Listening is done periodically as specified in a
/// [PeriodicMeasure] listening on intervals every [frequency] for a period of [duration]. During this
/// period, all events are forwarded to this probes [events] stream.
///
/// Just like in [StreamProbe], sub-classes must implement the
///
///     Stream<Datum> get stream => ...
///
/// method in order to provide the stream to collect data from.
abstract class PeriodicStreamProbe extends StreamProbe {
  Timer timer;
  Duration frequency, duration;

  Future<void> onInitialize(Measure measure) async {
    assert(measure is PeriodicMeasure);
    frequency = Duration(milliseconds: (measure as PeriodicMeasure).frequency);
    duration = ((measure as PeriodicMeasure).duration != null)
        ? Duration(milliseconds: (measure as PeriodicMeasure).duration)
        : null;
  }

  Future<void> onRestart() async {
    frequency = Duration(milliseconds: (measure as PeriodicMeasure).frequency);
    duration = ((measure as PeriodicMeasure).duration != null)
        ? Duration(milliseconds: (measure as PeriodicMeasure).duration)
        : null;
    super.onRestart();
  }

  Future<void> onResume() async {
    print('${this.runtimeType} - onResume() - subscription: $subscription');
    // if we don't have a subscription yet, or it has been canceled, try to get one
    if (subscription == null) subscription = stream?.listen(onData, onError: onError, onDone: onDone);
    if (subscription != null) {
      // create a recurrent timer that resume sampling.
      timer = Timer.periodic(frequency, (Timer t) {
        print('${this.runtimeType} - onResume() - subscription.resume()');
        subscription.resume();
        // create a timer that pause the sampling after the specified duration.
        Timer(duration, () {
          print('${this.runtimeType} - onResume() - subscription.pause()');
          subscription.pause();
        });
      });
    }
  }

  Future<void> onPause() async {
    timer?.cancel();
    subscription?.pause();
  }

  Future<void> onStop() async {
    timer?.cancel();
    super.onStop();
  }
}

/// An abstract probe which can be used to sample data into a buffer,
/// every [frequency] for a period of [duration]. These events are buffered, and
/// once collected for the [duration], are collected from the [getDatum] method and
/// send to the main [events] stream.
///
/// When sampling starts, the [onSamplingStart] handle is called.
/// When the sampling window ends, the [onSamplingEnd] handle is called.
///
/// See [AudioProbe] for an example.
abstract class BufferingPeriodicProbe extends DatumProbe {
  StreamController<Datum> controller = StreamController<Datum>.broadcast();
  Stream<Datum> get events => controller.stream;
  Timer timer;
  Duration frequency, duration;

  Future<void> onInitialize(Measure measure) async {
    assert(measure is PeriodicMeasure);
    frequency = Duration(milliseconds: (measure as PeriodicMeasure).frequency);
    duration = ((measure as PeriodicMeasure).duration != null)
        ? Duration(milliseconds: (measure as PeriodicMeasure).duration)
        : null;
  }

  Future<void> onRestart() async {
    frequency = Duration(milliseconds: (measure as PeriodicMeasure).frequency);
    duration = ((measure as PeriodicMeasure).duration != null)
        ? Duration(milliseconds: (measure as PeriodicMeasure).duration)
        : null;
  }

  Future<void> onResume() async {
    // create a recurrent timer that every [frequency] resumes the buffering.
    timer = Timer.periodic(frequency, (Timer t) {
      onSamplingStart();
      // create a timer that stops the buffering after the specified [duration].
      Timer(duration, () {
        onSamplingEnd();
        // collect the datum
        getDatum().then((datum) {
          if (datum != null) controller.add(datum);
        }).catchError((error, stacktrace) => controller.addError(error, stacktrace));
      });
    });
  }

  Future<void> onPause() async {
    if (timer != null) timer.cancel();
    // check if there are some buffered data that needs to be collected before pausing
    getDatum().then((datum) {
      if (datum != null) controller.add(datum);
    }).catchError((error, stacktrace) => controller.addError(error, stacktrace));
  }

  Future<void> onStop() {
    if (timer != null) timer.cancel();
    controller.close();
  }

  /// Handler called when sampling period starts.
  void onSamplingStart();

  /// Handler called when sampling period ends.
  void onSamplingEnd();

  /// Subclasses should implement / override this method to collect the [Datum].
  /// This method will be called every time data has been buffered for a [duration]
  /// and should return the final [Datum] for the buffered data.
  Future<Datum> getDatum();
}

//typedef OnSamplingDataCallback = void Function(dynamic event);
//typedef OnSamplingCallback = void Function();

/// An abstract probe which can be used to sample data from a buffering stream,
/// every [frequency] for a period of [duration]. These events are buffered, and
/// once collected for the [duration], are collected from the [getDatum] method and
/// send to the main [events] stream.
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
  Stream<Datum> get stream => Stream<Datum>.empty();

  Future<void> onInitialize(Measure measure) async {
    super.onInitialize(measure);
    assert(bufferingStream != null, 'Buffering event stream must not be null');
  }

  Future<void> onResume() async {
    // if we don't have a subscription yet, or it has been canceled, try to get one
    if (subscription == null)
      subscription = bufferingStream?.listen((data) {
        // we don't need this data - first collect the Datum in the end
      });

    subscription?.resume();
    timer = Timer.periodic(frequency, (Timer t) {
      onSamplingStart();
      subscription?.resume();
      Timer(duration, () {
        subscription?.pause();
        onSamplingEnd();
        getDatum().then((datum) {
          if (datum != null) controller.add(datum);
        }).catchError((error, stacktrace) => controller.addError(error, stacktrace));
      });
    });
  }

  Future<void> onPause() async {
    timer?.cancel();
    subscription?.pause();
    // check if there are some buffered data that needs to be collected before pausing
    getDatum().then((datum) {
      if (datum != null) controller.add(datum);
    }).catchError((error, stacktrace) => controller.addError(error, stacktrace));
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
  Future<Datum> getDatum();
}

/// An abstract probe which can be used to buffer data from a stream and collect data
/// every [frequency]. All events from the [bufferingStream] are buffered, and
/// collected from the [getDatum] method every [frequency] and send to the
/// main [events] stream.
///
/// Sub-classes must implement the
///
///     Stream<dynamic> get bufferingStream => ...
///
/// method in order to provide the stream to be buffered.
///
/// When the sampling window ends, the [getDatum] method is called.
///
/// See [PedometerProbe] for an example.
abstract class BufferingStreamProbe extends BufferingPeriodicStreamProbe {
  Future<void> onResume() async {
    subscription.resume();
    timer = Timer.periodic(frequency, (Timer t) {
      onSamplingStart();
      getDatum().then((datum) {
        if (datum != null) controller.add(datum);
      }).catchError((error, stacktrace) => controller.addError(error, stacktrace));
    });
  }

  void onSamplingEnd() {}
  void onSamplingStart() {}
}
