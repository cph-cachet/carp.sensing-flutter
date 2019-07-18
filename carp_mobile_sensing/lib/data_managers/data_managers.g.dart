// GENERATED CODE - DO NOT MODIFY BY HAND

part of data_managers;

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FileDataEndPoint _$FileDataEndPointFromJson(Map<String, dynamic> json) {
  return FileDataEndPoint(
      type: _$enumDecodeNullable(_$DataEndPointTypeEnumMap, json['type']),
      bufferSize: json['buffer_size'] as int,
      zip: json['zip'] as bool,
      encrypt: json['encrypt'] as bool,
      publicKey: json['public_key'] as String)
    ..c__ = json['c__'] as String;
}

Map<String, dynamic> _$FileDataEndPointToJson(FileDataEndPoint instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('c__', instance.c__);
  writeNotNull('type', _$DataEndPointTypeEnumMap[instance.type]);
  writeNotNull('buffer_size', instance.bufferSize);
  writeNotNull('zip', instance.zip);
  writeNotNull('encrypt', instance.encrypt);
  writeNotNull('public_key', instance.publicKey);
  return val;
}

T _$enumDecode<T>(Map<T, dynamic> enumValues, dynamic source) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }
  return enumValues.entries
      .singleWhere((e) => e.value == source,
          orElse: () => throw ArgumentError(
              '`$source` is not one of the supported values: '
              '${enumValues.values.join(', ')}'))
      .key;
}

T _$enumDecodeNullable<T>(Map<T, dynamic> enumValues, dynamic source) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source);
}

const _$DataEndPointTypeEnumMap = <DataEndPointType, dynamic>{
  DataEndPointType.PRINT: 'PRINT',
  DataEndPointType.FILE: 'FILE',
  DataEndPointType.SQLITE: 'SQLITE',
  DataEndPointType.FIREBASE_STORAGE: 'FIREBASE_STORAGE',
  DataEndPointType.FIREBASE_DATABSE: 'FIREBASE_DATABSE',
  DataEndPointType.CARP: 'CARP',
  DataEndPointType.OMH: 'OMH',
  DataEndPointType.AWS: 'AWS'
};
