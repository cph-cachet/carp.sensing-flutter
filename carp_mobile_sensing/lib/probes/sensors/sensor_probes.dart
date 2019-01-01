/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of sensors;

/// A simple abstract probe to be used to implement specific buffered sensor probes.
abstract class BufferingSensorProbe extends BufferingPeriodicStreamProbe {
  MultiDatum datum = MultiDatum();

  BufferingSensorProbe(PeriodicMeasure measure) : super(measure);

  Future<Datum> getDatum() async => datum;

  void onPeriodStart() {
    datum = MultiDatum();
  }

  void onPeriodEnd() {}
}

/// A probe that collects accelerometer events and buffers them and return a [MultiDatum] with
/// all the buffered [AccelerometerDatum]s.
class BufferingAccelerometerProbe extends BufferingSensorProbe {
  BufferingAccelerometerProbe(PeriodicMeasure measure) : super(measure);

  Stream get bufferingEvents => accelerometerEvents;

  void onData(event) => datum.addDatum(AccelerometerDatum.fromAccelerometerEvent(event));
}

/// A  probe collecting raw data from the accelerometer.
///
/// Note that this probe generates a lot of data and should be used with caution.
/// See [PeriodicMeasure] on how to configure this probe, including setting the
/// [frequency] and [duration] of the sampling rate.
class AccelerometerProbe extends PeriodicStreamProbe {
  AccelerometerProbe(PeriodicMeasure measure) : super(measure);

  Stream<Datum> get stream => accelerometerEvents.map((event) => AccelerometerDatum.fromAccelerometerEvent(event));
}

/// A probe that collects gyroscope events and buffers them and return a [MultiDatum] with
/// all the buffered [GyroscopeDatum]s.
class BufferingGyroscopeProbe extends BufferingSensorProbe {
  BufferingGyroscopeProbe(PeriodicMeasure measure) : super(measure);

  Stream get bufferingEvents => gyroscopeEvents;

  void onData(event) => datum.addDatum(GyroscopeDatum.fromGyroscopeEvent(event));
}

/// A  probe collecting raw data from the gyroscope.
///
/// Note that this probe generates a lot of data and should be used with caution.
/// See [PeriodicMeasure] on how to configure this probe, including setting the
/// [frequency] and [duration] of the sampling rate.
class GyroscopeProbe extends PeriodicStreamProbe {
  GyroscopeProbe(PeriodicMeasure measure) : super(measure);

  Stream<Datum> get stream => gyroscopeEvents.map((event) => GyroscopeDatum.fromGyroscopeEvent(event));
}
