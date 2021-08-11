// GENERATED CODE - DO NOT MODIFY BY HAND

part of carp_backend;

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CarpDataEndPoint _$CarpDataEndPointFromJson(Map<String, dynamic> json) {
  return CarpDataEndPoint(
    uploadMethod: _$enumDecode(_$CarpUploadMethodEnumMap, json['uploadMethod']),
    name: json['name'] as String,
    uri: json['uri'] as String,
    clientId: json['clientId'] as String,
    clientSecret: json['clientSecret'] as String,
    email: json['email'] as String?,
    password: json['password'] as String?,
    collection: json['collection'] as String?,
    deleteWhenUploaded: json['deleteWhenUploaded'] as bool,
    bufferSize: json['bufferSize'] as int,
    zip: json['zip'] as bool,
    encrypt: json['encrypt'] as bool,
    publicKey: json['publicKey'] as String?,
  )
    ..$type = json[r'$type'] as String?
    ..type = json['type'] as String
    ..dataFormat = json['dataFormat'] as String;
}

Map<String, dynamic> _$CarpDataEndPointToJson(CarpDataEndPoint instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull(r'$type', instance.$type);
  val['type'] = instance.type;
  val['dataFormat'] = instance.dataFormat;
  val['bufferSize'] = instance.bufferSize;
  val['zip'] = instance.zip;
  val['encrypt'] = instance.encrypt;
  writeNotNull('publicKey', instance.publicKey);
  val['uploadMethod'] = _$CarpUploadMethodEnumMap[instance.uploadMethod];
  val['name'] = instance.name;
  val['uri'] = instance.uri;
  val['clientId'] = instance.clientId;
  val['clientSecret'] = instance.clientSecret;
  writeNotNull('email', instance.email);
  writeNotNull('password', instance.password);
  writeNotNull('collection', instance.collection);
  val['deleteWhenUploaded'] = instance.deleteWhenUploaded;
  return val;
}

K _$enumDecode<K, V>(
  Map<K, V> enumValues,
  Object? source, {
  K? unknownValue,
}) {
  if (source == null) {
    throw ArgumentError(
      'A value must be provided. Supported values: '
      '${enumValues.values.join(', ')}',
    );
  }

  return enumValues.entries.singleWhere(
    (e) => e.value == source,
    orElse: () {
      if (unknownValue == null) {
        throw ArgumentError(
          '`$source` is not one of the supported values: '
          '${enumValues.values.join(', ')}',
        );
      }
      return MapEntry(unknownValue, enumValues.values.first);
    },
  ).key;
}

const _$CarpUploadMethodEnumMap = {
  CarpUploadMethod.DATA_POINT: 'DATA_POINT',
  CarpUploadMethod.BATCH_DATA_POINT: 'BATCH_DATA_POINT',
  CarpUploadMethod.FILE: 'FILE',
  CarpUploadMethod.DOCUMENT: 'DOCUMENT',
};
