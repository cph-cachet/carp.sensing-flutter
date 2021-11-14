/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of communication;

@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class CalendarMeasure extends CAMSMeasure {
  static const int DEFAULT_NUMBER_OF_DAYS = 1;

  /// The time duration back in time to collect calendar events.
  late Duration past;

  /// The time duration ahead in time to collect calendar events.
  late Duration future;

  CalendarMeasure({
    required String type,
    String? name,
    String? description,
    enabled = true,
    Duration? past,
    Duration? future,
  }) : super(
          type: type,
          enabled: enabled,
          name: name,
          description: description,
        ) {
    this.past = past ?? const Duration(days: DEFAULT_NUMBER_OF_DAYS);
    this.future = future ?? const Duration(days: DEFAULT_NUMBER_OF_DAYS);
  }

  Function get fromJsonFunction => _$CalendarMeasureFromJson;
  factory CalendarMeasure.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson(json) as CalendarMeasure;
  Map<String, dynamic> toJson() => _$CalendarMeasureToJson(this);
}
