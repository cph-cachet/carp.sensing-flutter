/*
 * Copyright 2018-2023 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of carp_context_package;

/// A manger that knows how to get location information.
/// Provide access to location data while the app is in the background.
///
/// Use as a singleton:
///
///  `LocationManager()...`
///
/// Note that this [LocationManager] **tries** to handle location permissions
/// during its configuration (via the [configure] method) and the [hasPermission]
/// and [requestPermission] methods.
///
/// **However**, it is much better - and also recommended by both Apple and
/// Google - to handle permissions on an application level and show the location
/// permission dialogue to the user **before** using probes that depend on location.
///
/// This version of the location manager is based on the [location](https://pub.dev/packages/location)
/// plugin.
class LocationManager {
  static final LocationManager _instance = LocationManager._();
  LocationManager._();

  /// Get the singleton [LocationManager] instance
  factory LocationManager() => _instance;

  bool _enabled = false, _configured = false;
  final _provider = location.Location();

  /// Is the location service enabled, which entails that
  ///  * location service is enabled
  ///  * permissions granted
  bool get enabled => _enabled;

  /// Is the location service configured via the [configure] method.
  bool get configured => _configured;

  /// Is the location service enabled in background mode?
  Future<bool> isBackgroundModeEnabled() async =>
      await _provider.isBackgroundModeEnabled();

  /// What kind of location permissions does this manager have?
  ///
  /// If the result is [PermissionStatus.deniedForever], no dialog will be
  /// shown on [requestPermission].
  Future<location.PermissionStatus> hasPermission() async =>
      await _provider.hasPermission();

  /// Has location been granted to this location manager?
  Future<bool> isGranted() async =>
      (await hasPermission()) == location.PermissionStatus.granted;

  /// Request permissions to access location?
  ///
  /// If the result is [PermissionStatus.deniedForever], no dialog will be
  /// shown on [requestPermission].
  Future<location.PermissionStatus> requestPermission() async =>
      await _provider.requestPermission();

  /// Enable the [LocationManager], incl. sending a notification to the
  /// Android notification system.
  ///
  /// After the location manager is enabled, configuration can be done via the
  /// [configure] method.
  Future<void> enable() async {
    // fast out if already enabled
    if (enabled) return;

    info('Enabling $runtimeType...');
    _enabled = false;

    bool serviceEnabled = await _provider.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _provider.requestService();
      if (!serviceEnabled) {
        warning('$runtimeType - Location service could not be enabled.');
        return;
      }
    }

    if (await _provider.hasPermission() != location.PermissionStatus.granted) {
      warning(
          "$runtimeType - Permission to collect location data 'Always' in the background has not been granted. "
          "Make sure to grant this BEFORE sensing is resumed. "
          "The context sampling package does not handle permissions. This should be handled on the application level.");
      // return;
    }

    _enabled = true;

    bool backgroundMode = false;
    try {
      backgroundMode = await _provider.enableBackgroundMode();
    } catch (error) {
      warning('$runtimeType - Could not enable background mode - $error');
    }
    info('$runtimeType - enabled, background mode enabled: $backgroundMode');
  }

  /// Configures the [LocationManager], incl. sending a notification to the
  /// Android notification system.
  ///
  /// Configuration is done based on the [LocationService]. If not provided,
  /// as set of default configurations are used.
  Future<void> configure(LocationService configuration) async {
    // fast out if already configured
    if (configured) return;

    // if not enabled, enable first
    await enable();

    info('Configuring $runtimeType - configuration: $configuration');
    _configured = false;

    try {
      await _provider.changeSettings(
        accuracy:
            location.LocationAccuracy.values[configuration.accuracy.index],
        distanceFilter: configuration.distance,
        interval: configuration.interval.inMilliseconds,
      );

      await _provider.changeNotificationOptions(
          title: configuration.notificationTitle ?? 'CARP Location Service',
          subtitle: configuration.notificationMessage ??
              'The location service is running in the background',
          description: configuration.notificationDescription ??
              'Background location is on to keep the CARP Mobile Sensing app up-to-date with your location. '
                  'This is required for main features to work properly when the app is not in use.',
          onTapBringToFront: configuration.notificationOnTapBringToFront,
          iconName: configuration.notificationIconName);

      info('$runtimeType - configured successfully.');
      _configured = true;
    } catch (error) {
      warning('$runtimeType - Configuration failed - $error');
      return;
    }
  }

  /// Gets the current location of the phone.
  /// Throws an error if the app has no permission to access location.
  Future<Location> getLocation() async =>
      Location.fromLocationData(await _provider.getLocation());

  /// Returns a stream of [Location] objects.
  /// Throws an error if the app has no permission to access location.
  Stream<Location> get onLocationChanged => _provider.onLocationChanged
      .map((location) => Location.fromLocationData(location));
}

/// The precision of the Location. A lower precision will provide a greater
/// battery life.
///
/// This is modelled following [LocationAccuracy](https://pub.dev/documentation/location_platform_interface/latest/location_platform_interface/LocationAccuracy.html)
/// in the location plugin. This is good compromise between the iOS and Android models:
///
///  * iOS [CLLocationAccuracy](https://developer.apple.com/documentation/corelocation/cllocationaccuracy?language=objc)
///  * Android [LocationRequest](https://developers.google.com/android/reference/com/google/android/gms/location/LocationRequest)
enum GeolocationAccuracy {
  powerSave,
  low,
  balanced,
  high,
  navigation,
}
