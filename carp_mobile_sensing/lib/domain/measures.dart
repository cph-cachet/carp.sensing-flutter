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

  /// Whether the measure is enabled - i.e. collecting data - when the study is running.
  /// A measure is enabled as default.
  bool enabled = true;

  /// A key-value map holding any application-specific configuration.
  Map<String, String> configuration = new Map<String, String>();

  bool _storedEnabled = true;
  List<MeasureListener> _listeners = new List<MeasureListener>();

  Measure(this.type, {this.name, this.enabled = true})
      : assert(type != null),
        super() {
    enabled = enabled ?? true;
    _storedEnabled = enabled;
  }

  static Function get fromJsonFunction => _$MeasureFromJson;
  factory Measure.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory.fromJson(json[Serializable.CLASS_IDENTIFIER].toString(), json);
  Map<String, dynamic> toJson() => _$MeasureToJson(this);

  /// Add a key-value pair as configuration for this measure.
  void setConfiguration(String key, String configuration) => this.configuration[key] = configuration;

  /// Get value from the configuration for this measure.
  String getConfiguration(String key) => this.configuration[key];

  /// Add a [MeasureListener] to this [Measure].
  void addMeasureListener(MeasureListener listener) => _listeners.add(listener);

  /// Remove a [MeasureListener] to this [Measure].
  void removeMeasureListener(MeasureListener listener) => _listeners.remove(listener);

  /// Adapt this [Measure] to a new value specified in [measure].
  void adapt(Measure measure) {
    assert(measure != null,
        "Don't adapt a measure to a null measure. If you want to disable a measure, set the enabled property to false.");
    _storedEnabled = this.enabled;
    this.enabled = measure.enabled ?? true;
  }

  // TODO - support a stack-based approach to adapt/restore.
  /// Restore this [Measure] to its original value before [adapt] was called.
  ///
  /// Note that the adapt/restore mechanism only supports **one** cycle, i.e
  /// multiple adaptation followed by multiple restoration is not supported.
  void restore() {
    this.enabled = _storedEnabled;
  }

  Future<void> hasChanged() async => _listeners.forEach((listener) => listener.hasChanged(this));

  String toString() => '${this.runtimeType}: type: $type, enabled: $enabled';
}

/// A [PeriodicMeasure] specify how to collect data on a regular basis.
///
/// Data collection will be started as specified by the [frequency] for a time interval specified as the [duration].
/// Useful for listening in on a sensor (e.g. the accelerometer) on a regular, but limited time window.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class PeriodicMeasure extends Measure {
  /// Sampling frequency in milliseconds (i.e., delay between sampling).
  int frequency;
  int _storedFrequency;

  /// The sampling duration in milliseconds.
  int duration;
  int _storedDuration;

  PeriodicMeasure(MeasureType type, {String name, bool enabled, this.frequency, this.duration})
      : super(type, name: name, enabled: enabled) {
    _storedFrequency = frequency;
    _storedDuration = duration;
  }

  static Function get fromJsonFunction => _$PeriodicMeasureFromJson;
  factory PeriodicMeasure.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory.fromJson(json[Serializable.CLASS_IDENTIFIER].toString(), json);
  Map<String, dynamic> toJson() => _$PeriodicMeasureToJson(this);

  void adapt(Measure measure) {
    super.adapt(measure);
    if (measure is PeriodicMeasure) {
      _storedFrequency = this.frequency;
      this.frequency = measure.frequency;
      _storedDuration = this.duration;
      this.duration = measure.duration;
    }
  }

  void restore() {
    super.restore();
    this.frequency = _storedFrequency;
    this.duration = _storedDuration;
  }

  String toString() => super.toString() + ', frequency: $frequency, duration: $duration';
}

/// Specifies the type of a [Measure].
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class MeasureType extends Serializable {
  /// The data type namespace. See [NameSpace].
  String namespace;

  /// The name of this data format. See [DataType].
  String name;

  MeasureType(this.namespace, this.name) : super();

  static Function get fromJsonFunction => _$MeasureTypeFromJson;
  factory MeasureType.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory.fromJson(json[Serializable.CLASS_IDENTIFIER].toString(), json);
  Map<String, dynamic> toJson() => _$MeasureTypeToJson(this);

  String toString() => "$namespace.$name";
}

/// A Listener that can listen on changes to a [Measure].
abstract class MeasureListener {
  void hasChanged(Measure measure);
}
