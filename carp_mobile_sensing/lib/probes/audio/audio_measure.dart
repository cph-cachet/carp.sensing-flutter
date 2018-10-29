/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

//part of audio;



part of audio;

/// Configuration of a sensor (e.g., accelerometer,  gyroscope, light) sampling.
/// Each [Probe] will use an instance of this as its configuration.
///
///Please note that this sensor generates data at a very high sampling rate and
///this measure (and its associated [AudioProbe]) can potentially generate a
///lot of data. Therefore you should specify the [frequency] at which you want to sample
///(e.g. once every 10 seconds) as well as the [duration] (in milliseconds) you want to
///sample.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class AudioMeasure extends PollingProbeMeasure {
  AudioMeasure(measureType) : super(measureType);

  static Function get fromJsonFunction => _$AudioMeasureFromJson;
  factory AudioMeasure.fromJson(Map<String, dynamic> json) =>
      _$AudioMeasureFromJson(json);
  Map<String, dynamic> toJson() => _$AudioMeasureToJson(this);
}
