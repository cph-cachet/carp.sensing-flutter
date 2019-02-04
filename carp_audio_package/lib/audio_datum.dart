/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of audio;

/// An [AudioDatum] that holds the path to audio file on the local device,
/// as well as the timestamps of when the recording was started and stopped
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class AudioDatum extends CARPDatum {
  static const DataFormat CARP_DATA_FORMAT = DataFormat(NameSpace.CARP, DataType.AUDIO);
  DataFormat get format => CARP_DATA_FORMAT;

  /// The filename of the audio file store on this device.
  String filename;

  /// The timestamp for start of recording.
  DateTime startRecordingTime;

  /// The timestamp for end of recording.
  DateTime endRecordingTime;

  AudioDatum({this.filename, this.startRecordingTime, this.endRecordingTime}) : super();

  factory AudioDatum.fromJson(Map<String, dynamic> json) => _$AudioDatumFromJson(json);
  Map<String, dynamic> toJson() => _$AudioDatumToJson(this);
  String toString() => 'Audio Recording - filename: $filename, start: $startRecordingTime, end: $endRecordingTime';
}

/// A [NoiseDatum] that holds the noise level in decibel of a noise sampling.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class NoiseDatum extends CARPDatum {
  static const DataFormat CARP_DATA_FORMAT = DataFormat(NameSpace.CARP, DataType.NOISE);
  DataFormat get format => CARP_DATA_FORMAT;

  // The sound intensity [dB] measurement statistics for a given sampling window.

  /// Mean decibel of sampling window.
  num meanDecibel;

  /// Standard deviation (in decibel) of sampling window.
  num stdDecibel;

  /// Minimum decibel of sampling window.
  num minDecibel;

  /// Maximum decibel of sampling window.
  num maxDecibel;

  NoiseDatum({this.meanDecibel, this.stdDecibel, this.minDecibel, this.maxDecibel}) : super();

  factory NoiseDatum.fromJson(Map<String, dynamic> json) => _$NoiseDatumFromJson(json);
  Map<String, dynamic> toJson() => _$NoiseDatumToJson(this);
  String toString() => 'Noise - mean: $meanDecibel, std: $stdDecibel, min: $minDecibel, max: $maxDecibel';
}
