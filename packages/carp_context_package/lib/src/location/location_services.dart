/*
 * Copyright 2022 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of carp_context_package;

/// An [OnlineService] for the location manager.
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class LocationService extends OnlineService {
  /// The type of a location service.
  static const String DEVICE_TYPE =
      '${DeviceDescriptor.DEVICE_NAMESPACE}.LocationService';

  /// The default rolename for a location service.
  static const String DEFAULT_ROLENAME = 'location_service';

  /// Defines the desired accuracy that should be used to determine the location
  /// data. Default value is [GeolocationAccuracy.balanced].
  GeolocationAccuracy accuracy;

  /// The minimum distance in meters a device must move horizontally
  /// before an update event is generated.
  /// Specify 0 when you want to be notified of all movements.
  double distance = 0;

  /// The interval between location updates.
  late Duration interval;

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

  /// Create and configure a [LocationService].
  ///
  /// Default configuration is:
  ///  * roleName = "location_service"
  ///  * accuracy = balanced
  ///  * distance = 0
  ///  * interval = 1 minute
  LocationService({
    String? roleName,
    List<String>? supportedDataTypes,
    this.accuracy = GeolocationAccuracy.balanced,
    this.distance = 0,
    Duration? interval,
    this.notificationTitle,
    this.notificationMessage,
    this.notificationDescription,
  }) : super(
          roleName: roleName ?? DEFAULT_ROLENAME,
          supportedDataTypes: supportedDataTypes,
        ) {
    this.interval = interval ?? const Duration(minutes: 1);
  }

  @override
  Function get fromJsonFunction => _$LocationServiceFromJson;
  factory LocationService.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson(json) as LocationService;
  @override
  Map<String, dynamic> toJson() => _$LocationServiceToJson(this);
}

/// A [DeviceManager] for the location service.
class LocationServiceManager
    extends OnlineServiceManager<DeviceRegistration, LocationService> {
  /// A handle to the [LocationManager].
  LocationManager manager = LocationManager();

  @override
  String get id =>
      deviceDescriptor?.roleName ?? LocationService.DEFAULT_ROLENAME;

  @override
  // ignore: avoid_renaming_method_parameters
  void onInitialize(LocationService service) {}

  @override
  Future<bool> canConnect() async => true;

  @override
  Future<DeviceStatus> onConnect() async {
    await manager.configure(deviceDescriptor);
    return manager.enabled ? DeviceStatus.connected : DeviceStatus.disconnected;
  }

  @override
  Future<bool> onDisconnect() async => true;
}
