/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of sensors;


/// The [LightProbe] listens to the phone's light sensor typically located near the front camera.
/// Every value is in the SI unit Lux and will be stored in a [LightDatum] object.
class LightProbe extends ListeningProbe {
  StreamSubscription<int> _subscription;
  Timer _startTimer;
  Timer _stopTimer;
  LightDatum _datum;
  Light _light;
  List<int> _luxValues = new List();

  LightProbe(SensorMeasure _measure) : super(_measure);

  @override
  void initialize() {
    _light = new Light();
    super.initialize();
  }

  @override
  Future start() async {
    super.start();
    // starting the subscription to the accelerometer events
    _subscription = _light.lightSensorStream.listen(_onData,
        onError: _onError, onDone: _onDone, cancelOnError: true);

    // pause it for now.
    _subscription.pause();

    int _frequency = (measure as SensorMeasure).frequency;
    Duration _pause = new Duration(milliseconds: _frequency);
    int _duration = (measure as SensorMeasure).duration;
    Duration _samplingDuration = new Duration(milliseconds: _duration);

    // create a recurrent timer that wait (pause) and then resume the sampling.
    _startTimer = new Timer.periodic(_pause, (Timer timer) {
      this.resume();

      // create a timer that stops the sampling after the specified duration.
      _stopTimer = new Timer(_samplingDuration, () {
        this.pause();
      });
    });
  }

  @override
  void stop() {
    if (_datum != null) this.notifyAllListeners(_datum);
    _subscription.cancel();
    _subscription = null;
    _datum = null;
  }

  @override
  void resume() {
    _subscription.resume();
  }

  @override
  void pause() {
//    double avgLux = Stats.fromData(_luxValues).mean;
//    double stdLux = Stats.fromData(_luxValues).standardDeviation;
//    double minLux = Stats.fromData(_luxValues).min;
//    double maxLux = Stats.fromData(_luxValues).max;
//    _datum = new LightDatum(
//        avgLux: avgLux, stdLux: stdLux, minLux: minLux, maxLux: maxLux);

    if (_datum != null) this.notifyAllListeners(_datum);
    _datum = null;
    _subscription.pause();
  }

  void _onData(int luxValue) async {
    if (_datum != null) {
      _luxValues.add(luxValue);
    }
  }

  void _onDone() {
    if (_datum != null) this.notifyAllListeners(_datum);
  }

  void _onError(error) {
    ErrorDatum _ed = new ErrorDatum(error.toString());
    this.notifyAllListeners(_ed);
  }
}
