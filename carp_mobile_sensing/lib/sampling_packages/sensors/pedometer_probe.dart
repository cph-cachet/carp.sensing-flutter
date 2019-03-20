/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of sensors;

/// The pedometer probe listens to the hardware step counts.
///
/// It samples step counts periodically, as specified by [frequency] in [PeriodicMeasure] and
/// reports the step count in a [PedometerDatum] for the duration of the period.
/// The probe reports the number of steps taken since the last sampling. For example, if [frequency]
/// is 1 hour, then numbers of step are sampled and reported on an hourly basis.
class PedometerProbe extends BufferingPeriodicStreamProbe {
  int _steps = 0;
  DateTime _startTime = DateTime.now();
  List<num> luxValues = new List();

  Stream<dynamic> get bufferingStream => Pedometer().stepCountStream;

  Future<Datum> getDatum() async => PedometerDatum(stepCount: _steps, startTime: _startTime, endTime: DateTime.now());

  void onSamplingStart() {
    _steps = 0;
    _startTime = DateTime.now();
  }

  void onSamplingEnd() {}

  void onSamplingData(count) => _steps += count;
}
