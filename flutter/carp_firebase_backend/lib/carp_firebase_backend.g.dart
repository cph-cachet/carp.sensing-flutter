// GENERATED CODE - DO NOT MODIFY BY HAND

part of carp_firebase_backend;

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FirebaseStorageDataEndPoint _$FirebaseStorageDataEndPointFromJson(
    Map<String, dynamic> json) {
  return FirebaseStorageDataEndPoint(json['type'] as String,
      uri: json['uri'] as String,
      firebaseAuthenticationMethod:
          json['firebase_authentication_method'] as String)
    ..$ = json[r'$'] as String
    ..bufferSize = json['buffer_size'] as int
    ..zip = json['zip'] as bool
    ..encrypt = json['encrypt'] as bool
    ..publicKey = json['public_key'] as String
    ..name = json['name'] as String
    ..path = json['path'] as String
    ..email = json['email'] as String
    ..password = json['password'] as String
    ..token = json['token'] as String
    ..projectID = json['project_i_d'] as String
    ..webAPIKey = json['web_a_p_i_key'] as String
    ..androidGoogleAppID = json['android_google_app_i_d'] as String
    ..iOSGoogleAppID = json['i_o_s_google_app_i_d'] as String
    ..gcmSenderID = json['gcm_sender_i_d'] as String;
}

Map<String, dynamic> _$FirebaseStorageDataEndPointToJson(
    FirebaseStorageDataEndPoint instance) {
  var val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull(r'$', instance.$);
  writeNotNull('type', instance.type);
  writeNotNull('buffer_size', instance.bufferSize);
  writeNotNull('zip', instance.zip);
  writeNotNull('encrypt', instance.encrypt);
  writeNotNull('public_key', instance.publicKey);
  writeNotNull('name', instance.name);
  writeNotNull('uri', instance.uri);
  writeNotNull('path', instance.path);
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
