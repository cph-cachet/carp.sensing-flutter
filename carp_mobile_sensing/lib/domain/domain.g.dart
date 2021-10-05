// GENERATED CODE - DO NOT MODIFY BY HAND

part of domain;

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StudyDescription _$StudyDescriptionFromJson(Map<String, dynamic> json) {
  return StudyDescription(
    title: json['title'] as String,
    description: json['description'] as String,
    purpose: json['purpose'] as String,
    responsible: json['responsible'] == null
        ? null
        : StudyReponsible.fromJson(json['responsible'] as Map<String, dynamic>),
  )..$type = json[r'$type'] as String?;
}

Map<String, dynamic> _$StudyDescriptionToJson(StudyDescription instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull(r'$type', instance.$type);
  val['title'] = instance.title;
  val['description'] = instance.description;
  val['purpose'] = instance.purpose;
  writeNotNull('responsible', instance.responsible);
  return val;
}

StudyReponsible _$StudyReponsibleFromJson(Map<String, dynamic> json) {
  return StudyReponsible(
    id: json['id'] as String,
    name: json['name'] as String,
    title: json['title'] as String,
    email: json['email'] as String,
    affiliation: json['affiliation'] as String,
    address: json['address'] as String,
  )..$type = json[r'$type'] as String?;
}

Map<String, dynamic> _$StudyReponsibleToJson(StudyReponsible instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull(r'$type', instance.$type);
  val['id'] = instance.id;
  val['name'] = instance.name;
  val['title'] = instance.title;
  val['email'] = instance.email;
  val['address'] = instance.address;
  val['affiliation'] = instance.affiliation;
  return val;
}

FileDataEndPoint _$FileDataEndPointFromJson(Map<String, dynamic> json) {
  return FileDataEndPoint(
    type: json['type'] as String,
    dataFormat: json['dataFormat'] as String,
    bufferSize: json['bufferSize'] as int,
    zip: json['zip'] as bool,
    encrypt: json['encrypt'] as bool,
    publicKey: json['publicKey'] as String?,
  )..$type = json[r'$type'] as String?;
}

Map<String, dynamic> _$FileDataEndPointToJson(FileDataEndPoint instance) {
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
  return val;
}

CAMSMeasure _$CAMSMeasureFromJson(Map<String, dynamic> json) {
  return CAMSMeasure(
    type: json['type'] as String,
    name: json['name'] as String?,
    description: json['description'] as String?,
    enabled: json['enabled'] as bool,
  )
    ..$type = json[r'$type'] as String?
    ..configuration = Map<String, String>.from(json['configuration'] as Map);
}

Map<String, dynamic> _$CAMSMeasureToJson(CAMSMeasure instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull(r'$type', instance.$type);
  val['type'] = instance.type;
  writeNotNull('name', instance.name);
  writeNotNull('description', instance.description);
  val['enabled'] = instance.enabled;
  val['configuration'] = instance.configuration;
  return val;
}

PeriodicMeasure _$PeriodicMeasureFromJson(Map<String, dynamic> json) {
  return PeriodicMeasure(
    type: json['type'] as String,
    name: json['name'] as String?,
    description: json['description'] as String?,
    enabled: json['enabled'] as bool,
    frequency: Duration(microseconds: json['frequency'] as int),
    duration: Duration(microseconds: json['duration'] as int),
  )
    ..$type = json[r'$type'] as String?
    ..configuration = Map<String, String>.from(json['configuration'] as Map);
}

Map<String, dynamic> _$PeriodicMeasureToJson(PeriodicMeasure instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull(r'$type', instance.$type);
  val['type'] = instance.type;
  writeNotNull('name', instance.name);
  writeNotNull('description', instance.description);
  val['enabled'] = instance.enabled;
  val['configuration'] = instance.configuration;
  val['frequency'] = instance.frequency.inMicroseconds;
  val['duration'] = instance.duration.inMicroseconds;
  return val;
}

