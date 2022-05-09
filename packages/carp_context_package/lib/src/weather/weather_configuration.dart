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
class WeatherSamplingConfiguration extends PersistentSamplingConfiguration {
  /// API key for the OpenWeatherMap API.
  String apiKey;

  WeatherSamplingConfiguration({required this.apiKey}) : super();

  Function get fromJsonFunction => _$WeatherSamplingConfigurationFromJson;
  Map<String, dynamic> toJson() => _$WeatherSamplingConfigurationToJson(this);
  factory WeatherSamplingConfiguration.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson(json) as WeatherSamplingConfiguration;
}
