/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of sensors;

// TODO - this probe really needs a rewrite according to the new architecture....

/// The pedometer probe listens to the hardware step counts.
///
/// It samples step counts periodically, as specified by [frequency] in [PeriodicMeasure] and
/// reports the step count in a [PedometerDatum] for the duration of the period.
/// The probe reports the number of steps taken since the last sampling. For example, if [frequency]
/// is 1 hour, then numbers of step are sampled and reported on an hourly basis.
///
/// When the probe is started, step count is zero. The lastes sensed step count is available in the
/// [latestStepCount] property.
class PedometerProbe extends StreamProbe {
  Duration frequency;
  Pedometer pedometer = new Pedometer();
  int _latestStepCount = 0;
  DateTime _startTime;

  /// Returns the latest known step count.
  int get latestStepCount => _latestStepCount;

//  PedometerProbe(PeriodicMeasure measure)
//      : super(measure, Stream<Datum>.empty()) // we're not using this stream - creating our own StreamSubscription.
//  {
//    frequency = Duration(milliseconds: measure.frequency);
//  }

  PedometerProbe() : super(Stream<Datum>.empty()); // we're not using this stream - creating our own StreamSubscription.

  void onInitialize(Measure measure) {
    super.onInitialize(measure);
    frequency = Duration(milliseconds: (measure as PeriodicMeasure).frequency);
  }

  void onStart() {
//    super.onStart();
    // start listening to the pedometer, but pause until the probe is started
    subscription = pedometer.stepCountStream.listen(_onStep, onError: onError);
    _startTime = DateTime.now();
    subscription.pause();

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
    // propagate the event up to the [StreamProbe] controller.
    super.onData(_scd);
  }
}
