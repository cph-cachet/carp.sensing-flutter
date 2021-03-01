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
  String get jsonType =>
      'dk.cachet.carp.protocols.domain.tasks.measures.Measure';

  String toString() => '$runtimeType: type: $type';
}

/// Defines data that needs to be measured/collected from a data stream on a
/// [DeviceDescriptor], as part of a task defined by [TaskDescriptor].
///
/// See [Measure.kt](https://github.com/cph-cachet/carp.core-kotlin/blob/develop/carp.protocols.core/src/commonMain/kotlin/dk/cachet/carp/protocols/domain/tasks/measures/DataTypeMeasure.kt).
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class DataTypeMeasure extends Measure {
  DataTypeMeasure({DataType type}) : super(type: type);

  Function get fromJsonFunction => _$DataTypeMeasureFromJson;
  factory DataTypeMeasure.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory()
          .fromJson(json[Serializable.CLASS_IDENTIFIER].toString(), json);
  Map<String, dynamic> toJson() => _$DataTypeMeasureToJson(this);
  String get jsonType =>
      'dk.cachet.carp.protocols.domain.tasks.measures.DataTypeMeasure';

  String toString() => '$runtimeType - type: $type';
}

/// Defines data that needs to be measured/collected from a data stream on a
/// [DeviceDescriptor], as part of a task defined by [TaskDescriptor].
///
/// See [Measure.kt](https://github.com/cph-cachet/carp.core-kotlin/blob/develop/carp.protocols.core/src/commonMain/kotlin/dk/cachet/carp/protocols/domain/tasks/measures/PhoneSensorMeasure.kt).
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class PhoneSensorMeasure extends DataTypeMeasure {
  PhoneSensorMeasure() : super();

  CarpTime duration;

  Function get fromJsonFunction => _$PhoneSensorMeasureFromJson;
  factory PhoneSensorMeasure.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory()
          .fromJson(json[Serializable.CLASS_IDENTIFIER].toString(), json);
  Map<String, dynamic> toJson() => _$PhoneSensorMeasureToJson(this);
  String get jsonType =>
      'dk.cachet.carp.protocols.domain.tasks.measures.PhoneSensorMeasure';

  String toString() => '${super.toString()}, duration: $duration';
}

/// Time as specified in carp.core as a value in 'microseconds'.
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class CarpTime {
  CarpTime() : super();

  int microseconds;

  factory CarpTime.fromJson(Map<String, dynamic> json) =>
      _$CarpTimeFromJson(json);
  Map<String, dynamic> toJson() => _$CarpTimeToJson(this);

  String toString() => '$runtimeType - microseconds: $microseconds';
}
