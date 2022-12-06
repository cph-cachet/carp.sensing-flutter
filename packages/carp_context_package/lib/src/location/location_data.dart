/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of carp_context_package;

/// Holds location information using the GPS format.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class LocationData extends Data {
  static const dataType = ContextSamplingPackage.LOCATION;

  LocationData() : super();

  LocationData.fromLocation(location.LocationData location)
      : latitude = location.latitude,
        longitude = location.longitude,
        altitude = location.altitude,
        accuracy = location.accuracy,
        speed = location.speed,
        speedAccuracy = location.speedAccuracy,
        heading = location.heading,
        time = (location.time != null)
            ? DateTime.fromMillisecondsSinceEpoch(location.time!.toInt())
            : null,
        super();

  factory LocationData.fromJson(Map<String, dynamic> json) =>
      _$LocationDataFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$LocationDataToJson(this);

  /// The time when this location was collected.
  DateTime? time;

  /// Latitude in GPS coordinates.
  double? latitude;

  /// Longitude in GPS coordinates.
  double? longitude;

  /// Altitude in GPS coordinates.
  double? altitude;

  /// Accuracy in absolute measures.
  double? accuracy;

  /// Estimated movement speed.
  double? speed;

  /// Accuracy in speed estimation.
  ///
  /// Will always be 0 on iOS
  double? speedAccuracy;

  /// Heading in degrees
  double? heading;

  /// The 2D GPS coordinates [latitude, longitude].
  // get gpsCoordinates => [latitude, longitude];

  @override
  String toString() =>
      '${super.toString()}, latitude: $latitude, longitude: $longitude, accuracy; $accuracy, altitude: $altitude, speed: $speed, speed_accuracy: $speedAccuracy, heading: $heading, time: $time';
}
