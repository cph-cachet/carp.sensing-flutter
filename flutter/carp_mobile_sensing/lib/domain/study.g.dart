// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'study.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Study _$StudyFromJson(Map<String, dynamic> json) {
  return Study(json['id'] as String, json['user_id'] as String,
      name: json['name'] as String, description: json['description'] as String)
    ..$ = json[r'$'] as String
    ..dataEndPoint = json['data_end_point'] == null
        ? null
        : DataEndPoint.fromJson(json['data_end_point'] as Map<String, dynamic>)
    ..tasks = (json['tasks'] as List)
        ?.map(
            (e) => e == null ? null : Task.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$StudyToJson(Study instance) {
  var val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull(r'$', instance.$);
  writeNotNull('id', instance.id);
  writeNotNull('user_id', instance.userId);
  writeNotNull('name', instance.name);
  writeNotNull('description', instance.description);
  writeNotNull('data_end_point', instance.dataEndPoint);
  writeNotNull('tasks', instance.tasks);
  return val;
}

DataEndPoint _$DataEndPointFromJson(Map<String, dynamic> json) {
  return DataEndPoint(json['type'] as String)..$ = json[r'$'] as String;
}

Map<String, dynamic> _$DataEndPointToJson(DataEndPoint instance) {
  var val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull(r'$', instance.$);
  writeNotNull('type', instance.type);
  return val;
}

FileDataEndPoint _$FileDataEndPointFromJson(Map<String, dynamic> json) {
  return FileDataEndPoint(json['type'] as String)
    ..$ = json[r'$'] as String
    ..bufferSize = json['buffer_size'] as int
    ..zip = json['zip'] as bool
    ..encrypt = json['encrypt'] as bool
    ..publicKey = json['public_key'] as String;
}

Map<String, dynamic> _$FileDataEndPointToJson(FileDataEndPoint instance) {
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
  return val;
}

RESTDataEndPoint _$RESTDataEndPointFromJson(Map<String, dynamic> json) {
  return RESTDataEndPoint(json['type'] as String,
      uri: json['uri'] == null ? null : Uri.parse(json['uri'] as String),
      method: _$enumDecodeNullable(_$HTTPMethodEnumMap, json['method']),
      uploadStrategy: _$enumDecodeNullable(
          _$UploadStrategyEnumMap, json['upload_strategy']))
    ..$ = json[r'$'] as String;
}

Map<String, dynamic> _$RESTDataEndPointToJson(RESTDataEndPoint instance) {
  var val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull(r'$', instance.$);
  writeNotNull('type', instance.type);
  writeNotNull('method', _$HTTPMethodEnumMap[instance.method]);
  writeNotNull('uri', instance.uri?.toString());
  writeNotNull(
      'upload_strategy', _$UploadStrategyEnumMap[instance.uploadStrategy]);
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

const _$HTTPMethodEnumMap = <HTTPMethod, dynamic>{
  HTTPMethod.GET: 'GET',
  HTTPMethod.POST: 'POST',
  HTTPMethod.HEAD: 'HEAD',
  HTTPMethod.PUT: 'PUT',
  HTTPMethod.DELETE: 'DELETE'
};

const _$UploadStrategyEnumMap = <UploadStrategy, dynamic>{
  UploadStrategy.CONTINUOUSLY: 'CONTINUOUSLY',
  UploadStrategy.PERIODIC: 'PERIODIC'
};
