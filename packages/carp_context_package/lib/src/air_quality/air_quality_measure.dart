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
class AirQualityMeasure extends CAMSMeasure {
  /// API key for the OpenWeatherMap API.
  String apiKey;

  AirQualityMeasure({
    required String type,
    String? name,
    String? description,
    enabled = true,
    required this.apiKey,
  }) : super(
            type: type, name: name, description: description, enabled: enabled);

  Function get fromJsonFunction => _$AirQualityMeasureFromJson;
  factory AirQualityMeasure.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson(json) as AirQualityMeasure;

  Map<String, dynamic> toJson() => _$AirQualityMeasureToJson(this);

  String toString() => super.toString() + ', API key: $apiKey';
}
