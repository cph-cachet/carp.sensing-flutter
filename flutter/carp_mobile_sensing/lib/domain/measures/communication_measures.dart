/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */
import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';
import 'package:carp_mobile_sensing/domain/serialization.dart';
import 'package:json_annotation/json_annotation.dart';

part 'communication_measures.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class TextMessageMeasure extends ProbeMeasure {
  TextMessageMeasure(String measureType, {name}) : super(measureType, name: name);

  static Function get fromJsonFunction => _$TextMessageMeasureFromJson;
  factory TextMessageMeasure.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory.fromJson(json['\$'].toString(), json);
  Map<String, dynamic> toJson() => _$TextMessageMeasureToJson(this);
}
