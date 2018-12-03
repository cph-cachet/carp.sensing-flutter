/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of carp_firebase_backend;

/// Specify a Google Firebase endpoint.
abstract class FirebaseDataEndPoint {
  /// The name of the Firebase endpoint.
  /// Can be anything, but its recommended to name it according to the Firebase bucket.
  String name;

  /// The URI of the Firebase endpoint.
  String uri;

  /// The authentization method used for Firebase. See [FireBaseAuthenticationMethods] for options.
  ///
  /// See [Firebase Authentication](https://firebase.google.com/docs/auth/) for a list of authentication options.
  String firebaseAuthenticationMethod;

  /// Email (used as username) if using password authentication.
  String email;

  /// Password if using password authentication.
  ///
  /// TODO : right now in clear text -- not so good.
  String password;

  /// Custom token, if using custom auth system integration.
  String token;

  /// The Firebase project ID (not the Name!). See Firebase project settings for this ID.
  String projectID;

  /// The Firebase Web API Key. See Firebase project settings for this ID.
  String webAPIKey;

  /// The Firebase App ID for Android. Should be set up in the Firebase project settings.
  String androidGoogleAppID;

  /// The Firebase App ID for iOS. Should be set up in the Firebase project settings.
  String iOSGoogleAppID;

  // The Firebase GCM (Google Cloud Messaging) Sender ID. See project setting under the 'Cloud Messaging' tab.
  String gcmSenderID;
}

/// Specify a Google Firebase Database document endpoint.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class FirebaseDatabaseDataEndPoint extends DataEndPoint with FirebaseDataEndPoint {
  /// When uploading to the Firebase Database using the [FirebaseDatabaseDataManager],
  /// [collection] hold the name of the collection to store json objects. May contain sub-collections separated with `/`.
  ///
  /// JSON objects will be stored in collections named <study_id>/<device_id> relative to this path.
  /// For example, if collection = "carp_data", study_id = "1234" and device_id = "987234", the data will
  /// be stored as documents in "carp_data/1234/987234/".
  String collection;

  /// Creates a [FirebaseDatabaseDataEndPoint]. [type] is defined in [DataEndPointType].
  FirebaseDatabaseDataEndPoint(String type,
      {this.collection,
      name,
      uri,
      firebaseAuthenticationMethod,
      email,
      password,
      token,
      projectID,
      webAPIKey,
      androidGoogleAppID,
      iOSGoogleAppID,
      gcmSenderID})
      : super(type) {
    this.name = name;
    this.uri = uri;
    this.firebaseAuthenticationMethod = firebaseAuthenticationMethod;
    this.email = email;
    this.password = password;
    this.token = token;
    this.projectID = projectID;
    this.webAPIKey = webAPIKey;
    this.androidGoogleAppID = androidGoogleAppID;
    this.iOSGoogleAppID = iOSGoogleAppID;
    this.gcmSenderID = gcmSenderID;
  }

  static Function get fromJsonFunction => _$FirebaseDatabaseDataEndPointFromJson;
  factory FirebaseDatabaseDataEndPoint.fromJson(Map<String, dynamic> json) =>
      _$FirebaseDatabaseDataEndPointFromJson(json);
  Map<String, dynamic> toJson() => _$FirebaseDatabaseDataEndPointToJson(this);
}

/// Specify a Google Firebase Storage file endpoint.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class FirebaseStorageDataEndPoint extends FileDataEndPoint with FirebaseDataEndPoint {
  /// When uploading to the Firebase Storage using the [FirebaseStorageDataManager],
  /// [path] hold the folder path where to store files. May contain sub-folders separated with `/`.
  ///
  /// Data (zip files) will be stored in folders named <study_id>/<device_id> relative to this path.
  /// For example, if path = "sensing/data", study_id = "1234" and device_id = "987234", the data will
  /// be stored in "sensing/data/1234/987234/".
  String path;

  /// Creates a [FirebaseStorageDataEndPoint]. [type] is defined in [DataEndPointType].
  FirebaseStorageDataEndPoint(String type,
      {this.path,
      name,
      uri,
      firebaseAuthenticationMethod,
      email,
      password,
      token,
      projectID,
      webAPIKey,
      androidGoogleAppID,
      iOSGoogleAppID,
      gcmSenderID})
      : super(type) {
    this.name = name;
    this.uri = uri;
    this.firebaseAuthenticationMethod = firebaseAuthenticationMethod;
    this.email = email;
    this.password = password;
    this.token = token;
    this.projectID = projectID;
    this.webAPIKey = webAPIKey;
    this.androidGoogleAppID = androidGoogleAppID;
    this.iOSGoogleAppID = iOSGoogleAppID;
    this.gcmSenderID = gcmSenderID;
  }

  static Function get fromJsonFunction => _$FirebaseStorageDataEndPointFromJson;
  factory FirebaseStorageDataEndPoint.fromJson(Map<String, dynamic> json) =>
      _$FirebaseStorageDataEndPointFromJson(json);
  Map<String, dynamic> toJson() => _$FirebaseStorageDataEndPointToJson(this);
}

/// A enumeration of possible authentication methods in Firebase.
class FireBaseAuthenticationMethods {
  static const String PASSWORD = "password";
  static const String GOOGLE = "google";
  static const String FACEBOOK = "facebook";
  static const String TWITTER = "twitter";
  static const String GITHUB = "github";
  static const String PHONE = "phone";
  static const String ANONYMOUSLY = "anonymously";
  static const String CUSTOM = "custom";
}
