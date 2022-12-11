/*
 * Copyright 2018-2022 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of carp_context_package;

/// Holds location information using the GPS format from the phone.
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class Location extends Geolocation {
  static const dataType = ContextSamplingPackage.LOCATION;

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

  /// The time when this location was collected.
  DateTime? time;

  Location({
    super.latitude,
    super.longitude,
    this.altitude,
    this.accuracy,
    this.heading,
    this.speed,
    this.speedAccuracy,
    this.time,
  }) : super();

  Location.fromLocation(location.LocationData location) : super() {
    latitude = location.latitude ?? 0;
    longitude = location.longitude ?? 0;
    altitude = location.altitude;
    accuracy = location.accuracy;
    speed = location.speed;
    speedAccuracy = location.speedAccuracy;
    heading = location.heading;
    time = (location.time != null)
        ? DateTime.fromMillisecondsSinceEpoch(location.time!.toInt())
        : null;
  }

  factory Location.fromJson(Map<String, dynamic> json) =>
      _$LocationFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$LocationToJson(this);

  @override
  String toString() =>
      '${super.toString()}, latitude: $latitude, longitude: $longitude, accuracy; $accuracy, altitude: $altitude, speed: $speed, speed_accuracy: $speedAccuracy, heading: $heading, time: $time';
}
