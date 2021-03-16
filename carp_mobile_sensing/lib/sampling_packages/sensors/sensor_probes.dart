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
  DateTime samplingStart;

  Future<DataPoint> getDataPoint() async => DataPoint.fromData(datum)
    ..carpHeader.startTime = samplingStart
    ..carpHeader.endTime = DateTime.now();

  void onSamplingStart() {
    datum = MultiDatum();
    samplingStart = DateTime.now();
  }

  void onSamplingEnd() {}
}

/// A  probe collecting raw data from the accelerometer.
///
/// Note that this probe generates a lot of data and should be used
/// with caution.
class AccelerometerProbe extends StreamProbe {
  Stream<DataPoint> get stream => accelerometerEvents.map((event) =>
      DataPoint.fromData(AccelerometerDatum.fromAccelerometerEvent(event)));
}

/// A probe that collects accelerometer events and buffers them and return
/// a [MultiDatum] with all the buffered [AccelerometerDatum]s.
///
/// See [PeriodicMeasure] on how to configure this probe, including setting the
/// [frequency] and [duration] of the sampling rate.
class BufferingAccelerometerProbe extends BufferingSensorProbe {
  Stream<dynamic> get bufferingStream => accelerometerEvents;
  void onSamplingData(event) => datum.addDatum(
      AccelerometerDatum.fromAccelerometerEvent(event, multiDatum: true));
}

/// A  probe collecting raw data from the gyroscope.
///
/// Note that this probe generates a lot of data and should be used
/// with caution.
class GyroscopeProbe extends StreamProbe {
  Stream<DataPoint> get stream => gyroscopeEvents.map(
      (event) => DataPoint.fromData(GyroscopeDatum.fromGyroscopeEvent(event)));
}

/// A probe that collects gyroscope events and buffers them and return
/// a [MultiDatum] with
/// all the buffered [GyroscopeDatum]s.
///
/// See [PeriodicMeasure] on how to configure this probe, including setting the
/// [frequency] and [duration] of the sampling rate.
class BufferingGyroscopeProbe extends BufferingSensorProbe {
  Stream<dynamic> get bufferingStream => gyroscopeEvents;
  void onSamplingData(dynamic event) => datum
      .addDatum(GyroscopeDatum.fromGyroscopeEvent(event, multiDatum: true));
}
