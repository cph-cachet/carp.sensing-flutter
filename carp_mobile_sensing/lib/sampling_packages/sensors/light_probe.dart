/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of sensors;

/// The [LightProbe] listens to the phone's light sensor typically located near the front camera.
/// Every value is in the SI unit Lux and is stored in a [LightDatum] object.
class LightProbe extends BufferingPeriodicStreamProbe {
  List<num> luxValues = [];

  late Stream<dynamic> _bufferingStream;
  Stream<dynamic> get bufferingStream => _bufferingStream;

  @override
  void onInitialize(Measure measure) {
    // check if Light is available (only available on Android)
    _bufferingStream = Light().lightSensorStream;
    super.onInitialize(measure);
  }

  @override
  Future<Datum?> getDatum() async {
    if (luxValues.isEmpty) return null;

    Stats stats = Stats.fromData(luxValues);
    return LightDatum(
        meanLux: stats.average,
        stdLux: stats.standardDeviation,
        minLux: stats.min,
        maxLux: stats.max);
  }

  @override
  void onSamplingStart() => luxValues.clear();

  @override
  void onSamplingEnd() {}

  @override
  void onSamplingData(luxValue) => luxValues.add(luxValue);
}
