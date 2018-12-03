// GENERATED CODE - DO NOT MODIFY BY HAND

part of carp_firebase_backend;

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FirebaseDatabaseDataEndPoint _$FirebaseDatabaseDataEndPointFromJson(
    Map<String, dynamic> json) {
  return FirebaseDatabaseDataEndPoint(json['type'] as String,
      collection: json['collection'] as String,
      name: json['name'],
      uri: json['uri'],
      firebaseAuthenticationMethod: json['firebase_authentication_method'],
      email: json['email'],
      password: json['password'],
      token: json['token'],
      projectID: json['project_i_d'],
      webAPIKey: json['web_a_p_i_key'],
      androidGoogleAppID: json['android_google_app_i_d'],
      iOSGoogleAppID: json['i_o_s_google_app_i_d'],
      gcmSenderID: json['gcm_sender_i_d'])
    ..c__ = json['c__'] as String;
}

Map<String, dynamic> _$FirebaseDatabaseDataEndPointToJson(
    FirebaseDatabaseDataEndPoint instance) {
  var val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('name', instance.name);
  writeNotNull('c__', instance.c__);
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
  writeNotNull('type', instance.type);
  writeNotNull('collection', instance.collection);
  return val;
}

FirebaseStorageDataEndPoint _$FirebaseStorageDataEndPointFromJson(
    Map<String, dynamic> json) {
  return FirebaseStorageDataEndPoint(json['type'] as String,
      path: json['path'] as String,
      name: json['name'],
      uri: json['uri'],
      firebaseAuthenticationMethod: json['firebase_authentication_method'],
      email: json['email'],
      password: json['password'],
      token: json['token'],
      projectID: json['project_i_d'],
      webAPIKey: json['web_a_p_i_key'],
      androidGoogleAppID: json['android_google_app_i_d'],
      iOSGoogleAppID: json['i_o_s_google_app_i_d'],
      gcmSenderID: json['gcm_sender_i_d'])
    ..c__ = json['c__'] as String
    ..bufferSize = json['buffer_size'] as int
    ..zip = json['zip'] as bool
    ..encrypt = json['encrypt'] as bool
    ..publicKey = json['public_key'] as String;
}

Map<String, dynamic> _$FirebaseStorageDataEndPointToJson(
    FirebaseStorageDataEndPoint instance) {
  var val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('name', instance.name);
  writeNotNull('c__', instance.c__);
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
  writeNotNull('type', instance.type);
  writeNotNull('buffer_size', instance.bufferSize);
  writeNotNull('zip', instance.zip);
  writeNotNull('encrypt', instance.encrypt);
  writeNotNull('public_key', instance.publicKey);
  writeNotNull('path', instance.path);
  return val;
}
