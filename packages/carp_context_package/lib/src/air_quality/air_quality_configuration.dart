/*
 * Copyright 2019 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of context;

/// Specify the configuration on how to collect air quality data.
/// Needs an [apiKey] for the [World's Air Quality Index (WAQI) API](https://aqicn.org/data-platform/token/#/).
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class AirQualitySamplingConfiguration extends PersistentSamplingConfiguration {
  /// API key for the WAQI API.
  String apiKey;

  AirQualitySamplingConfiguration({required this.apiKey}) : super();

  Function get fromJsonFunction => _$AirQualitySamplingConfigurationFromJson;
  Map<String, dynamic> toJson() =>
      _$AirQualitySamplingConfigurationToJson(this);
  factory AirQualitySamplingConfiguration.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson(json) as AirQualitySamplingConfiguration;
}
