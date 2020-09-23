// GENERATED CODE - DO NOT MODIFY BY HAND

part of carp_backend;

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CarpDataEndPoint _$CarpDataEndPointFromJson(Map<String, dynamic> json) {
  return CarpDataEndPoint(
    _$enumDecodeNullable(_$CarpUploadMethodEnumMap, json['upload_method']),
    name: json['name'] as String,
    uri: json['uri'] as String,
    clientId: json['client_id'] as String,
    clientSecret: json['client_secret'] as String,
    email: json['email'] as String,
    password: json['password'] as String,
    collection: json['collection'] as String,
    deleteWhenUploaded: json['delete_when_uploaded'] as bool,
    bufferSize: json['buffer_size'],
    zip: json['zip'],
    encrypt: json['encrypt'],
    publicKey: json['public_key'],
  )
    ..c__ = json['c__'] as String
    ..type = json['type'] as String;
}

Map<String, dynamic> _$CarpDataEndPointToJson(CarpDataEndPoint instance) {
  final val = <String, dynamic>{};

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
  writeNotNull(
      'upload_method', _$CarpUploadMethodEnumMap[instance.uploadMethod]);
  writeNotNull('name', instance.name);
  writeNotNull('uri', instance.uri);
  writeNotNull('client_id', instance.clientId);
  writeNotNull('client_secret', instance.clientSecret);
  writeNotNull('email', instance.email);
  writeNotNull('password', instance.password);
  writeNotNull('collection', instance.collection);
  writeNotNull('delete_when_uploaded', instance.deleteWhenUploaded);
  return val;
}

T _$enumDecode<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }

  final value = enumValues.entries
      .singleWhere((e) => e.value == source, orElse: () => null)
      ?.key;

  if (value == null && unknownValue == null) {
    throw ArgumentError('`$source` is not one of the supported values: '
        '${enumValues.values.join(', ')}');
  }
  return value ?? unknownValue;
}

T _$enumDecodeNullable<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source, unknownValue: unknownValue);
}

const _$CarpUploadMethodEnumMap = {
  CarpUploadMethod.DATA_POINT: 'DATA_POINT',
  CarpUploadMethod.BATCH_DATA_POINT: 'BATCH_DATA_POINT',
  CarpUploadMethod.FILE: 'FILE',
  CarpUploadMethod.DOCUMENT: 'DOCUMENT',
};
