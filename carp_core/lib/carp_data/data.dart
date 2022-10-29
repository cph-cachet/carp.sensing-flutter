/*
 * Copyright 2021 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of carp_core_data;

/// A base class for a single unit of sensed information of a certain [format].
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class Data {
  /// The [DataFormat] of this [Data].
  @JsonKey(ignore: true)
  DataFormat format;

  Data([this.format = DataFormat.UNKNOWN]);

  /// Create a Dart object from a JSON map.
  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);

  /// Return a JSON encoding of this object.
  Map<String, dynamic> toJson() => _$DataToJson(this);
}
