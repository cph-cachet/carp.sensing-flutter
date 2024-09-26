part of 'media.dart';

/// Type of media.
enum MediaType { audio, video, image }

/// A datum that holds the path to media file on the local device,
/// as well as the timestamps of when the recording was started and stopped
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class Media extends FileData {
  static const dataType = MediaSamplingPackage.MEDIA;

  /// A unique id of this media file.
  late String id;

  /// The type of media.
  MediaType mediaType;

  /// The timestamp for start of recording, if available.
  DateTime? startRecordingTime;

  /// The timestamp for end of recording, if available.
  DateTime? endRecordingTime;

  Media({
    required super.filename,
    required this.mediaType,
    this.startRecordingTime,
    this.endRecordingTime,
  }) {
    id = const Uuid().v1;
  }

  @override
  Function get fromJsonFunction => _$MediaFromJson;
  factory Media.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson<Media>(json);
  @override
  Map<String, dynamic> toJson() => _$MediaToJson(this);

  @override
  String toString() =>
      '${super.toString()}, start: $startRecordingTime, end: $endRecordingTime';
}

/// Holds the noise level in decibel of a noise sampling.
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class Noise extends Data {
  static const dataType = MediaSamplingPackage.NOISE;

  // The sound intensity [dB] measurement statistics for a given sampling window.

  /// Mean decibel of sampling window.
  double meanDecibel;

  /// Standard deviation (in decibel) of sampling window.
  double stdDecibel;

  /// Minimum decibel of sampling window.
  double minDecibel;

  /// Maximum decibel of sampling window.
  double maxDecibel;

  Noise({
    required this.meanDecibel,
    required this.stdDecibel,
    required this.minDecibel,
    required this.maxDecibel,
  }) : super();

  @override
  Function get fromJsonFunction => _$NoiseFromJson;
  factory Noise.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson<Noise>(json);
  @override
  Map<String, dynamic> toJson() => _$NoiseToJson(this);

  @override
  String toString() =>
      '${super.toString()}, mean: $meanDecibel, std: $stdDecibel, min: $minDecibel, max: $maxDecibel';
}
