/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of communication;

@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class TextMessageMeasure extends ProbeMeasure {
  TextMessageMeasure(String measureType, {name}) : super(measureType, name: name);

  /// Specify if the body (i.e, the full text) should be collected.
  ///
  /// For privacy reasons, this should be set to false. True as default.
  bool collectBodyOfMessage = true;

  static Function get fromJsonFunction => _$TextMessageMeasureFromJson;
  factory TextMessageMeasure.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory.fromJson(json['\$'].toString(), json);
  Map<String, dynamic> toJson() => _$TextMessageMeasureToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class PhoneLogMeasure extends ProbeMeasure {
  PhoneLogMeasure(String measureType, {name, this.days}) : super(measureType, name: name);

  /// The number of days back in time to collect the phone log from.
  ///
  /// Default is -1, which is the entire log.
  int days = -1;

  static Function get fromJsonFunction => _$PhoneLogMeasureFromJson;
  factory PhoneLogMeasure.fromJson(Map<String, dynamic> json) => FromJsonFactory.fromJson(json['\$'].toString(), json);
  Map<String, dynamic> toJson() => _$PhoneLogMeasureToJson(this);
}
