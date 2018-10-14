/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of location;

/// Defines how to measure location.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class LocationMeasure extends ProbeMeasure {
  LocationMeasure(String measureType, {name}) : super(measureType, name: name);

  static Function get fromJsonFunction => _$LocationMeasureFromJson;
  factory LocationMeasure.fromJson(Map<String, dynamic> json) => FromJsonFactory.fromJson(json['\$'].toString(), json);
  Map<String, dynamic> toJson() => _$LocationMeasureToJson(this);
}
