/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of sensors;

/// A probe collecting raw data from the accelerometer.
///
/// Note that this probe generates a lot of data and should be used
/// with caution.
class AccelerometerProbe extends StreamProbe {
  @override
  Stream<Measurement> get stream => accelerometerEvents.map((event) =>
      Measurement.fromData(Acceleration(x: event.x, y: event.y, z: event.z)));
}

/// A probe collecting raw data from the gyroscope.
///
/// Note that this probe generates a lot of data and should be used
/// with caution.
class GyroscopeProbe extends StreamProbe {
  @override
  Stream<Measurement> get stream => gyroscopeEvents.map((event) =>
      Measurement.fromData(Rotation(x: event.x, y: event.y, z: event.z)));
}

/// A probe collecting raw data from the magnetometer.
///
/// Note that this probe generates a lot of data and should be used
/// with caution.
class MagnetometerProbe extends StreamProbe {
  @override
  Stream<Measurement> get stream => magnetometerEvents.map((event) =>
      Measurement.fromData(MagneticField(x: event.x, y: event.y, z: event.z)));
}
