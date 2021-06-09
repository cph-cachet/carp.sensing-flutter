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
/// A probe can be stopped at any time.
/// If an error occurs the state of a probe becomes [undefined]. This is, for example, used when an exception
/// is caught or when a probe is not available (e.g. on iOS).
///
/// The [state] property reveals the probe's current runtime state.
/// The [stateEvents] is a stream of state changes which can be listen to as a broadcast stream.
///
/// Probes return sensed data in a [Stream] as [data]. This is the main
/// usage of a probe. For example, to listens to events and print them;
///
///     probe.data.forEach(print);
///
abstract class Probe {
  /// Is this probe enabled, i.e. available for collection of data using the [resume] method.
  bool get enabled;

  /// The type of this probe according to [String].
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

  /// Is [ProbeState] a valid next [state] for this probe?
  ///
  /// For example:
  ///   * if the current state of this probe is `initialized` then a valid next state is `resumed`.
  ///   * if the current state of this probe is `resumed` then a valid next state is `paused`.
  ///   * if the current state of this probe is `resumed` then `initialized` is **not** a valid next state.
  bool validNextState(ProbeState nextState);

  /// The [Measure] that configures this probe.
  Measure? get measure;

  /// A printer-friendly name for this probe.
  String get name;

  /// The stream of [DataPoint] generated from this probe.
  Stream<DataPoint> get data;

  /// Initialize the probe before starting it.
  ///
  /// The configuration of the probe is specified in the [measure].
  /// The study deployment that this probe is part of can be specified
  /// as the [studyDeploymentId].
  void initialize(Measure measure);

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
  /// If you need to restart a probe, use the [restart] or [pause] and
  /// [resume] methods.
  void stop();
}

/// An abstract implementation of a [Probe] to extend from.
abstract class AbstractProbe extends Probe implements MeasureListener {
  final StreamController<ProbeState> _stateEventController =
      StreamController.broadcast();
  Stream<ProbeState> get stateEvents => _stateEventController.stream;

  bool get enabled => (measure is CAMSMeasure)
      ? (measure as CAMSMeasure).enabled ?? true
      : true;
  String get type => measure!.type;
  String get name => (measure is CAMSMeasure)
      ? (measure as CAMSMeasure).name ?? runtimeType.toString()
      : runtimeType.toString();

  ProbeState get state => _stateMachine.state;
  bool validNextState(ProbeState nextState) =>
      _stateMachine.validNextState(nextState);

  late _ProbeStateMachine _stateMachine;
  void _setState(_ProbeStateMachine state) {
    _stateMachine = state;
    _stateEventController.add(state.state);
    debug('$runtimeType state is set to $state');
  }

  Measure? _measure;
  Measure? get measure => _measure;

  AbstractProbe() : super() {
    _stateMachine = _CreatedState(this);
  }

  void initialize(Measure measure) {
    assert(measure != null, 'Probe cannot be initialized with a null measure.');
    _measure = measure;
    if (measure is CAMSMeasure) measure.addMeasureListener(this);
    return _stateMachine.initialize(measure);
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
  ///
  /// Note that this is a non-async method and should hence be 'light-weight'
  /// and not block execution for a long duration.
  @protected
  void onInitialize(Measure measure);

  /// Callback for resuming probe
  @protected
  Future onResume();

  /// Callback for pausing probe
  @protected
  Future onPause();

  /// Callback for restarting probe
  @protected
  Future onRestart();

  /// Callback for stopping probe
  @protected
  Future onStop();

  /// Callback when this probe's [measure] has changed.
  void hasChanged(Measure measure) => restart();

  /// Mark the latest sampling
  @protected
  void mark() {
    if (measure is MarkedMeasure) {
      Settings().preferences!.setString(
          (measure as MarkedMeasure).tag(), DateTime.now().toUtc().toString());
    }
  }

  /// Get the latest mark
  @protected
  void marking() {
    if (measure is MarkedMeasure) {
      String? mark =
          Settings().preferences!.getString((measure as MarkedMeasure).tag());
      debug('mark : $mark');
      (measure as MarkedMeasure).lastTime =
          (mark != null) ? DateTime.tryParse(mark) : null;
    }
  }
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
  bool validNextState(ProbeState nextState);

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
  _AbstractProbeState(this.probe, this.state) {
    assert(probe != null);
  }

  // Default behavior is to print a warning.
  // If a state supports this method, this behavior is overwritten in
  // the state implementation classes below.
  void initialize(Measure measure) => _printWarning('initialize');
  void restart() => _printWarning('restart');
  void resume() => _printWarning('resume');
  void pause() => _printWarning('pause');

  // Default stop behavior. A probe can be stopped in all states.
  void stop() {
    info('Stopping ${probe.runtimeType}');
    probe._setState(_StoppedState(probe));
    probe.onStop();
  }

  // Default error behavior. A probe can become undefined in all states.
  void error() {
    warning('Error in ${probe.runtimeType}.');
    probe._setState(_UndefinedState(probe));
  }

  // Default implementation of next state. Can always be stopped.
  bool validNextState(ProbeState nextState) =>
      (nextState == ProbeState.stopped);

  void _printWarning(String operation) => warning(
      'Trying to $operation a ${probe.runtimeType} in a state where this cannot be done'
      ' - state: $state, type: ${probe.type}, name: ${probe.name}');
}

class _CreatedState extends _AbstractProbeState implements _ProbeStateMachine {
  _CreatedState(Probe probe)
      : super(probe as AbstractProbe, ProbeState.created);

