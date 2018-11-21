/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */
part of environment;

/// Specify the configuration on how to collect weather data.
/// Needs an [apiKey] for the OpenWeatherMap API.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class WeatherMeasure extends PollingProbeMeasure {

  String apiKey;

  WeatherMeasure(measureType, {this.apiKey, name, frequency, duration})
      : super(measureType, name: name, frequency: frequency, duration: duration);

  static Function get fromJsonFunction => _$WeatherMeasureFromJson;
  factory WeatherMeasure.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory.fromJson(json[Serializable.CLASS_IDENTIFIER].toString(), json);
  Map<String, dynamic> toJson() => _$WeatherMeasureToJson(this);
}

