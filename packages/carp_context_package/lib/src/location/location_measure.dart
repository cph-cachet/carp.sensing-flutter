/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of context;

/// Specify the configuration on how to collect location data.
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class LocationMeasure extends PeriodicMeasure with LocationConfiguration {
  LocationMeasure({
    required String type,
    String? name,
    String? description,
    bool enabled = true,
    Duration frequency = const Duration(seconds: 30),
    Duration duration = const Duration(seconds: 1),
    GeolocationAccuracy accuracy = GeolocationAccuracy.balanced,
    double distance = 0,
    int interval = 1000,
    String? notificationTitle,
    String? notificationMessage,
    String? notificationDescription,
  }) : super(
            type: type,
            name: name,
            description: description,
            enabled: enabled,
            frequency: frequency,
            duration: duration) {
    this.accuracy = accuracy;
    this.distance = distance;
    this.interval = interval;
    this.notificationTitle = notificationTitle;
    this.notificationMessage = notificationMessage;
    this.notificationDescription = notificationDescription;
  }

  Function get fromJsonFunction => _$LocationMeasureFromJson;
  factory LocationMeasure.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson(json) as LocationMeasure;
  Map<String, dynamic> toJson() => _$LocationMeasureToJson(this);

  String toString() =>
      super.toString() + ', accuracy: $accuracy, distance: $distance';
}
