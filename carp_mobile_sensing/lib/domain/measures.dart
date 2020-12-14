/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */
part of domain;

/// A [Measure] holds information about what measure to do/collect for a
/// [Task] in a [Study].
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class Measure extends Serializable {
  /// The type of measure to do.
  MeasureType type;

  /// A printer-friendly name for this measure.
  String name;

  /// Whether the measure is enabled - i.e. collecting data - when the
  /// study is running.
  /// A measure is enabled as default.
  bool enabled = true;

  /// A key-value map holding any application-specific configuration.
  Map<String, String> configuration = {};

  bool _storedEnabled = true;
  final List<MeasureListener> _listeners = [];

  Measure._();

  Measure(this.type, {this.name, this.enabled = true})
      : assert(type != null),
        super() {
    enabled = enabled ?? true;
    _storedEnabled = enabled;
  }

  //static Function get fromJsonFunction => _$MeasureFromJson;
  Function get fromJsonFunction => _$MeasureFromJson;
  // factory Measure.fromJson(Map<String, dynamic> json) =>
  //     FromJsonFactory.fromJson(
  //         json[Serializable.CLASS_IDENTIFIER].toString(), json);
  factory Measure.fromJson(Map<String, dynamic> json) => FromJsonFactory()
      .fromJson(json[Serializable.CLASS_IDENTIFIER].toString(), json);
  Map<String, dynamic> toJson() => _$MeasureToJson(this);

  /// Add a key-value pair as configuration for this measure.
  void setConfiguration(String key, String configuration) =>
      this.configuration[key] = configuration;

  /// Get value from the configuration for this measure.
  String getConfiguration(String key) => configuration[key];

  /// Add a [MeasureListener] to this [Measure].
  void addMeasureListener(MeasureListener listener) => _listeners.add(listener);

  /// Remove a [MeasureListener] to this [Measure].
  void removeMeasureListener(MeasureListener listener) =>
      _listeners.remove(listener);

  /// Adapt this [Measure] to a new value specified in [measure].
  void adapt(Measure measure) {
    assert(
        measure != null,
        "Don't adapt a measure to a null measure. If you want to disable a "
        'measure, set the enabled property to false.');
    _storedEnabled = enabled;
    enabled = measure.enabled ?? true;
  }

  // TODO - support a stack-based approach to adapt/restore.
  /// Restore this [Measure] to its original value before [adapt] was called.
  ///
  /// Note that the adapt/restore mechanism only supports **one** cycle, i.e
  /// multiple adaptation followed by multiple restoration is not supported.
  void restore() {
    enabled = _storedEnabled;
  }

  /// Call this method when this measure has changed.
  Future<void> hasChanged() async =>
      _listeners.forEach((listener) => listener.hasChanged(this));

  String toString() => '$runtimeType: type: $type, enabled: $enabled';
}

/// A [PeriodicMeasure] specify how to collect data on a regular basis.
///
/// Data collection will be started as specified by the [frequency] for a time
/// interval specified as the [duration]. Useful for listening in on a
/// sensor (e.g. the accelerometer) on a regular, but limited time window.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class PeriodicMeasure extends Measure {
  /// Sampling frequency (i.e., delay between sampling).
  Duration frequency;
  Duration _storedFrequency;

  /// The sampling duration.
  Duration duration;
  Duration _storedDuration;

  PeriodicMeasure._() : super._();

  /// Create a [PeriodicMeasure].
  PeriodicMeasure(MeasureType type,
      {String name, bool enabled, this.frequency, this.duration})
      : super(type, name: name, enabled: enabled) {
    _storedFrequency = frequency;
    _storedDuration = duration;
  }

  Function get fromJsonFunction => _$PeriodicMeasureFromJson;
  factory PeriodicMeasure.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory()
          .fromJson(json[Serializable.CLASS_IDENTIFIER].toString(), json);
  Map<String, dynamic> toJson() => _$PeriodicMeasureToJson(this);

  void adapt(Measure measure) {
    super.adapt(measure);
    if (measure is PeriodicMeasure) {
      _storedFrequency = frequency;
      frequency = measure.frequency;
      _storedDuration = duration;
      duration = measure.duration;
    }
  }

  void restore() {
    super.restore();
    frequency = _storedFrequency;
    duration = _storedDuration;
  }

  String toString() =>
      '${super.toString()}, frequency: $frequency, duration: $duration';
}

/// A [MarkedMeasure] specify how to collect data historically back to a
/// persistent mark.
///
/// This measure persistently marks the last time this data measure was done
/// and provide this in the [lastTime] variable.
/// This is useful for measures that want to collect data since last time it
/// was collected. For example the [AppUsageMeasure].
///
/// A [MarkedMeasure] can only be used with [DatumProbe], [StreamProbe]
/// and [PeriodicStreamProbe] probes. The mark is read when the probe is
/// resumed and saved when the probe is paused.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class MarkedMeasure extends Measure {
  /// The date and time of the last time this measure was collected.
  @JsonKey(ignore: true)
  DateTime lastTime;

  /// The tag to be used to uniquely identify this measure.
  /// Default is the [type] but can be overwritten in sub-classes.
  String tag() => type.toString();

  /// If there is no persistent mark, how long time back in history should
  /// this measure be collected?
  Duration history;

  MarkedMeasure._() : super._();

  MarkedMeasure(
    MeasureType type, {
    String name,
    bool enabled,
    this.history = const Duration(days: 1),
  }) : super(type, name: name, enabled: enabled);

  Function get fromJsonFunction => _$MarkedMeasureFromJson;
  Map<String, dynamic> toJson() => _$MarkedMeasureToJson(this);
  factory MarkedMeasure.fromJson(Map<String, dynamic> json) => FromJsonFactory()
      .fromJson(json[Serializable.CLASS_IDENTIFIER].toString(), json);

  String toString() =>
      '${super.toString()}, mark: $lastTime, history: $history';
}

/// Specifies the type of a [Measure].
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class MeasureType extends Serializable {
  /// The data type namespace. See [NameSpace].
  String namespace;

  /// The name of this data format. See [DataType].
  String name;

  MeasureType._();

  /// Create a [MeasureType].
  MeasureType(this.namespace, this.name) : super();

  Function get fromJsonFunction => _$MeasureTypeFromJson;
  factory MeasureType.fromJson(Map<String, dynamic> json) => FromJsonFactory()
      .fromJson(json[Serializable.CLASS_IDENTIFIER].toString(), json);
  Map<String, dynamic> toJson() => _$MeasureTypeToJson(this);

  String toString() => '$namespace.$name';

  bool operator ==(other) {
    if (other is! MeasureType) return false;
    return (other.namespace == namespace && other.name == name);
  }

  // taken from https://dart.dev/guides/libraries/library-tour#implementing-map-keys
  int get hashCode {
    var result = 17;
    result = 37 * result + namespace.hashCode;
    result = 37 * result + name.hashCode;
    return result;
  }
}

/// A Listener that can listen on changes to a [Measure].
abstract class MeasureListener {
  /// Called when this [MeasureListener] has changed.
  /// [measure] is the changed measure.
  void hasChanged(Measure measure);
}
