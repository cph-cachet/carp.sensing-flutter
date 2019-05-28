## 0.5.0 BREAKING
* **Breaking change.** This version has been migrated from the deprecated Android Support Library to *AndroidX*. 
This should not result in any functional changes, but it requires any Android app using this plugin to also 
[migrate](https://developer.android.com/jetpack/androidx/migrate) if they're using the original support library. 
   * See Flutter [AndroidX compatibility](https://flutter.dev/docs/development/packages-and-plugins/androidx-compatibility)
* Fixed error in `PedometerProbe`
## 0.4.0
* support for data transformers
   * OMH Geolocation
   * OMH PhysicalActivity
* support for privacy schema
   * added support for hashing bluetooth names in the bluetooth package
* upgrade to json_serializable v.2

## 0.3.10
* minor change to the `StreamProbe` API - now non-static streams can be used by implementing the `get stream` method.
* update of the relevant sampling packages using `StreamProbe`

## 0.3.8+9
* update and rename of `CARPDataPoint` to `DataPoint` to reflect new CARP API.
* moved CARP web service specific data model to `CARPDataPoint` to the `carp_webservices` package.


## 0.3.5+6+7
* rename of `packages` folder to `sampling_packages` (seems like Dart Pub don't like folders called `packages`)
* rename of `core` folder to `domain`

## 0.3.3
* update to new versions of [CACHET Flutter Plugins](https://github.com/cph-cachet/flutter-plugins)
* rename of `probes` folder to `packages`
* upgrade and test on Flutter v. 1.3.4 Dart v. 2.2.1 

## 0.3.2
* support for dividing probes into separate sampling packages
* included in `carp_mobile_sensing` are
     * `device` (device, screen, memory, battery)
     * `sensors` (sensors, light, pedometer)
     * `connectivity` (connectivity, bluetooth)
     * `apps` (installed apps, app usage)
* implementation of the following **external** probe packages:
     * `communication` (sms & call log)
     * `context` (location, activity, weather)
     * `audio` (noise, audio recording)
     * `movisens` (Movisens Move/ECG devices)

## 0.3.1
* small updates to the data format incl. documentation on the [wiki](https://github.com/cph-cachet/carp.sensing-flutter/wiki/Sampling-Data-Formats).
* fixed error in the `stop` method.

## 0.3.0 - no backward compatibility
* major updates to the domain model as a `core` library
    * `Measure` now have a `configuration`
* simplification to probe implementations
* all probes now uses the Dart `Stream` API and supports a reactive programming model
* all probes adjusted to a stream model
* implementation of `SamplingSchema` architecture
* support for power-aware sampling using different sampling schemas


## 0.2.6
* fixed small bug in `weater` probe.

## 0.2.5 
* small bug fixes in connectivity datum model (to work w. `carp_firebase_backend).
* `weather` probe added. 

## 0.2.4 
* error in `light` probe fixed.
* `noise` probe added.
* using the `carp_core` domain model

## 0.2.3
* fixed error in `readme` file.

## 0.2.2 
* `phone_log` probe added
* `audio` probe added
* `activity` probe added
* improvement to `readme` file on `manifest.xml` and `Info.plist`.


## 0.2.1 
* re-organization of github location and outline
* improvements to `FileDataManager` to avoid race conditions
* improved API documentation


## 0.2.0 
* refactor of organization of classes into libraries 
* complete API documentation

## 0.1.1 
* small improvements incl. documentation

## 0.1.0 
* removal of all remote backend code to separate packages

## 0.0.1 
* Initial version by Jakob E. Bardram 
* Transferring the old implementation to this carp.sensing-flutter framework 
* General refactor and clean-up

