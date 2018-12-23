/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of environment;

/// A [Datum] that holds weather information collected through OpenWeatherMap.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class WeatherDatum extends CARPDatum {
  String country, areaName, weatherMain, weatherDescription;
  DateTime date, sunrise, sunset;
  double latitude,
      longitude,
      pressure,
      windSpeed,
      windDegree,
      humidity,
      cloudiness,
      rainLastHour,
      rainLast3Hours,
      snowLastHour,
      snowLast3Hours,
      temperature,
      tempMin,
      tempMax;

  WeatherDatum({Measure measure}) : super(measure: measure);

  factory WeatherDatum.fromJson(Map<String, dynamic> json) => _$WeatherDatumFromJson(json);
  Map<String, dynamic> toJson() => _$WeatherDatumToJson(this);

  String toString() {
    return '''
    Place Name: $areaName ($country)
    Date: $date
    Weather: $weatherMain, $weatherDescription
    Temp: $temperature, Temp (min): $tempMin, Temp (max): $tempMax
    Sunrise: $sunrise, Sunset: $sunset
    ''';
  }
}
