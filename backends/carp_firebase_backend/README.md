# CARP Firebase Data Backend

A Flutter plugin for uploading data from the [CARP Mobile Sensing Framework](https://pub.dartlang.org/packages/carp_mobile_sensing) 
to a Google Firebase data backend. 

Supports uploading json to Firebase as either (zipped) files to Firebase Storage or as plain json to a Firebase Database.

[![pub package](https://img.shields.io/pub/v/carp_firebase_backend.svg)](https://pub.dartlang.org/packages/carp_firebase_backend)

For Flutter plugins for other CARP products, see [CARP Mobile Sensing in Flutter](https://github.com/cph-cachet/carp.sensing-flutter/blob/master/README.md).

This package can upload sending data to Goggle Firebase in two ways:

* **Google Firebase Storage** – By using the Google Firebase **Storage** endpoint, CARP sensing data are uploaded as raw or zipped JSON file, generated using the 
[`FileDataManager`](https://pub.dartlang.org/documentation/carp_mobile_sensing/latest/datastore/FileDataManager-class.html) 
in `carp_mobile_sensing`.
In Firebase, files with sensed data is stored in the `path` specified in the `FirebaseStorageDataEndPoint` plus subfolders for each study and device. 
The path on Firebase hence follow this pattern: `/<path>/<study_id>/<device_id>/`

* **Google Firebase Database** – By using the Google Firebase **Database** endpoint, CARP sensing data are uploaded as raw JSON data points, 
using Firebase as a [`DataManager`](https://pub.dartlang.org/documentation/carp_core/latest/carp_core/DataManager-class.html) in `carp_mobile_sensing`.
In Firebase, data json objects are stores in the `collection` specified in the `FirebaseDatabaseDataManager`.
JSON objects will be stored in collections named `/<collection>/<study_id>/<device_id>/upload/<data_type>` 
relative to this path. For example, if `collection` is `carp_data`, `study_id` is `1234` and `device_id` is `R16NW`, 
location data will be stored as documents in this collection: `carp_data/1234/R16NW/upload/location`.



## Setting up support for Google Firebase

For Firebase to work with your Flutter app, configuration of both Firebase and your Flutter app has to be done. 
Please follow the step below in details, since the level of debugging / error messages are quite limited 
when setting this up. If you are new to Firebase, then please start by reading the extensive 
[Firebase documentation](https://firebase.google.com/docs/) first.
Then read the [Add Firebase to your Flutter app](https://firebase.google.com/docs/flutter/setup) tutorial.



### Step 1: Configure Google Firebase

1. Create a Firebase project with a [cloud storage](https://firebase.google.com/docs/storage/)
1. Add Firebase to your  [Flutter](https://firebase.google.com/docs/flutter/setup) project by following the description. 
Note that you need to add support for **both** the Android and iOS version of the Flutter app.
4. Configure [authentication](https://firebase.google.com/docs/auth/)
    * `carp_firebase_backend` supports two types of authentication:
         * [username/password](https://firebase.google.com/docs/auth/android/password-auth) authentication
         * [Google Sign-In](https://firebase.google.com/docs/auth/android/google-signin) on Android. 
         **Note:** [SHA-1](https://developers.google.com/android/guides/client-auth) information is required by Google Sign-In
5. Add users that can upload data e.g. via the console
6. Set up your [storage security rules](https://firebase.google.com/docs/storage/security/start) as shown below.

```
# Default access rule
service firebase.storage {
  match /b/{bucket}/o {
    match /{allPaths=**} {
      allow read, write: if request.auth != null;
    }
  }
}
```

For testing/debugging purposes, you may remove authentication by the authentication rule below (but should be removed
in production)

```
# No authentication rule
service firebase.storage {
  match /b/{bucket}/o {
    match /{allPaths=**} {
      allow read, write;
    }
  }
}
```

### Step 2: Configure your app to use Firebase

Follow the direction on [how to configure a Flutter app to use Firebase](https://firebase.google.com/docs/flutter/setup#configure_to_use_firebase).

#### On iOS

1. Add your app to your Firebase project. Enter your app’s bundle ID in the iOS bundle ID field.
2. Download the `GoogleService-Info.plist` file to obtain your Firebase iOS config file.
3. Using XCode, move the file into the `Runner/Runner` directory of your Flutter app.
4. Google services use CocoaPods to install and manage dependencies. Open a terminal window 
and navigate to the location of the Xcode project for your app. The type

```
$ pod init
§ pod install
```

This should install all the necessary pods for Firebase.

> **Note:** It seems like Firebase is putting constraints on the naming of the iOS **Bundle Name**. 
Even though a valid iOS bundle name can contain `.` (dots) and spaces, Firebase throws the following exception:

```
Terminating app due to uncaught exception 'com.firebase.core', reason: 'App name can only contain alphanumeric, hyphen (-), and underscore (_) characters'
```

if dots are used. Hence, avoid using dots, but use `-` (hypen) instead. This is specified in the `ios/Runner/info.plist' file:

```
<key>CFBundleName</key>
<string>your-app-name</string>
```

**Note** – it seems like adding Firebase support to your iOS app dramatically increases the Xcode build 
process for the Flutter app. So – have patience...


#### On Android

1. Add your app to your Firebase project. Enter your app’s application ID in the Android package name field.
2. [Download the configuration file](https://support.google.com/firebase/answer/7015592) named `google-services.json`
and make sure to put in in your Android app module root directory, i.e a folder like `<appname>/android/app/`
3. Add support for the [Google Services Gradle plugin](https://developers.google.com/android/guides/google-services-plugin)
 to read the `google-services.json` file that was generated by Firebase.
    * in your IDE, open `android/app/build.gradle`, and add the following line as the last line in the file:
    
     ` apply plugin: 'com.google.gms.google-services'`
    
    * In `android/build.gradle`, inside the `buildscript` tag, add a new dependency:
     ```
     dependencies {
             // ...
             classpath 'com.google.gms:google-services:4.3.2'   // new
         }
     ```
    * note the version of this SDK may chance - see [Add Firebase to Your Android Project](https://firebase.google.com/docs/android/setup#manually_add_firebase) 



### Step 3: Use the CARP Firebase Backend in your Flutter App

In Flutter, the `carp_firebase_backend` plugin is used to upload data from `carp_mobile_sensing` to a Firebase endpoint.

Add the `carp_firebase_backend` plugin to the `pubspec.yaml` file.

```dart
dependencies:
  flutter:
    sdk: flutter
  carp_firebase_backend: ^0.3.0     # support for uploading CARP data to Firebase
```

Run `flutter packages get`. For more information on managing packages and plugins, 
see [Using Packages](https://flutter.io/using-packages/).


## Using the Plugin

Upload of files to Firebase Storage uses the `FirebaseStorageDataManager` and
upload of json objects to Firebase Database uses `FirebaseDatabaseDataManager`.
Using the library takes three steps.

### 1. Register the Data Managers

First you should register the data manager you want to use (or both) in the `DataManagerRegistry`.

````dart
DataManagerRegistry.register(DataEndPointType.FIREBASE_STORAGE, new FirebaseStorageDataManager());
DataManagerRegistry.register(DataEndPointType.FIREBASE_DATABASE, new FirebaseDatabaseDataManager());
````

### 2. Specify Access Details to the Firebase App
 
Both data managers uses a `FirebaseEndPoint` object to handle access to Firebase. 
In this object, Firebase endpoint configuration keys are stored as well as authentication details. 
All of the Firebase configuration keys can be found in the _Projects Settings_ in the Firebase Console.
Remember to register your app in Firebase, as described above.
The `firebaseAuthenticationMethod` key specify the authentication method. Currently, only _email/password_ and 
_Google Sign-In_ is implemented (even though `FireBaseAuthenticationMethods` lists them all (for future use)).
 

**Using email/password as authentication**

````dart
final FirebaseEndPoint firebaseEndPoint = new FirebaseEndPoint(
    name: "Flutter Sensing Sandbox",
    uri: 'gs://flutter-sensing-sandbox.appspot.com',
    projectID: 'flutter-sensing-sandbox',
    webAPIKey: 'AIzaSyCGy6MeHkiv5XkBtMcMbtgGYOpf6ntNVE4',
    gcmSenderID: '201621881872',
    androidGoogleAppID: '1:201621881872:android:8e84e7ccfc85e121',
    iOSGoogleAppID: '1:159623150305:ios:4a213ef3dbd8997b',
    firebaseAuthenticationMethod: FireBaseAuthenticationMethods.PASSWORD,
    email: "some_email@dtu.dk",
    password: "some_password");
````

**Using Google Sign-In as authentication**


````dart
final FirebaseEndPoint firebaseEndPoint = new FirebaseEndPoint(
    name: "Flutter Sensing Sandbox",
    uri: 'gs://flutter-sensing-sandbox.appspot.com',
    projectID: 'flutter-sensing-sandbox',
    webAPIKey: 'AIzaSyCGy6MeHkiv5XkBtMcMbtgGYOpf6ntNVE4',
    gcmSenderID: '201621881872',
    androidGoogleAppID: '1:201621881872:android:8e84e7ccfc85e121',
    iOSGoogleAppID: '1:159623150305:ios:4a213ef3dbd8997b',
    firebaseAuthenticationMethod: FireBaseAuthenticationMethods.GOOGLE);
````

### 3. Create the Data Endpoint 

Finally, you create the data endpoint (`FirebaseStorageDataEndPoint` or `FirebaseDatabaseDataEndPoint`) providing it
with a `FirebaseEndPoint` and add it as your `Study` data endpoint.

**Firebase Storage Endpoint**

````dart
final FirebaseStorageDataEndPoint storageEndPoint = new FirebaseStorageDataEndPoint(
   firebaseEndPoint,
   path: 'sensing/data', 
   bufferSize: 500 * 1000, 
   zip: true, 
   encrypt: false);

Study study_1 = new Study("1234", "user_1@dtu.dk", name: "Test study #1");
study_1.dataEndPoint = storageEndPoint;
````

Note that a `FirebaseStorageDataEndPoint` extends the `FileDataEndPoint` class and parameters related to 
how to create the files can be specified, including `bufferSize`, `zip`, and `encrypt`.
In the example above, the file buffer size is set to 1 MB, which is zipped before upload.


**Firebase Database Endpoint**

````dart
final FirebaseDatabaseDataEndPoint databaseEndPoint =
    new FirebaseDatabaseDataEndPoint(firebaseEndPoint, collection: 'carp_data');

Study study_2 = new Study("5678", "user_2@dtu.dk", name: "Test study #2");
study_2.dataEndPoint = databaseEndPoint;
````

 
## Features and bugs

Please file feature requests and bug reports at the [issue tracker][tracker].

[tracker]: https://github.com/cph-cachet/carp.sensing/issues

## License

This software is copyright (c) 2018 [Copenhagen Center for Health Technology (CACHET)](http://www.cachet.dk/) at the [Technical University of Denmark (DTU)](http://www.dtu.dk).
This software is made available 'as-is' in a MIT [license](/LICENSE).

