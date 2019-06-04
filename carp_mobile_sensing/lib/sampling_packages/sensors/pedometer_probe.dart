/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of sensors;

/// The pedometer probe listens to the hardware step count sensor.
///
/// It samples step counts periodically, as specified by [frequency] in [PeriodicMeasure] and
/// reports the step count in a [PedometerDatum] for the duration of the period.
/// The probe reports the number of steps taken since the last sampling. For example, if [frequency]
/// is 1 hour, then numbers of step are sampled and reported on an hourly basis.
class PedometerProbe extends BufferingStreamProbe {
  int _steps = 0;
  int _count = 0;
  DateTime _startTime = DateTime.now();

  // listen to the pedometer plugin - fires an event on every step
  Stream<dynamic> get bufferingStream => Pedometer().stepCountStream;

  Future<Datum> getDatum() async {
    // check if we have passed midnight, then _steps has to be reset to zero.
    if (_count < _steps) _steps = 0;
    PedometerDatum pd = PedometerDatum(_count - _steps, _startTime, DateTime.now());
    _steps = _count;
    _startTime = DateTime.now();
    return pd;
  }

  // the pedometer plugin reports absolute number of steps taken since midnight.
  void onSamplingData(count) {
    _count = count;
  }
}
