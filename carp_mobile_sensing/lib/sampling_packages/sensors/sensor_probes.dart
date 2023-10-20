/*
 * Copyright 2018-2022 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of sensors;

/// A probe collecting raw data from the accelerometer.
class AccelerometerProbe extends StreamProbe {
  @override
  Stream<Measurement> get stream => accelerometerEvents.map((event) =>
      Measurement.fromData(Acceleration(x: event.x, y: event.y, z: event.z)));
}

/// A probe collecting raw data from the user accelerometer.
class UserAccelerometerProbe extends StreamProbe {
  @override
  Stream<Measurement> get stream => userAccelerometerEvents.map((event) =>
      Measurement.fromData(Acceleration(x: event.x, y: event.y, z: event.z)));
}

/// A probe collecting accelerometer data over a sampling period and calculates
/// a set of features based on the samplings, as represented by a
/// [AccelerationFeatures] data point.
///
/// Configured with a [PeriodicSamplingConfiguration] configuration.
class AccelerometerFeaturesProbe extends BufferingPeriodicStreamProbe {
  List<UserAccelerometerEvent> userAccelerometerEventList = [];
  int sensorStartTime = 0;
  int? sensorEndTime;

  @override
  Stream<dynamic> get bufferingStream => userAccelerometerEvents;

  @override
  Future<Measurement?> getMeasurement() async =>
      userAccelerometerEventList.isEmpty
          ? null
          : Measurement(
              sensorStartTime: sensorStartTime,
              sensorEndTime: sensorEndTime,
              data: AccelerationFeatures.fromAccelerometerReadings(
                  userAccelerometerEventList));

  @override
  void onSamplingStart() {
    sensorStartTime = DateTime.now().microsecondsSinceEpoch;
    userAccelerometerEventList.clear();
  }

  @override
  void onSamplingEnd() {
    sensorEndTime = DateTime.now().microsecondsSinceEpoch;
  }

  @override
  void onSamplingData(event) {
    if (event is UserAccelerometerEvent) {
      userAccelerometerEventList.add(event);
    }
  }
}

/// A probe collecting raw data from the gyroscope.
class GyroscopeProbe extends StreamProbe {
  @override
  Stream<Measurement> get stream => gyroscopeEvents.map((event) =>
      Measurement.fromData(Rotation(x: event.x, y: event.y, z: event.z)));
}

/// A probe collecting raw data from the magnetometer.
class MagnetometerProbe extends StreamProbe {
  @override
  Stream<Measurement> get stream => magnetometerEvents.map((event) =>
      Measurement.fromData(MagneticField(x: event.x, y: event.y, z: event.z)));
}
