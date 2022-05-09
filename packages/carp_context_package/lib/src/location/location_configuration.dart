/*
 * Copyright 2018-22 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of context;

// /// Specify the configuration on how to collect location data.
// @JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
// class LocationMeasure extends CAMSMeasure with LocationConfiguration {
//   /// Create a location measure configuration.
//   ///
//   /// This configuration combines the [CAMSMeasure] and [LocationConfiguration].
//   /// See these classes for the specific atrributes.
//   LocationMeasure({
//     required String type,
//     String? name,
//     String? description,
//     bool enabled = true,
//     GeolocationAccuracy accuracy = GeolocationAccuracy.balanced,
//     double distance = 0,
//     Duration? interval,
//     String? notificationTitle,
//     String? notificationMessage,
//     String? notificationDescription,
//   }) : super(
//           type: type,
//           name: name,
//           description: description,
//           enabled: enabled,
//         ) {
//     this.accuracy = accuracy;
//     this.distance = distance;
//     this.interval = interval ?? const Duration(minutes: 1);
//     this.notificationTitle = notificationTitle;
//     this.notificationMessage = notificationMessage;
//     this.notificationDescription = notificationDescription;
//   }

//   Function get fromJsonFunction => _$LocationMeasureFromJson;
//   factory LocationMeasure.fromJson(Map<String, dynamic> json) =>
//       FromJsonFactory().fromJson(json) as LocationMeasure;
//   Map<String, dynamic> toJson() => _$LocationMeasureToJson(this);

//   String toString() => super.toString();
// }

/// A sampling configuration which allows configuring location sampling.
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class LocationSamplingConfiguration extends PersistentSamplingConfiguration {
  /// Defines the desired accuracy that should be used to determine the location
  /// data. Default value is [GeolocationAccuracy.balanced].
  GeolocationAccuracy accuracy;

  /// The minimum distance in meters a device must move horizontally
  /// before an update event is generated.
  /// Specify 0 when you want to be notified of all movements.
  double distance = 0;

  /// The interval between location updates.
  Duration interval;

  /// The title of the notification to be shown to the user when
  /// location tracking takes place in the background.
  /// Only used on Android.
  String? notificationTitle;

  /// The message in the notification to be shown to the user when
  /// location tracking takes place in the background.
  /// Only used on Android.
  String? notificationMessage;

  /// The longer description in the notification to be shown to the user when
  /// location tracking takes place in the background.
  /// Only used on Android.
  String? notificationDescription;

  LocationSamplingConfiguration({
    this.accuracy = GeolocationAccuracy.balanced,
    this.distance = 0,
    this.interval = const Duration(minutes: 1),
    this.notificationTitle,
    this.notificationMessage,
    this.notificationDescription,
  }) : super();

  Function get fromJsonFunction => _$LocationSamplingConfigurationFromJson;
  Map<String, dynamic> toJson() => _$LocationSamplingConfigurationToJson(this);
  factory LocationSamplingConfiguration.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson(json) as LocationSamplingConfiguration;
}
