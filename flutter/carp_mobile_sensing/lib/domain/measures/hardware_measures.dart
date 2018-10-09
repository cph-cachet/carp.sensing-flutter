/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */
import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';
import 'package:carp_mobile_sensing/domain/serialization.dart';
import 'package:json_annotation/json_annotation.dart';

part 'hardware_measures.g.dart';

/// Configuration of the battery sampling.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class BatteryMeasure extends ProbeMeasure {
  BatteryMeasure(String measureType, {name}) : super(measureType, name: name);

  static Function get fromJsonFunction => _$BatteryMeasureFromJson;
  factory BatteryMeasure.fromJson(Map<String, dynamic> json) => FromJsonFactory.fromJson(json['\$'].toString(), json);
  Map<String, dynamic> toJson() => _$BatteryMeasureToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class ScreenMeasure extends ProbeMeasure {
  ScreenMeasure(String measureType, {name}) : super(measureType, name: name);

  static Function get fromJsonFunction => _$ScreenMeasureFromJson;
  factory ScreenMeasure.fromJson(Map<String, dynamic> json) => FromJsonFactory.fromJson(json['\$'].toString(), json);
  Map<String, dynamic> toJson() => _$ScreenMeasureToJson(this);
}
