/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of context;

/// Holds location information using the GPS format.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class LocationDatum extends CARPDatum {
  static const DataFormat CARP_DATA_FORMAT = DataFormat(NameSpace.CARP, DataType.LOCATION);
  DataFormat get format => CARP_DATA_FORMAT;

  LocationDatum() : super();

  LocationDatum.fromMap(Map<dynamic, dynamic> map)
      : latitude = map['latitude'],
        longitude = map['longitude'],
        altitude = map['altitude'],
        accuracy = map['accuracy'],
        speed = map['speed'],
        speedAccuracy = map['speedAccuracy'],
        super();

  factory LocationDatum.fromJson(Map<String, dynamic> json) => _$LocationDatumFromJson(json);
  Map<String, dynamic> toJson() => _$LocationDatumToJson(this);

  /// Latitude in GPS coordinates.
  double latitude;

  /// Longitude in GPS coordinates.
  double longitude;

  /// Altitude in GPS coordinates.
  double altitude;

  // TODO : check if this is true.
  /// Accuracy in absolute measures.
  double accuracy;

  // TODO : check if this is true.
  /// Estimated movement speed.
  double speed;

  // TODO : check if this is true.
  /// Accuracy in speed estimation.
  ///
  /// Will always be 0 on iOS
  double speedAccuracy;

  /// The 2D GPS coordinates [latitude, longitude].
  get gpsCoordinates => [latitude, longitude];

  String toString() =>
      "Location - latitude: $latitude, longitude: $longitude, accuracy; $accuracy, altitude: $altitude, speed: $speed, speed_accuracy: $speedAccuracy";
}
