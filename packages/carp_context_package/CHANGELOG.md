## 0.9.5
* upgrade to `carp_mobile_sensing` v. 0.9.5

## 0.9.4
* fix: using the [geolocator](https://pub.dev/packages/geolocator) plugin for the `location` measure.
* fix: stabilizing `weather` and `air_quality` probes

## 0.9.3
* upgrade: to `carp_mobile_sensing` v. 0.9.3
* doc: update of README to reflect using new CARP plugins for background location and activity recognition.

## 0.9.2
* upgrade: to `carp_mobile_sensing` v. 0.9.2

## 0.9.1
* upgrade: to `carp_mobile_sensing` v. 0.9.x

## 0.9.0+2
* fix: corrected static analysis errors caused by an old location plugin
* upgrade: dependencies to their newest versions
    * in particular; `MobilityFeatures` was upgraded to the 2.x.x API

## 0.9.0+1
* fic: corrected static analysis error caused by the new Activity Recognition API
* docs: added example

## 0.8.6
* refactor: removed the latitude and longitude fields from `WeatherMeasure` since they were not used.

## 0.8.5
* Added mobility sampling via the [mobility_features](https://pub.dev/packages/mobility_features)  package

## 0.8.0
* upgrade to `carp_mobile_sensing` v. 0.8.x

## 0.7.1
* upgrade to `carp_mobile_sensing` v. 0.7.1 and `weather` v. 1.1.x

## 0.7.0
* upgrade to `carp_mobile_sensing` v. 0.7.0

## 0.6.6
* the ``location`` measure is now a ``DatumProbe`` and only collects location on request. 
If continuous (stream-based) location is needed, use the `geolocation` measure.
* using our own Flutter plugin for activity recognition - [`activity_recognition_flutter`](https://pub.dev/packages/activity_recognition_flutter).

## 0.6.5
* upgrade to `carp_mobile_sensing` v. 0.6.5

## 0.6.4
* change of location provider to the [geolocator](https://pub.dev/packages/geolocator) plugin.
* introduction of a `geolocation` measure type for listening to location events.
* adjustment of the `LocationMeasure` to hold configuration for specifying various options.

## 0.6.3
* support for `air_quality` 

## 0.6.1
* Changed the location probe to a periodic probe which can be configured to sample location data on a specific frequency.
* allignment with `carp_mobile_sensing` v. 0.6.1.
* testing on iOS reveals that activity recognition does not work on iOS

## 0.6.0
* update to `carp_mobile_sensing` version 0.6.0
* Weather measure is no longer periodic but 'one-off', i.e. at `DatumProbe`. 
Use the new `Trigger` model in `carp_mobile_sensing` v.0.6.0 to achieve periodic sampling of weather information.


## 0.5.0 BREAKING
* Upgraded to use [`carp_mobile_sensing`](https://pub.dartlang.org/packages/carp_mobile_sensing) version 0.5.0 
   * **Breaking change.** This version has been migrated from the deprecated Android Support Library to *AndroidX*. 
This should not result in any functional changes, but it requires any Android app using this plugin to also 
[migrate](https://developer.android.com/jetpack/androidx/migrate) if using the original support library. 
   * See Flutter [AndroidX compatibility](https://flutter.dev/docs/development/packages-and-plugins/androidx-compatibility)

## 0.3.6
* small update to domain model

## 0.3.5
* update to json_serialization v.2
* added support for `geofence` measure

## 0.3.4
* update to `carp_mobile_sensing` version 0.3.10

## 0.3.3
* Documentation

## 0.3.2
* Update to `carp_mobile_sensing` v. 0.3.7
* Using the data types in the package (`activity`, `weather`, `location`)

## 0.3.1
* Documentation

## 0.3.0
* Initial release compatible with `carp_mobile_sensing` version `0.3.*`
