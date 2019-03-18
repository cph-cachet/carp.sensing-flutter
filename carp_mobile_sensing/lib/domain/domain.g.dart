// GENERATED CODE - DO NOT MODIFY BY HAND

part of domain;

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Study _$StudyFromJson(Map<String, dynamic> json) {
  return Study(json['id'] as String, json['user_id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      samplingStrategy: json['sampling_strategy'] as String,
      dataEndPoint: json['data_end_point'] == null
          ? null
          : DataEndPoint.fromJson(
              json['data_end_point'] as Map<String, dynamic>),
      dataFormat: json['data_format'] as String)
    ..c__ = json['c__'] as String
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

  writeNotNull('c__', instance.c__);
  writeNotNull('id', instance.id);
  writeNotNull('user_id', instance.userId);
  writeNotNull('name', instance.name);
  writeNotNull('description', instance.description);
  writeNotNull('sampling_strategy', instance.samplingStrategy);
  writeNotNull('data_end_point', instance.dataEndPoint);
  writeNotNull('data_format', instance.dataFormat);
  writeNotNull('tasks', instance.tasks);
  return val;
}

DataEndPoint _$DataEndPointFromJson(Map<String, dynamic> json) {
  return DataEndPoint(json['type'] as String)..c__ = json['c__'] as String;
}

Map<String, dynamic> _$DataEndPointToJson(DataEndPoint instance) {
  var val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('c__', instance.c__);
  writeNotNull('type', instance.type);
  return val;
}

FileDataEndPoint _$FileDataEndPointFromJson(Map<String, dynamic> json) {
  return FileDataEndPoint(
      type: json['type'] as String,
      bufferSize: json['buffer_size'] as int,
      zip: json['zip'] as bool,
      encrypt: json['encrypt'] as bool,
      publicKey: json['public_key'] as String)
    ..c__ = json['c__'] as String;
}

Map<String, dynamic> _$FileDataEndPointToJson(FileDataEndPoint instance) {
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
  return val;
}

Task _$TaskFromJson(Map<String, dynamic> json) {
  return Task(json['name'] as String)
    ..c__ = json['c__'] as String
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

  writeNotNull('c__', instance.c__);
  writeNotNull('name', instance.name);
  writeNotNull('measures', instance.measures);
  return val;
}

ParallelTask _$ParallelTaskFromJson(Map<String, dynamic> json) {
  return ParallelTask(json['name'] as String)
    ..c__ = json['c__'] as String
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

  writeNotNull('c__', instance.c__);
  writeNotNull('name', instance.name);
  writeNotNull('measures', instance.measures);
  return val;
}

SequentialTask _$SequentialTaskFromJson(Map<String, dynamic> json) {
  return SequentialTask(json['name'] as String)
    ..c__ = json['c__'] as String
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

  writeNotNull('c__', instance.c__);
  writeNotNull('name', instance.name);
  writeNotNull('measures', instance.measures);
  return val;
}

DataPoint _$DataPointFromJson(Map<String, dynamic> json) {
  return DataPoint(
      json['header'] == null
          ? null
          : DataPointHeader.fromJson(json['header'] as Map<String, dynamic>),
      json['body'] == null
          ? null
          : Datum.fromJson(json['body'] as Map<String, dynamic>));
}

Map<String, dynamic> _$DataPointToJson(DataPoint instance) {
  var val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('header', instance.header);
  writeNotNull('body', instance.body);
  return val;
}

DataPointHeader _$DataPointHeaderFromJson(Map<String, dynamic> json) {
  return DataPointHeader(json['study_id'] as String, json['user_id'] as String,
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
        : DataFormat.fromJson(json['data_format'] as Map<String, dynamic>);
}

Map<String, dynamic> _$DataPointHeaderToJson(DataPointHeader instance) {
  var val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('study_id', instance.studyId);
  writeNotNull('user_id', instance.userId);
  writeNotNull('upload_time', instance.uploadTime?.toIso8601String());
  writeNotNull('start_time', instance.startTime?.toIso8601String());
  writeNotNull('end_time', instance.endTime?.toIso8601String());
  writeNotNull('data_format', instance.dataFormat);
  return val;
}

Datum _$DatumFromJson(Map<String, dynamic> json) {
  return Datum();
}

Map<String, dynamic> _$DatumToJson(Datum instance) => <String, dynamic>{};

CARPDatum _$CARPDatumFromJson(Map<String, dynamic> json) {
  return CARPDatum()
    ..id = json['id'] as String
    ..timestamp = json['timestamp'] == null
        ? null
        : DateTime.parse(json['timestamp'] as String);
}

Map<String, dynamic> _$CARPDatumToJson(CARPDatum instance) {
  var val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  writeNotNull('timestamp', instance.timestamp?.toIso8601String());
  return val;
}

StringDatum _$StringDatumFromJson(Map<String, dynamic> json) {
  return StringDatum(str: json['str'] as String)
    ..id = json['id'] as String
    ..timestamp = json['timestamp'] == null
        ? null
        : DateTime.parse(json['timestamp'] as String);
}

Map<String, dynamic> _$StringDatumToJson(StringDatum instance) {
  var val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  writeNotNull('timestamp', instance.timestamp?.toIso8601String());
  writeNotNull('str', instance.str);
  return val;
}

MapDatum _$MapDatumFromJson(Map<String, dynamic> json) {
  return MapDatum(
      map: (json['map'] as Map<String, dynamic>)
          ?.map((k, e) => MapEntry(k, e as String)))
    ..id = json['id'] as String
    ..timestamp = json['timestamp'] == null
        ? null
        : DateTime.parse(json['timestamp'] as String);
}

Map<String, dynamic> _$MapDatumToJson(MapDatum instance) {
  var val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  writeNotNull('timestamp', instance.timestamp?.toIso8601String());
  writeNotNull('map', instance.map);
  return val;
}

ErrorDatum _$ErrorDatumFromJson(Map<String, dynamic> json) {
  return ErrorDatum(message: json['message'] as String)
    ..id = json['id'] as String
    ..timestamp = json['timestamp'] == null
        ? null
        : DateTime.parse(json['timestamp'] as String);
}

Map<String, dynamic> _$ErrorDatumToJson(ErrorDatum instance) {
  var val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  writeNotNull('timestamp', instance.timestamp?.toIso8601String());
  writeNotNull('message', instance.message);
  return val;
}

MultiDatum _$MultiDatumFromJson(Map<String, dynamic> json) {
  return MultiDatum()
    ..id = json['id'] as String
    ..timestamp = json['timestamp'] == null
        ? null
        : DateTime.parse(json['timestamp'] as String)
    ..data = (json['data'] as List)
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

  writeNotNull('id', instance.id);
  writeNotNull('timestamp', instance.timestamp?.toIso8601String());
  writeNotNull('data', instance.data);
  return val;
}

DataFormat _$DataFormatFromJson(Map<String, dynamic> json) {
  return DataFormat(json['namepace'] as String, json['name'] as String);
}

Map<String, dynamic> _$DataFormatToJson(DataFormat instance) {
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

Measure _$MeasureFromJson(Map<String, dynamic> json) {
  return Measure(
      json['type'] == null
          ? null
          : MeasureType.fromJson(json['type'] as Map<String, dynamic>),
      name: json['name'] as String,
      enabled: json['enabled'] as bool)
    ..c__ = json['c__'] as String
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

  writeNotNull('c__', instance.c__);
  writeNotNull('type', instance.type);
  writeNotNull('name', instance.name);
  writeNotNull('enabled', instance.enabled);
  writeNotNull('configuration', instance.configuration);
  return val;
}

PeriodicMeasure _$PeriodicMeasureFromJson(Map<String, dynamic> json) {
  return PeriodicMeasure(
      json['type'] == null
          ? null
          : MeasureType.fromJson(json['type'] as Map<String, dynamic>),
      name: json['name'] as String,
      enabled: json['enabled'] as bool,
      frequency: json['frequency'] as int,
      duration: json['duration'] as int)
    ..c__ = json['c__'] as String
    ..configuration = (json['configuration'] as Map<String, dynamic>)
        ?.map((k, e) => MapEntry(k, e as String));
}

Map<String, dynamic> _$PeriodicMeasureToJson(PeriodicMeasure instance) {
  var val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('c__', instance.c__);
  writeNotNull('type', instance.type);
  writeNotNull('name', instance.name);
  writeNotNull('enabled', instance.enabled);
  writeNotNull('configuration', instance.configuration);
  writeNotNull('frequency', instance.frequency);
  writeNotNull('duration', instance.duration);
  return val;
}

MeasureType _$MeasureTypeFromJson(Map<String, dynamic> json) {
  return MeasureType(json['namespace'] as String, json['name'] as String)
    ..c__ = json['c__'] as String;
}

Map<String, dynamic> _$MeasureTypeToJson(MeasureType instance) {
  var val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('c__', instance.c__);
  writeNotNull('namespace', instance.namespace);
  writeNotNull('name', instance.name);
  return val;
}
