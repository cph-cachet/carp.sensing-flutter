/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */
part of carp_core;

/// A [Measure] holds information about what measure to do/collect for each [TaskDescriptor] in a [Study].
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class Measure extends Serializable {
  /// The type of measure to do.
  DataFormat type;

  /// A printer-friendly name for this measure.
  String name;

  /// Whether the measure is enabled when the study is started.
  /// A measure is enabled as default.
  bool enabled = true;

  Measure(this.type, {this.name, this.enabled}) : super();

  static Function get fromJsonFunction => _$MeasureFromJson;
  factory Measure.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory.fromJson(json[Serializable.CLASS_IDENTIFIER].toString(), json);
  Map<String, dynamic> toJson() => _$MeasureToJson(this);

  String toString() => type.toString();
}
