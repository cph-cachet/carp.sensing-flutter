/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of context;

/// Holds location information using the GPS format.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class LocationDatum extends Datum {
  DataFormat get format =>
      DataFormat.fromString(ContextSamplingPackage.LOCATION);

  LocationDatum() : super();

  LocationDatum.fromLocationDto(LocationDto dto)
      : latitude = dto.latitude,
        longitude = dto.longitude,
        altitude = dto.altitude,
        accuracy = dto.accuracy,
        speed = dto.speed,
        speedAccuracy = dto.speedAccuracy,
        heading = dto.heading,
        time = DateTime.fromMillisecondsSinceEpoch(dto.time.toInt()),
        super();

  // LocationDatum.fromLocation(location.LocationData location)
  //     : latitude = location.latitude,
  //       longitude = location.longitude,
  //       altitude = location.altitude,
  //       accuracy = location.accuracy,
  //       speed = location.speed,
  //       speedAccuracy = location.speedAccuracy,
  //       heading = location.heading,
  //       time = DateTime.fromMillisecondsSinceEpoch(location.time.toInt()),
  //       super();

  LocationDatum.fromPosition(Position position)
      : latitude = position.latitude,
        longitude = position.longitude,
        altitude = position.altitude,
        accuracy = position.accuracy,
        speed = position.speed,
        speedAccuracy = position.speedAccuracy,
        heading = position.heading,
        time = position.timestamp,
        super();

  factory LocationDatum.fromJson(Map<String, dynamic> json) =>
      _$LocationDatumFromJson(json);

  Map<String, dynamic> toJson() => _$LocationDatumToJson(this);

  /// The time when this location was collected.
  DateTime? time;

  /// Latitude in GPS coordinates.
  var latitude;

  /// Longitude in GPS coordinates.
  var longitude;

  /// Altitude in GPS coordinates.
  var altitude;

  /// Accuracy in absolute measures.
  var accuracy;

  /// Estimated movement speed.
  var speed;

  /// Accuracy in speed estimation.
  ///
  /// Will always be 0 on iOS
  var speedAccuracy;

  /// Heading in degrees
  var heading;

  /// The 2D GPS coordinates [latitude, longitude].
  get gpsCoordinates => [latitude, longitude];

  String toString() =>
      super.toString() +
      'latitude: $latitude, '
      'longitude: $longitude, '
      'accuracy; $accuracy, '
      'altitude: $altitude, '
      'speed: $speed, '
      'speed_accuracy: $speedAccuracy, '
      'heading: $heading, '
      'time: $time';
}