  void initialize(Measure measure) {
    info('Initializing ${probe.runtimeType} - $measure');
    try {
      probe.onInitialize(measure);
      probe._setState(_InitializedState(probe));
    } catch (error) {
      warning('Error initializing ${probe.runtimeType}: $error');
      probe._setState(_UndefinedState(probe));
    }
  }

  bool validNextState(ProbeState nextState) =>
      (nextState == ProbeState.initialized);

  String toString() => 'created';
}

class _InitializedState extends _AbstractProbeState
    implements _ProbeStateMachine {
  _InitializedState(Probe probe)
      : super(probe as AbstractProbe, ProbeState.initialized);

  void resume() {
    info('Resuming ${probe.runtimeType}');
    probe.onResume();
    probe._setState(_ResumedState(probe));
  }

  bool validNextState(ProbeState nextState) =>
      (nextState == ProbeState.resumed);

  String toString() => 'initialized';
}

class _ResumedState extends _AbstractProbeState implements _ProbeStateMachine {
  _ResumedState(Probe probe)
      : super(probe as AbstractProbe, ProbeState.resumed);

  void restart() {
    info('Restarting ${probe.runtimeType}');
    probe.pause(); // first pause probe, setting it in a paused state
    probe.onRestart();
    if (probe.enabled) {
      probe.resume();
    }
  }

  void pause() {
    info('Pausing ${probe.runtimeType}');
    probe.onPause();
    probe._setState(_PausedState(probe));
  }

  bool validNextState(ProbeState nextState) => (nextState == ProbeState.paused);

  String toString() => 'resumed';
}

class _PausedState extends _AbstractProbeState implements _ProbeStateMachine {
  _PausedState(Probe probe) : super(probe as AbstractProbe, ProbeState.paused);

  void restart() {
    info('Restarting ${probe.runtimeType}');
    probe.onRestart();
    if (probe.enabled) {
      // only resume if probe is enabled
      probe.resume();
    }
  }

  void resume() {
    if (probe.enabled) {
      info('Resuming ${probe.runtimeType}');
      probe.onResume();
      probe._setState(_ResumedState(probe));
    }
  }

  bool validNextState(ProbeState nextState) =>
      (nextState == ProbeState.resumed);

  String toString() => 'paused';
}

class _StoppedState extends _AbstractProbeState implements _ProbeStateMachine {
  _StoppedState(Probe probe)
      : super(probe as AbstractProbe, ProbeState.stopped);
  String toString() => 'stopped';
}

class _UndefinedState extends _AbstractProbeState
    implements _ProbeStateMachine {
  _UndefinedState(Probe probe)
      : super(probe as AbstractProbe, ProbeState.undefined);
  String toString() => 'undefined';
}

//---------------------------------------------------------------------------------------
//                                SPECIALIZED PROBES
//---------------------------------------------------------------------------------------

/// This probe collects one piece of [Datum] when resumed, send its to the
/// [data] stream, and then pause.
///
/// The [Datum] to be collected should be implemented in the [getDatum] method.
abstract class DatumProbe extends AbstractProbe {
  StreamController<Datum> controller = StreamController.broadcast();
  Stream<DataPoint> get data =>
      controller.stream.map((datum) => DataPoint.fromData(datum));

  void onInitialize(Measure measure) {}

  Future onRestart() async {}

