/*
 * Copyright 2021 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */
part of carp_core;

/// A base (abstract) class for a single unit of sensed information.
/// Holds data for a [DataType].
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class Data {
  /// The [DataType] of this [Data].
  @JsonKey(ignore: true)
  DataType format;

  /// Unique identifier for the current Datum, unique across all data generated.
  String id;

  /// The UTC timestamp when this data was generated on the device.
  DateTime timestamp;

  Data({this.id, this.timestamp}) {
    id ??= Uuid().v1();
    timestamp ??= DateTime.now().toUtc();
  }

  /// Create a Dart object from a JSON map.
  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);

  /// Return a JSON encoding of this object.
  Map<String, dynamic> toJson() => _$DataToJson(this);
}
