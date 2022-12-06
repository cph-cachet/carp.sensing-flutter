/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of carp_context_package;

/// A [Data] that holds weather information collected through OpenWeatherMap.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class WeatherData extends Data {
  static const dataType = ContextSamplingPackage.WEATHER;

  String? country, areaName, weatherMain, weatherDescription;
  DateTime? date, sunrise, sunset;
  double? latitude,
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

  WeatherData() : super();

  WeatherData.fromWeatherData(Weather weather)
      : country = weather.country,
        areaName = weather.areaName,
        weatherMain = weather.weatherMain,
        weatherDescription = weather.weatherDescription,
        date = weather.date,
        sunrise = weather.sunrise,
        sunset = weather.sunset,
        latitude = weather.latitude,
        longitude = weather.longitude,
        pressure = weather.pressure,
        windSpeed = weather.windSpeed,
        windDegree = weather.windDegree,
        humidity = weather.humidity,
        cloudiness = weather.cloudiness,
        rainLastHour = weather.rainLastHour,
        rainLast3Hours = weather.rainLast3Hours,
        snowLastHour = weather.snowLastHour,
        snowLast3Hours = weather.snowLast3Hours,
        temperature = weather.temperature!.celsius,
        tempMin = weather.tempMin!.celsius,
        tempMax = weather.tempMax!.celsius,
        super();

  factory WeatherData.fromJson(Map<String, dynamic> json) =>
      _$WeatherDataFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$WeatherDataToJson(this);

  @override
  String toString() =>
      '${super.toString()}, place: $areaName ($country), date: $date, weather: $weatherMain, $weatherDescription, temperature (min, max): $temperature ($tempMin, $tempMax), sunrise: $sunrise, sunset: $sunset';
}
