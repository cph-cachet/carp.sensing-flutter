/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */
part of '../carp_context_package.dart';

/// The precision of the Location. A lower precision will provide a greater
/// battery life.
///
/// This is modelled following [LocationAccuracy](https://pub.dev/documentation/location_platform_interface/latest/location_platform_interface/LocationAccuracy.html)
/// in the location plugin. This is good compromise between the iOS and Android models:
///
///  * iOS [CLLocationAccuracy](https://developer.apple.com/documentation/corelocation/cllocationaccuracy?language=objc)
///  * Android [LocationRequest](https://developers.google.com/android/reference/com/google/android/gms/location/LocationRequest)
enum GeolocationAccuracy {
  /// Location is accurate within a distance of 3000m on iOS and 500m on Android.
  powerSave,

  /// Location is accurate within a distance of 1000m on iOS and 500m on Android.
  low,

  /// Location is accurate within a distance of 100m on iOS and between 100m and
  /// 500m on Android.
  balanced,

  /// Location is accurate within a distance of 10m on iOS and between 0m and
  /// 100m on Android.
  high,

  /// Location accuracy is optimized for navigation on iOS and between 0m and
  /// 100m on Android.
  navigation,

  /// Location accuracy is reduced for iOS 14+ devices, matches the
  /// [GeolocationAccuracy.powerSave] on iOS 13 and below and all other platforms.
  reduced,
}

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
/// This [LocationManager] based on the [location](https://pub.dev/packages/location)
/// plugin.
class LocationManager {
  static final LocationManager _instance = LocationManager._();
  LocationManager._();

  /// Get the singleton [LocationManager] instance
  factory LocationManager() => _instance;

  bool _enabled = false, _configured = false;
  final _provider = location.Location();
  Location? _lastKnownLocation;

  /// Is the location service enabled, which entails that
  ///  * location service is enabled
  ///  * permissions granted
  bool get enabled => _enabled;

  /// Is the location service configured via the [configure] method.
  bool get configured => _configured;

  /// Is the location service enabled in background mode?
  Future<bool> isBackgroundModeEnabled() async =>
      await _provider.isBackgroundModeEnabled();

  /// Does this location manger have permission to access location "always"?
  ///
  /// If the result is [PermissionStatus.permanentlyDenied], no dialog will be
  /// shown on [requestPermission].
  Future<PermissionStatus> hasPermission() async =>
      await Permission.locationAlways.status;

  /// Has location been granted to this location manager?
  Future<bool> isGranted() async =>
      (await hasPermission()) == PermissionStatus.granted;

  /// Request permissions to access location.
  ///
  /// If the result is [PermissionStatus.permanentlyDenied], no dialog will be
  /// shown on [requestPermission].
  Future<PermissionStatus> requestPermission() async {
    var serviceEnabled =
        await Permission.locationWhenInUse.serviceStatus.isEnabled;

    // return await Permission.locationAlways.request();
    var permission = await Permission.location.request();

    debug('$runtimeType'
        ' - Location service enabled: $serviceEnabled'
        ' - permission: $permission');

    // if (await Permission.location.isPermanentlyDenied) {
    if (permission == PermissionStatus.permanentlyDenied) {
      // The user opted to never again see the permission request dialog for this
      // app. The only way to change the permission's status now is to let the
      // user manually enables it in the system settings.
      debug('$runtimeType - trying to open app settings.');
      openAppSettings();
    }

    return permission;
  }

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

    var permission = await _provider.hasPermission();

    if (permission != location.PermissionStatus.granted) {
      warning(
          "$runtimeType - Permission to collect location data 'Always' in the background has not been granted. "
          "Make sure to grant this BEFORE sensing is resumed. "
          "The context sampling package does not handle permissions. This should be handled on the application level.");
    }

    _enabled = true;

    bool backgroundMode = false;
    try {
      backgroundMode = await _provider.enableBackgroundMode();
    } catch (error) {
      warning('$runtimeType - Could not enable background mode - $error');
    }

    info('$runtimeType'
        ' - service enabled: $serviceEnabled'
        ' - permission: $permission'
        ' - background mode: $backgroundMode');
  }

  /// Configures the [LocationManager], incl. sending a notification to the
  /// Android notification system.
  ///
  /// Configuration is done based on the [LocationService]. If not provided,
  /// as set of default configurations are used.
  Future<void> configure(LocationService configuration) async {
    // fast out if already configured
    if (configured) return;

    // ensured that this location manager is enable first
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

  /// The last know location, if any.
  Location? get lastKnownLocation => _lastKnownLocation;

  /// Gets the current location of the phone.
  ///
  /// Throws an error if location cannot be obtained within a few seconds or
  /// if the app has no permission to access location.
  Future<Location> getLocation() async => _lastKnownLocation =
      Location.fromLocationData(await _provider.getLocation().timeout(
            const Duration(seconds: 6),
            // onTimeout: () => lastKnownLocation,
          ));

  /// Returns a stream of [Location] objects.
  ///
  /// Throws an error if the app has no permission to access location.
  Stream<Location> get onLocationChanged => _provider.onLocationChanged.map(
      (location) => _lastKnownLocation = Location.fromLocationData(location));
}

// /// A manger that knows how to get location information.
// /// Provide access to location data while the app is in the background.
// ///
// /// Use as a singleton:
// ///
// ///  `LocationManager()...`
// ///
// /// Note that this [LocationManager] **tries** to handle location permissions
// /// during its configuration (via the [configure] method) and the [hasPermission]
// /// and [requestPermission] methods.
// ///
// /// **However**, it is much better - and also recommended by both Apple and
// /// Google - to handle permissions on an application level and show the location
// /// permission dialogue to the user **before** using probes that depend on location.
// ///
// /// This [LocationManager] based on the [geolocator](https://pub.dev/packages/geolocator)
// /// plugin.
// class LocationManager {
//   static final LocationManager _instance = LocationManager._();
//   LocationManager._();

