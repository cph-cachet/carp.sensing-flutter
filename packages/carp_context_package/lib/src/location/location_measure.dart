/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of context;

enum GeolocationAccuracy {
  lowest,
  low,
  medium,
  high,
  best,
  bestForNavigation,
}

/// Specify the configuration on how to collect location data.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class LocationMeasure extends PeriodicMeasure {
  /// Defines the desired accuracy that should be used to determine the location data.
  ///
  /// The default value for this field is GeolocationAccuracy.best.
  GeolocationAccuracy accuracy;

  /// The minimum distance (measured in meters) a device must move horizontally before an update event is generated.
  ///
  /// Specify 0 when you want to be notified of all movements. The default is 0.
  double distance = 0;

  LocationMeasure(
    MeasureType type, {
    String name,
    bool enabled,
    Duration frequency,
    Duration duration,
    this.accuracy = GeolocationAccuracy.best,
    this.distance = 0,
  })
      : super(type,
            name: name,
            enabled: enabled,
            frequency: frequency,
            duration: duration);

  static Function get fromJsonFunction => _$LocationMeasureFromJson;

  factory LocationMeasure.fromJson(Map<String, dynamic> json) => FromJsonFactory
      .fromJson(json[Serializable.CLASS_IDENTIFIER].toString(), json);

  Map<String, dynamic> toJson() => _$LocationMeasureToJson(this);

  String toString() => super.toString() + ', accuracy: $accuracy';
}
