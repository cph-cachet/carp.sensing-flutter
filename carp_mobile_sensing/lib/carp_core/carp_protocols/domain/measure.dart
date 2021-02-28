/*
 * Copyright 2021 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */
part of carp_core;

/// A [Measure] holds information about what measure to do/collect for a
/// [TaskDescriptor] in a [StudyProtocol].
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class Measure extends Serializable {
  /// The type of measure to do.
  DataType type;

  Measure({this.type}) : super();

  Function get fromJsonFunction => _$MeasureFromJson;
  factory Measure.fromJson(Map<String, dynamic> json) => FromJsonFactory()
      .fromJson(json[Serializable.CLASS_IDENTIFIER].toString(), json);
  Map<String, dynamic> toJson() => _$MeasureToJson(this);

  String toString() => '$runtimeType: type: $type';
}
