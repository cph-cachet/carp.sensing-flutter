/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of audio;

/// Specify the configuration on how to collect audio. As any other sensor, the [frequency] specify
/// the sampling rate and [duration] specify the duration of the recording.
///
/// The filename format is "audio-yyyy-mm-dd-hh-mm-ss-ms.m4a".
/// See also the [FileDataManager] on how files are handled.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class AudioMeasure extends SensorMeasure {
  /// The path to the directory in which to store audio files.
  /// Will be created relative to the application directory on this device.
  String soundFileDirPath;

  AudioMeasure(measureType, {name, frequency, duration, this.soundFileDirPath})
      : super(measureType, name: name, frequency: frequency, duration: duration);

  static Function get fromJsonFunction => _$AudioMeasureFromJson;

  factory AudioMeasure.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory.fromJson(json[Serializable.CLASS_IDENTIFIER].toString(), json);

  Map<String, dynamic> toJson() => _$AudioMeasureToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class NoiseMeasure extends SensorMeasure {

  int samplingRate;
  NoiseMeasure(measureType, {name, frequency, duration, this.samplingRate})
      : super(measureType, name: name, frequency: frequency, duration: duration);

  static Function get fromJsonFunction => _$NoiseMeasureFromJson;

  factory NoiseMeasure.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory.fromJson(json[Serializable.CLASS_IDENTIFIER].toString(), json);

  Map<String, dynamic> toJson() => _$NoiseMeasureToJson(this);
}
