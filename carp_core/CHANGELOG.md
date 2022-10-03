## 0.40.1

* fix of issue [#265](https://github.com/cph-cachet/carp.sensing-flutter/issues/265).

## 0.40.0

* Serialization has been moved to a separate package - [carp_serializable](https://pub.dev/packages/carp_serializable)
* `ConcurrentTask` is renamed to `BackgroundTask`
* support for `BatteryAwareSamplingConfiguration` sampling configuration added
* fix of error in `SetParticipantData` request
* Upgraded to Dart 2.17
* Refactoring to comply to [official Dart recommended lint rules](https://pub.dev/packages/flutter_lints)

## 0.33.1

* implementation of `ScheduledTrigger` incl. test

## 0.33.0

* updates to the device model API in the `client` library.

## 0.31.3+1

* small update to dependencies in pubspec.
* re-generation of json serialization.

## 0.31.2

* support for stopping (permanently) a study deployment.

## 0.31.1

* small update to `DataManager` interface to fix issue [#221](https://github.com/cph-cachet/carp.sensing-flutter/issues/221).

## 0.31.0

* `description` in `StudyProtocol` is now non-nullable (required when uploading a protocol to CARP)

## 0.30.1+3

* fix of json serialization bugs (x2)
* update of API docs
* re-build of json functions

## 0.30.0

* upgrade to null-safety

## 0.21.5

* Removed unnecesary JSON object from `CreateStudyDeployment` request ([PR#200](https://github.com/cph-cachet/carp.sensing-flutter/pull/200)).

## 0.21.4+3

* small bug fix in json serialization
* new constructor to `Trigger` classes

## 0.21.3

* added support for `ProtocolService` sub-system including request classes for using this.
* added support for `DataEndPoint` and `DataManager` handling as part of `MasterDeviceDeployment`.
* now using a `SerializationException` to raise issues in de/serialization of objects to/from json.
* fixed a bug in the `StudyDeployment.getDeviceDeploymentFor()` method.

## 0.21.2

* removal of the overall `carp_core` library - now only using the sub-system libraries. This make the API documentation much more readable.
* update and improval of API documentation

## 0.21.1

* small improvement to the `client` sub-system domain classes

## 0.21.0

* implementation of the `client` sub-system domain classes

## 0.20.3

* improvements to the `FromJsonFactory().fromJson()` method.
* added a example of how to support json serialization of polymorphic classes using the `Serialization` class.

## 0.20.2

* `DataPoint` updated to support both up- and download to the CARP server

## 0.20.1

* `ProtocolOwner` class added
* example added

## 0.20.0

* 1st extraction of core library from the CAMS package
