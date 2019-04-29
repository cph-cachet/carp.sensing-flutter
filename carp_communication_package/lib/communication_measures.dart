/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of communication;

/// Specifies the configuration of how to sample a phone log from this device.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class PhoneLogMeasure extends Measure {
  static const int DEFAULT_NUMBER_OF_DAYS = 30;

  /// The number of days back in time to collect the phone log from.
  int days = DEFAULT_NUMBER_OF_DAYS;

  PhoneLogMeasure(MeasureType type, {name, enabled, this.days = DEFAULT_NUMBER_OF_DAYS})
      : super(type, enabled: enabled, name: name);

  static Function get fromJsonFunction => _$PhoneLogMeasureFromJson;
  factory PhoneLogMeasure.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory.fromJson(json[Serializable.CLASS_IDENTIFIER].toString(), json);
  Map<String, dynamic> toJson() => _$PhoneLogMeasureToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class CalendarMeasure extends PeriodicMeasure {
  static const int DEFAULT_NUMBER_OF_DAYS = 1;

  /// The number of days back in time to collect calendar events.
  int daysBack = DEFAULT_NUMBER_OF_DAYS;

  /// The number of days ahead in time to collect calendar events.
  int daysFuture = DEFAULT_NUMBER_OF_DAYS;

  CalendarMeasure(MeasureType type,
      {name,
      enabled,
      frequency,
      duration,
      this.daysBack = DEFAULT_NUMBER_OF_DAYS,
      this.daysFuture = DEFAULT_NUMBER_OF_DAYS})
      : super(type, enabled: enabled, name: name, frequency: frequency, duration: duration);

  static Function get fromJsonFunction => _$CalendarMeasureFromJson;
  factory CalendarMeasure.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory.fromJson(json[Serializable.CLASS_IDENTIFIER].toString(), json);
  Map<String, dynamic> toJson() => _$CalendarMeasureToJson(this);
}
