/*
 * Copyright 2019 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of context;

/// A [Datum] that holds weather information collected through OpenWeatherMap.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class AirQualityDatum extends CARPDatum {
  static const DataFormat CARP_DATA_FORMAT = DataFormat(NameSpace.CARP, ContextSamplingPackage.AIR_QUALITY);
  DataFormat get format => CARP_DATA_FORMAT;

  String airQualityIndex, source, place;
  double latitude, longitude;
  AirQualityLevel airQualityLevel;

  AirQualityDatum() : super();

  AirQualityDatum.fromAirQualityData(AirQualityData airQualityData)
      : latitude = double.tryParse(airQualityData.latitude),
        longitude = double.tryParse(airQualityData.longitude),
        airQualityIndex = airQualityData.airQualityIndex,
        source = airQualityData.source,
        place = airQualityData.place,
        airQualityLevel = airQualityData.airQualityLevel,
        super();

  factory AirQualityDatum.fromJson(Map<String, dynamic> json) => _$AirQualityDatumFromJson(json);
  Map<String, dynamic> toJson() => _$AirQualityDatumToJson(this);

  String toString() =>
      super.toString() +
      ',place: $place (latitude:$latitude, longitude:$longitude), '
          'souce: $source, '
          'airQualityIndex: $airQualityIndex, '
          'airQualityLevel: $airQualityLevel';
}
