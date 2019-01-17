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
class WeatherMeasure extends PeriodicMeasure {
  static const String DEFAULT_WEATHER_API_KEY = '12b6e28582eb9298577c734a31ba9f4f';

  /// API key for the OpenWeatherMap API.
  String apiKey = DEFAULT_WEATHER_API_KEY;

  WeatherMeasure(MeasureType type, {name, enabled, frequency, duration, this.apiKey})
      : super(type, name: name, enabled: enabled, frequency: frequency, duration: duration);

  static Function get fromJsonFunction => _$WeatherMeasureFromJson;
  factory WeatherMeasure.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory.fromJson(json[Serializable.CLASS_IDENTIFIER].toString(), json);
  Map<String, dynamic> toJson() => _$WeatherMeasureToJson(this);
}
