/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */
part of domain;

/// A [Measure] holds information about what measure to do/collect for a
/// [TaskDescriptor] in a [StudyProtocol].
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class CAMSMeasure extends Measure {
  /// The textual [MeasureDescription] containing the name and description
  /// of this measure organized according to language locales.
  Map<String, MeasureDescription> measureDescription = {};

  /// The default English name for this measure.
  /// If the English name is not set, then the measure's [type] is returned.
  @JsonKey(ignore: true)
  String get name => measureDescription.containsKey('en')
      ? measureDescription['en'].name
      : type;

  /// The default English description of this measure.
  @JsonKey(ignore: true)
  String get description => getDescription('en').description;

  /// Whether the measure is enabled - i.e. collecting data - when the
  /// study is running. A measure is enabled as default.
  @override
  bool enabled = true;

  /// A key-value map holding any application-specific configuration.
  Map<String, String> configuration = {};

  bool _storedEnabled = true;
  final List<MeasureListener> _listeners = [];

  CAMSMeasure({
    @required String type,
    this.measureDescription,
    this.enabled = true,
  }) : super(type: type) {
    enabled = enabled ?? true;
    _storedEnabled = enabled;
  }

  MeasureDescription getDescription(String locale) =>
      measureDescription[locale] ??
      MeasureDescription(
        name: 'No name for locale: $locale',
        description: 'No description for locale: $locale',
      );

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
    enabled = (measure is CAMSMeasure) ? measure.enabled ?? true : true;
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
  Future hasChanged() async =>
      _listeners.forEach((listener) => listener.hasChanged(this));

  Function get fromJsonFunction => _$CAMSMeasureFromJson;
  factory CAMSMeasure.fromJson(Map<String, dynamic> json) => FromJsonFactory()
      .fromJson(json[Serializable.CLASS_IDENTIFIER].toString(), json);
  Map<String, dynamic> toJson() => _$CAMSMeasureToJson(this);

  String toString() => '$runtimeType - type: $type, enabled: $enabled';
}

@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class MeasureDescription extends Serializable {
  /// A printer-friendly name for this measure.
  String name;

  /// A longer description of this measure.
  String description;

  MeasureDescription({this.name, this.description});

  Function get fromJsonFunction => _$MeasureDescriptionFromJson;
  factory MeasureDescription.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory()
          .fromJson(json[Serializable.CLASS_IDENTIFIER].toString(), json);
  Map<String, dynamic> toJson() => _$MeasureDescriptionToJson(this);

  String toString() => '$runtimeType - name: $name, description: $description';
}

/// A [PeriodicMeasure] specify how to collect data on a regular basis.
///
/// Data collection will be started as specified by the [frequency] for a time
/// interval specified as the [duration]. Useful for listening in on a
/// sensor (e.g. the accelerometer) on a regular, but limited time window.
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class PeriodicMeasure extends CAMSMeasure {
  /// Sampling frequency (i.e., delay between sampling).
  Duration frequency;
  Duration _storedFrequency;

  /// The sampling duration.
  Duration duration;
  Duration _storedDuration;

  /// Create a [PeriodicMeasure].
  PeriodicMeasure({
    @required String type,
    Map<String, MeasureDescription> measureDescription,
    bool enabled,
    this.frequency,
    this.duration,
  }) : super(
            type: type,
            measureDescription: measureDescription,
            enabled: enabled) {
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
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class MarkedMeasure extends CAMSMeasure {
  /// The date and time of the last time this measure was collected.
  @JsonKey(ignore: true)
  DateTime lastTime;

  /// The tag to be used to uniquely identify this measure.
  /// Default is the [type] but can be overwritten in sub-classes.
  String tag() => type.toString();

  /// If there is no persistent mark, how long time back in history should
  /// this measure be collected?
  Duration history;

  MarkedMeasure({
    @required String type,
    Map<String, MeasureDescription> measureDescription,
    bool enabled,
    this.history = const Duration(days: 1),
  }) : super(
          type: type,
          measureDescription: measureDescription,
          enabled: enabled,
        );

  Function get fromJsonFunction => _$MarkedMeasureFromJson;
  Map<String, dynamic> toJson() => _$MarkedMeasureToJson(this);
  factory MarkedMeasure.fromJson(Map<String, dynamic> json) => FromJsonFactory()
      .fromJson(json[Serializable.CLASS_IDENTIFIER].toString(), json);

  String toString() =>
      '${super.toString()}, mark: $lastTime, history: $history';
}

/// A Listener that can listen on changes to a [Measure].
abstract class MeasureListener {
  /// Called when this [MeasureListener] has changed.
  /// [measure] is the changed measure.
  void hasChanged(Measure measure);
}
