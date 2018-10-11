/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */
import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';
import 'package:json_annotation/json_annotation.dart';

part 'pedometer_datum.g.dart';

/// Holds the step count for a specific time period.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class PedometerDatum extends CARPDatum {
  static CARPDataFormat CARP_DATA_FORMAT =
      new CARPDataFormat(NameSpace.CARP_NAMESPACE, ProbeRegistry.PEDOMETER_MEASURE);

  /// The start time of the collection period.
  DateTime startTime;

  /// The end time of the collection period.
  DateTime endTime;

  /// The total amount of steps.
  int stepCount;

  PedometerDatum() : super();

  factory PedometerDatum.fromJson(Map<String, dynamic> json) => _$PedometerDatumFromJson(json);
  Map<String, dynamic> toJson() => _$PedometerDatumToJson(this);

  CARPDataFormat getCARPDataFormat() => CARP_DATA_FORMAT;

  String toString() => 'step_count: {start: $startTime, end: $endTime, steps: $stepCount}';
}
