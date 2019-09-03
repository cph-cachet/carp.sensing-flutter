## 0.3.0
* update to `carp_mobile_sensing` v.0.6.0
* json serialization 3.0.0

## 0.2.8+3
* fixed bug in token refresh.

## 0.2.8
* query interface for documents
* add participant to study by invite
* add researcher to study by invite
* changed create user to reflect the name of the backend endpoint

## 0.2.7
* update of GET user endpoint

## 0.2.6
* rename of collection is now supported
* refresh token
* get user profile incl. name
* create user from email and password
* upload and get of informed consent documents as a `ConsentDocument` 
* `DocumentSnapshot` now handles timestamps as real `DateTime` 


## 0.2.5
* support for rename, update, and delete of documents and collections
  * _note_ than rename of a collection don't happen in the CARP web service at the time of this release
* support for query of DataPoints

## 0.2.4
* dependent on `carp_mobile_sensing` library to version 0.5.0
* support for authenticate with (locally saved) token

## 0.2.3
* refresh of auth token when expired

## 0.2.2
* upgrade to json_serializable v.2

## 0.2.1
* support for get document by id

## 0.2.0
* upgrade and test on Flutter v. 1.3.4 Dart v. 2.2.1 
* upgrading to the new CARP Web Service API for documents (instead of objects) and collections

## 0.1.3
* Adjustment to refactoring of `carp_mobile_sensing` library to version 0.3.0

## 0.1.2
* Small refactor and removal of debug print.
* Adding an example
* Added support for batch upload of data points as a file.

## 0.1.1
* Documentation update.

## 0.1.0 
* Initial release.
