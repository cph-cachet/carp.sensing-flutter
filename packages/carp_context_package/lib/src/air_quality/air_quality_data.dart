/*
 * Copyright 2019-2022 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of carp_context_package;

/// A [Data] that holds air quality information collected via the
/// [World's Air Quality Index (WAQI)](https://waqi.info) API.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class AirQualityIndexData extends Data {
  static const dataType = ContextSamplingPackage.AIR_QUALITY;

  int airQualityIndex;
  String source, place;
  double latitude, longitude;
  AirQualityLevel airQualityLevel;

  AirQualityIndexData(
    this.airQualityIndex,
    this.source,
    this.place,
    this.latitude,
    this.longitude,
    this.airQualityLevel,
  ) : super();

  AirQualityIndexData.fromAirQualityData(AirQualityData airQualityData)
      : latitude = airQualityData.latitude,
        longitude = airQualityData.longitude,
        airQualityIndex = airQualityData.airQualityIndex,
        source = airQualityData.source,
        place = airQualityData.place,
        airQualityLevel = airQualityData.airQualityLevel,
        super();

  factory AirQualityIndexData.fromJson(Map<String, dynamic> json) =>
      _$AirQualityIndexDataFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$AirQualityIndexDataToJson(this);

  @override
  String toString() =>
      '${super.toString()}, place: $place (latitude:$latitude, longitude:$longitude), souce: $source, airQualityIndex: $airQualityIndex, airQualityLevel: $airQualityLevel';
}
