## 0.3.2
* support for dividing probes into separate probe packages
* included in `carp_mobile_sensing` are
     * `sensors` (sensors, light, pedometer)
     * `device` (device, screen, memory, battery)
     * `connectivity` (connectivity, bluetooth)
     * `apps` (installed apps, app usage)
* implementation of the following external probe packages:
     * `communication` (sms & call log)
     * `context` (location, activity, weather)
     * `sound` (noise, recording)
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

