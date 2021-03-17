/*
 * Copyright 2018-2020 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of audio;

/// Specify the configuration on how to collect an audio recording.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class AudioMeasure extends CAMSMeasure {
  static const String DEFAULT_STUDY_ID = 'default_study';

  /// The study id for the study recording this audio. Needed for
  /// storing the audio file correctly in the device's file system.
  /// If no [studyId] is provide, `default_study` will be used as the default id.
  String studyId = DEFAULT_STUDY_ID;

  AudioMeasure({
    @required String type,
    String name,
    bool enabled = true,
    this.studyId = DEFAULT_STUDY_ID,
  }) : super(type: type, name: name, enabled: enabled);

  Function get fromJsonFunction => _$AudioMeasureFromJson;
  factory AudioMeasure.fromJson(Map<String, dynamic> json) => FromJsonFactory()
      .fromJson(json[Serializable.CLASS_IDENTIFIER].toString(), json);
  Map<String, dynamic> toJson() => _$AudioMeasureToJson(this);

  String toString() => super.toString() + ', studyId: $studyId';
}

/// Specify how to collect noise data, including setting the
/// [frequency], [duration], and [samplingRate] for collecting audio.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class NoiseMeasure extends PeriodicMeasure {
  static const int DEFAULT_SAMPLING_RATE = 500;

  int samplingRate = DEFAULT_SAMPLING_RATE;

  NoiseMeasure({
    @required String type,
    String name,
    bool enabled = true,
    Duration frequency,
    Duration duration,
    this.samplingRate = DEFAULT_SAMPLING_RATE,
  }) : super(
          type: type,
          name: name,
          enabled: enabled,
          frequency: frequency,
          duration: duration,
        );

  Function get fromJsonFunction => _$NoiseMeasureFromJson;
  factory NoiseMeasure.fromJson(Map<String, dynamic> json) => FromJsonFactory()
      .fromJson(json[Serializable.CLASS_IDENTIFIER].toString(), json);
  Map<String, dynamic> toJson() => _$NoiseMeasureToJson(this);

  String toString() => super.toString() + ', samplingRate: $samplingRate';
}
