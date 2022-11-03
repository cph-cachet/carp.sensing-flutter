/*
 * Copyright 2022 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of carp_core_data;

/// Holds data for a [DataType].
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class Data extends Serializable {
  @JsonKey(ignore: true)
  DataType format;

  Data([this.format = DataType.UNKNOWN]) : super();

  @override
  Function get fromJsonFunction => _$DataFromJson;
  factory Data.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson(json) as Data;
  @override
  Map<String, dynamic> toJson() => _$DataToJson(this);
  @override
  String get jsonType => format.toString();
}
