/*
 * Copyright 2022 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */
part of carp_core_common;

/// Defines data that needs to be measured/collected passively as part of a
/// task defined by [TaskConfiguration].
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class Measure extends Serializable {
  /// The type of measure to do.
  String type;

  /// The type of measure as a [DataType].
  @JsonKey(ignore: true)
  DataType get dataType => DataType.fromString(type);

  /// Optionally, override the default configuration on how to sample the data
  /// stream of the matching [type] on the device.
  /// In case `null` is specified, the default configuration is derived from the
  /// [DeviceConfiguration].
  SamplingConfiguration? overrideSamplingConfiguration;

  /// Create a measure by specifying its [type].
  Measure({required this.type}) : super();

  @override
  Function get fromJsonFunction => _$MeasureFromJson;
  factory Measure.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson(json) as Measure;
  @override
  Map<String, dynamic> toJson() => _$MeasureToJson(this);
  @override
  String get jsonType =>
      'dk.cachet.carp.common.application.tasks.Measure.DataStream';

  @override
  String toString() => '$runtimeType - type: $type';
}
