/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of sensors;

/// Holds the step count for a specific time period.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class PedometerDatum extends CARPDatum {
  /// The start time of the collection period.
  DateTime startTime;

  /// The end time of the collection period.
  DateTime endTime;

  /// The total amount of steps.
  int stepCount;

  PedometerDatum({Measure measure}) : super(measure: measure);

  factory PedometerDatum.fromJson(Map<String, dynamic> json) => _$PedometerDatumFromJson(json);
  Map<String, dynamic> toJson() => _$PedometerDatumToJson(this);

  String toString() => 'step_count: {start: $startTime, end: $endTime, steps: $stepCount}';
}
