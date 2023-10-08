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

/// A probe collecting average accelerometer data collected over a sampling
/// period. Configured with a [PeriodicSamplingConfiguration] configuration.
class AverageUserAccelerometerProbe extends BufferingPeriodicStreamProbe {
  List<UserAccelerometerEvent> userAccelerometerEventList = [];
  int sensorStartTime = 0;
  int? sensorEndTime;

  @override
  Stream<dynamic> get bufferingStream => userAccelerometerEvents;

  @override
  Future<Measurement?> getMeasurement() async {
    if (userAccelerometerEventList.isEmpty) return null;

    // compute averages of accelerometer
    // xm, ym, zm: normal averages (or means)
    // xms, yms, zms: averages of squared values
    // n: number of values included
    int n = userAccelerometerEventList.length;
    double xms = 0, yms = 0, zms = 0;
    double xm = 0, ym = 0, zm = 0;

    for (UserAccelerometerEvent event in (userAccelerometerEventList)) {
      xms += (event.x) * (event.x);
      xm += event.x;
      yms += (event.y) * (event.y);
      ym += event.y;
      zms += (event.z) * (event.z);
      zm += event.z;
    }

    xms = xms / n;
    xm = xm / n;
    yms = yms / n;
    ym = ym / n;
    zms = zms / n;
    zm = zm / n;

    var data = AverageAccelerometer(
        xm: xm, ym: ym, zm: zm, xms: xms, yms: yms, zms: zms, n: n);

    return Measurement(
        sensorStartTime: sensorStartTime,
        sensorEndTime: sensorEndTime,
        data: data);
  }

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
