/*
 * Copyright 2021 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */
part of carp_core_protocols;

/// A [Measure] holds information about what measure to do/collect for a
/// [TaskDescriptor] in a [StudyProtocol].
///
/// See [Measure](https://github.com/cph-cachet/carp.core-kotlin/blob/master/carp.protocols.core/src/commonMain/kotlin/dk/cachet/carp/protocols/domain/tasks/measures/Measure.kt).
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class Measure extends Serializable {
  /// The type of measure to do.
  String type;

  /// The type of measure to do as a [DataType].
  @JsonKey(ignore: true)
  DataType get dataType => DataType.fromString(type);

  Measure({required this.type}) : super();

  Function get fromJsonFunction => _$MeasureFromJson;
  factory Measure.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson(json) as Measure;
  Map<String, dynamic> toJson() => _$MeasureToJson(this);
  String get jsonType =>
      'dk.cachet.carp.protocols.domain.tasks.measures.$runtimeType';

  String toString() => '$runtimeType - type: $type';
}

/// Defines data that needs to be measured/collected from a data stream on a
/// [DeviceDescriptor], as part of a task defined by [TaskDescriptor].
///
/// See [DataTypeMeasure.kt](https://github.com/cph-cachet/carp.core-kotlin/blob/master/carp.protocols.core/src/commonMain/kotlin/dk/cachet/carp/protocols/domain/tasks/measures/DataTypeMeasure.kt).
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class DataTypeMeasure extends Measure {
  DataTypeMeasure({required String type}) : super(type: type);

  Function get fromJsonFunction => _$DataTypeMeasureFromJson;
  factory DataTypeMeasure.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson(json) as DataTypeMeasure;
  Map<String, dynamic> toJson() => _$DataTypeMeasureToJson(this);
}

/// Defines data that needs to be measured/collected from a data stream on a
/// [DeviceDescriptor], as part of a task defined by [TaskDescriptor].
///
/// See [PhoneSensorMeasure.kt](https://github.com/cph-cachet/carp.core-kotlin/blob/master/carp.protocols.core/src/commonMain/kotlin/dk/cachet/carp/protocols/domain/tasks/measures/PhoneSensorMeasure.kt).
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class PhoneSensorMeasure extends Measure {
  PhoneSensorMeasure({required String type, this.duration}) : super(type: type);

  int? duration;

  Function get fromJsonFunction => _$PhoneSensorMeasureFromJson;
  factory PhoneSensorMeasure.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson(json) as PhoneSensorMeasure;
  Map<String, dynamic> toJson() => _$PhoneSensorMeasureToJson(this);

  String toString() => '${super.toString()}, duration: $duration';
}

// /// Time as specified in carp.core as a value in 'microseconds'.
// @JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
// class CarpTime {
//   CarpTime() : super();

//   int microseconds;

//   factory CarpTime.fromJson(Map<String, dynamic> json) =>
//       _$CarpTimeFromJson(json);
//   Map<String, dynamic> toJson() => _$CarpTimeToJson(this);

//   String toString() => '$runtimeType - microseconds: $microseconds';
// }
