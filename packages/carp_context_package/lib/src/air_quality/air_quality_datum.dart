/*
 * Copyright 2019 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of context;

/// A [Datum] that holds air quality information collected through the [World's Air Quality Index (WAQI)](https://waqi.info) API.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class AirQualityDatum extends Datum {
  DataFormat get format =>
      DataFormat.fromString(ContextSamplingPackage.AIR_QUALITY);

  int airQualityIndex;
  String source, place;
  var latitude, longitude;
  AirQualityLevel airQualityLevel;

  AirQualityDatum(
    this.airQualityIndex,
    this.source,
    this.place,
    this.latitude,
    this.longitude,
    this.airQualityLevel,
  ) : super();

  AirQualityDatum.fromAirQualityData(AirQualityData airQualityData)
      : latitude = airQualityData.latitude,
        longitude = airQualityData.longitude,
        airQualityIndex = airQualityData.airQualityIndex,
        source = airQualityData.source,
        place = airQualityData.place,
        airQualityLevel = airQualityData.airQualityLevel,
        super();

  factory AirQualityDatum.fromJson(Map<String, dynamic> json) =>
      _$AirQualityDatumFromJson(json);

  Map<String, dynamic> toJson() => _$AirQualityDatumToJson(this);

  String toString() =>
      super.toString() +
      ', place: $place (latitude:$latitude, longitude:$longitude), '
          'souce: $source, '
          'airQualityIndex: $airQualityIndex, '
          'airQualityLevel: $airQualityLevel';
}
