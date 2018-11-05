/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of sensors;

/// Configuration of a sensor (e.g., accelerometer,  gyroscope, light) sampling.
/// Each [Probe] will use an instance of this as its configuration.
///
///Please note that this sensor generates data at a very high sampling rate and
///this measure (and its associated [AccelerometerProbe]) can potentially generate a
///lot of data. Therefore you should specify the [frequency] at which you want to sample
///(e.g. once every 10 seconds) as well as the [duration] (in milliseconds) you want to
///sample.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class SensorMeasure extends PollingProbeMeasure {
  SensorMeasure(measureType, {name, frequency, duration})
      : super(measureType,
            name: name, frequency: frequency, duration: duration);

  static Function get fromJsonFunction => _$SensorMeasureFromJson;
  factory SensorMeasure.fromJson(Map<String, dynamic> json) =>
      _$SensorMeasureFromJson(json);
  Map<String, dynamic> toJson() => _$SensorMeasureToJson(this);
}
