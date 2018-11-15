/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of connectivity;

/// Configuration of the connectivity sampling.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class ConnectivityMeasure extends ProbeMeasure {
  ConnectivityMeasure(String measureType, {name}) : super(measureType, name: name);

  static Function get fromJsonFunction => _$ConnectivityMeasureFromJson;
  factory ConnectivityMeasure.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory.fromJson(json[Serializable.CLASS_IDENTIFIER].toString(), json);
  Map<String, dynamic> toJson() => _$ConnectivityMeasureToJson(this);
}

/// Configuration of Bluetooth device scanning. Each [BluetoothProbe] will use an
/// instance of this as its configuration.
///
/// A bluetooth scan can be scheduled to take place with a certain [frequency]
/// and runs for a specific [duration] (in milliseconds).
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class BluetoothMeasure extends PollingProbeMeasure {
  /// Sampling frequency in milliseconds. Default is 60,000 (once every minute).
  static const int DEFAULT_FREQUENCY = 60 * 1000;

  /// The sampling duration in milliseconds. Default is 3,000 (three second).
  static const int DEFAULT_DURATION = 3 * 1000;

  BluetoothMeasure(String measureType, {name, frequency, duration})
      : super(measureType, name: name, frequency: frequency, duration: duration) {
    if (frequency == null) this.frequency = DEFAULT_FREQUENCY;
    if (duration == null) this.duration = DEFAULT_DURATION;
  }

  static Function get fromJsonFunction => _$BluetoothMeasureFromJson;
  factory BluetoothMeasure.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory.fromJson(json[Serializable.CLASS_IDENTIFIER].toString(), json);
  Map<String, dynamic> toJson() => _$BluetoothMeasureToJson(this);
}
