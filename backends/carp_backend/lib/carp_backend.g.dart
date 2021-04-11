// GENERATED CODE - DO NOT MODIFY BY HAND

part of carp_backend;

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CarpDataEndPoint _$CarpDataEndPointFromJson(Map<String, dynamic> json) {
  return CarpDataEndPoint(
    uploadMethod:
        _$enumDecodeNullable(_$CarpUploadMethodEnumMap, json['uploadMethod']),
    name: json['name'] as String,
    uri: json['uri'] as String,
    clientId: json['clientId'] as String,
    clientSecret: json['clientSecret'] as String,
    email: json['email'] as String,
    password: json['password'] as String,
    collection: json['collection'] as String,
    deleteWhenUploaded: json['deleteWhenUploaded'] as bool,
    bufferSize: json['bufferSize'],
    zip: json['zip'],
    encrypt: json['encrypt'],
    publicKey: json['publicKey'],
  )
    ..$type = json[r'$type'] as String
    ..type = json['type'] as String;
}

Map<String, dynamic> _$CarpDataEndPointToJson(CarpDataEndPoint instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull(r'$type', instance.$type);
  writeNotNull('type', instance.type);
  writeNotNull('bufferSize', instance.bufferSize);
  writeNotNull('zip', instance.zip);
  writeNotNull('encrypt', instance.encrypt);
  writeNotNull('publicKey', instance.publicKey);
  writeNotNull(
      'uploadMethod', _$CarpUploadMethodEnumMap[instance.uploadMethod]);
  writeNotNull('name', instance.name);
  writeNotNull('uri', instance.uri);
  writeNotNull('clientId', instance.clientId);
  writeNotNull('clientSecret', instance.clientSecret);
  writeNotNull('email', instance.email);
  writeNotNull('password', instance.password);
  writeNotNull('collection', instance.collection);
  writeNotNull('deleteWhenUploaded', instance.deleteWhenUploaded);
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
