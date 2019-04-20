/*
 * Copyright 2019 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of context;

/// Eart radius in km.
const double earthRadius = 6371000.0;

/// Location coordinated in Degrees (i.e. GPS-style).
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class Location extends Serializable {
  /// Latitude in GPS coordinates.
  final double latitude;

  /// Longitude in GPS coordinates.
  final double longitude;

  Location(this.latitude, this.longitude)
      : assert(latitude != null),
        assert(longitude != null);

  Location.fromMap(Map<dynamic, dynamic> map)
      : latitude = map['latitude'],
        longitude = map['longitude'],
        super();

  static Function get fromJsonFunction => _$LocationFromJson;
  factory Location.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory.fromJson(json[Serializable.CLASS_IDENTIFIER].toString(), json);
  Map<String, dynamic> toJson() => _$LocationToJson(this);

  String toString() => 'Location (latitude:$latitude, longitude:$longitude)';
  int get hashCode => latitude.hashCode + longitude.hashCode;
  bool operator ==(Object other) => other is Location && latitude == other.latitude && longitude == other.longitude;
}

/// Specify the configuration of a circular geofence measure, specifying the:
///  - center
///  - radius
///  - name
/// of the geofence.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class GeofenceMeasure extends Measure {
  /// The center of the geofence as a GPS location.
  Location center;

  /// The radius of the geofence in meters.
  double radius;

  /// The name of this geofence.
  String name;

  /// Specify a geofence measure
  GeofenceMeasure(MeasureType type, {enabled, this.center, this.radius, this.name}) : super(type, enabled: enabled);

  static Function get fromJsonFunction => _$GeofenceMeasureFromJson;
  factory GeofenceMeasure.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory.fromJson(json[Serializable.CLASS_IDENTIFIER].toString(), json);
  Map<String, dynamic> toJson() => _$GeofenceMeasureToJson(this);
}
