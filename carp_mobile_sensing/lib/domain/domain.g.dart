// GENERATED CODE - DO NOT MODIFY BY HAND

part of domain;

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CAMSStudyProtocol _$CAMSStudyProtocolFromJson(Map<String, dynamic> json) {
  return CAMSStudyProtocol(
    studyId: json['studyId'] as String,
    name: json['name'] as String,
    owner: json['owner'] == null
        ? null
        : ProtocolOwner.fromJson(json['owner'] as Map<String, dynamic>),
    protocolDescription: json['protocolDescription'] == null
        ? null
        : StudyProtocolDescription.fromJson(
            json['protocolDescription'] as Map<String, dynamic>),
    dataEndPoint: json['dataEndPoint'] == null
        ? null
        : DataEndPoint.fromJson(json['dataEndPoint'] as Map<String, dynamic>),
    dataFormat: json['dataFormat'] as String,
  )
    ..$type = json[r'$type'] as String
    ..description = json['description'] as String
    ..masterDevices = (json['masterDevices'] as List)
        ?.map((e) => e == null
            ? null
            : MasterDeviceDescriptor.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..connectedDevices = (json['connectedDevices'] as List)
        ?.map((e) => e == null
            ? null
            : DeviceDescriptor.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..triggers = (json['triggers'] as List)
        ?.map((e) =>
            e == null ? null : Trigger.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..tasks = (json['tasks'] as List)
        ?.map((e) => e == null
            ? null
            : TaskDescriptor.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..triggeredTasks = (json['triggeredTasks'] as List)
        ?.map((e) => e == null
            ? null
            : TriggeredTask.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$CAMSStudyProtocolToJson(CAMSStudyProtocol instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull(r'$type', instance.$type);
  writeNotNull('name', instance.name);
  writeNotNull('description', instance.description);
  writeNotNull('masterDevices', instance.masterDevices);
  writeNotNull('connectedDevices', instance.connectedDevices);
  writeNotNull('triggers', instance.triggers);
  writeNotNull('tasks', instance.tasks);
  writeNotNull('triggeredTasks', instance.triggeredTasks);
  writeNotNull('studyId', instance.studyId);
  writeNotNull('protocolDescription', instance.protocolDescription);
  writeNotNull('owner', instance.owner);
  writeNotNull('dataEndPoint', instance.dataEndPoint);
  writeNotNull('dataFormat', instance.dataFormat);
  return val;
}

StudyProtocolDescription _$StudyProtocolDescriptionFromJson(
    Map<String, dynamic> json) {
  return StudyProtocolDescription(
    title: json['title'] as String,
    description: json['description'] as String,
    purpose: json['purpose'] as String,
  )..$type = json[r'$type'] as String;
}

Map<String, dynamic> _$StudyProtocolDescriptionToJson(
    StudyProtocolDescription instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull(r'$type', instance.$type);
  writeNotNull('title', instance.title);
  writeNotNull('description', instance.description);
  writeNotNull('purpose', instance.purpose);
  return val;
}

DataEndPoint _$DataEndPointFromJson(Map<String, dynamic> json) {
  return DataEndPoint(
    type: json['type'] as String,
    publicKey: json['publicKey'] as String,
  )..$type = json[r'$type'] as String;
}

Map<String, dynamic> _$DataEndPointToJson(DataEndPoint instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull(r'$type', instance.$type);
  writeNotNull('type', instance.type);
  writeNotNull('publicKey', instance.publicKey);
  return val;
}

FileDataEndPoint _$FileDataEndPointFromJson(Map<String, dynamic> json) {
  return FileDataEndPoint(
    type: json['type'] as String,
    bufferSize: json['bufferSize'] as int,
    zip: json['zip'] as bool,
    encrypt: json['encrypt'] as bool,
    publicKey: json['publicKey'] as String,
  )..$type = json[r'$type'] as String;
}

Map<String, dynamic> _$FileDataEndPointToJson(FileDataEndPoint instance) {
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
  return val;
}

CAMSMeasure _$CAMSMeasureFromJson(Map<String, dynamic> json) {
  return CAMSMeasure(
    type: json['type'] as String,
    name: json['name'] as String,
    description: json['description'] as String,
    enabled: json['enabled'] as bool,
  )
    ..$type = json[r'$type'] as String
    ..configuration = (json['configuration'] as Map<String, dynamic>)?.map(
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

  writeNotNull(r'$type', instance.$type);
  writeNotNull('type', instance.type);
  writeNotNull('name', instance.name);
  writeNotNull('description', instance.description);
  writeNotNull('enabled', instance.enabled);
  writeNotNull('configuration', instance.configuration);
  return val;
}

PeriodicMeasure _$PeriodicMeasureFromJson(Map<String, dynamic> json) {
  return PeriodicMeasure(
    type: json['type'] as String,
    name: json['name'] as String,
    description: json['description'] as String,
    enabled: json['enabled'] as bool,
    frequency: json['frequency'] == null
        ? null
        : Duration(microseconds: json['frequency'] as int),
    duration: json['duration'] == null
        ? null
        : Duration(microseconds: json['duration'] as int),
  )
    ..$type = json[r'$type'] as String
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

  writeNotNull(r'$type', instance.$type);
  writeNotNull('type', instance.type);
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
    type: json['type'] as String,
    name: json['name'] as String,
    description: json['description'] as String,
    enabled: json['enabled'] as bool,
    history: json['history'] == null
        ? null
        : Duration(microseconds: json['history'] as int),
  )
    ..$type = json[r'$type'] as String
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

  writeNotNull(r'$type', instance.$type);
  writeNotNull('type', instance.type);
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
    roleName: json['roleName'] as String,
    supportedDataTypes:
        (json['supportedDataTypes'] as List)?.map((e) => e as String)?.toList(),
  )
    ..$type = json[r'$type'] as String
    ..isMasterDevice = json['isMasterDevice'] as bool
    ..samplingConfiguration =
        (json['samplingConfiguration'] as Map<String, dynamic>)?.map(
      (k, e) => MapEntry(
          k,
          e == null
              ? null
              : SamplingConfiguration.fromJson(e as Map<String, dynamic>)),
    )
    ..collectingMeasureTypes = (json['collectingMeasureTypes'] as List)
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

  writeNotNull(r'$type', instance.$type);
  writeNotNull('isMasterDevice', instance.isMasterDevice);
  writeNotNull('roleName', instance.roleName);
  writeNotNull('supportedDataTypes', instance.supportedDataTypes);
  writeNotNull('samplingConfiguration', instance.samplingConfiguration);
  writeNotNull('deviceType', instance.deviceType);
  writeNotNull('name', instance.name);
  writeNotNull('collectingMeasureTypes', instance.collectingMeasureTypes);
  return val;
}

CAMSMasterDeviceDeployment _$CAMSMasterDeviceDeploymentFromJson(
    Map<String, dynamic> json) {
  return CAMSMasterDeviceDeployment(
    studyId: json['studyId'] as String,
    studyDeploymentId: json['studyDeploymentId'] as String,
    name: json['name'] as String,
    protocolDescription: json['protocolDescription'] == null
        ? null
        : StudyProtocolDescription.fromJson(
            json['protocolDescription'] as Map<String, dynamic>),
    owner: json['owner'] == null
        ? null
        : ProtocolOwner.fromJson(json['owner'] as Map<String, dynamic>),
    dataFormat: json['dataFormat'] as String,
    dataEndPoint: json['dataEndPoint'] == null
        ? null
        : DataEndPoint.fromJson(json['dataEndPoint'] as Map<String, dynamic>),
    deviceDescriptor: json['deviceDescriptor'] == null
        ? null
        : MasterDeviceDescriptor.fromJson(
            json['deviceDescriptor'] as Map<String, dynamic>),
    configuration: json['configuration'] == null
        ? null
        : DeviceRegistration.fromJson(
            json['configuration'] as Map<String, dynamic>),
    connectedDevices: (json['connectedDevices'] as List)
        ?.map((e) => e == null
            ? null
            : DeviceDescriptor.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    connectedDeviceConfigurations:
        (json['connectedDeviceConfigurations'] as Map<String, dynamic>)?.map(
      (k, e) => MapEntry(
          k,
          e == null
              ? null
              : DeviceRegistration.fromJson(e as Map<String, dynamic>)),
    ),
    tasks: (json['tasks'] as List)
        ?.map((e) => e == null
            ? null
            : TaskDescriptor.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    triggers: (json['triggers'] as Map<String, dynamic>)?.map(
      (k, e) => MapEntry(
          k, e == null ? null : Trigger.fromJson(e as Map<String, dynamic>)),
    ),
    triggeredTasks: (json['triggeredTasks'] as List)
        ?.map((e) => e == null
            ? null
            : TriggeredTask.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  )
    ..lastUpdateDate = json['lastUpdateDate'] == null
        ? null
        : DateTime.parse(json['lastUpdateDate'] as String)
    ..userId = json['userId'] as String
    ..samplingStrategy = _$enumDecodeNullable(
        _$SamplingSchemaTypeEnumMap, json['samplingStrategy']);
}

Map<String, dynamic> _$CAMSMasterDeviceDeploymentToJson(
    CAMSMasterDeviceDeployment instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('deviceDescriptor', instance.deviceDescriptor);
  writeNotNull('configuration', instance.configuration);
  writeNotNull('connectedDevices', instance.connectedDevices);
  writeNotNull(
      'connectedDeviceConfigurations', instance.connectedDeviceConfigurations);
  writeNotNull('tasks', instance.tasks);
  writeNotNull('triggers', instance.triggers);
  writeNotNull('triggeredTasks', instance.triggeredTasks);
  writeNotNull('lastUpdateDate', instance.lastUpdateDate?.toIso8601String());
  writeNotNull('studyId', instance.studyId);
  writeNotNull('studyDeploymentId', instance.studyDeploymentId);
  writeNotNull('userId', instance.userId);
  writeNotNull('name', instance.name);
  writeNotNull('protocolDescription', instance.protocolDescription);
  writeNotNull('owner', instance.owner);
  writeNotNull('dataEndPoint', instance.dataEndPoint);
  writeNotNull('dataFormat', instance.dataFormat);
  writeNotNull('samplingStrategy',
      _$SamplingSchemaTypeEnumMap[instance.samplingStrategy]);
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

const _$SamplingSchemaTypeEnumMap = {
  SamplingSchemaType.maximum: 'maximum',
  SamplingSchemaType.common: 'common',
  SamplingSchemaType.normal: 'normal',
  SamplingSchemaType.light: 'light',
  SamplingSchemaType.minimum: 'minimum',
  SamplingSchemaType.none: 'none',
  SamplingSchemaType.debug: 'debug',
};

AppTask _$AppTaskFromJson(Map<String, dynamic> json) {
  return AppTask(
    name: json['name'] as String,
    type: json['type'] as String,
    title: json['title'] as String,
    description: json['description'] as String,
    instructions: json['instructions'] as String,
    minutesToComplete: json['minutes_to_complete'] as int,
    expire: json['expire'] == null
        ? null
        : Duration(microseconds: json['expire'] as int),
    notification: json['notification'] as bool,
  )
    ..$type = json[r'$type'] as String
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

  writeNotNull(r'$type', instance.$type);
  writeNotNull('name', instance.name);
  writeNotNull('measures', instance.measures);
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
  )
    ..$type = json[r'$type'] as String
    ..sourceDeviceRoleName = json['sourceDeviceRoleName'] as String
    ..requiresMasterDevice = json['requiresMasterDevice'] as bool;
}

Map<String, dynamic> _$CAMSTriggerToJson(CAMSTrigger instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull(r'$type', instance.$type);
  writeNotNull('sourceDeviceRoleName', instance.sourceDeviceRoleName);
  writeNotNull('requiresMasterDevice', instance.requiresMasterDevice);
  writeNotNull('triggerId', instance.triggerId);
  return val;
}

ImmediateTrigger _$ImmediateTriggerFromJson(Map<String, dynamic> json) {
  return ImmediateTrigger(
    triggerId: json['triggerId'] as String,
  )
    ..$type = json[r'$type'] as String
    ..sourceDeviceRoleName = json['sourceDeviceRoleName'] as String
    ..requiresMasterDevice = json['requiresMasterDevice'] as bool;
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
  writeNotNull('requiresMasterDevice', instance.requiresMasterDevice);
  writeNotNull('triggerId', instance.triggerId);
  return val;
}

PassiveTrigger _$PassiveTriggerFromJson(Map<String, dynamic> json) {
  return PassiveTrigger(
    triggerId: json['triggerId'] as String,
  )
    ..$type = json[r'$type'] as String
    ..sourceDeviceRoleName = json['sourceDeviceRoleName'] as String
    ..requiresMasterDevice = json['requiresMasterDevice'] as bool;
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
  writeNotNull('requiresMasterDevice', instance.requiresMasterDevice);
  writeNotNull('triggerId', instance.triggerId);
  return val;
}

DelayedTrigger _$DelayedTriggerFromJson(Map<String, dynamic> json) {
  return DelayedTrigger(
    triggerId: json['triggerId'] as String,
    delay: json['delay'] == null
        ? null
        : Duration(microseconds: json['delay'] as int),
  )
    ..$type = json[r'$type'] as String
    ..sourceDeviceRoleName = json['sourceDeviceRoleName'] as String
    ..requiresMasterDevice = json['requiresMasterDevice'] as bool;
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
  writeNotNull('requiresMasterDevice', instance.requiresMasterDevice);
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
  )
    ..$type = json[r'$type'] as String
    ..sourceDeviceRoleName = json['sourceDeviceRoleName'] as String
    ..requiresMasterDevice = json['requiresMasterDevice'] as bool;
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
  writeNotNull('requiresMasterDevice', instance.requiresMasterDevice);
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
  )
    ..$type = json[r'$type'] as String
    ..sourceDeviceRoleName = json['sourceDeviceRoleName'] as String
    ..requiresMasterDevice = json['requiresMasterDevice'] as bool;
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
  writeNotNull('requiresMasterDevice', instance.requiresMasterDevice);
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
  )..$type = json[r'$type'] as String;
}

Map<String, dynamic> _$TimeToJson(Time instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull(r'$type', instance.$type);
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
  )
    ..$type = json[r'$type'] as String
    ..sourceDeviceRoleName = json['sourceDeviceRoleName'] as String
    ..requiresMasterDevice = json['requiresMasterDevice'] as bool
    ..period = json['period'] == null
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

  writeNotNull(r'$type', instance.$type);
  writeNotNull('sourceDeviceRoleName', instance.sourceDeviceRoleName);
  writeNotNull('requiresMasterDevice', instance.requiresMasterDevice);
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
  )
    ..$type = json[r'$type'] as String
    ..sourceDeviceRoleName = json['sourceDeviceRoleName'] as String
    ..requiresMasterDevice = json['requiresMasterDevice'] as bool
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
  writeNotNull('requiresMasterDevice', instance.requiresMasterDevice);
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
  )
    ..$type = json[r'$type'] as String
    ..sourceDeviceRoleName = json['sourceDeviceRoleName'] as String
    ..requiresMasterDevice = json['requiresMasterDevice'] as bool;
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
  writeNotNull('requiresMasterDevice', instance.requiresMasterDevice);
  writeNotNull('triggerId', instance.triggerId);
  writeNotNull('measureType', instance.measureType);
  writeNotNull('resumeCondition', instance.resumeCondition);
  writeNotNull('pauseCondition', instance.pauseCondition);
  return val;
}

ConditionalEvent _$ConditionalEventFromJson(Map<String, dynamic> json) {
  return ConditionalEvent(
    json['condition'] as Map<String, dynamic>,
  )..$type = json[r'$type'] as String;
}

Map<String, dynamic> _$ConditionalEventToJson(ConditionalEvent instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull(r'$type', instance.$type);
  writeNotNull('condition', instance.condition);
  return val;
}

ConditionalSamplingEventTrigger _$ConditionalSamplingEventTriggerFromJson(
    Map<String, dynamic> json) {
  return ConditionalSamplingEventTrigger(
    triggerId: json['triggerId'] as String,
    measureType: json['measureType'] as String,
  )
    ..$type = json[r'$type'] as String
    ..sourceDeviceRoleName = json['sourceDeviceRoleName'] as String
    ..requiresMasterDevice = json['requiresMasterDevice'] as bool;
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
  writeNotNull('requiresMasterDevice', instance.requiresMasterDevice);
  writeNotNull('triggerId', instance.triggerId);
  writeNotNull('measureType', instance.measureType);
  return val;
}

Datum _$DatumFromJson(Map<String, dynamic> json) {
  return Datum()
    ..id = json['id'] as String
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
    filename: json['filename'] as String,
    upload: json['upload'] as bool,
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

AutomaticTask _$AutomaticTaskFromJson(Map<String, dynamic> json) {
  return AutomaticTask(
    name: json['name'] as String,
  )
    ..$type = json[r'$type'] as String
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

  writeNotNull(r'$type', instance.$type);
  writeNotNull('name', instance.name);
  writeNotNull('measures', instance.measures);
  return val;
}
