/*
 * Copyright 2018-2021 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */
part of domain;

/// A CAMS-specific [Measure] that holds information about what measure to collect
/// in a task.
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class CAMSMeasure extends Measure {
  /// A printer-friendly name for this measure.
  String? name;

  /// A longer description of this measure.
  String? description;

  /// The study deployment id that this measure is part of.
  /// Set on runtime.
  @JsonKey(ignore: true)
  // String? studyDeploymentId;

  /// Whether the measure is enabled - i.e. collecting data - when the
  /// study is running. A measure is enabled as default.
  bool enabled;

  /// A key-value map holding any application-specific configuration.
  Map<String, String> configuration = {};

  bool _storedEnabled = true;
  final List<MeasureListener> _listeners = [];

  CAMSMeasure({
    required String type,
    this.name,
    this.description,
    this.enabled = true,
  }) : super(type: type) {
    _storedEnabled = enabled;
  }

  /// Add a key-value pair as configuration for this measure.
  void setConfiguration(String key, String configuration) =>
      this.configuration[key] = configuration;

  /// Get value from the configuration for this measure.
  String? getConfiguration(String key) => configuration[key];

  /// Add a [MeasureListener] to this [Measure].
  void addMeasureListener(MeasureListener listener) => _listeners.add(listener);

  /// Remove a [MeasureListener] to this [Measure].
  void removeMeasureListener(MeasureListener listener) =>
      _listeners.remove(listener);

  /// Adapt this measure to a new value specified in [measure].
  void adapt(Measure measure) {
    _storedEnabled = enabled;
    if (measure is CAMSMeasure) enabled = measure.enabled;
  }

  /// Restore this measure to its original value before [adapt] was called.
  ///
  /// Note that the adapt/restore mechanism only supports **one** cycle, i.e
  /// multiple adaptation followed by multiple restoration is not supported.
  void restore() {
    enabled = _storedEnabled;
  }

  /// Call this method when this measure has changed.
  Future hasChanged() async =>
      _listeners.forEach((listener) => listener.hasChanged(this));

  Function get fromJsonFunction => _$CAMSMeasureFromJson;
  factory CAMSMeasure.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson(json) as CAMSMeasure;
  Map<String, dynamic> toJson() => _$CAMSMeasureToJson(this);

  String toString() => '$runtimeType - type: $type, enabled: $enabled';
}

/// A measure specifying how to collect data on a regular basis.
///
/// Data collection will be started as specified by the [frequency] for a time
/// interval specified as the [duration]. Useful for listening in on a
/// sensor (e.g. the accelerometer) on a regular, but limited time window.
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class PeriodicMeasure extends CAMSMeasure {
  /// Sampling frequency (i.e., delay between sampling).
  Duration frequency;
  late Duration _storedFrequency;

  /// The sampling duration. Default is 1 second, if not specified.
  late Duration duration;
  late Duration _storedDuration;

  /// Create a [PeriodicMeasure].
  PeriodicMeasure({
    required String type,
    String? name,
    String? description,
    bool enabled = true,
    required this.frequency,
    Duration? duration,
  }) : super(
            type: type,
            name: name,
            description: description,
            enabled: enabled) {
    _storedFrequency = frequency;
    this.duration = duration ?? const Duration(seconds: 1);
    _storedDuration = this.duration;
  }

  Function get fromJsonFunction => _$PeriodicMeasureFromJson;
  factory PeriodicMeasure.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson(json) as PeriodicMeasure;
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
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class MarkedMeasure extends CAMSMeasure {
  /// The date and time of the last time this measure was collected.
  @JsonKey(ignore: true)
  DateTime? lastTime;

  /// The tag to be used to uniquely identify this measure.
  /// Default is the [type] but can be overwritten in sub-classes.
  String tag() => type.toString();

  /// If there is no persistent mark, how long time back in history should
  /// this measure be collected? Default is one day back.
  late Duration history;

  MarkedMeasure({
    required String type,
    String? name,
    String? description,
    bool enabled = true,
    Duration? history,
  }) : super(
          type: type,
          name: name,
          description: description,
          enabled: enabled,
        ) {
    this.history = history ?? const Duration(days: 1);
  }

  Function get fromJsonFunction => _$MarkedMeasureFromJson;
  Map<String, dynamic> toJson() => _$MarkedMeasureToJson(this);
  factory MarkedMeasure.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson(json) as MarkedMeasure;

  String toString() =>
      '${super.toString()}, mark: $lastTime, history: $history';
}

/// A Listener that can listen on changes to a [Measure].
abstract class MeasureListener {
  /// Called when this [MeasureListener] has changed.
  /// [measure] is the changed measure.
  void hasChanged(Measure measure);
}
