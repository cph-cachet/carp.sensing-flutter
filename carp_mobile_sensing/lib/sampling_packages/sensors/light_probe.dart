/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of sensors;

/// The [LightProbe] listens to the phone's light sensor typically located
/// near the front camera.
/// Every value is in the SI unit Lux and is stored in a [AmbientLight] object.
///
/// This probe is only available on Android.
class LightProbe extends BufferingPeriodicStreamProbe {
  List<num> luxValues = [];
  int sensorStartTime = 0;
  int? sensorEndTime;

  late Stream<dynamic> _bufferingStream;

  @override
  Stream<dynamic> get bufferingStream => _bufferingStream;

  @override
  bool onInitialize() {
    _bufferingStream = Light().lightSensorStream;
    return true;
  }

  @override
  Future<Measurement?> getMeasurement() async {
    if (luxValues.isEmpty) return null;

    var stats = Stats.fromData(luxValues);
    var data = AmbientLight(
        meanLux: stats.average,
        stdLux: stats.standardDeviation,
        minLux: stats.min,
        maxLux: stats.max);

    return Measurement(
        sensorStartTime: sensorStartTime,
        sensorEndTime: sensorEndTime,
        dataType: data.format,
        data: data);
  }

  @override
  void onSamplingStart() {
    sensorStartTime = DateTime.now().microsecondsSinceEpoch;
    luxValues.clear();
  }

  @override
  void onSamplingEnd() {
    sensorEndTime = DateTime.now().microsecondsSinceEpoch;
  }

  @override
  void onSamplingData(event) {
    if (event is num) luxValues.add(event);
  }
}
