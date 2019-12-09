/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of audio;

// TODO - PERMISSIONS
// This probe needs PERMISSIONS to use
//    - audio recording / microphone
//    - file access / storage
//
// If these permissions are not set, the app crashes....
// See issue on github.

/// A listening probe collecting noise sampling from the microphone.
///
/// See [NoiseMeasure] on how to configure this probe, including setting the
/// frequency, duration and sampling rate of the sampling rate.
///
/// Does not record sound. Instead reports the audio level with a specified frequency,
/// in a given sampling window as a [NoiseDatum].
class NoiseProbe extends BufferingPeriodicStreamProbe {
  NoiseMeter _noiseMeter;
  DateTime _startRecordingTime;
  DateTime _endRecordingTime;
  List<num> _noiseReadings = new List();

  Stream get bufferingStream => _noiseMeter.noiseStream;

  void _init() {
    _noiseMeter = NoiseMeter();
  }

  Future<void> onInitialize(Measure measure) async {
    super.onInitialize(measure);
    _init();
  }

  Future<void> onRestart() async {
    super.onRestart();
    _init();
  }

  Future<void> onStop() async {
    super.onStop();
    _noiseMeter = null;
  }

  void onSamplingEnd() {
    _endRecordingTime = DateTime.now();
  }

  void onSamplingStart() {} // Do nothing

  void onSamplingData(dynamic noiseReading) => _noiseReadings.add(noiseReading.db);

  Future<Datum> getDatum() async {
    if (_noiseReadings.length > 0) {
      Stats stats = Stats.fromData(_noiseReadings);
      num mean = stats.mean;
      num std = stats.standardDeviation;
      num min = stats.min;
      num max = stats.max;

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
