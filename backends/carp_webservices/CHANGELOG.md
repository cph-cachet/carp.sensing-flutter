## 0.13.0
* update to CARP core version 28

## 0.12.0
* updated to carp_mobile_sensing v. 0.12.x

## 0.11.3
* update of `CarpApp` to handle study ID from the server (as opposed to from a local `Study` configuration)
* refactor of the `getStudyInvitation` method

## 0.11.2
* updated to carp_mobile_sensing v. 0.11.1
* support for getting a list of deployment invitation using a modal dialog (UI).
* misc refactor and optimization of API

## 0.11.1
* the singleton CarpService is accessed using `CarpService()` (instead of the old `CarpService.instance`) 
  in order to be consist with the rest of CAMS.
* support for authentication using a modal dialog (UI).
* support for sending 'forgotten password' emails using the `sendForgottenPasswordEmail()` method.

## 0.11.0
* updated to carp_mobile_sensing v. 0.11.x

## 0.10.0
* updated to carp_mobile_sensing v. 0.10.x
* alligning version number

## 0.5.2
* feature: support for `changePassword()`
* fix: password is no longer stored as part of `carp_webservices` neither in memory or serialized to json.
* refactor: removal of old deprecated methods for inviting particpants and researchers.

## 0.5.1
* feature: support for deployment endpoints using the `DeploymentReference` class

## 0.5.0
* **BREAKING**: Updated to CAMS v. 0.9.0 with new `$type` json serialization
* fix: OAuth token in `CarpUser` is now serialized ([#96](https://github.com/cph-cachet/carp.sensing-flutter/issues/96))
* fix: fixed an error in the refresh token method.

## 0.4.6
* feature: better support for authentication with stored tokens ([#79](https://github.com/cph-cachet/carp.sensing-flutter/issues/79)).
* feature: `CarpUser` can be serialized to JSON.

## 0.4.5
* refactor: separation of Study ID and Deployment ID when calling CARP endpoints
* refactor: better error handling and messages
* test: unit test for uploading file fails, but seems to be a server-side issue

## 0.4.4
* feature: data point and informed consent endpoint changed to use `deployments` in URL.
* refactor: aligned the collection/documents to the new CANS endpoints

## 0.4.3
* refactor: `study_id` is now a String (not an int anymore).
* fix: fixed [#66](https://github.com/cph-cachet/carp.sensing-flutter/issues/66).

## 0.4.2
* update: updated to carp_mobile_sensing v. 0.8.x

## 0.4.1
* feature: upload of files to CANS implemented.
* feature: support for serializing the OAuth token to JSON.

## 0.4.0
* **Breaking** Update to the new CANS API and data model.

## 0.3.3
* improvement on retry in offline mode
* testing w. iOS
* aligned with `carp_mobile_sensing` version 0.6.2

## 0.3.2
* support for retry in all RESTfull calls, incl. upload of JSON data files.

## 0.3.1
* fixed a bug in the get all files method

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