  Future onResume() async {
    marking();
    Datum? datum;
    try {
      datum = await getDatum();
    } catch (error) {
      controller.addError(error);
    }
    if (datum != null) controller.add(datum);
    mark();
  }

  Future onPause() async {}
  Future onStop() async {}

  /// Subclasses should implement this method to collect the [DataPoint].
  Future<Datum> getDatum();
}

/// A periodic probe is triggered at regular intervals, specified by its [frequency]
/// property in a [PeriodicMeasure].
///
/// When triggered, a periodic probe collect a piece of data ([Datum]) using
/// the [getDatum] method.
/// Note that the [duration] parameter in a [PeriodicMeasure] is **not** used.
///
/// See [MemoryProbe] for an example.
abstract class PeriodicDatumProbe extends DatumProbe {
  Timer? timer;
  // StreamController<DataPoint> controller = StreamController.broadcast();
  Duration? frequency, duration;

  // Stream<DataPoint> get events => controller.stream;

  void onInitialize(Measure measure) {
    assert(measure is PeriodicMeasure);
    frequency = (measure as PeriodicMeasure).frequency;
    duration = measure.duration;
  }

  Future onRestart() async {
    frequency = (measure as PeriodicMeasure).frequency;
    duration = (measure as PeriodicMeasure).duration;
  }

  Future onResume() async {
    marking();

    // create a recurrent timer that gets the data point every [frequency].
    timer = Timer.periodic(frequency!, (Timer t) async {
      await getDatum().then((datum) {
        if (datum != null) controller.add(datum);
      }).catchError(
          (error, stacktrace) => controller.addError(error, stacktrace));
    });
  }

  Future onPause() async {
    timer?.cancel();
    mark();
  }

  Future onStop() async {
    timer?.cancel();
    await controller.close();
  }
}

/// An abstract class used to create a probe that listen to events from a
/// [stream] of [Datum] objects.
///
/// Sub-classes must implement the
///
///     Stream<Datum> get stream => ...
///
/// method in order to provide the stream to collect data from.
/// See [BatteryProbe] for an example.
abstract class StreamProbe extends AbstractProbe {
  StreamSubscription<dynamic>? subscription;
  StreamController<Datum> controller = StreamController.broadcast();
  Stream<DataPoint> get data =>
      controller.stream.map((datum) => DataPoint.fromData(datum));

  /// The stream for this [StreamProbe]. Must be implemented by sub-classes.
  Stream<Datum> get stream;

  // Do nothing here. Can be overwritten in subclasses.
  void onInitialize(Measure measure) {}

  Future onRestart() async {
    //await onResume();
  }

  Future onResume() async {
    marking();
    subscription = stream?.listen(onData, onError: onError, onDone: onDone);
  }

  Future onPause() async {
    await subscription?.cancel();
    mark();
  }

  Future onStop() async {
    await subscription?.cancel();
    await controller?.close();
    subscription = null;
  }

  // just forwarding to the controller
  void onData(Datum datum) => controller.add(datum);
  void onError(error) => controller.addError(error);
  void onDone() => controller.close();
}

/// A periodic probe listening on a stream. Listening is done periodically as
/// specified in a [PeriodicMeasure] listening on intervals every [frequency]
/// for a period of [duration].
/// During this period, all data are forwarded to this probes [data] stream.
///
/// Just like in [StreamProbe], sub-classes must implement the
///
///     Stream<DataPoint> get stream => ...
///
/// method in order to provide the stream to collect data from.
abstract class PeriodicStreamProbe extends StreamProbe {
  Timer? timer;
  Duration? frequency, duration;

  void onInitialize(Measure measure) {
    assert(measure is PeriodicMeasure);
    frequency = (measure as PeriodicMeasure).frequency;
    duration = measure.duration;
    super.onInitialize(measure);
  }

  Future onRestart() async {
    frequency = (measure as PeriodicMeasure).frequency;
    duration = (measure as PeriodicMeasure).duration;
    await super.onRestart();
  }

  Future onResume() async {
    marking();

    if (subscription != null) {
      // create a recurrent timer that resume sampling.
      timer = Timer.periodic(frequency!, (timer) {
        subscription = stream?.listen(onData, onError: onError, onDone: onDone);
        // create a timer that pause the sampling after the specified duration.
        Timer(duration!, () async {
          await subscription!.cancel();
        });
      });
    }
  }

  Future onPause() async {
    timer?.cancel();
    await super.onPause();
  }

