/*
 * Copyright 2019 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of context;

/// Holds information about a geofence event of entering, exiting, or dweling.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class GeofenceDatum extends Datum {
  DataFormat get format =>
      DataFormat.fromString(ContextSamplingPackage.GEOFENCE);

  GeofenceDatum({required this.type, this.name}) : super();

  factory GeofenceDatum.fromJson(Map<String, dynamic> json) =>
      _$GeofenceDatumFromJson(json);

  Map<String, dynamic> toJson() => _$GeofenceDatumToJson(this);

  /// The name of this geofence.
  String? name;

  /// Type of geofence event:
  ///  - ENTER
  ///  - EXIT
  ///  - DWELL
  GeofenceType type;

  String toString() => super.toString() + ', name: $name, type: $type';
}

enum GeofenceType { ENTER, EXIT, DWELL }
