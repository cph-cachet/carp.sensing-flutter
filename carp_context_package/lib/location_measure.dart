/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of context;

/// Specify the configuration on how to collect location data.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class LocationMeasure extends PeriodicMeasure {
  /// Location accuracy according the `location` plugin
  /// [LocationAccuracy](https://pub.dev/documentation/location/latest/location/LocationAccuracy-class.html).
  LocationAccuracy accuracy;

  LocationMeasure(MeasureType type, {name, enabled, frequency, duration, this.accuracy = LocationAccuracy.BALANCED})
      : super(type, name: name, enabled: enabled, frequency: frequency, duration: duration);

  static Function get fromJsonFunction => _$LocationMeasureFromJson;
  factory LocationMeasure.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory.fromJson(json[Serializable.CLASS_IDENTIFIER].toString(), json);
  Map<String, dynamic> toJson() => _$LocationMeasureToJson(this);

  String toString() => super.toString() + ', accuracy: $accuracy';
}
