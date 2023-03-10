/*
 * Copyright 2018-2022 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of carp_context_package;

/// Holds location information using the GPS format from the phone.
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class Location extends Geolocation {
  static const dataType = ContextSamplingPackage.LOCATION;

  /// In meters above the WGS 84 reference ellipsoid.
  /// Derived from GPS information.
  double? altitude;

  /// Estimated horizontal accuracy of this location, radial, in meters
  double? accuracy;

  /// Estimated vertical accuracy of this location, in meters.
  double? verticalAccuracy;

  /// Estimated movement speed.
  /// In meters/second
  double? speed;

  /// Accuracy in speed estimation.
  /// In meters/second
  double? speedAccuracy;

  /// Heading is the horizontal direction of travel of this device, in degrees
  double? heading;

  /// The time when this location was collected.
  DateTime? time;

  /// Is the location currently mocked
  ///
  /// Always false on iOS
  bool? isMock;

  /// Get the estimated bearing accuracy of this location, in degrees.
  /// Only available on Android
  /// https://developer.android.com/reference/android/location/Location#getBearingAccuracyDegrees()
  double? headingAccuracy;

  /// Return the time of this fix, in elapsed real-time since system boot.
  /// Only available on Android
  /// https://developer.android.com/reference/android/location/Location#getElapsedRealtimeNanos()
  double? elapsedRealtimeNanos;

  /// Get estimate of the relative precision of the alignment of the ElapsedRealtimeNanos timestamp.
  /// Only available on Android
  /// https://developer.android.com/reference/android/location/Location#getElapsedRealtimeUncertaintyNanos()
  double? elapsedRealtimeUncertaintyNanos;

  /// The number of satellites used to derive the fix.
  /// Only available on Android
  /// https://developer.android.com/reference/android/location/Location#getExtras()
  int? satelliteNumber;

  /// The name of the provider that generated this fix.
  /// Only available on Android
  /// https://developer.android.com/reference/android/location/Location#getProvider()
  String? provider;

  Location({
    super.latitude,
    super.longitude,
    this.altitude,
    this.accuracy,
    this.heading,
    this.speed,
    this.speedAccuracy,
    this.time,
    this.isMock,
    this.headingAccuracy,
    this.elapsedRealtimeNanos,
    this.elapsedRealtimeUncertaintyNanos,
    this.satelliteNumber,
    this.provider,
  }) : super();

  Location.fromLocation(location.LocationData location) : super() {
    latitude = location.latitude ?? 0;
    longitude = location.longitude ?? 0;
    altitude = location.altitude;
    accuracy = location.accuracy;
    speed = location.speed;
    speedAccuracy = location.speedAccuracy;
    heading = location.heading;
    time = (location.time != null)
        ? DateTime.fromMillisecondsSinceEpoch(location.time!.toInt())
        : null;
    isMock = location.isMock;
    headingAccuracy = location.headingAccuracy;
    elapsedRealtimeNanos = location.elapsedRealtimeNanos;
    elapsedRealtimeUncertaintyNanos = location.elapsedRealtimeUncertaintyNanos;
    satelliteNumber = location.satelliteNumber;
    provider = location.provider;
  }

  @override
  Function get fromJsonFunction => _$LocationFromJson;
  factory Location.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson(json) as Location;
  @override
  Map<String, dynamic> toJson() => _$LocationToJson(this);

  @override
  String toString() =>
      '$runtimeType -  latitude: $latitude, longitude: $longitude, altitude: $altitude, speed: $speed, time: $time';
}