  Future onStop() async {
    timer?.cancel();
    await super.onStop();
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
  // StreamController<DataPoint> controller = StreamController.broadcast();
  // Stream<DataPoint> get data => controller.stream;
  Timer? timer;
  Duration? frequency, duration;

  void onInitialize(Measure measure) {
    assert(measure is PeriodicMeasure);
    frequency = (measure as PeriodicMeasure).frequency;
    duration = measure.duration;
  }

  Future onRestart() async {
    frequency = (measure as PeriodicMeasure).frequency;
    duration = (measure as PeriodicMeasure).duration;
  }

  Future onResume() async {
    // create a recurrent timer that every [frequency] resumes the buffering.
    timer = Timer.periodic(frequency!, (Timer t) {
      onSamplingStart();
      // create a timer that stops the buffering after the specified [duration].
      Timer(duration!, () {
        onSamplingEnd();
        // collect the data point
        getDatum().then((dataPoint) {
          if (dataPoint != null) controller.add(dataPoint);
        }).catchError(
            (error, stacktrace) => controller.addError(error, stacktrace));
      });
    });
  }

  Future onPause() async {
    if (timer != null) timer!.cancel();
    // check if there are some buffered data that needs to be collected before pausing
    await getDatum().then((dataPoint) {
      if (dataPoint != null) controller.add(dataPoint);
    }).catchError(
        (error, stacktrace) => controller.addError(error, stacktrace));
  }

  Future onStop() async {
    if (timer != null) timer!.cancel();
    await controller.close();
  }

  /// Handler called when sampling period starts.
  void onSamplingStart();

  /// Handler called when sampling period ends.
  void onSamplingEnd();

  /// Subclasses should implement / override this method to collect the [Datum].
  /// This method will be called every time data has been buffered for a
  /// [duration] and should return the final [Datum] for the buffered data.
  Future<Datum> getDatum();
}

/// An abstract probe which can be used to sample data from a buffering stream,
/// every [frequency] for a period of [duration]. These events are buffered,
/// and once collected for the [duration], are collected from the [getDataPoint]
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
  Stream<Datum> get stream => Stream.empty();

  void onInitialize(Measure measure) {
    assert(bufferingStream != null, 'Buffering event stream must not be null');
    super.onInitialize(measure);
  }

  Future onResume() async {
    timer = Timer.periodic(frequency!, (Timer t) {
      onSamplingStart();
      subscription = bufferingStream?.listen(onSamplingData,
          onError: onError, onDone: onDone);
      Timer(duration!, () async {
        await subscription?.cancel();
        onSamplingEnd();
        await getDatum().then((datum) {
          if (datum != null) controller.add(datum);
        }).catchError(
            (error, stacktrace) => controller.addError(error, stacktrace));
      });
    });
  }

  Future onPause() async {
    await super.onPause();
    onSamplingEnd();
    await getDatum().then((datum) {
      if (datum != null) controller.add(datum);
    }).catchError(
        (error, stacktrace) => controller.addError(error, stacktrace));
  }

  // Sub-classes should implement the following handler methods.

  /// The stream of events to be buffered. Must be specified by sub-classes.
  Stream<dynamic>? get bufferingStream;

  /// Handler called when sampling period starts.
  void onSamplingStart();

  /// Handler called when sampling period ends.
  void onSamplingEnd();

  /// Handler for handling onData events from the buffering stream.
  void onSamplingData(dynamic event);

  /// Subclasses should implement / override this method to collect the [Datum].
  /// This method will be called every time data has been buffered for a [duration]
  /// and should return the final [Datum] for the buffered data.
  Future<Datum?> getDatum();
}

/// An abstract probe which can be used to buffer data from a stream and collect data
/// every [frequency]. All events from the [bufferingStream] are buffered, and
/// collected from the [getDatum] method every [frequency] and send to the
/// main [data] stream.
///
/// Sub-classes must implement the
///
///     Stream<dynamic> get bufferingStream => ...
///
/// method in order to provide the stream to be buffered.
///
/// When the sampling window ends, the [getDataPoint] method is called.
abstract class BufferingStreamProbe extends BufferingPeriodicStreamProbe {
  Future onResume() async {
    subscription!.resume();
    timer = Timer.periodic(frequency!, (Timer t) {
      onSamplingStart();
      getDatum().then((datum) {
        if (datum != null) controller.add(datum);
      }).catchError(
          (error, stacktrace) => controller.addError(error, stacktrace));
    });
  }

  void onSamplingEnd() {}
  void onSamplingStart() {}
}
