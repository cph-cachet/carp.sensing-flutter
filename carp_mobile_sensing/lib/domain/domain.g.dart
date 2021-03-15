// GENERATED CODE - DO NOT MODIFY BY HAND

part of domain;

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CAMSStudyProtocol _$CAMSStudyProtocolFromJson(Map<String, dynamic> json) {
  return CAMSStudyProtocol(
    studyId: json['studyId'] as String,
    owner: json['owner'],
    title: json['title'] as String,
    purpose: json['purpose'] as String,
    dataEndPoint: json['dataEndPoint'] == null
        ? null
        : DataEndPoint.fromJson(json['dataEndPoint'] as Map<String, dynamic>),
    dataFormat: json['dataFormat'] as String,
  );
}

Map<String, dynamic> _$CAMSStudyProtocolToJson(CAMSStudyProtocol instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('studyId', instance.studyId);
  writeNotNull('title', instance.title);
  writeNotNull('purpose', instance.purpose);
  writeNotNull('owner', instance.owner);
  writeNotNull('dataEndPoint', instance.dataEndPoint);
  writeNotNull('dataFormat', instance.dataFormat);
  return val;
}

DataEndPoint _$DataEndPointFromJson(Map<String, dynamic> json) {
  return DataEndPoint(
    type: json['type'] as String,
    publicKey: json['publicKey'] as String,
  );
}

Map<String, dynamic> _$DataEndPointToJson(DataEndPoint instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('type', instance.type);
  writeNotNull('publicKey', instance.publicKey);
  return val;
}

CAMSMeasure _$CAMSMeasureFromJson(Map<String, dynamic> json) {
  return CAMSMeasure(
    name: json['name'] as String,
    description: json['description'] as String,
    enabled: json['enabled'] as bool,
  )..configuration = (json['configuration'] as Map<String, dynamic>)?.map(
      (k, e) => MapEntry(k, e as String),
    );
}

Map<String, dynamic> _$CAMSMeasureToJson(CAMSMeasure instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('name', instance.name);
  writeNotNull('description', instance.description);
  writeNotNull('enabled', instance.enabled);
  writeNotNull('configuration', instance.configuration);
  return val;
}

