// GENERATED CODE - DO NOT MODIFY BY HAND

part of domain;

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Study _$StudyFromJson(Map<String, dynamic> json) {
  return Study(json['id'] as String, json['user_id'] as String,
      name: json['name'] as String, description: json['description'] as String)
    ..classname = json['classname'] as String
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

  writeNotNull('classname', instance.classname);
  writeNotNull('id', instance.id);
  writeNotNull('user_id', instance.userId);
  writeNotNull('name', instance.name);
  writeNotNull('description', instance.description);
  writeNotNull('data_end_point', instance.dataEndPoint);
  writeNotNull('tasks', instance.tasks);
  return val;
}

DataEndPoint _$DataEndPointFromJson(Map<String, dynamic> json) {
  return DataEndPoint(json['type'] as String)
    ..classname = json['classname'] as String;
}

Map<String, dynamic> _$DataEndPointToJson(DataEndPoint instance) {
  var val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('classname', instance.classname);
  writeNotNull('type', instance.type);
  return val;
}

FileDataEndPoint _$FileDataEndPointFromJson(Map<String, dynamic> json) {
  return FileDataEndPoint(json['type'] as String)
    ..classname = json['classname'] as String
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

  writeNotNull('classname', instance.classname);
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
    ..classname = json['classname'] as String;
}

