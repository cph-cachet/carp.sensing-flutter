/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of context;

/// Specify the configuration on how to collect weather data.
/// Needs an [apiKey] for the OpenWeatherMap API.
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class WeatherMeasure extends CAMSMeasure {
  /// API key for the OpenWeatherMap API.
  String apiKey;

  WeatherMeasure({
    required String type,
    String? name,
    String? description,
    bool enabled = true,
    required this.apiKey,
  }) : super(
            type: type, name: name, description: description, enabled: enabled);

  Function get fromJsonFunction => _$WeatherMeasureFromJson;
  factory WeatherMeasure.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson(json) as WeatherMeasure;
  Map<String, dynamic> toJson() => _$WeatherMeasureToJson(this);

  String toString() => super.toString() + ', API key: $apiKey';
}
