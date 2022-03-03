/*
 * Copyright 2020 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of media;

/// Type of media.
enum MediaType { audio, video, image }

/// A datum that holds the path to media file on the local device,
/// as well as the timestamps of when the recording was started and stopped
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class MediaDatum extends FileDatum {
  DataFormat get format => DataFormat.fromString(MediaSamplingPackage.AUDIO);

  /// The type of media.
  MediaType mediaType;

  /// The timestamp for start of recording, if available.
  DateTime? startRecordingTime;

  /// The timestamp for end of recording, if available.
  DateTime? endRecordingTime;

  MediaDatum({
    required String filename,
    required this.mediaType,
    this.startRecordingTime,
    this.endRecordingTime,
  }) : super(filename: filename);

  factory MediaDatum.fromJson(Map<String, dynamic> json) =>
      _$MediaDatumFromJson(json);

  Map<String, dynamic> toJson() => _$MediaDatumToJson(this);

  String toString() =>
      super.toString() + ', start: $startRecordingTime, end: $endRecordingTime';
}

/// A [NoiseDatum] that holds the noise level in decibel of a noise sampling.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class NoiseDatum extends Datum {
  DataFormat get format => DataFormat.fromString(MediaSamplingPackage.NOISE);

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
