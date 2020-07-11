/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of context;

/// Specify the configuration on how to collect weather data.
/// Needs an [apiKey] for the OpenWeatherMap API.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class WeatherMeasure extends Measure {
  /// API key for the OpenWeatherMap API.
  String apiKey;
  double latitude, longitude;

  WeatherMeasure(MeasureType type,
      {name, enabled, this.apiKey, this.latitude, this.longitude})
      : super(type, name: name, enabled: enabled);

  static Function get fromJsonFunction => _$WeatherMeasureFromJson;

  factory WeatherMeasure.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory.fromJson(
          json[Serializable.CLASS_IDENTIFIER].toString(), json);

  Map<String, dynamic> toJson() => _$WeatherMeasureToJson(this);

  String toString() =>
      super.toString() +
      ', API key: $apiKey, Location: ($latitude, $longitude)';
}
