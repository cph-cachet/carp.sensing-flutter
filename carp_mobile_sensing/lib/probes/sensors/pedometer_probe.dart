/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of sensors;

/// The pedometer probe listens to the hardware step counts.
/// It samples step counts periodically, as specified by [frequency] in [PeriodicMeasure] and
/// reports the step count in a [PedometerDatum] for the duration of the period.
class PedometerProbe extends StreamProbe {
  Duration frequency;
  Pedometer pedometer = new Pedometer();
  int _latestStepCount = 0;
  DateTime _startTime;

  /// Returns the latest known step count.
  int get latestStepCount => _latestStepCount;

  PedometerProbe(PeriodicMeasure measure)
      : assert(measure != null),
        assert(measure.frequency != null, 'Measure frequency cannot be null for a PedometerProbe.'),
        frequency = Duration(milliseconds: measure.frequency),
        super(measure);

  @override
  void initialize() {
    super.initialize();

    // start listening to the pedometer, but pause until the probe is started
    subscription = pedometer.stepCountStream.listen(_onStep, onError: onError);
    _startTime = DateTime.now();
    subscription.pause();
  }

  Stream<Datum> get stream => null; // we're not using this stream - creating our own above.

  @override
  Future start() async {
    super.start();

    // create a recurrent timer that wait (pause) and then resumes the sampling.
    Timer.periodic(frequency, (Timer timer) {
      subscription.resume();
    });
  }

  // FlutterPedometer callback
  void _onStep(int count) async {
    PedometerDatum _scd =
        new PedometerDatum(stepCount: count - _latestStepCount, startTime: _startTime, endTime: DateTime.now());

    // pause the listening until the periodic timer above resumes it
    subscription.pause();
    // save this timestamp and the step count as the start for the next period
    _startTime = DateTime.now();
    _latestStepCount = count;
    // propagate the event up to the super controller.
    onData(_scd);
  }
}

/// The [OldPedometerProbe] listens to the hardware step counts.
/// It samples step counts periodically, as specified by [frequency] in [PeriodicMeasure] and
/// reports the step count in a [PedometerDatum] for the duration of the period.
class OldPedometerProbe extends AbstractProbe {
  Pedometer _pedometer;
  StreamSubscription<int> _subscription;
  int _latestStepCount = 0;
  DateTime _startTime;

  /// Returns the latest known step count.
  int get latestStepCount => _latestStepCount;

  Stream<Datum> get events => null;

  OldPedometerProbe(PeriodicMeasure measure) : super.init(measure);

  @override
  void initialize() {
    super.initialize();
    _pedometer = new Pedometer();

    // start listening to the pedometer, but pause until the probe is started
    _subscription = _pedometer.stepCountStream.listen(_onData, onError: _onError, onDone: _onDone, cancelOnError: true);
    _startTime = DateTime.now();
    _subscription.pause();
  }

  @override
  Future start() async {
    super.start();

    final int _frequency = (measure as PeriodicMeasure).frequency;
    final Duration _pause = new Duration(milliseconds: _frequency);

    // create a recurrent timer that wait (pause) and then resumes the sampling.
    Timer.periodic(_pause, (Timer timer) {
      _subscription.resume();
    });
  }

  @override
  void stop() {
    _subscription.cancel();
    _subscription = null;
  }

  @override
  void pause() {
    _subscription.pause();
  }

  @override
  void resume() {
    _subscription.resume();
  }

  // FlutterPedometer callback
  void _onData(int count) async {
    PedometerDatum _scd = new PedometerDatum();
    // calculate step count for this period
    _scd.stepCount = count - _latestStepCount;
    _scd.startTime = _startTime;
    _scd.endTime = DateTime.now();

    // pause the listening until the periodic timer above resumes it
    _subscription.pause();
    // save this timestamp and the step count as the start for the next period
    _startTime = DateTime.now();
    _latestStepCount = count;

    this.notifyAllListeners(_scd);
  }

  void _onDone() {}

  void _onError(error) {
    ErrorDatum _ed = new ErrorDatum(message: error.toString());
    this.notifyAllListeners(_ed);
  }
}
