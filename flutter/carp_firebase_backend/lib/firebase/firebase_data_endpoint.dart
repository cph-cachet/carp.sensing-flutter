/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */
import 'package:carp_sensing/carp_sensing.dart';
import 'package:json_annotation/json_annotation.dart';

part 'firebase_data_endpoint.g.dart';

/// Specify a data endpoint for the Google Firebase Storage for storing files.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class FirebaseStorageDataEndPoint extends FileDataEndPoint {
  /// The name of the Firebase Storage endpoint to upload files to.
  /// Can be anything, but its recommended to name it according to the Firebase bucket.
  String name;

  /// The URI of the Firebase Storage endpoint to upload files to.
  String uri;

  /// The folder path where to store files. May contain subfolders separated with `/`.
  ///
  /// Data (zip files) will be stored in folders named <study_id>/<device_id> relative to this path.
  /// For example, if path = "sensing/data", study_id = "1234" and device_id = "987234", the data will
  /// be stored in "sensing/data/1234/987234/".
  String path;

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

  /// Creates a [DataEndPoint]. [type] is defined in [DataEndPointType].
  FirebaseStorageDataEndPoint(String type, {this.uri, this.firebaseAuthenticationMethod}) : super(type);

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