PeriodicMeasure _$PeriodicMeasureFromJson(Map<String, dynamic> json) {
  return PeriodicMeasure(
    name: json['name'] as String,
    description: json['description'] as String,
    enabled: json['enabled'] as bool,
    frequency: json['frequency'] == null
        ? null
        : Duration(microseconds: json['frequency'] as int),
    duration: json['duration'] == null
        ? null
        : Duration(microseconds: json['duration'] as int),
  )..configuration = (json['configuration'] as Map<String, dynamic>)?.map(
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

  writeNotNull('name', instance.name);
  writeNotNull('description', instance.description);
  writeNotNull('enabled', instance.enabled);
  writeNotNull('configuration', instance.configuration);
  writeNotNull('frequency', instance.frequency?.inMicroseconds);
  writeNotNull('duration', instance.duration?.inMicroseconds);
  return val;
}

MarkedMeasure _$MarkedMeasureFromJson(Map<String, dynamic> json) {
  return MarkedMeasure(
    name: json['name'] as String,
    description: json['description'] as String,
    enabled: json['enabled'] as bool,
    history: json['history'] == null
        ? null
        : Duration(microseconds: json['history'] as int),
  )..configuration = (json['configuration'] as Map<String, dynamic>)?.map(
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

  writeNotNull('name', instance.name);
  writeNotNull('description', instance.description);
  writeNotNull('enabled', instance.enabled);
  writeNotNull('configuration', instance.configuration);
  writeNotNull('history', instance.history?.inMicroseconds);
  return val;
}

ConnectableDeviceDescriptor _$ConnectableDeviceDescriptorFromJson(
    Map<String, dynamic> json) {
  return ConnectableDeviceDescriptor(
    deviceType: json['deviceType'] as String,
    name: json['name'] as String,
  )..collectingMeasureTypes = (json['collectingMeasureTypes'] as List)
      ?.map((e) => e as String)
      ?.toList();
}

Map<String, dynamic> _$ConnectableDeviceDescriptorToJson(
    ConnectableDeviceDescriptor instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('deviceType', instance.deviceType);
  writeNotNull('name', instance.name);
  writeNotNull('collectingMeasureTypes', instance.collectingMeasureTypes);
  return val;
}

AppTask _$AppTaskFromJson(Map<String, dynamic> json) {
  return AppTask(
    type: json['type'] as String,
    title: json['title'] as String,
    description: json['description'] as String,
    instructions: json['instructions'] as String,
    minutesToComplete: json['minutes_to_complete'] as int,
    expire: json['expire'] == null
        ? null
        : Duration(microseconds: json['expire'] as int),
    notification: json['notification'] as bool,
  );
}

Map<String, dynamic> _$AppTaskToJson(AppTask instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('type', instance.type);
  writeNotNull('title', instance.title);
  writeNotNull('description', instance.description);
  writeNotNull('instructions', instance.instructions);
  writeNotNull('minutes_to_complete', instance.minutesToComplete);
  writeNotNull('expire', instance.expire?.inMicroseconds);
  writeNotNull('notification', instance.notification);
  return val;
}

CAMSTrigger _$CAMSTriggerFromJson(Map<String, dynamic> json) {
  return CAMSTrigger(
    triggerId: json['triggerId'] as String,
  );
}

Map<String, dynamic> _$CAMSTriggerToJson(CAMSTrigger instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('triggerId', instance.triggerId);
  return val;
}

ImmediateTrigger _$ImmediateTriggerFromJson(Map<String, dynamic> json) {
  return ImmediateTrigger(
    triggerId: json['triggerId'] as String,
  );
}

Map<String, dynamic> _$ImmediateTriggerToJson(ImmediateTrigger instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('triggerId', instance.triggerId);
  return val;
}

PassiveTrigger _$PassiveTriggerFromJson(Map<String, dynamic> json) {
  return PassiveTrigger(
    triggerId: json['triggerId'] as String,
  );
}

Map<String, dynamic> _$PassiveTriggerToJson(PassiveTrigger instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('triggerId', instance.triggerId);
  return val;
}

DelayedTrigger _$DelayedTriggerFromJson(Map<String, dynamic> json) {
  return DelayedTrigger(
    triggerId: json['triggerId'] as String,
    delay: json['delay'] == null
        ? null
        : Duration(microseconds: json['delay'] as int),
  );
}

Map<String, dynamic> _$DelayedTriggerToJson(DelayedTrigger instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('triggerId', instance.triggerId);
  writeNotNull('delay', instance.delay?.inMicroseconds);
  return val;
}

PeriodicTrigger _$PeriodicTriggerFromJson(Map<String, dynamic> json) {
  return PeriodicTrigger(
    triggerId: json['triggerId'] as String,
    period: json['period'] == null
        ? null
        : Duration(microseconds: json['period'] as int),
    duration: json['duration'] == null
        ? null
        : Duration(microseconds: json['duration'] as int),
  );
}

Map<String, dynamic> _$PeriodicTriggerToJson(PeriodicTrigger instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('triggerId', instance.triggerId);
  writeNotNull('period', instance.period?.inMicroseconds);
  writeNotNull('duration', instance.duration?.inMicroseconds);
  return val;
}

DateTimeTrigger _$DateTimeTriggerFromJson(Map<String, dynamic> json) {
  return DateTimeTrigger(
    triggerId: json['triggerId'] as String,
    schedule: json['schedule'] == null
        ? null
        : DateTime.parse(json['schedule'] as String),
    duration: json['duration'] == null
        ? null
        : Duration(microseconds: json['duration'] as int),
  );
}

Map<String, dynamic> _$DateTimeTriggerToJson(DateTimeTrigger instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('triggerId', instance.triggerId);
  writeNotNull('schedule', instance.schedule?.toIso8601String());
  writeNotNull('duration', instance.duration?.inMicroseconds);
  return val;
}

Time _$TimeFromJson(Map<String, dynamic> json) {
  return Time(
    hour: json['hour'] as int,
    minute: json['minute'] as int,
    second: json['second'] as int,
  );
}

Map<String, dynamic> _$TimeToJson(Time instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('hour', instance.hour);
  writeNotNull('minute', instance.minute);
  writeNotNull('second', instance.second);
  return val;
}

RecurrentScheduledTrigger _$RecurrentScheduledTriggerFromJson(
    Map<String, dynamic> json) {
  return RecurrentScheduledTrigger(
    triggerId: json['triggerId'] as String,
    type: _$enumDecodeNullable(_$RecurrentTypeEnumMap, json['type']),
    time: json['time'] == null
        ? null
        : Time.fromJson(json['time'] as Map<String, dynamic>),
    end: json['end'] == null ? null : DateTime.parse(json['end'] as String),
    separationCount: json['separationCount'] as int,
    maxNumberOfSampling: json['maxNumberOfSampling'] as int,
    dayOfWeek: json['dayOfWeek'] as int,
    weekOfMonth: json['weekOfMonth'] as int,
    dayOfMonth: json['dayOfMonth'] as int,
    remember: json['remember'] as bool,
    duration: json['duration'] == null
        ? null
        : Duration(microseconds: json['duration'] as int),
  )..period = json['period'] == null
      ? null
      : Duration(microseconds: json['period'] as int);
}

Map<String, dynamic> _$RecurrentScheduledTriggerToJson(
    RecurrentScheduledTrigger instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('triggerId', instance.triggerId);
  writeNotNull('duration', instance.duration?.inMicroseconds);
  writeNotNull('type', _$RecurrentTypeEnumMap[instance.type]);
  writeNotNull('time', instance.time);
  writeNotNull('end', instance.end?.toIso8601String());
  writeNotNull('separationCount', instance.separationCount);
  writeNotNull('maxNumberOfSampling', instance.maxNumberOfSampling);
  writeNotNull('dayOfWeek', instance.dayOfWeek);
  writeNotNull('weekOfMonth', instance.weekOfMonth);
  writeNotNull('dayOfMonth', instance.dayOfMonth);
  writeNotNull('remember', instance.remember);
  writeNotNull('period', instance.period?.inMicroseconds);
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
  RecurrentType.monthly: 'monthly',
};

CronScheduledTrigger _$CronScheduledTriggerFromJson(Map<String, dynamic> json) {
  return CronScheduledTrigger(
    triggerId: json['triggerId'] as String,
    duration: json['duration'] == null
        ? null
        : Duration(microseconds: json['duration'] as int),
  )..cronExpression = json['cronExpression'] as String;
}

Map<String, dynamic> _$CronScheduledTriggerToJson(
    CronScheduledTrigger instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('triggerId', instance.triggerId);
  writeNotNull('cronExpression', instance.cronExpression);
  writeNotNull('duration', instance.duration?.inMicroseconds);
  return val;
}

SamplingEventTrigger _$SamplingEventTriggerFromJson(Map<String, dynamic> json) {
  return SamplingEventTrigger(
    triggerId: json['triggerId'] as String,
    measureType: json['measureType'] as String,
    resumeCondition: json['resumeCondition'] == null
        ? null
        : ConditionalEvent.fromJson(
            json['resumeCondition'] as Map<String, dynamic>),
    pauseCondition: json['pauseCondition'] == null
        ? null
        : ConditionalEvent.fromJson(
            json['pauseCondition'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$SamplingEventTriggerToJson(
    SamplingEventTrigger instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('triggerId', instance.triggerId);
  writeNotNull('measureType', instance.measureType);
  writeNotNull('resumeCondition', instance.resumeCondition);
  writeNotNull('pauseCondition', instance.pauseCondition);
  return val;
}

ConditionalEvent _$ConditionalEventFromJson(Map<String, dynamic> json) {
  return ConditionalEvent(
    json['condition'] as Map<String, dynamic>,
  );
}

Map<String, dynamic> _$ConditionalEventToJson(ConditionalEvent instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('condition', instance.condition);
  return val;
}

ConditionalSamplingEventTrigger _$ConditionalSamplingEventTriggerFromJson(
    Map<String, dynamic> json) {
  return ConditionalSamplingEventTrigger(
    triggerId: json['triggerId'] as String,
    measureType: json['measureType'] as String,
  );
}

Map<String, dynamic> _$ConditionalSamplingEventTriggerToJson(
    ConditionalSamplingEventTrigger instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('triggerId', instance.triggerId);
  writeNotNull('measureType', instance.measureType);
  return val;
}

Datum _$DatumFromJson(Map<String, dynamic> json) {
  return Datum()..id = json['id'] as String;
}

Map<String, dynamic> _$DatumToJson(Datum instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  return val;
}

StringDatum _$StringDatumFromJson(Map<String, dynamic> json) {
  return StringDatum(
    json['str'] as String,
  )..id = json['id'] as String;
}

Map<String, dynamic> _$StringDatumToJson(StringDatum instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  writeNotNull('str', instance.str);
  return val;
}

MapDatum _$MapDatumFromJson(Map<String, dynamic> json) {
  return MapDatum(
    (json['map'] as Map<String, dynamic>)?.map(
      (k, e) => MapEntry(k, e as String),
    ),
  )..id = json['id'] as String;
}

Map<String, dynamic> _$MapDatumToJson(MapDatum instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  writeNotNull('map', instance.map);
  return val;
}

ErrorDatum _$ErrorDatumFromJson(Map<String, dynamic> json) {
  return ErrorDatum(
    json['message'] as String,
  )..id = json['id'] as String;
}

Map<String, dynamic> _$ErrorDatumToJson(ErrorDatum instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  writeNotNull('message', instance.message);
  return val;
}

FileDatum _$FileDatumFromJson(Map<String, dynamic> json) {
  return FileDatum(
    filename: json['filename'] as String,
    upload: json['upload'] as bool,
  )
    ..id = json['id'] as String
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
  writeNotNull('filename', instance.filename);
  writeNotNull('upload', instance.upload);
  writeNotNull('metadata', instance.metadata);
  return val;
}

MultiDatum _$MultiDatumFromJson(Map<String, dynamic> json) {
  return MultiDatum()
    ..id = json['id'] as String
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
  writeNotNull('data', instance.data);
  return val;
}

AutomaticTask _$AutomaticTaskFromJson(Map<String, dynamic> json) {
  return AutomaticTask();
}

Map<String, dynamic> _$AutomaticTaskToJson(AutomaticTask instance) =>
    <String, dynamic>{};
