/*
 * Copyright 2022 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of context;

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

  Function get fromJsonFunction => _$LocationServiceFromJson;
  factory LocationService.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson(json) as LocationService;
  Map<String, dynamic> toJson() => _$LocationServiceToJson(this);
}

/// A [DeviceManager] for the eSense device.
class LocationServiceManager extends OnlineServiceManager {
  /// A handle to the [LocationManager].
  LocationManager manager = LocationManager();

  @override
  LocationService? get deviceDescriptor =>
      super.deviceDescriptor as LocationService;

  @override
  String get id =>
      deviceDescriptor?.roleName ?? LocationService.DEFAULT_ROLENAME;

  @override
  void onInitialize(DeviceDescriptor descriptor) {
    assert(descriptor is LocationService,
        '$runtimeType initialized with a wrong device descriptor of type ${descriptor.runtimeType}');
  }

  @override
  bool canConnect() => true;

  @override
  Future<bool> onConnect() async {
    await manager.configure(deviceDescriptor);
    return manager.enabled;
  }

  @override
  Future<bool> onDisconnect() async => true;
}
