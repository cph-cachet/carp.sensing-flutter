/*
 * Copyright 2019 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of context;

/// Holds information about a geofence event of entering, exiting, or dweling.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class GeofenceDatum extends CARPDatum {
  static const DataFormat CARP_DATA_FORMAT = DataFormat(NameSpace.CARP, ContextSamplingPackage.GEOFENCE);
  DataFormat get format => CARP_DATA_FORMAT;

  GeofenceDatum({this.type, this.name}) : super();

  factory GeofenceDatum.fromJson(Map<String, dynamic> json) => _$GeofenceDatumFromJson(json);
  Map<String, dynamic> toJson() => _$GeofenceDatumToJson(this);

  /// The name of this geofence.
  String name;

  /// Type of geofence event.
  /// Holds information about a geofence event:
  ///  - ENTER
  ///  - EXIT
  ///  - DWELL
  String type;

  String toString() => "Geofence - name: $name, type: $type";
}
