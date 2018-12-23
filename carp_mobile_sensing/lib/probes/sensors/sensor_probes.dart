/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of sensors;

/// A listening probe collecting data from the accelerometer.
///
/// Note that this probe generates a lot of data and should be used with caution.
/// See [PeriodicMeasure] on how to configure this probe, including setting the
/// frequency and duration of the sampling rate.
class AccelerometerProbe extends ListeningProbe {
  StreamSubscription<AccelerometerEvent> _subscription;
  MultiDatum data;

  AccelerometerProbe(PeriodicMeasure measure) : super(measure);

  @override
  void initialize() {
    super.initialize();
  }

  @override
  Future start() async {
    super.start();

    // starting the subscription to the accelerometer events
    _subscription = accelerometerEvents.listen(_onData, onError: _onError, onDone: _onDone, cancelOnError: true);

    // pause it for now.
    _subscription.pause();

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
    _subscription.cancel();
    _subscription = null;
    data = null;
  }

  @override
  void resume() {
    data = new MultiDatum(measure: measure);
    _subscription.resume();
  }

  @override
  void pause() {
    if (data != null) this.notifyAllListeners(data);
    data = null;
    _subscription.pause();
  }

  void _onData(AccelerometerEvent event) async {
    if (data != null) {
      data.addDatum(AccelerometerDatum.fromAccelerometerEvent(measure, event));
    }
  }

  void _onDone() {
    if (data != null) this.notifyAllListeners(data);
  }

  void _onError(error) {
    ErrorDatum _ed = new ErrorDatum(measure: measure, message: error.toString());
    this.notifyAllListeners(_ed);
  }

  //Stream<AccelerometerDatum> _myStream;

  Stream<MultiDatum> myStream(Stream<AccelerometerDatum> source) async* {
    // Stores any partial line from the previous chunk.
    var partial = '';
    // Wait until a new chunk is available, then process it.
    await for (var event in source) {
//      var lines = chunk.split('\n');
//      lines[0] = partial + lines[0]; // Prepend partial line.
//      partial = lines.removeLast(); // Remove new partial line.
//      for (var line in lines) {
//        yield line; // Add lines to output stream.
//      }
    }
    // Add final partial line to output stream, if any.
    ///    if (partial.isNotEmpty) yield partial;
  }

  Stream<MultiDatum> get stream => myStream(datum);

  Stream<AccelerometerDatum> get datum =>
      accelerometerEvents.map((event) => AccelerometerDatum.fromAccelerometerEvent(measure, event));
}

/// A listening probe collecting data from the gyroscope.
///
/// Note that this probe generates a lot of data and should be used with caution.
/// See [SensorMeasure] on how to configure this probe, including setting the
/// frequency and duration of the sampling rate.
class GyroscopeProbe extends ListeningProbe {
  StreamSubscription<GyroscopeEvent> _subscription;
  MultiDatum data;

  GyroscopeProbe(PeriodicMeasure _measure) : super(_measure);

  Stream<Datum> get stream => null;

  @override
  void initialize() {
    super.initialize();
  }

  @override
  Future start() async {
    super.start();

    // starting the subscription to the accelerometer events
    _subscription = gyroscopeEvents.listen(_onData, onError: _onError, onDone: _onDone, cancelOnError: true);

    // pause it for now.
    _subscription.pause();

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
    _subscription.cancel();
    _subscription = null;
    data = null;
  }

  @override
  void pause() {
    if (data != null) this.notifyAllListeners(data);
    data = null;
    _subscription.pause();
  }

  @override
  void resume() {
    data = new MultiDatum(measure: measure);
    _subscription.resume();
  }

  void _onData(GyroscopeEvent event) async {
    if (data != null) {
      data.addDatum(GyroscopeDatum.fromGyroscopeEvent(measure, event));
    }
  }

  void _onDone() {
    if (data != null) this.notifyAllListeners(data);
  }

  void _onError(error) {
    this.notifyAllListeners(ErrorDatum(measure: measure, message: error.toString()));
  }
}