MarkedMeasure _$MarkedMeasureFromJson(Map<String, dynamic> json) {
  return MarkedMeasure(
    type: json['type'] as String,
    name: json['name'] as String?,
    description: json['description'] as String?,
    enabled: json['enabled'] as bool,
    history: Duration(microseconds: json['history'] as int),
  )
    ..$type = json[r'$type'] as String?
    ..configuration = Map<String, String>.from(json['configuration'] as Map);
}

Map<String, dynamic> _$MarkedMeasureToJson(MarkedMeasure instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull(r'$type', instance.$type);
  val['type'] = instance.type;
  writeNotNull('name', instance.name);
  writeNotNull('description', instance.description);
  val['enabled'] = instance.enabled;
  val['configuration'] = instance.configuration;
  val['history'] = instance.history.inMicroseconds;
  return val;
}

ConnectableDeviceDescriptor _$ConnectableDeviceDescriptorFromJson(
    Map<String, dynamic> json) {
  return ConnectableDeviceDescriptor(
    deviceType: json['deviceType'] as String,
    roleName: json['roleName'] as String,
    supportedDataTypes: (json['supportedDataTypes'] as List<dynamic>)
        .map((e) => e as String)
        .toList(),
    name: json['name'] as String?,
  )
    ..$type = json[r'$type'] as String?
    ..isMasterDevice = json['isMasterDevice'] as bool?
    ..samplingConfiguration =
        (json['samplingConfiguration'] as Map<String, dynamic>).map(
      (k, e) => MapEntry(
          k, SamplingConfiguration.fromJson(e as Map<String, dynamic>)),
    )
    ..collectingMeasureTypes = (json['collectingMeasureTypes'] as List<dynamic>)
        .map((e) => e as String)
        .toList();
}

Map<String, dynamic> _$ConnectableDeviceDescriptorToJson(
    ConnectableDeviceDescriptor instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull(r'$type', instance.$type);
  writeNotNull('isMasterDevice', instance.isMasterDevice);
  val['roleName'] = instance.roleName;
  writeNotNull('supportedDataTypes', instance.supportedDataTypes);
  val['samplingConfiguration'] = instance.samplingConfiguration;
  val['deviceType'] = instance.deviceType;
  writeNotNull('name', instance.name);
  val['collectingMeasureTypes'] = instance.collectingMeasureTypes;
  return val;
}

SmartphoneDeployment _$SmartphoneDeploymentFromJson(Map<String, dynamic> json) {
  return SmartphoneDeployment(
    studyDeploymentId: json['studyDeploymentId'] as String?,
    protocolDescription: json['protocolDescription'] == null
        ? null
        : StudyDescription.fromJson(
            json['protocolDescription'] as Map<String, dynamic>),
    deviceDescriptor: MasterDeviceDescriptor.fromJson(
        json['deviceDescriptor'] as Map<String, dynamic>),
    configuration: DeviceRegistration.fromJson(
        json['configuration'] as Map<String, dynamic>),
    connectedDevices: (json['connectedDevices'] as List<dynamic>)
        .map((e) => DeviceDescriptor.fromJson(e as Map<String, dynamic>))
        .toList(),
    connectedDeviceConfigurations:
        (json['connectedDeviceConfigurations'] as Map<String, dynamic>).map(
      (k, e) => MapEntry(
          k,
          e == null
              ? null
              : DeviceRegistration.fromJson(e as Map<String, dynamic>)),
    ),
    tasks: (json['tasks'] as List<dynamic>)
        .map((e) => TaskDescriptor.fromJson(e as Map<String, dynamic>))
        .toList(),
    triggers: (json['triggers'] as Map<String, dynamic>).map(
      (k, e) => MapEntry(k, Trigger.fromJson(e as Map<String, dynamic>)),
    ),
    triggeredTasks: (json['triggeredTasks'] as List<dynamic>)
        .map((e) => TriggeredTask.fromJson(e as Map<String, dynamic>))
        .toList(),
    dataEndPoint: json['dataEndPoint'] == null
        ? null
        : DataEndPoint.fromJson(json['dataEndPoint'] as Map<String, dynamic>),
  )
    ..lastUpdateDate = DateTime.parse(json['lastUpdateDate'] as String)
    ..userId = json['userId'] as String?
    ..samplingStrategy = _$enumDecodeNullable(
        _$SamplingSchemaTypeEnumMap, json['samplingStrategy']);
}

