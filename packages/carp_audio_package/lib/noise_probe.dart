/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of audio;

/// A listening probe collecting noise sampling from the microphone.
///
/// See [NoiseMeasure] on how to configure this probe, including setting the
/// frequency, duration and sampling rate of the sampling rate.
///
/// Does not record sound. Instead reports the audio level with a specified frequency,
/// in a given sampling window as a [NoiseDatum].
class NoiseProbe extends BufferingPeriodicStreamProbe {
  NoiseMeter _noiseMeter = NoiseMeter();
  List<NoiseReading> _noiseReadings = new List<NoiseReading>();

  Stream get bufferingStream => _noiseMeter.noiseStream;

  void onInitialize(Measure measure) {
    assert(measure is NoiseMeasure);
    super.onInitialize(measure);
  }

  Future<void> onRestart() async {
    super.onRestart();
    _noiseMeter = NoiseMeter();
  }

  Future<void> onStop() async {
    super.onStop();
    _noiseMeter = null;
  }

  void onSamplingEnd() {}

  void onSamplingStart() {} // Do nothing

  void onSamplingData(dynamic noiseReading) => _noiseReadings.add(noiseReading);

  Future<Datum> getDatum() async {
    if (_noiseReadings.length > 0) {
      List<num> _meanList = List();
      List<num> _maxList = List();

      _noiseReadings.forEach((reading) {
        _meanList.add(reading.meanDecibel);
        _maxList.add(reading.maxDecibel);
      });

      Stats meanStats = Stats.fromData(_meanList);
      Stats maxStats = Stats.fromData(_maxList);
      // get statistics from the list of mean db's
      num mean = meanStats.average;
      num std = meanStats.standardDeviation;
      num min = meanStats.min;
      // get the max db from the list of max db's
      num max = maxStats.max;

      if (mean.isFinite && std.isFinite && min.isFinite && max.isFinite)
        return NoiseDatum(
            meanDecibel: mean.toDouble(),
            stdDecibel: std.toDouble(),
            minDecibel: min.toDouble(),
            maxDecibel: max.toDouble());
    }
    return null;
  }
}
