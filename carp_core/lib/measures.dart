/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */
part of carp_core;

/// A [Measure] holds information about what measure to do for each task.
/// This also includes measure specific configuration.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class Measure extends Serializable {
  static const String GENERIC_MEASURE = "measure";
  static const String STRING_MEASURE = "string";
  static const String ERROR_MEASURE = "error";
  static const String PROBE_MEASURE = "probe";
  static const String LISTENING_MEASURE = "listening";
  static const String POLLING_MEASURE = "polling";

  /// The type of measure to do.
  String measureType;

  /// A printer-friendly name for this measure.
  String name;

  /// Whether the measure is enabled when the study is started.
  /// A measure is enabled as default.
  bool enabled = true;

  /// A simple key-value map which can hold any application-specific configuration.
  Map<String, String> configuration = new Map<String, String>();

  Measure(this.measureType, {this.name}) : super();

  static Function get fromJsonFunction => _$MeasureFromJson;
  factory Measure.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory.fromJson(json[Serializable.CLASS_IDENTIFIER].toString(), json);
  Map<String, dynamic> toJson() => _$MeasureToJson(this);

  /// Add a key-value pair as configuration for this measure.
  void setConfiguration(String key, String configuration) {
    this.configuration[key] = configuration;
  }

  String toString() {
    return measureType;
  }
}

/// A [ProbeMeasure] specify how a probe should collect data.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class ProbeMeasure extends Measure {
  ProbeMeasure(measureType, {name}) : super(measureType, name: name);

  static Function get fromJsonFunction => _$ProbeMeasureFromJson;
  factory ProbeMeasure.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory.fromJson(json[Serializable.CLASS_IDENTIFIER].toString(), json);
  Map<String, dynamic> toJson() => _$ProbeMeasureToJson(this);
}

/// A [ListeningProbeMeasure] specify how data can be collected by listening to events.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class ListeningProbeMeasure extends Measure {
  ListeningProbeMeasure(measureType, {name}) : super(measureType, name: name);

  static Function get fromJsonFunction => _$ListeningProbeMeasureFromJson;
  factory ListeningProbeMeasure.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory.fromJson(json[Serializable.CLASS_IDENTIFIER].toString(), json);
  Map<String, dynamic> toJson() => _$ListeningProbeMeasureToJson(this);
}

/// A [PollingProbeMeasure] specify how to collect data by polling a sensor/probe on a regular basis.
///
/// Data collection will be started as specified by the [frequency] for a time interval specified as the [duration].
/// Usefull for listening in on sensors (e.g. the accelerometer) on a regular, but limited basis.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class PollingProbeMeasure extends ProbeMeasure {
  /// Sampling frequency in milliseconds (i.e., delay between sampling).
  int frequency;

  /// The sampling duration in milliseconds.
  int duration;

  PollingProbeMeasure(measureType, {name, this.frequency, this.duration}) : super(measureType, name: name);

  static Function get fromJsonFunction => _$PollingProbeMeasureFromJson;
  factory PollingProbeMeasure.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory.fromJson(json[Serializable.CLASS_IDENTIFIER].toString(), json);
  Map<String, dynamic> toJson() => _$PollingProbeMeasureToJson(this);
}
