// GENERATED CODE - DO NOT MODIFY BY HAND

part of carp_backend;

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CarpDataEndPoint _$CarpDataEndPointFromJson(Map<String, dynamic> json) =>
    CarpDataEndPoint(
      uploadMethod:
          $enumDecode(_$CarpUploadMethodEnumMap, json['uploadMethod']),
      name: json['name'] as String,
      uri: json['uri'] as String?,
      clientId: json['clientId'] as String?,
      clientSecret: json['clientSecret'] as String?,
      email: json['email'] as String?,
      password: json['password'] as String?,
      collection: json['collection'] as String?,
      deleteWhenUploaded: json['deleteWhenUploaded'] as bool? ?? true,
      bufferSize: json['bufferSize'] as int? ?? 500 * 1000,
      zip: json['zip'] as bool? ?? true,
      encrypt: json['encrypt'] as bool? ?? false,
      publicKey: json['publicKey'] as String?,
    )
      ..$type = json[r'$type'] as String?
      ..type = json['type'] as String
      ..dataFormat = json['dataFormat'] as String;

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
  writeNotNull('uri', instance.uri);
  writeNotNull('clientId', instance.clientId);
  writeNotNull('clientSecret', instance.clientSecret);
  writeNotNull('email', instance.email);
  writeNotNull('password', instance.password);
  val['collection'] = instance.collection;
  val['deleteWhenUploaded'] = instance.deleteWhenUploaded;
  return val;
}

const _$CarpUploadMethodEnumMap = {
  CarpUploadMethod.DATA_POINT: 'DATA_POINT',
  CarpUploadMethod.BATCH_DATA_POINT: 'BATCH_DATA_POINT',
  CarpUploadMethod.FILE: 'FILE',
  CarpUploadMethod.DOCUMENT: 'DOCUMENT',
};
