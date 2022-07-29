/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of sensors;

/// A simple abstract probe to be used to implement specific buffered
/// sensor probes.
abstract class BufferingSensorProbe extends BufferingPeriodicStreamProbe {
  MultiDatum datum = MultiDatum();

  @override
  Future<Datum?> getDatum() async => datum;

  @override
  void onSamplingStart() {
    datum = MultiDatum();
  }

  @override
  void onSamplingEnd() {}
}

/// A  probe collecting raw data from the accelerometer.
///
/// Note that this probe generates a lot of data and should be used
/// with caution.
class AccelerometerProbe extends StreamProbe {
  @override
  Stream<Datum> get stream => accelerometerEvents
      .map((event) => AccelerometerDatum.fromAccelerometerEvent(event));
}

/// A probe that collects accelerometer events and buffers them and return
/// a [MultiDatum] with all the buffered [AccelerometerDatum]s.
///
/// See [PeriodicMeasure] on how to configure this probe, including setting the
/// [interval] and [duration] of the sampling rate.
class BufferingAccelerometerProbe extends BufferingSensorProbe {
  @override
  Stream<dynamic> get bufferingStream => accelerometerEvents;

  @override
  void onSamplingData(event) {
    if (event is AccelerometerEvent) {
      datum.addDatum(
          AccelerometerDatum.fromAccelerometerEvent(event, multiDatum: true));
    }
  }
}

/// A  probe collecting raw data from the gyroscope.
///
/// Note that this probe generates a lot of data and should be used
/// with caution.
class GyroscopeProbe extends StreamProbe {
  @override
  Stream<Datum> get stream =>
      gyroscopeEvents.map((event) => GyroscopeDatum.fromGyroscopeEvent(event));
}

/// A probe that collects gyroscope events and buffers them and return
/// a [MultiDatum] with
/// all the buffered [GyroscopeDatum]s.
///
/// See [PeriodicMeasure] on how to configure this probe, including setting the
/// [interval] and [duration] of the sampling rate.
class BufferingGyroscopeProbe extends BufferingSensorProbe {
  @override
  Stream<dynamic> get bufferingStream => gyroscopeEvents;

  @override
  void onSamplingData(dynamic event) {
    if (event is GyroscopeEvent) {
      datum
          .addDatum(GyroscopeDatum.fromGyroscopeEvent(event, multiDatum: true));
    }
  }
}
