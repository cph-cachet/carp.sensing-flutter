/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */
import 'dart:async';

import 'package:sensors/sensors.dart';
import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';

class GyroscopeProbe extends ListeningProbe {
  StreamSubscription<GyroscopeEvent> _subscription;
  Timer _startTimer;
  Timer _stopTimer;
  MultiDatum data;

  GyroscopeProbe(SensorMeasure _measure) : super(_measure);

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
    data = new MultiDatum();
    _subscription.resume();
  }

  void _onData(GyroscopeEvent event) async {
    if (data != null) {
      GyroscopeDatum _gd = new GyroscopeDatum(x: event.x, y: event.y, z: event.z);
      data.addDatum(_gd);
    }
  }

  void _onDone() {
    if (data != null) this.notifyAllListeners(data);
  }

  void _onError(error) {
    ErrorDatum _ed = new ErrorDatum(error.toString());
    this.notifyAllListeners(_ed);
  }
}