Map<String, dynamic> _$RESTDataEndPointToJson(RESTDataEndPoint instance) {
  var val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('classname', instance.classname);
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

Task _$TaskFromJson(Map<String, dynamic> json) {
  return Task(json['name'] as String)
    ..classname = json['classname'] as String
    ..measures = (json['measures'] as List)
        ?.map((e) =>
            e == null ? null : Measure.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$TaskToJson(Task instance) {
  var val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('classname', instance.classname);
  writeNotNull('name', instance.name);
  writeNotNull('measures', instance.measures);
  return val;
}

ParallelTask _$ParallelTaskFromJson(Map<String, dynamic> json) {
  return ParallelTask(json['name'] as String)
    ..classname = json['classname'] as String
    ..measures = (json['measures'] as List)
        ?.map((e) =>
            e == null ? null : Measure.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$ParallelTaskToJson(ParallelTask instance) {
  var val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('classname', instance.classname);
  writeNotNull('name', instance.name);
  writeNotNull('measures', instance.measures);
  return val;
}

SequentialTask _$SequentialTaskFromJson(Map<String, dynamic> json) {
  return SequentialTask(json['name'] as String)
    ..classname = json['classname'] as String
    ..measures = (json['measures'] as List)
        ?.map((e) =>
            e == null ? null : Measure.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$SequentialTaskToJson(SequentialTask instance) {
  var val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('classname', instance.classname);
  writeNotNull('name', instance.name);
  writeNotNull('measures', instance.measures);
  return val;
}

CARPDataPoint _$CARPDataPointFromJson(Map<String, dynamic> json) {
  return CARPDataPoint(
      json['carp_header'] == null
          ? null
          : CARPDataPointHeader.fromJson(
              json['carp_header'] as Map<String, dynamic>),
      json['carp_body'] == null
          ? null
          : Datum.fromJson(json['carp_body'] as Map<String, dynamic>))
    ..id = json['id'] as String;
}

Map<String, dynamic> _$CARPDataPointToJson(CARPDataPoint instance) {
  var val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  writeNotNull('carp_header', instance.carpHeader);
  writeNotNull('carp_body', instance.carpBody);
  return val;
}

CARPDataPointHeader _$CARPDataPointHeaderFromJson(Map<String, dynamic> json) {
  return CARPDataPointHeader(
      json['study_id'] as String, json['user_id'] as String,
      deviceRoleName: json['device_role_name'] as String,
      triggerId: json['trigger_id'] as String,
      startTime: json['start_time'] == null
          ? null
          : DateTime.parse(json['start_time'] as String),
      endTime: json['end_time'] == null
          ? null
          : DateTime.parse(json['end_time'] as String))
    ..uploadTime = json['upload_time'] == null
        ? null
        : DateTime.parse(json['upload_time'] as String)
    ..dataFormat = json['data_format'] == null
        ? null
        : CARPDataFormat.fromJson(json['data_format'] as Map<String, dynamic>);
}

Map<String, dynamic> _$CARPDataPointHeaderToJson(CARPDataPointHeader instance) {
  var val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('study_id', instance.studyId);
  writeNotNull('device_role_name', instance.deviceRoleName);
  writeNotNull('trigger_id', instance.triggerId);
  writeNotNull('user_id', instance.userId);
  writeNotNull('upload_time', instance.uploadTime?.toIso8601String());
  writeNotNull('start_time', instance.startTime?.toIso8601String());
  writeNotNull('end_time', instance.endTime?.toIso8601String());
  writeNotNull('data_format', instance.dataFormat);
  return val;
}

CARPDataFormat _$CARPDataFormatFromJson(Map<String, dynamic> json) {
  return CARPDataFormat(json['namepace'] as String, json['name'] as String);
}

Map<String, dynamic> _$CARPDataFormatToJson(CARPDataFormat instance) {
  var val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('namepace', instance.namepace);
  writeNotNull('name', instance.name);
  return val;
}

Datum _$DatumFromJson(Map<String, dynamic> json) {
  return Datum()..classname = json['classname'] as String;
}

Map<String, dynamic> _$DatumToJson(Datum instance) {
  var val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('classname', instance.classname);
  return val;
}

CARPDatum _$CARPDatumFromJson(Map<String, dynamic> json) {
  return CARPDatum()
    ..classname = json['classname'] as String
    ..id = json['id'] as String
    ..timestamp = json['timestamp'] == null
        ? null
        : DateTime.parse(json['timestamp'] as String)
    ..deviceInfo = json['device_info'] == null
        ? null
        : DeviceInfo.fromJson(json['device_info'] as Map<String, dynamic>);
}

Map<String, dynamic> _$CARPDatumToJson(CARPDatum instance) {
  var val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('classname', instance.classname);
  writeNotNull('id', instance.id);
  writeNotNull('timestamp', instance.timestamp?.toIso8601String());
  writeNotNull('device_info', instance.deviceInfo);
  return val;
}

DeviceInfo _$DeviceInfoFromJson(Map<String, dynamic> json) {
  return DeviceInfo(json['platform'] as String, json['device_id'] as String,
      deviceName: json['device_name'] as String,
      deviceModel: json['device_model'] as String,
      deviceManufacturer: json['device_manufacturer'] as String,
      operatingSystem: json['operating_system'] as String,
      hardware: json['hardware'] as String);
}

Map<String, dynamic> _$DeviceInfoToJson(DeviceInfo instance) {
  var val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('platform', instance.platform);
  writeNotNull('device_id', instance.deviceId);
  writeNotNull('hardware', instance.hardware);
  writeNotNull('device_name', instance.deviceName);
  writeNotNull('device_manufacturer', instance.deviceManufacturer);
  writeNotNull('device_model', instance.deviceModel);
  writeNotNull('operating_system', instance.operatingSystem);
  return val;
}

StringDatum _$StringDatumFromJson(Map<String, dynamic> json) {
  return StringDatum(data: json['data'] as String)
    ..classname = json['classname'] as String
    ..id = json['id'] as String
    ..timestamp = json['timestamp'] == null
        ? null
        : DateTime.parse(json['timestamp'] as String)
    ..deviceInfo = json['device_info'] == null
        ? null
        : DeviceInfo.fromJson(json['device_info'] as Map<String, dynamic>);
}

Map<String, dynamic> _$StringDatumToJson(StringDatum instance) {
  var val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('classname', instance.classname);
  writeNotNull('id', instance.id);
  writeNotNull('timestamp', instance.timestamp?.toIso8601String());
  writeNotNull('device_info', instance.deviceInfo);
  writeNotNull('data', instance.data);
  return val;
}

ErrorDatum _$ErrorDatumFromJson(Map<String, dynamic> json) {
  return ErrorDatum(json['error_message'] as String)
    ..classname = json['classname'] as String
    ..id = json['id'] as String
    ..timestamp = json['timestamp'] == null
        ? null
        : DateTime.parse(json['timestamp'] as String)
    ..deviceInfo = json['device_info'] == null
        ? null
        : DeviceInfo.fromJson(json['device_info'] as Map<String, dynamic>);
}

Map<String, dynamic> _$ErrorDatumToJson(ErrorDatum instance) {
  var val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('classname', instance.classname);
  writeNotNull('id', instance.id);
  writeNotNull('timestamp', instance.timestamp?.toIso8601String());
  writeNotNull('device_info', instance.deviceInfo);
  writeNotNull('error_message', instance.errorMessage);
  return val;
}

MultiDatum _$MultiDatumFromJson(Map<String, dynamic> json) {
  return MultiDatum()
    ..classname = json['classname'] as String
    ..id = json['id'] as String
    ..timestamp = json['timestamp'] == null
        ? null
        : DateTime.parse(json['timestamp'] as String)
    ..deviceInfo = json['device_info'] == null
        ? null
        : DeviceInfo.fromJson(json['device_info'] as Map<String, dynamic>)
    ..datums = (json['datums'] as List)
        ?.map(
            (e) => e == null ? null : Datum.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$MultiDatumToJson(MultiDatum instance) {
  var val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('classname', instance.classname);
  writeNotNull('id', instance.id);
  writeNotNull('timestamp', instance.timestamp?.toIso8601String());
  writeNotNull('device_info', instance.deviceInfo);
  writeNotNull('datums', instance.datums);
  return val;
}

Measure _$MeasureFromJson(Map<String, dynamic> json) {
  return Measure(json['measure_type'] as String, name: json['name'] as String)
    ..classname = json['classname'] as String
    ..enabled = json['enabled'] as bool
    ..configuration = (json['configuration'] as Map<String, dynamic>)
        ?.map((k, e) => MapEntry(k, e as String));
}

Map<String, dynamic> _$MeasureToJson(Measure instance) {
  var val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('classname', instance.classname);
  writeNotNull('measure_type', instance.measureType);
  writeNotNull('name', instance.name);
  writeNotNull('enabled', instance.enabled);
  writeNotNull('configuration', instance.configuration);
  return val;
}

ProbeMeasure _$ProbeMeasureFromJson(Map<String, dynamic> json) {
  return ProbeMeasure(json['measure_type'], name: json['name'])
    ..classname = json['classname'] as String
    ..enabled = json['enabled'] as bool
    ..configuration = (json['configuration'] as Map<String, dynamic>)
        ?.map((k, e) => MapEntry(k, e as String));
}

Map<String, dynamic> _$ProbeMeasureToJson(ProbeMeasure instance) {
  var val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('classname', instance.classname);
  writeNotNull('measure_type', instance.measureType);
  writeNotNull('name', instance.name);
  writeNotNull('enabled', instance.enabled);
  writeNotNull('configuration', instance.configuration);
  return val;
}

ListeningProbeMeasure _$ListeningProbeMeasureFromJson(
    Map<String, dynamic> json) {
  return ListeningProbeMeasure(json['measure_type'], name: json['name'])
    ..classname = json['classname'] as String
    ..enabled = json['enabled'] as bool
    ..configuration = (json['configuration'] as Map<String, dynamic>)
        ?.map((k, e) => MapEntry(k, e as String));
}

Map<String, dynamic> _$ListeningProbeMeasureToJson(
    ListeningProbeMeasure instance) {
  var val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('classname', instance.classname);
  writeNotNull('measure_type', instance.measureType);
  writeNotNull('name', instance.name);
  writeNotNull('enabled', instance.enabled);
  writeNotNull('configuration', instance.configuration);
  return val;
}

PollingProbeMeasure _$PollingProbeMeasureFromJson(Map<String, dynamic> json) {
  return PollingProbeMeasure(json['measure_type'],
      name: json['name'],
      frequency: json['frequency'] as int,
      duration: json['duration'] as int)
    ..classname = json['classname'] as String
    ..enabled = json['enabled'] as bool
    ..configuration = (json['configuration'] as Map<String, dynamic>)
        ?.map((k, e) => MapEntry(k, e as String));
}

Map<String, dynamic> _$PollingProbeMeasureToJson(PollingProbeMeasure instance) {
  var val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('classname', instance.classname);
  writeNotNull('measure_type', instance.measureType);
  writeNotNull('name', instance.name);
  writeNotNull('enabled', instance.enabled);
  writeNotNull('configuration', instance.configuration);
  writeNotNull('frequency', instance.frequency);
  writeNotNull('duration', instance.duration);
  return val;
}
