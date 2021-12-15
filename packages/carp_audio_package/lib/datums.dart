/*
 * Copyright 2020 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of audio;

/// A datum that holds the path to audio file on the local device,
/// as well as the timestamps of when the recording was started and stopped
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class AudioDatum extends FileDatum {
  DataFormat get format =>
      DataFormat.fromString(AudioVideoSamplingPackage.AUDIO);

  /// The timestamp for start of recording.
  DateTime? startRecordingTime;

  /// The timestamp for end of recording.
  DateTime? endRecordingTime;

  AudioDatum({
    required String filename,
    this.startRecordingTime,
    this.endRecordingTime,
  }) : super(filename: filename);

  factory AudioDatum.fromJson(Map<String, dynamic> json) =>
      _$AudioDatumFromJson(json);

  Map<String, dynamic> toJson() => _$AudioDatumToJson(this);

  String toString() =>
      super.toString() + ', start: $startRecordingTime, end: $endRecordingTime';
}

/// A [NoiseDatum] that holds the noise level in decibel of a noise sampling.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class NoiseDatum extends Datum {
  DataFormat get format =>
      DataFormat.fromString(AudioVideoSamplingPackage.NOISE);

  // The sound intensity [dB] measurement statistics for a given sampling window.

  /// Mean decibel of sampling window.
  double meanDecibel;

  /// Standard deviation (in decibel) of sampling window.
  double stdDecibel;

  /// Minimum decibel of sampling window.
  double minDecibel;

  /// Maximum decibel of sampling window.
  double maxDecibel;

  NoiseDatum({
    required this.meanDecibel,
    required this.stdDecibel,
    required this.minDecibel,
    required this.maxDecibel,
  }) : super();

  factory NoiseDatum.fromJson(Map<String, dynamic> json) =>
      _$NoiseDatumFromJson(json);

  Map<String, dynamic> toJson() => _$NoiseDatumToJson(this);

  String toString() =>
      super.toString() +
      ', mean: $meanDecibel, std: $stdDecibel, min: $minDecibel, max: $maxDecibel';
}

enum VideoType { video, image }

/// A datum that holds the path to a video or image file on the local device,
/// as well as the timestamps of when the recording was started and stopped.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class VideoDatum extends AudioDatum {
  DataFormat get format =>
      DataFormat.fromString(AudioVideoSamplingPackage.VIDEO);

  VideoType videoType;

  VideoDatum({
    required String filename,
    required this.videoType,
    DateTime? startRecordingTime,
    DateTime? endRecordingTime,
  }) : super(
          filename: filename,
          startRecordingTime: startRecordingTime,
          endRecordingTime: endRecordingTime,
        );

  factory VideoDatum.fromJson(Map<String, dynamic> json) =>
      _$VideoDatumFromJson(json);

  Map<String, dynamic> toJson() => _$VideoDatumToJson(this);

  String toString() => super.toString() + ', videoType: $videoType';
}
