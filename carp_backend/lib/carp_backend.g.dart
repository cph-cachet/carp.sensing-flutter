// GENERATED CODE - DO NOT MODIFY BY HAND

part of carp_backend;

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CarpDataEndPoint _$CarpDataEndPointFromJson(Map<String, dynamic> json) {
  return CarpDataEndPoint(json['upload_method'] as String,
      name: json['name'] as String,
      uri: json['uri'] as String,
      clientId: json['client_id'] as String,
      clientSecret: json['client_secret'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
      collection: json['collection'] as String)
    ..c__ = json['c__'] as String
    ..type = json['type'] as String
    ..bufferSize = json['buffer_size'] as int
    ..zip = json['zip'] as bool
    ..encrypt = json['encrypt'] as bool
    ..publicKey = json['public_key'] as String;
}

Map<String, dynamic> _$CarpDataEndPointToJson(CarpDataEndPoint instance) {
  var val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('c__', instance.c__);
  writeNotNull('type', instance.type);
  writeNotNull('buffer_size', instance.bufferSize);
  writeNotNull('zip', instance.zip);
  writeNotNull('encrypt', instance.encrypt);
  writeNotNull('public_key', instance.publicKey);
  writeNotNull('upload_method', instance.uploadMethod);
  writeNotNull('name', instance.name);
  writeNotNull('uri', instance.uri);
  writeNotNull('client_id', instance.clientId);
  writeNotNull('client_secret', instance.clientSecret);
  writeNotNull('email', instance.email);
  writeNotNull('password', instance.password);
  writeNotNull('collection', instance.collection);
  return val;
}
