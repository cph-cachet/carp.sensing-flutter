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
  DataType type;

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

  PeriodicMeasure(DataType type, {name, enabled = true, this.frequency, this.duration})
      : super(type, name: name, enabled: enabled);

  static Function get fromJsonFunction => _$PeriodicMeasureFromJson;
  factory PeriodicMeasure.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory.fromJson(json[Serializable.CLASS_IDENTIFIER].toString(), json);
  Map<String, dynamic> toJson() => _$PeriodicMeasureToJson(this);
}

/// Specifies the data type of a [Measure].
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class DataType extends Serializable {
  /// The data format namespace. See [NameSpace].
  String namepace;

  /// The name of this data format.
  String name;

  DataType(this.namepace, this.name) : super();

  static Function get fromJsonFunction => _$DataTypeFromJson;
  factory DataType.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory.fromJson(json[Serializable.CLASS_IDENTIFIER].toString(), json);
  Map<String, dynamic> toJson() => _$DataTypeToJson(this);

  String toString() => "$namepace.$name";
}

/// An abstract class represent any namespace schema.
/// Currently supporting:
/// * `omh`  : Open mHealth data format
/// * `carp` : CARP data format
abstract class NameSpace {
  static const String UNKNOWN_NAMESPACE = "unknown";
  static const String OMH_NAMESPACE = "omh";
  static const String CARP_NAMESPACE = "carp";
}

class MeasureType {
  static const String MEASURE = "measure";
  static const String STRING = "string";
  static const String ERROR = "error";
  static const String MEMORY = "memory";
  static const String PEDOMETER = "pedometer";
  static const String ACCELEROMETER = "accelerometer";
  static const String GYROSCOPE = "gyroscope";
  static const String BATTERY = "battery";
  static const String BLUETOOTH = "bluetooth";
  static const String AUDIO = "audio";
  static const String NOISE = "noise";
  static const String LOCATION = "location";
  static const String CONNECTIVITY = "connectivity";
  static const String LIGHT = "light";
  static const String APPS = "apps";
  static const String APP_USAGE = "app_usage";
  static const String TEXT_MESSAGE_LOG = "text-message-log";
  static const String TEXT_MESSAGE = "text-message";
  static const String SCREEN = "screen";
  static const String PHONE_LOG = "phone_log";
  static const String ACTIVITY = "activity";
  static const String APPLE_HEALTHKIT = "apple-healthkit";
  static const String GOOGLE_FIT = "google-fit";
  static const String WEATHER = "weather";
}
