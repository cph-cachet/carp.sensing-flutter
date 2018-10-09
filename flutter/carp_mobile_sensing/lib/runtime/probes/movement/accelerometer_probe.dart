/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:sensors/sensors.dart';
import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';

class AccelerometerProbe extends ListeningProbe {
  StreamSubscription<AccelerometerEvent> _subscription;
  Timer _startTimer;
  Timer _stopTimer;
  MultiDatum _data;

  AccelerometerProbe(SensorMeasure _measure) : super(_measure);

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
    if (_data != null) this.notifyAllListeners(_data);
    _subscription.cancel();
    _subscription = null;
    _data = null;
  }

  @override
  void resume() {
    _data = new MultiDatum();
    _subscription.resume();
  }

  @override
  void pause() {
    if (_data != null) this.notifyAllListeners(_data);
    _data = null;
    _subscription.pause();
  }

  void _onData(AccelerometerEvent event) async {
    if (_data != null) {
      AccelerometerDatum _ad = new AccelerometerDatum(x: event.x, y: event.y, z: event.z);
      _data.addDatum(_ad);
    }
  }

  void _onDone() {
    if (_data != null) this.notifyAllListeners(_data);
  }

  void _onError(error) {
    ErrorDatum _ed = new ErrorDatum(error.toString());
    this.notifyAllListeners(_ed);
  }
}
