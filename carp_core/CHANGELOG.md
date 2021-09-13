## 0.30.1+2
* fix of json serialization bugs (x2)
* update of API docs

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
* improvements to the ` FromJsonFactory().fromJson()` method.
* added a example of how to support json serialization of polymorphic classes using the `Serialization` class.

## 0.20.2
* `DataPoint` updated to support both up- and download to the CARP server

## 0.20.1
* `ProtocolOwner` class added
* example added

## 0.20.0
* 1st extraction of core library from the CAMS package
