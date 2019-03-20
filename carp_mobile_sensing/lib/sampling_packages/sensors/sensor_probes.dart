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

  Future<Datum> getDatum() async => datum;

  void onSamplingStart() {
    datum = MultiDatum();
  }

  void onSamplingEnd() {}
}

/// A probe that collects accelerometer events and buffers them and return a [MultiDatum] with
/// all the buffered [AccelerometerDatum]s.
class BufferingAccelerometerProbe extends BufferingSensorProbe {
  Stream<dynamic> get bufferingStream => accelerometerEvents;
  void onSamplingData(event) => datum.addDatum(AccelerometerDatum.fromAccelerometerEvent(event));
}

/// A  probe collecting raw data from the accelerometer.
///
/// Note that this probe generates a lot of data and should be used with caution.
/// See [PeriodicMeasure] on how to configure this probe, including setting the
/// [frequency] and [duration] of the sampling rate.
class AccelerometerProbe extends PeriodicStreamProbe {
  Stream<Datum> get stream => accelerometerEvents.map((event) => AccelerometerDatum.fromAccelerometerEvent(event));
}

/// A probe that collects gyroscope events and buffers them and return a [MultiDatum] with
/// all the buffered [GyroscopeDatum]s.
class BufferingGyroscopeProbe extends BufferingSensorProbe {
  Stream<dynamic> get bufferingStream => gyroscopeEvents;
  void onSamplingData(event) => datum.addDatum(GyroscopeDatum.fromGyroscopeEvent(event));
}

/// A  probe collecting raw data from the gyroscope.
///
/// Note that this probe generates a lot of data and should be used with caution.
/// See [PeriodicMeasure] on how to configure this probe, including setting the
/// [frequency] and [duration] of the sampling rate.
class GyroscopeProbe extends PeriodicStreamProbe {
  Stream<Datum> get stream => gyroscopeEvents.map((event) => GyroscopeDatum.fromGyroscopeEvent(event));
}
