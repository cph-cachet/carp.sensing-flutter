/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */
part of core;

/// A [Measure] holds information about what measure to do/collect for a [Task] in a [Study].
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class Measure extends Serializable {
  /// The type of measure to do.
  MeasureType type;

  /// A printer-friendly name for this measure.
  String name;

  /// Whether the measure is enabled when the study is started.
  /// A measure is enabled as default.
  bool enabled = true;

  /// A key-value map holding any application-specific configuration.
  Map<String, String> configuration = new Map<String, String>();

  Measure(this.type, {this.name, this.enabled = true})
      : assert(type != null),
        super();

  static Function get fromJsonFunction => _$MeasureFromJson;
  factory Measure.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory.fromJson(json[Serializable.CLASS_IDENTIFIER].toString(), json);
  Map<String, dynamic> toJson() => _$MeasureToJson(this);

  /// Add a key-value pair as configuration for this measure.
  void setConfiguration(String key, String configuration) => this.configuration[key] = configuration;

  /// Get value from the configuration for this measure.
  String getConfiguration(String key) => this.configuration[key];

  String toString() => type.toString();
}

/// A [PeriodicMeasure] specify how to collect data on a regular basis.
///
/// Data collection will be started as specified by the [frequency] for a time interval specified as the [duration].
/// Usefull for listening in on a sensor (e.g. the accelerometer) on a regular, but limited basis.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class PeriodicMeasure extends Measure {
  /// Sampling frequency in milliseconds (i.e., delay between sampling).
  int frequency;

  /// The sampling duration in milliseconds.
  int duration;

  PeriodicMeasure(MeasureType type, {name, enabled = true, this.frequency, this.duration})
      : super(type, name: name, enabled: enabled);

  static Function get fromJsonFunction => _$PeriodicMeasureFromJson;
  factory PeriodicMeasure.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory.fromJson(json[Serializable.CLASS_IDENTIFIER].toString(), json);
  Map<String, dynamic> toJson() => _$PeriodicMeasureToJson(this);
}

/// Specifies the type of a [Measure].
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class MeasureType extends Serializable {
  /// The data format namespace. See [NameSpace].
  String namepace;

  /// The name of this data format.
  String name;

  MeasureType(this.namepace, this.name) : super();

  static Function get fromJsonFunction => _$MeasureTypeFromJson;
  factory MeasureType.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory.fromJson(json[Serializable.CLASS_IDENTIFIER].toString(), json);
  Map<String, dynamic> toJson() => _$MeasureTypeToJson(this);

  String toString() => "$namepace.$name";
}
