/*
 * Copyright 2019 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of carp_context_package;

/// Holds information about a geofence event of entering, exiting, or dweling.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class GeofenceDatum extends Datum {
  @override
  DataFormat get format =>
      DataFormat.fromString(ContextSamplingPackage.GEOFENCE);

  GeofenceDatum({required this.type, this.name}) : super();

  factory GeofenceDatum.fromJson(Map<String, dynamic> json) =>
      _$GeofenceDatumFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$GeofenceDatumToJson(this);

  /// The name of this geofence.
  String? name;

  /// Type of geofence event:
  ///  - ENTER
  ///  - EXIT
  ///  - DWELL
  GeofenceType type;

  @override
  String toString() => '${super.toString()}, name: $name, type: $type';
}

enum GeofenceType { ENTER, EXIT, DWELL }
