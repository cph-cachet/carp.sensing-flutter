// GENERATED CODE - DO NOT MODIFY BY HAND

part of carp_firebase_backend;

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FirebaseEndPoint _$FirebaseEndPointFromJson(Map<String, dynamic> json) {
  return FirebaseEndPoint(
      name: json['name'] as String,
      uri: json['uri'] as String,
      firebaseAuthenticationMethod:
          json['firebase_authentication_method'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
      token: json['token'] as String,
      projectID: json['project_i_d'] as String,
      webAPIKey: json['web_a_p_i_key'] as String,
      androidGoogleAppID: json['android_google_app_i_d'] as String,
      iOSGoogleAppID: json['i_o_s_google_app_i_d'] as String,
      gcmSenderID: json['gcm_sender_i_d'] as String);
}

Map<String, dynamic> _$FirebaseEndPointToJson(FirebaseEndPoint instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('name', instance.name);
  writeNotNull('uri', instance.uri);
  writeNotNull(
      'firebase_authentication_method', instance.firebaseAuthenticationMethod);
  writeNotNull('email', instance.email);
  writeNotNull('password', instance.password);
  writeNotNull('token', instance.token);
  writeNotNull('project_i_d', instance.projectID);
  writeNotNull('web_a_p_i_key', instance.webAPIKey);
  writeNotNull('android_google_app_i_d', instance.androidGoogleAppID);
  writeNotNull('i_o_s_google_app_i_d', instance.iOSGoogleAppID);
  writeNotNull('gcm_sender_i_d', instance.gcmSenderID);
  return val;
}

FirebaseDatabaseDataEndPoint _$FirebaseDatabaseDataEndPointFromJson(
    Map<String, dynamic> json) {
  return FirebaseDatabaseDataEndPoint(
      json['firebase_end_point'] == null
          ? null
          : FirebaseEndPoint.fromJson(
              json['firebase_end_point'] as Map<String, dynamic>),
      collection: json['collection'] as String)
    ..c__ = json['c__'] as String
    ..type = json['type'] as String;
}

Map<String, dynamic> _$FirebaseDatabaseDataEndPointToJson(
    FirebaseDatabaseDataEndPoint instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('c__', instance.c__);
  writeNotNull('firebase_end_point', instance.firebaseEndPoint);
  writeNotNull('type', instance.type);
  writeNotNull('collection', instance.collection);
  return val;
}

FirebaseStorageDataEndPoint _$FirebaseStorageDataEndPointFromJson(
    Map<String, dynamic> json) {
  return FirebaseStorageDataEndPoint(
      json['firebase_end_point'] == null
          ? null
          : FirebaseEndPoint.fromJson(
              json['firebase_end_point'] as Map<String, dynamic>),
      path: json['path'] as String,
      bufferSize: json['buffer_size'],
      zip: json['zip'],
      encrypt: json['encrypt'],
      publicKey: json['public_key'])
    ..c__ = json['c__'] as String
    ..type = json['type'] as String;
}

Map<String, dynamic> _$FirebaseStorageDataEndPointToJson(
    FirebaseStorageDataEndPoint instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('c__', instance.c__);
  writeNotNull('firebase_end_point', instance.firebaseEndPoint);
  writeNotNull('type', instance.type);
  writeNotNull('buffer_size', instance.bufferSize);
  writeNotNull('zip', instance.zip);
  writeNotNull('encrypt', instance.encrypt);
  writeNotNull('public_key', instance.publicKey);
  writeNotNull('path', instance.path);
  return val;
}
