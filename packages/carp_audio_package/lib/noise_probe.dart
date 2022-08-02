/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of media;

/// A listening probe collecting noise sampling from the microphone.
///
/// See [PeriodicSamplingConfiguration] on how to configure this probe,
/// including setting the frequency and duration of the sampling rate.
///
/// Does not record sound. Instead reports the audio level with a specified
/// frequency, in a given sampling window as a [NoiseDatum].
class NoiseProbe extends BufferingPeriodicStreamProbe {
  NoiseMeter? _noiseMeter;
  final List<NoiseReading> _noiseReadings = [];

  @override
  Stream<NoiseReading> get bufferingStream => _noiseMeter!.noiseStream;

  @override
  void onInitialize() {
    _noiseMeter = NoiseMeter();
  }

  @override
  Future<void> onRestart() async {
    super.onRestart();
    _noiseMeter = NoiseMeter();
  }

  @override
  Future<void> onStop() async {
    super.onStop();
    _noiseMeter = null;
  }

  @override
  void onSamplingEnd() {} // Do nothing

  @override
  void onSamplingStart() {} // Do nothing

  @override
  void onSamplingData(dynamic event) {
    if (event is NoiseReading) _noiseReadings.add(event);
  }

  @override
  Future<Datum?> getDatum() async {
    if (_noiseReadings.isNotEmpty) {
      List<num> meanList = [];
      List<num> maxList = [];

      for (var reading in _noiseReadings) {
        meanList.add(reading.meanDecibel);
        maxList.add(reading.maxDecibel);
      }

      Stats meanStats = Stats.fromData(meanList);
      Stats maxStats = Stats.fromData(maxList);
      // get statistics from the list of mean db's
      num mean = meanStats.average;
      num std = meanStats.standardDeviation;
      num min = meanStats.min;
      // get the max db from the list of max db's
      num max = maxStats.max;

      if (mean.isFinite && std.isFinite && min.isFinite && max.isFinite) {
        return NoiseDatum(
            meanDecibel: mean.toDouble(),
            stdDecibel: std.toDouble(),
            minDecibel: min.toDouble(),
            maxDecibel: max.toDouble());
      }
    }

    return null;
  }
}
