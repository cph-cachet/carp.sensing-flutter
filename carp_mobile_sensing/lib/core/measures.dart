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
  bool get enabled => _enabled;
  bool _enabled = true;
  bool _storedEnabled;

  /// A key-value map holding any application-specific configuration.
  Map<String, String> configuration = new Map<String, String>();

  Measure(this.type, {this.name, bool enabled = true})
      : assert(type != null),
        super() {
    _enabled = enabled;
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

  List<MeasureListener> _listeners = new List<MeasureListener>();
  void addMeasureListener(MeasureListener listener) {
    print('...addMeasureListener(), listener: $listener');
    _listeners.add(listener);
  }

  void removeMeasureListener(MeasureListener listener) {
    _listeners.remove(listener);
  }

  void adapt(Measure measure) {
    assert(measure != null,
        "Don't adapt a measure to a null measure. If you want to disable a measure, set the enabled property to false.");
    //_storedEnabled = this.enabled;
    this._enabled = measure.enabled ?? this.enabled;
    print('.. setting enabled for $measure to ${measure.enabled}');
    //this.hasChanged();
  }

  void restore() {
    _enabled = _storedEnabled;
    print('...restoring $this');
    //this.hasChanged();
  }

  Future hasChanged() async {
    print('...hasChanged(), measure: $this');
    for (MeasureListener listener in _listeners) {
      print('...hasChanged(), listener: $listener');
      listener.hasChanged(this);
    }
  }

  String toString() => '${this.runtimeType}: type: $type, enabled: $enabled';
}

/// A [PeriodicMeasure] specify how to collect data on a regular basis.
///
/// Data collection will be started as specified by the [frequency] for a time interval specified as the [duration].
/// Usefull for listening in on a sensor (e.g. the accelerometer) on a regular, but limited basis.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class PeriodicMeasure extends Measure {
  /// Sampling frequency in milliseconds (i.e., delay between sampling).
  int get frequency => _frequency;
  int _frequency;
  int _storedFrequency;

  /// The sampling duration in milliseconds.
  int get duration => _duration;
  int _duration;
  int _storedDuration;

  PeriodicMeasure(MeasureType type, {name, enabled = true, int frequency, int duration})
      : super(type, name: name, enabled: enabled) {
    _frequency = frequency;
    _storedFrequency = frequency;
    _duration = duration;
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
      print('.. setting frequency for $measure to ${measure.frequency}');
      this._frequency = measure.frequency ?? this.frequency;
      _storedDuration = this.duration;
      print('.. setting duration for $measure to ${measure.duration}');
      this._duration = measure.duration ?? this.duration;
    }
    //this.hasChanged();
  }

  void restore() {
    super.restore();
    this._frequency = _storedFrequency;
    this._duration = _storedDuration;
    //this.hasChanged();
  }

  String toString() => super.toString() + ', frequency: $frequency, duration: $duration';
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

/// A Listener that can listen on changes to a [Measure].
abstract class MeasureListener {
  void hasChanged(Measure measure);
}