Map<String, dynamic> _$SmartphoneDeploymentToJson(
    SmartphoneDeployment instance) {
  final val = <String, dynamic>{
    'deviceDescriptor': instance.deviceDescriptor,
    'configuration': instance.configuration,
    'connectedDevices': instance.connectedDevices,
    'connectedDeviceConfigurations': instance.connectedDeviceConfigurations,
    'tasks': instance.tasks,
    'triggers': instance.triggers,
    'triggeredTasks': instance.triggeredTasks,
    'lastUpdateDate': instance.lastUpdateDate.toIso8601String(),
    'studyDeploymentId': instance.studyDeploymentId,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('userId', instance.userId);
  writeNotNull('protocolDescription', instance.protocolDescription);
  writeNotNull('samplingStrategy',
      _$SamplingSchemaTypeEnumMap[instance.samplingStrategy]);
  writeNotNull('dataEndPoint', instance.dataEndPoint);
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

K? _$enumDecodeNullable<K, V>(
  Map<K, V> enumValues,
  dynamic source, {
  K? unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<K, V>(enumValues, source, unknownValue: unknownValue);
}

const _$SamplingSchemaTypeEnumMap = {
  SamplingSchemaType.maximum: 'maximum',
  SamplingSchemaType.common: 'common',
  SamplingSchemaType.normal: 'normal',
  SamplingSchemaType.light: 'light',
  SamplingSchemaType.minimum: 'minimum',
  SamplingSchemaType.none: 'none',
  SamplingSchemaType.debug: 'debug',
};

AutomaticTask _$AutomaticTaskFromJson(Map<String, dynamic> json) {
  return AutomaticTask(
    name: json['name'] as String?,
  )
    ..$type = json[r'$type'] as String?
    ..measures = (json['measures'] as List<dynamic>)
        .map((e) => Measure.fromJson(e as Map<String, dynamic>))
        .toList();
}

Map<String, dynamic> _$AutomaticTaskToJson(AutomaticTask instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull(r'$type', instance.$type);
  val['name'] = instance.name;
  val['measures'] = instance.measures;
  return val;
}

AppTask _$AppTaskFromJson(Map<String, dynamic> json) {
  return AppTask(
    name: json['name'] as String?,
    type: json['type'] as String,
    title: json['title'] as String,
    description: json['description'] as String,
    instructions: json['instructions'] as String,
    minutesToComplete: json['minutes_to_complete'] as int?,
    expire: json['expire'] == null
        ? null
        : Duration(microseconds: json['expire'] as int),
    notification: json['notification'] as bool,
  )
    ..$type = json[r'$type'] as String?
    ..measures = (json['measures'] as List<dynamic>)
        .map((e) => Measure.fromJson(e as Map<String, dynamic>))
        .toList();
}

Map<String, dynamic> _$AppTaskToJson(AppTask instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull(r'$type', instance.$type);
  val['name'] = instance.name;
  val['measures'] = instance.measures;
  val['type'] = instance.type;
  val['title'] = instance.title;
  val['description'] = instance.description;
  val['instructions'] = instance.instructions;
  writeNotNull('minutes_to_complete', instance.minutesToComplete);
  writeNotNull('expire', instance.expire?.inMicroseconds);
  val['notification'] = instance.notification;
  return val;
}

ImmediateTrigger _$ImmediateTriggerFromJson(Map<String, dynamic> json) {
  return ImmediateTrigger()
    ..$type = json[r'$type'] as String?
    ..sourceDeviceRoleName = json['sourceDeviceRoleName'] as String?;
}

Map<String, dynamic> _$ImmediateTriggerToJson(ImmediateTrigger instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull(r'$type', instance.$type);
  writeNotNull('sourceDeviceRoleName', instance.sourceDeviceRoleName);
  return val;
}

PassiveTrigger _$PassiveTriggerFromJson(Map<String, dynamic> json) {
  return PassiveTrigger()
    ..$type = json[r'$type'] as String?
    ..sourceDeviceRoleName = json['sourceDeviceRoleName'] as String?;
}

Map<String, dynamic> _$PassiveTriggerToJson(PassiveTrigger instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull(r'$type', instance.$type);
  writeNotNull('sourceDeviceRoleName', instance.sourceDeviceRoleName);
  return val;
}

DelayedTrigger _$DelayedTriggerFromJson(Map<String, dynamic> json) {
  return DelayedTrigger(
    delay: Duration(microseconds: json['delay'] as int),
  )
    ..$type = json[r'$type'] as String?
    ..sourceDeviceRoleName = json['sourceDeviceRoleName'] as String?;
}

Map<String, dynamic> _$DelayedTriggerToJson(DelayedTrigger instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull(r'$type', instance.$type);
  writeNotNull('sourceDeviceRoleName', instance.sourceDeviceRoleName);
  val['delay'] = instance.delay.inMicroseconds;
  return val;
}

DeploymentDelayedTrigger _$DeploymentDelayedTriggerFromJson(
    Map<String, dynamic> json) {
  return DeploymentDelayedTrigger(
    delay: Duration(microseconds: json['delay'] as int),
  )
    ..$type = json[r'$type'] as String?
    ..sourceDeviceRoleName = json['sourceDeviceRoleName'] as String?;
}

Map<String, dynamic> _$DeploymentDelayedTriggerToJson(
    DeploymentDelayedTrigger instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull(r'$type', instance.$type);
  writeNotNull('sourceDeviceRoleName', instance.sourceDeviceRoleName);
  val['delay'] = instance.delay.inMicroseconds;
  return val;
}

PeriodicTrigger _$PeriodicTriggerFromJson(Map<String, dynamic> json) {
  return PeriodicTrigger(
    period: Duration(microseconds: json['period'] as int),
    duration: Duration(microseconds: json['duration'] as int),
  )
    ..$type = json[r'$type'] as String?
    ..sourceDeviceRoleName = json['sourceDeviceRoleName'] as String?;
}

Map<String, dynamic> _$PeriodicTriggerToJson(PeriodicTrigger instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull(r'$type', instance.$type);
  writeNotNull('sourceDeviceRoleName', instance.sourceDeviceRoleName);
  val['period'] = instance.period.inMicroseconds;
  val['duration'] = instance.duration.inMicroseconds;
  return val;
}

DateTimeTrigger _$DateTimeTriggerFromJson(Map<String, dynamic> json) {
  return DateTimeTrigger(
    schedule: DateTime.parse(json['schedule'] as String),
    duration: json['duration'] == null
        ? null
        : Duration(microseconds: json['duration'] as int),
  )
    ..$type = json[r'$type'] as String?
    ..sourceDeviceRoleName = json['sourceDeviceRoleName'] as String?;
}

Map<String, dynamic> _$DateTimeTriggerToJson(DateTimeTrigger instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull(r'$type', instance.$type);
  writeNotNull('sourceDeviceRoleName', instance.sourceDeviceRoleName);
  val['schedule'] = instance.schedule.toIso8601String();
  writeNotNull('duration', instance.duration?.inMicroseconds);
  return val;
}

Time _$TimeFromJson(Map<String, dynamic> json) {
  return Time(
    hour: json['hour'] as int,
    minute: json['minute'] as int,
    second: json['second'] as int,
  )..$type = json[r'$type'] as String?;
}

Map<String, dynamic> _$TimeToJson(Time instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull(r'$type', instance.$type);
  val['hour'] = instance.hour;
  val['minute'] = instance.minute;
  val['second'] = instance.second;
  return val;
}

RecurrentScheduledTrigger _$RecurrentScheduledTriggerFromJson(
    Map<String, dynamic> json) {
  return RecurrentScheduledTrigger(
    type: _$enumDecode(_$RecurrentTypeEnumMap, json['type']),
    time: Time.fromJson(json['time'] as Map<String, dynamic>),
    end: json['end'] == null ? null : DateTime.parse(json['end'] as String),
    separationCount: json['separationCount'] as int,
    maxNumberOfSampling: json['maxNumberOfSampling'] as int?,
    dayOfWeek: json['dayOfWeek'] as int?,
    weekOfMonth: json['weekOfMonth'] as int?,
    dayOfMonth: json['dayOfMonth'] as int?,
    remember: json['remember'] as bool,
    triggerId: json['triggerId'] as String?,
    duration: Duration(microseconds: json['duration'] as int),
  )
    ..$type = json[r'$type'] as String?
    ..sourceDeviceRoleName = json['sourceDeviceRoleName'] as String?
    ..period = Duration(microseconds: json['period'] as int);
}

Map<String, dynamic> _$RecurrentScheduledTriggerToJson(
    RecurrentScheduledTrigger instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull(r'$type', instance.$type);
  writeNotNull('sourceDeviceRoleName', instance.sourceDeviceRoleName);
  val['duration'] = instance.duration.inMicroseconds;
  val['type'] = _$RecurrentTypeEnumMap[instance.type];
  val['time'] = instance.time;
  writeNotNull('end', instance.end?.toIso8601String());
  val['separationCount'] = instance.separationCount;
  writeNotNull('maxNumberOfSampling', instance.maxNumberOfSampling);
  writeNotNull('dayOfWeek', instance.dayOfWeek);
  writeNotNull('weekOfMonth', instance.weekOfMonth);
  writeNotNull('dayOfMonth', instance.dayOfMonth);
  val['remember'] = instance.remember;
  writeNotNull('triggerId', instance.triggerId);
  val['period'] = instance.period.inMicroseconds;
  return val;
}

const _$RecurrentTypeEnumMap = {
  RecurrentType.daily: 'daily',
  RecurrentType.weekly: 'weekly',
  RecurrentType.monthly: 'monthly',
};

CronScheduledTrigger _$CronScheduledTriggerFromJson(Map<String, dynamic> json) {
  return CronScheduledTrigger(
    duration: Duration(microseconds: json['duration'] as int),
  )
    ..$type = json[r'$type'] as String?
    ..sourceDeviceRoleName = json['sourceDeviceRoleName'] as String?
    ..cronExpression = json['cronExpression'] as String;
}

Map<String, dynamic> _$CronScheduledTriggerToJson(
    CronScheduledTrigger instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull(r'$type', instance.$type);
  writeNotNull('sourceDeviceRoleName', instance.sourceDeviceRoleName);
  val['cronExpression'] = instance.cronExpression;
  val['duration'] = instance.duration.inMicroseconds;
  return val;
}

SamplingEventTrigger _$SamplingEventTriggerFromJson(Map<String, dynamic> json) {
  return SamplingEventTrigger(
    measureType: json['measureType'] as String,
    resumeCondition: json['resumeCondition'] == null
        ? null
        : ConditionalEvent.fromJson(
            json['resumeCondition'] as Map<String, dynamic>),
    pauseCondition: json['pauseCondition'] == null
        ? null
        : ConditionalEvent.fromJson(
            json['pauseCondition'] as Map<String, dynamic>),
  )
    ..$type = json[r'$type'] as String?
    ..sourceDeviceRoleName = json['sourceDeviceRoleName'] as String?;
}

Map<String, dynamic> _$SamplingEventTriggerToJson(
    SamplingEventTrigger instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull(r'$type', instance.$type);
  writeNotNull('sourceDeviceRoleName', instance.sourceDeviceRoleName);
  val['measureType'] = instance.measureType;
  writeNotNull('resumeCondition', instance.resumeCondition);
  writeNotNull('pauseCondition', instance.pauseCondition);
  return val;
}

ConditionalEvent _$ConditionalEventFromJson(Map<String, dynamic> json) {
  return ConditionalEvent(
    json['condition'] as Map<String, dynamic>,
  )..$type = json[r'$type'] as String?;
}

Map<String, dynamic> _$ConditionalEventToJson(ConditionalEvent instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull(r'$type', instance.$type);
  val['condition'] = instance.condition;
  return val;
}

ConditionalSamplingEventTrigger _$ConditionalSamplingEventTriggerFromJson(
    Map<String, dynamic> json) {
  return ConditionalSamplingEventTrigger(
    measureType: json['measureType'] as String,
  )
    ..$type = json[r'$type'] as String?
    ..sourceDeviceRoleName = json['sourceDeviceRoleName'] as String?;
}

Map<String, dynamic> _$ConditionalSamplingEventTriggerToJson(
    ConditionalSamplingEventTrigger instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull(r'$type', instance.$type);
  writeNotNull('sourceDeviceRoleName', instance.sourceDeviceRoleName);
  val['measureType'] = instance.measureType;
  return val;
}

RandomRecurrentTrigger _$RandomRecurrentTriggerFromJson(
    Map<String, dynamic> json) {
  return RandomRecurrentTrigger(
    minNumberOfTriggers: json['minNumberOfTriggers'] as int,
    maxNumberOfTriggers: json['maxNumberOfTriggers'] as int,
    startTime: Time.fromJson(json['startTime'] as Map<String, dynamic>),
    endTime: Time.fromJson(json['endTime'] as Map<String, dynamic>),
    duration: Duration(microseconds: json['duration'] as int),
  )
    ..$type = json[r'$type'] as String?
    ..sourceDeviceRoleName = json['sourceDeviceRoleName'] as String?;
}

Map<String, dynamic> _$RandomRecurrentTriggerToJson(
    RandomRecurrentTrigger instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull(r'$type', instance.$type);
  writeNotNull('sourceDeviceRoleName', instance.sourceDeviceRoleName);
  val['startTime'] = instance.startTime;
  val['endTime'] = instance.endTime;
  val['minNumberOfTriggers'] = instance.minNumberOfTriggers;
  val['maxNumberOfTriggers'] = instance.maxNumberOfTriggers;
  val['duration'] = instance.duration.inMicroseconds;
  return val;
}

Datum _$DatumFromJson(Map<String, dynamic> json) {
  return Datum()
    ..id = json['id'] as String?
    ..timestamp = json['timestamp'] == null
        ? null
        : DateTime.parse(json['timestamp'] as String);
}

Map<String, dynamic> _$DatumToJson(Datum instance) {
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
    ..id = json['id'] as String?
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
  val['str'] = instance.str;
  return val;
}

MapDatum _$MapDatumFromJson(Map<String, dynamic> json) {
  return MapDatum(
    Map<String, String>.from(json['map'] as Map),
  )
    ..id = json['id'] as String?
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
  val['map'] = instance.map;
  return val;
}

ErrorDatum _$ErrorDatumFromJson(Map<String, dynamic> json) {
  return ErrorDatum(
    json['message'] as String,
  )
    ..id = json['id'] as String?
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
  val['message'] = instance.message;
  return val;
}

FileDatum _$FileDatumFromJson(Map<String, dynamic> json) {
  return FileDatum(
    filename: json['filename'] as String,
    upload: json['upload'] as bool,
  )
    ..id = json['id'] as String?
    ..timestamp = json['timestamp'] == null
        ? null
        : DateTime.parse(json['timestamp'] as String)
    ..metadata = (json['metadata'] as Map<String, dynamic>?)?.map(
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
  val['filename'] = instance.filename;
  val['upload'] = instance.upload;
  writeNotNull('metadata', instance.metadata);
  return val;
}

MultiDatum _$MultiDatumFromJson(Map<String, dynamic> json) {
  return MultiDatum()
    ..id = json['id'] as String?
    ..timestamp = json['timestamp'] == null
        ? null
        : DateTime.parse(json['timestamp'] as String)
    ..data = (json['data'] as List<dynamic>)
        .map((e) => Datum.fromJson(e as Map<String, dynamic>))
        .toList();
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
  val['data'] = instance.data;
  return val;
}