//   /// Get the singleton [LocationManager] instance
//   factory LocationManager() => _instance;

//   bool _enabled = false, _configured = false;
//   Location? _lastKnownLocation;
//   geolocator.LocationSettings? _settings;

//   /// Is the location service enabled, which entails that
//   ///  * location service is enabled
//   ///  * permissions granted
//   bool get enabled => _enabled;

//   /// Is the location service configured via the [configure] method.
//   bool get configured => _configured;

//   // /// Is the location service enabled in background mode?
//   // Future<bool> isBackgroundModeEnabled() async =>
//   //     await _provider.isBackgroundModeEnabled();

//   /// Does this location manger have permission to access location "always"?
//   ///
//   /// If the result is [PermissionStatus.permanentlyDenied], no dialog will be
//   /// shown on [requestPermission].
//   Future<PermissionStatus> hasPermission() async =>
//       await Permission.locationAlways.status;

//   /// Has location been granted to this location manager?
//   Future<bool> isGranted() async =>
//       (await hasPermission()) == PermissionStatus.granted;

//   /// Request permissions to access location.
//   ///
//   /// If the result is [PermissionStatus.permanentlyDenied], no dialog will be
//   /// shown on [requestPermission].
//   Future<PermissionStatus> requestPermission() async =>
//       await Permission.locationAlways.request();

//   /// Enable the [LocationManager], incl. sending a notification to the
//   /// Android notification system.
//   ///
//   /// After the location manager is enabled, configuration can be done via the
//   /// [configure] method.
//   Future<void> enable() async {
//     // fast out if already enabled
//     if (enabled) return;

//     info('Enabling $runtimeType...');
//     _enabled = false;

//     bool serviceEnabled =
//         await geolocator.Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       warning('$runtimeType - Location service is not enabled on this device.');
//       return;
//     }

//     if (await geolocator.Geolocator.checkPermission() !=
//         geolocator.LocationPermission.always) {
//       warning(
//           "$runtimeType - Permission to collect location data 'Always' in the background has not been granted. "
//           "Make sure to grant this BEFORE sensing is resumed. "
//           "The context sampling package does not handle permissions. This should be handled on the application level.");
//     }

//     _enabled = true;
//     info('$runtimeType - enabled.');
//   }

//   /// Configures the [LocationManager], incl. sending a notification to the
//   /// Android notification system.
//   ///
//   /// Configuration is done based on the [LocationService]. If not provided,
//   /// as set of default configurations are used.
//   Future<void> configure(LocationService configuration) async {
//     // fast out if already configured
//     if (configured) return;

//     // ensured that this location manager is enable first
//     await enable();

//     info('Configuring $runtimeType - configuration: $configuration');
//     _configured = false;

//     if (Platform.isAndroid) {
//       _settings = AndroidSettings(
//           accuracy:
//               geolocator.LocationAccuracy.values[configuration.accuracy.index],
//           distanceFilter: configuration.distance.toInt(),
//           forceLocationManager: true,
//           intervalDuration: configuration.interval,
//           // Set foreground notification config to keep the app alive when going to the background
//           foregroundNotificationConfig: const ForegroundNotificationConfig(
//             notificationText:
//                 'Background location is on to keep the CARP Mobile Sensing app up-to-date with your location. '
//                 'This is required for main features to work properly when the app is not in use.',
//             notificationTitle: "CARP Location Service",
//             enableWakeLock: true,
//           ));
//     } else if (Platform.isAndroid) {
//       _settings = AppleSettings(
//         accuracy:
//             geolocator.LocationAccuracy.values[configuration.accuracy.index],
//         distanceFilter: configuration.distance.toInt(),
//         timeLimit: configuration.interval,
//         // activityType: geolocator.ActivityType.fitness,
//         pauseLocationUpdatesAutomatically: true,
//         allowBackgroundLocationUpdates: true,
//         // Only set to true if our app will be started up in the background.
//         showBackgroundLocationIndicator: false,
//       );
//     } else {
//       _settings = LocationSettings(
//         accuracy:
//             geolocator.LocationAccuracy.values[configuration.accuracy.index],
//         distanceFilter: configuration.distance.toInt(),
//         timeLimit: configuration.interval,
//       );
//     }

//     info('$runtimeType - configured successfully.');
//     _configured = true;
//   }

//   /// Gets the last known location of the phone.
//   ///
//   /// Throws an error if location cannot be obtained within a few seconds or
//   /// if the app has no permission to access location.
//   Future<Location?> lastKnownLocation() async {
//     var position = await geolocator.Geolocator.getLastKnownPosition()
//         .timeout(const Duration(seconds: 10));

//     return position != null
//         ? _lastKnownLocation = Location.fromPositionData(position)
//         : _lastKnownLocation;
//   }

//   /// Gets the current location of the phone.
//   ///
//   /// Throws an error if location cannot be obtained within a few seconds or
//   /// if the app has no permission to access location.
//   Future<Location> getLocation() async =>
//       _lastKnownLocation = Location.fromPositionData(
//           await geolocator.Geolocator.getCurrentPosition().timeout(
//         const Duration(seconds: 10),
//       ));

//   /// Returns a stream of [Location] objects.
//   ///
//   /// Throws an error if the app has no permission to access location.
//   Stream<Location> get onLocationChanged =>
//       geolocator.Geolocator.getPositionStream(
//         locationSettings: _settings,
//       ).map((position) =>
//           _lastKnownLocation = Location.fromPositionData(position));
// }
