/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */
import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';
import 'package:json_annotation/json_annotation.dart';

part 'sensor_measure.g.dart';

/**
 * Configuration of the sensor (accelerometer and gyroscope) sampling.
 * Each [AccelerometerProbe] or [GyroscopeProbe] will use an
 * instance of this as its configuration.
 *
 * Please note that this sensor generates data at a very high sampling rate and
 * this measure (and its associated [AccelerometerProbe]) can potentially generate a
 * lot of data. Therefore you should specify the [frequency] at which you want to sample
 * (e.g. once every 10 seconds) as well as the [duration] (in milliseconds) you want to
 * sample.
 */
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class SensorMeasure extends PollingProbeMeasure {
  SensorMeasure(measureType) : super(measureType) {}

  @override
  static Function get fromJsonFunction => _$SensorMeasureFromJson;

  factory SensorMeasure.fromJson(Map<String, dynamic> json) => _$SensorMeasureFromJson(json);

  Map<String, dynamic> toJson() => _$SensorMeasureToJson(this);
}
