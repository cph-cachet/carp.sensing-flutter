// GENERATED CODE - DO NOT MODIFY BY HAND

part of domain;

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Study _$StudyFromJson(Map<String, dynamic> json) {
  return Study(
    json['id'] as String,
    json['user_id'] as String,
    deploymentId: json['deployment_id'] as String,
    name: json['name'] as String,
    description: json['description'] as String,
    samplingStrategy: json['sampling_strategy'] as String,
    dataEndPoint: json['data_end_point'] == null
        ? null
        : DataEndPoint.fromJson(json['data_end_point'] as Map<String, dynamic>),
    dataFormat: json['data_format'] as String,
  )
    ..c__ = json['c__'] as String
    ..triggers = (json['triggers'] as List)
        ?.map((e) =>
            e == null ? null : Trigger.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$StudyToJson(Study instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('c__', instance.c__);
  writeNotNull('id', instance.id);
  writeNotNull('deployment_id', instance.deploymentId);
  writeNotNull('name', instance.name);
  writeNotNull('description', instance.description);
  writeNotNull('user_id', instance.userId);
  writeNotNull('sampling_strategy', instance.samplingStrategy);
  writeNotNull('data_end_point', instance.dataEndPoint);
  writeNotNull('data_format', instance.dataFormat);
  writeNotNull('triggers', instance.triggers);
  return val;
}

DataEndPoint _$DataEndPointFromJson(Map<String, dynamic> json) {
  return DataEndPoint(
    json['type'] as String,
  )..c__ = json['c__'] as String;
}

Map<String, dynamic> _$DataEndPointToJson(DataEndPoint instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('c__', instance.c__);
  writeNotNull('type', instance.type);
  return val;
}

Task _$TaskFromJson(Map<String, dynamic> json) {
  return Task(
    name: json['name'] as String,
  )
    ..c__ = json['c__'] as String
    ..measures = (json['measures'] as List)
        ?.map((e) =>
            e == null ? null : Measure.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$TaskToJson(Task instance) {
  final val = <String, dynamic>{};

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

AutomaticTask _$AutomaticTaskFromJson(Map<String, dynamic> json) {
  return AutomaticTask(
    name: json['name'] as String,
  )
    ..c__ = json['c__'] as String
    ..measures = (json['measures'] as List)
        ?.map((e) =>
            e == null ? null : Measure.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$AutomaticTaskToJson(AutomaticTask instance) {
  final val = <String, dynamic>{};

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

AppTask _$AppTaskFromJson(Map<String, dynamic> json) {
  return AppTask(
    name: json['name'] as String,
    description: json['description'] as String,
    instructions: json['instructions'] as String,
    minutesToComplete: json['minutes_to_complete'] as int,
    notification: json['notification'] as bool,
  )
    ..c__ = json['c__'] as String
    ..measures = (json['measures'] as List)
        ?.map((e) =>
            e == null ? null : Measure.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$AppTaskToJson(AppTask instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('c__', instance.c__);
  writeNotNull('name', instance.name);
  writeNotNull('measures', instance.measures);
  writeNotNull('description', instance.description);
  writeNotNull('instructions', instance.instructions);
  writeNotNull('minutes_to_complete', instance.minutesToComplete);
  writeNotNull('notification', instance.notification);
  return val;
}

DataPoint _$DataPointFromJson(Map<String, dynamic> json) {
  return DataPoint(
    json['header'] == null
        ? null
        : DataPointHeader.fromJson(json['header'] as Map<String, dynamic>),
    json['body'] == null
        ? null
        : Datum.fromJson(json['body'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$DataPointToJson(DataPoint instance) {
  final val = <String, dynamic>{};

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
  return DataPointHeader(
    json['study_id'] as String,
    json['user_id'] as String,
    startTime: json['start_time'] == null
        ? null
        : DateTime.parse(json['start_time'] as String),
    endTime: json['end_time'] == null
        ? null
        : DateTime.parse(json['end_time'] as String),
  )
    ..uploadTime = json['upload_time'] == null
        ? null
        : DateTime.parse(json['upload_time'] as String)
    ..dataFormat = json['data_format'] == null
        ? null
        : DataFormat.fromJson(json['data_format'] as Map<String, dynamic>);
}

Map<String, dynamic> _$DataPointHeaderToJson(DataPointHeader instance) {
  final val = <String, dynamic>{};

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
  final val = <String, dynamic>{};

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
  return StringDatum(
    json['str'] as String,
  )
    ..id = json['id'] as String
    ..timestamp = json['timestamp'] == null
        ? null
        : DateTime.parse(json['timestamp'] as String);
}

Map<String, dynamic> _$StringDatumToJson(StringDatum instance) {
  final val = <String, dynamic>{};

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
    (json['map'] as Map<String, dynamic>)?.map(
      (k, e) => MapEntry(k, e as String),
    ),
  )
    ..id = json['id'] as String
    ..timestamp = json['timestamp'] == null
        ? null
        : DateTime.parse(json['timestamp'] as String);
}

Map<String, dynamic> _$MapDatumToJson(MapDatum instance) {
  final val = <String, dynamic>{};

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
  return ErrorDatum(
    json['message'] as String,
  )
    ..id = json['id'] as String
    ..timestamp = json['timestamp'] == null
        ? null
        : DateTime.parse(json['timestamp'] as String);
}

Map<String, dynamic> _$ErrorDatumToJson(ErrorDatum instance) {
  final val = <String, dynamic>{};

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

FileDatum _$FileDatumFromJson(Map<String, dynamic> json) {
  return FileDatum(
    json['filename'] as String,
    json['upload'] as bool,
  )
    ..id = json['id'] as String
    ..timestamp = json['timestamp'] == null
        ? null
        : DateTime.parse(json['timestamp'] as String)
    ..metadata = (json['metadata'] as Map<String, dynamic>)?.map(
      (k, e) => MapEntry(k, e as String),
    );
}

Map<String, dynamic> _$FileDatumToJson(FileDatum instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  writeNotNull('timestamp', instance.timestamp?.toIso8601String());
  writeNotNull('filename', instance.filename);
  writeNotNull('upload', instance.upload);
  writeNotNull('metadata', instance.metadata);
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
  final val = <String, dynamic>{};

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
  return DataFormat(
    json['namepace'] as String,
    json['name'] as String,
  );
}

Map<String, dynamic> _$DataFormatToJson(DataFormat instance) {
  final val = <String, dynamic>{};

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
    enabled: json['enabled'] as bool,
  )
    ..c__ = json['c__'] as String
    ..configuration = (json['configuration'] as Map<String, dynamic>)?.map(
      (k, e) => MapEntry(k, e as String),
    );
}

Map<String, dynamic> _$MeasureToJson(Measure instance) {
  final val = <String, dynamic>{};

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
    frequency: json['frequency'] == null
        ? null
        : Duration(microseconds: json['frequency'] as int),
    duration: json['duration'] == null
        ? null
        : Duration(microseconds: json['duration'] as int),
  )
    ..c__ = json['c__'] as String
    ..configuration = (json['configuration'] as Map<String, dynamic>)?.map(
      (k, e) => MapEntry(k, e as String),
    );
}

Map<String, dynamic> _$PeriodicMeasureToJson(PeriodicMeasure instance) {
  final val = <String, dynamic>{};

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
  writeNotNull('frequency', instance.frequency?.inMicroseconds);
  writeNotNull('duration', instance.duration?.inMicroseconds);
  return val;
}

MarkedMeasure _$MarkedMeasureFromJson(Map<String, dynamic> json) {
  return MarkedMeasure(
    json['type'] == null
        ? null
        : MeasureType.fromJson(json['type'] as Map<String, dynamic>),
    name: json['name'] as String,
    enabled: json['enabled'] as bool,
    history: json['history'] == null
        ? null
        : Duration(microseconds: json['history'] as int),
  )
    ..c__ = json['c__'] as String
    ..configuration = (json['configuration'] as Map<String, dynamic>)?.map(
      (k, e) => MapEntry(k, e as String),
    );
}

Map<String, dynamic> _$MarkedMeasureToJson(MarkedMeasure instance) {
  final val = <String, dynamic>{};

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
  writeNotNull('history', instance.history?.inMicroseconds);
  return val;
}

MeasureType _$MeasureTypeFromJson(Map<String, dynamic> json) {
  return MeasureType(
    json['namespace'] as String,
    json['name'] as String,
  )..c__ = json['c__'] as String;
}

Map<String, dynamic> _$MeasureTypeToJson(MeasureType instance) {
  final val = <String, dynamic>{};

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

Trigger _$TriggerFromJson(Map<String, dynamic> json) {
  return Trigger(
    triggerId: json['trigger_id'] as String,
  )
    ..c__ = json['c__'] as String
    ..tasks = (json['tasks'] as List)
        ?.map(
            (e) => e == null ? null : Task.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$TriggerToJson(Trigger instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('c__', instance.c__);
  writeNotNull('trigger_id', instance.triggerId);
  writeNotNull('tasks', instance.tasks);
  return val;
}

ImmediateTrigger _$ImmediateTriggerFromJson(Map<String, dynamic> json) {
  return ImmediateTrigger(
    json['trigger_id'] as String,
  )
    ..c__ = json['c__'] as String
    ..tasks = (json['tasks'] as List)
        ?.map(
            (e) => e == null ? null : Task.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$ImmediateTriggerToJson(ImmediateTrigger instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('c__', instance.c__);
  writeNotNull('trigger_id', instance.triggerId);
  writeNotNull('tasks', instance.tasks);
  return val;
}

ManualTrigger _$ManualTriggerFromJson(Map<String, dynamic> json) {
  return ManualTrigger(
    triggerId: json['trigger_id'] as String,
  )
    ..c__ = json['c__'] as String
    ..tasks = (json['tasks'] as List)
        ?.map(
            (e) => e == null ? null : Task.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$ManualTriggerToJson(ManualTrigger instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('c__', instance.c__);
  writeNotNull('trigger_id', instance.triggerId);
  writeNotNull('tasks', instance.tasks);
  return val;
}

DelayedTrigger _$DelayedTriggerFromJson(Map<String, dynamic> json) {
  return DelayedTrigger(
    triggerId: json['trigger_id'] as String,
    delay: json['delay'] == null
        ? null
        : Duration(microseconds: json['delay'] as int),
  )
    ..c__ = json['c__'] as String
    ..tasks = (json['tasks'] as List)
        ?.map(
            (e) => e == null ? null : Task.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$DelayedTriggerToJson(DelayedTrigger instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('c__', instance.c__);
  writeNotNull('trigger_id', instance.triggerId);
  writeNotNull('tasks', instance.tasks);
  writeNotNull('delay', instance.delay?.inMicroseconds);
  return val;
}

PeriodicTrigger _$PeriodicTriggerFromJson(Map<String, dynamic> json) {
  return PeriodicTrigger(
    triggerId: json['trigger_id'] as String,
    period: json['period'] == null
        ? null
        : Duration(microseconds: json['period'] as int),
    duration: json['duration'] == null
        ? null
        : Duration(microseconds: json['duration'] as int),
  )
    ..c__ = json['c__'] as String
    ..tasks = (json['tasks'] as List)
        ?.map(
            (e) => e == null ? null : Task.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$PeriodicTriggerToJson(PeriodicTrigger instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('c__', instance.c__);
  writeNotNull('trigger_id', instance.triggerId);
  writeNotNull('tasks', instance.tasks);
  writeNotNull('period', instance.period?.inMicroseconds);
  writeNotNull('duration', instance.duration?.inMicroseconds);
  return val;
}

ScheduledTrigger _$ScheduledTriggerFromJson(Map<String, dynamic> json) {
  return ScheduledTrigger(
    triggerId: json['trigger_id'] as String,
    schedule: json['schedule'] == null
        ? null
        : DateTime.parse(json['schedule'] as String),
    duration: json['duration'] == null
        ? null
        : Duration(microseconds: json['duration'] as int),
  )
    ..c__ = json['c__'] as String
    ..tasks = (json['tasks'] as List)
        ?.map(
            (e) => e == null ? null : Task.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$ScheduledTriggerToJson(ScheduledTrigger instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('c__', instance.c__);
  writeNotNull('trigger_id', instance.triggerId);
  writeNotNull('tasks', instance.tasks);
  writeNotNull('schedule', instance.schedule?.toIso8601String());
  writeNotNull('duration', instance.duration?.inMicroseconds);
  return val;
}

Time _$TimeFromJson(Map<String, dynamic> json) {
  return Time(
    hour: json['hour'] as int,
    minute: json['minute'] as int,
    second: json['second'] as int,
  )..c__ = json['c__'] as String;
}

Map<String, dynamic> _$TimeToJson(Time instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('c__', instance.c__);
  writeNotNull('hour', instance.hour);
  writeNotNull('minute', instance.minute);
  writeNotNull('second', instance.second);
  return val;
}

RecurrentScheduledTrigger _$RecurrentScheduledTriggerFromJson(
    Map<String, dynamic> json) {
  return RecurrentScheduledTrigger(
    triggerId: json['trigger_id'] as String,
    type: _$enumDecodeNullable(_$RecurrentTypeEnumMap, json['type']),
    time: json['time'] == null
        ? null
        : Time.fromJson(json['time'] as Map<String, dynamic>),
    end: json['end'] == null ? null : DateTime.parse(json['end'] as String),
    separationCount: json['separation_count'] as int,
    maxNumberOfSampling: json['max_number_of_sampling'] as int,
    dayOfWeek: json['day_of_week'] as int,
    duration: json['duration'] == null
        ? null
        : Duration(microseconds: json['duration'] as int),
  )
    ..c__ = json['c__'] as String
    ..tasks = (json['tasks'] as List)
        ?.map(
            (e) => e == null ? null : Task.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$RecurrentScheduledTriggerToJson(
    RecurrentScheduledTrigger instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('c__', instance.c__);
  writeNotNull('trigger_id', instance.triggerId);
  writeNotNull('tasks', instance.tasks);
  writeNotNull('duration', instance.duration?.inMicroseconds);
  writeNotNull('type', _$RecurrentTypeEnumMap[instance.type]);
  writeNotNull('time', instance.time);
  writeNotNull('end', instance.end?.toIso8601String());
  writeNotNull('separation_count', instance.separationCount);
  writeNotNull('max_number_of_sampling', instance.maxNumberOfSampling);
  writeNotNull('day_of_week', instance.dayOfWeek);
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

const _$RecurrentTypeEnumMap = {
  RecurrentType.daily: 'daily',
  RecurrentType.weekly: 'weekly',
};

SamplingEventTrigger _$SamplingEventTriggerFromJson(Map<String, dynamic> json) {
  return SamplingEventTrigger(
    triggerId: json['trigger_id'] as String,
    measureType: json['measure_type'] == null
        ? null
        : MeasureType.fromJson(json['measure_type'] as Map<String, dynamic>),
    resumeCondition: json['resume_condition'] == null
        ? null
        : Datum.fromJson(json['resume_condition'] as Map<String, dynamic>),
    pauseCondition: json['pause_condition'] == null
        ? null
        : Datum.fromJson(json['pause_condition'] as Map<String, dynamic>),
  )
    ..c__ = json['c__'] as String
    ..tasks = (json['tasks'] as List)
        ?.map(
            (e) => e == null ? null : Task.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$SamplingEventTriggerToJson(
    SamplingEventTrigger instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('c__', instance.c__);
  writeNotNull('trigger_id', instance.triggerId);
  writeNotNull('tasks', instance.tasks);
  writeNotNull('measure_type', instance.measureType);
  writeNotNull('resume_condition', instance.resumeCondition);
  writeNotNull('pause_condition', instance.pauseCondition);
  return val;
}
