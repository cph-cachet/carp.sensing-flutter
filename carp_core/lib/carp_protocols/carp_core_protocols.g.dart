// GENERATED CODE - DO NOT MODIFY BY HAND

part of carp_core_protocols;

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeviceDescriptor _$DeviceDescriptorFromJson(Map<String, dynamic> json) {
  return DeviceDescriptor(
    roleName: json['roleName'] as String,
    isMasterDevice: json['isMasterDevice'] as bool,
    supportedDataTypes:
        (json['supportedDataTypes'] as List)?.map((e) => e as String)?.toList(),
  )
    ..$type = json[r'$type'] as String
    ..samplingConfiguration =
        (json['samplingConfiguration'] as Map<String, dynamic>)?.map(
      (k, e) => MapEntry(
          k,
          e == null
              ? null
              : SamplingConfiguration.fromJson(e as Map<String, dynamic>)),
    );
}

Map<String, dynamic> _$DeviceDescriptorToJson(DeviceDescriptor instance) {
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
  return val;
}

MasterDeviceDescriptor _$MasterDeviceDescriptorFromJson(
    Map<String, dynamic> json) {
  return MasterDeviceDescriptor(
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
    );
}

Map<String, dynamic> _$MasterDeviceDescriptorToJson(
    MasterDeviceDescriptor instance) {
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
  return val;
}

CustomProtocolDevice _$CustomProtocolDeviceFromJson(Map<String, dynamic> json) {
  return CustomProtocolDevice(
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
    );
}

Map<String, dynamic> _$CustomProtocolDeviceToJson(
    CustomProtocolDevice instance) {
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
  return val;
}

Smartphone _$SmartphoneFromJson(Map<String, dynamic> json) {
  return Smartphone(
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
    );
}

Map<String, dynamic> _$SmartphoneToJson(Smartphone instance) {
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
  return val;
}

AltBeacon _$AltBeaconFromJson(Map<String, dynamic> json) {
  return AltBeacon(
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
    );
}

Map<String, dynamic> _$AltBeaconToJson(AltBeacon instance) {
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
  return val;
}

DeviceConnection _$DeviceConnectionFromJson(Map<String, dynamic> json) {
  return DeviceConnection(
    json['roleName'] as String,
    json['connectedToRoleName'] as String,
  )..$type = json[r'$type'] as String;
}

Map<String, dynamic> _$DeviceConnectionToJson(DeviceConnection instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull(r'$type', instance.$type);
  writeNotNull('roleName', instance.roleName);
  writeNotNull('connectedToRoleName', instance.connectedToRoleName);
  return val;
}

Measure _$MeasureFromJson(Map<String, dynamic> json) {
  return Measure(
    type: json['type'] as String,
  )..$type = json[r'$type'] as String;
}

Map<String, dynamic> _$MeasureToJson(Measure instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull(r'$type', instance.$type);
  writeNotNull('type', instance.type);
  return val;
}

DataTypeMeasure _$DataTypeMeasureFromJson(Map<String, dynamic> json) {
  return DataTypeMeasure(
    type: json['type'] as String,
  )..$type = json[r'$type'] as String;
}

Map<String, dynamic> _$DataTypeMeasureToJson(DataTypeMeasure instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull(r'$type', instance.$type);
  writeNotNull('type', instance.type);
  return val;
}

PhoneSensorMeasure _$PhoneSensorMeasureFromJson(Map<String, dynamic> json) {
  return PhoneSensorMeasure(
    type: json['type'] as String,
    duration: json['duration'] as int,
  )..$type = json[r'$type'] as String;
}

Map<String, dynamic> _$PhoneSensorMeasureToJson(PhoneSensorMeasure instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull(r'$type', instance.$type);
  writeNotNull('type', instance.type);
  writeNotNull('duration', instance.duration);
  return val;
}

StudyProtocol _$StudyProtocolFromJson(Map<String, dynamic> json) {
  return StudyProtocol(
    ownerId: json['ownerId'] as String,
    name: json['name'] as String,
    description: json['description'] as String,
  )
    ..creationDate = json['creationDate'] == null
        ? null
        : DateTime.parse(json['creationDate'] as String)
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
    ..connections = (json['connections'] as List)
        ?.map((e) => e == null
            ? null
            : DeviceConnection.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..triggers = (json['triggers'] as Map<String, dynamic>)?.map(
      (k, e) => MapEntry(
          k, e == null ? null : Trigger.fromJson(e as Map<String, dynamic>)),
    )
    ..tasks = (json['tasks'] as List)
        ?.map((e) => e == null
            ? null
            : TaskDescriptor.fromJson(e as Map<String, dynamic>))
        ?.toSet()
    ..triggeredTasks = (json['triggeredTasks'] as List)
        ?.map((e) => e == null
            ? null
            : TriggeredTask.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..expectedParticipantData = (json['expectedParticipantData'] as List)
        ?.map((e) => e as Map<String, dynamic>)
        ?.toList();
}

Map<String, dynamic> _$StudyProtocolToJson(StudyProtocol instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('ownerId', instance.ownerId);
  writeNotNull('name', instance.name);
  writeNotNull('description', instance.description);
  writeNotNull('creationDate', instance.creationDate?.toIso8601String());
  writeNotNull('masterDevices', instance.masterDevices);
  writeNotNull('connectedDevices', instance.connectedDevices);
  writeNotNull('connections', instance.connections);
  writeNotNull('triggers', instance.triggers);
  writeNotNull('tasks', instance.tasks?.toList());
  writeNotNull('triggeredTasks', instance.triggeredTasks);
  writeNotNull('expectedParticipantData', instance.expectedParticipantData);
  return val;
}

TaskDescriptor _$TaskDescriptorFromJson(Map<String, dynamic> json) {
  return TaskDescriptor(
    name: json['name'] as String,
    measures: (json['measures'] as List)
        ?.map((e) =>
            e == null ? null : Measure.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  )..$type = json[r'$type'] as String;
}

Map<String, dynamic> _$TaskDescriptorToJson(TaskDescriptor instance) {
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

ConcurrentTask _$ConcurrentTaskFromJson(Map<String, dynamic> json) {
  return ConcurrentTask(
    name: json['name'] as String,
    measures: (json['measures'] as List)
        ?.map((e) =>
            e == null ? null : Measure.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  )..$type = json[r'$type'] as String;
}

Map<String, dynamic> _$ConcurrentTaskToJson(ConcurrentTask instance) {
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

CustomProtocolTask _$CustomProtocolTaskFromJson(Map<String, dynamic> json) {
  return CustomProtocolTask(
    name: json['name'] as String,
    studyProtocol: json['studyProtocol'] as String,
  )
    ..$type = json[r'$type'] as String
    ..measures = (json['measures'] as List)
        ?.map((e) =>
            e == null ? null : Measure.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$CustomProtocolTaskToJson(CustomProtocolTask instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull(r'$type', instance.$type);
  writeNotNull('name', instance.name);
  writeNotNull('measures', instance.measures);
  writeNotNull('studyProtocol', instance.studyProtocol);
  return val;
}

TriggeredTask _$TriggeredTaskFromJson(Map<String, dynamic> json) {
  return TriggeredTask(
    triggerId: json['triggerId'] as int,
  )
    ..taskName = json['taskName'] as String
    ..targetDeviceRoleName = json['targetDeviceRoleName'] as String;
}

Map<String, dynamic> _$TriggeredTaskToJson(TriggeredTask instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('triggerId', instance.triggerId);
  writeNotNull('taskName', instance.taskName);
  writeNotNull('targetDeviceRoleName', instance.targetDeviceRoleName);
  return val;
}

Trigger _$TriggerFromJson(Map<String, dynamic> json) {
  return Trigger()
    ..$type = json[r'$type'] as String
    ..sourceDeviceRoleName = json['sourceDeviceRoleName'] as String
    ..requiresMasterDevice = json['requiresMasterDevice'] as bool;
}

Map<String, dynamic> _$TriggerToJson(Trigger instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull(r'$type', instance.$type);
  writeNotNull('sourceDeviceRoleName', instance.sourceDeviceRoleName);
  writeNotNull('requiresMasterDevice', instance.requiresMasterDevice);
  return val;
}

ElapsedTimeTrigger _$ElapsedTimeTriggerFromJson(Map<String, dynamic> json) {
  return ElapsedTimeTrigger(
    elapsedTime: json['elapsedTime'] == null
        ? null
        : Duration(microseconds: json['elapsedTime'] as int),
  )
    ..$type = json[r'$type'] as String
    ..sourceDeviceRoleName = json['sourceDeviceRoleName'] as String
    ..requiresMasterDevice = json['requiresMasterDevice'] as bool;
}

Map<String, dynamic> _$ElapsedTimeTriggerToJson(ElapsedTimeTrigger instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull(r'$type', instance.$type);
  writeNotNull('sourceDeviceRoleName', instance.sourceDeviceRoleName);
  writeNotNull('requiresMasterDevice', instance.requiresMasterDevice);
  writeNotNull('elapsedTime', instance.elapsedTime?.inMicroseconds);
  return val;
}

ManualTrigger _$ManualTriggerFromJson(Map<String, dynamic> json) {
  return ManualTrigger(
    label: json['label'] as String,
    description: json['description'] as String,
  )
    ..$type = json[r'$type'] as String
    ..sourceDeviceRoleName = json['sourceDeviceRoleName'] as String
    ..requiresMasterDevice = json['requiresMasterDevice'] as bool;
}

Map<String, dynamic> _$ManualTriggerToJson(ManualTrigger instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull(r'$type', instance.$type);
  writeNotNull('sourceDeviceRoleName', instance.sourceDeviceRoleName);
  writeNotNull('requiresMasterDevice', instance.requiresMasterDevice);
  writeNotNull('label', instance.label);
  writeNotNull('description', instance.description);
  return val;
}

ScheduledTrigger _$ScheduledTriggerFromJson(Map<String, dynamic> json) {
  return ScheduledTrigger(
    time: json['time'] == null
        ? null
        : TimeOfDay.fromJson(json['time'] as Map<String, dynamic>),
    recurrenceRule: json['recurrenceRule'] == null
        ? null
        : RecurrenceRule
            .fromJson(json['recurrenceRule'] as Map<String, dynamic>),
  )
    ..$type = json[r'$type'] as String
    ..sourceDeviceRoleName = json['sourceDeviceRoleName'] as String
    ..requiresMasterDevice = json['requiresMasterDevice'] as bool;
}

Map<String, dynamic> _$ScheduledTriggerToJson(ScheduledTrigger instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull(r'$type', instance.$type);
  writeNotNull('sourceDeviceRoleName', instance.sourceDeviceRoleName);
  writeNotNull('requiresMasterDevice', instance.requiresMasterDevice);
  writeNotNull('time', instance.time);
  writeNotNull('recurrenceRule', instance.recurrenceRule);
  return val;
}

TimeOfDay _$TimeOfDayFromJson(Map<String, dynamic> json) {
  return TimeOfDay(
    hour: json['hour'] as int,
    minute: json['minute'] as int,
    second: json['second'] as int,
  );
}

Map<String, dynamic> _$TimeOfDayToJson(TimeOfDay instance) {
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

RecurrenceRule _$RecurrenceRuleFromJson(Map<String, dynamic> json) {
  return RecurrenceRule(
    _$enumDecodeNullable(_$FrequencyEnumMap, json['frequency']),
    interval: json['interval'] as int,
    end: json['end'] == null
        ? null
        : End.fromJson(json['end'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$RecurrenceRuleToJson(RecurrenceRule instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('frequency', _$FrequencyEnumMap[instance.frequency]);
  writeNotNull('interval', instance.interval);
  writeNotNull('end', instance.end);
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

const _$FrequencyEnumMap = {
  Frequency.SECONDLY: 'SECONDLY',
  Frequency.MINUTELY: 'MINUTELY',
  Frequency.HOURLY: 'HOURLY',
  Frequency.DAILY: 'DAILY',
  Frequency.WEEKLY: 'WEEKLY',
  Frequency.MONTHLY: 'MONTHLY',
  Frequency.YEARLY: 'YEARLY',
};

End _$EndFromJson(Map<String, dynamic> json) {
  return End(
    _$enumDecodeNullable(_$EndTypeEnumMap, json['type']),
    elapsedTime: json['elapsedTime'] == null
        ? null
        : Duration(microseconds: json['elapsedTime'] as int),
    count: json['count'] as int,
  );
}

Map<String, dynamic> _$EndToJson(End instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('type', _$EndTypeEnumMap[instance.type]);
  writeNotNull('elapsedTime', instance.elapsedTime?.inMicroseconds);
  writeNotNull('count', instance.count);
  return val;
}

const _$EndTypeEnumMap = {
  EndType.UNTIL: 'UNTIL',
  EndType.COUNT: 'COUNT',
  EndType.NEVER: 'NEVER',
};

SamplingConfiguration _$SamplingConfigurationFromJson(
    Map<String, dynamic> json) {
  return SamplingConfiguration()..$type = json[r'$type'] as String;
}

Map<String, dynamic> _$SamplingConfigurationToJson(
    SamplingConfiguration instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull(r'$type', instance.$type);
  return val;
}

StudyProtocolId _$StudyProtocolIdFromJson(Map<String, dynamic> json) {
  return StudyProtocolId(
    json['ownerId'] as String,
    json['name'] as String,
  );
}

Map<String, dynamic> _$StudyProtocolIdToJson(StudyProtocolId instance) =>
    <String, dynamic>{
      'ownerId': instance.ownerId,
      'name': instance.name,
    };

ParticipantAttribute _$ParticipantAttributeFromJson(Map<String, dynamic> json) {
  return ParticipantAttribute(
    json['inputType'] as String,
  );
}

Map<String, dynamic> _$ParticipantAttributeToJson(
        ParticipantAttribute instance) =>
    <String, dynamic>{
      'inputType': instance.inputType,
    };

ProtocolVersion _$ProtocolVersionFromJson(Map<String, dynamic> json) {
  return ProtocolVersion(
    json['tag'] as String,
  )..date =
      json['date'] == null ? null : DateTime.parse(json['date'] as String);
}

Map<String, dynamic> _$ProtocolVersionToJson(ProtocolVersion instance) =>
    <String, dynamic>{
      'tag': instance.tag,
      'date': instance.date?.toIso8601String(),
    };

Add _$AddFromJson(Map<String, dynamic> json) {
  return Add(
    json['protocol'] == null
        ? null
        : StudyProtocol.fromJson(json['protocol'] as Map<String, dynamic>),
    json['versionTag'] as String,
  )..$type = json[r'$type'] as String;
}

Map<String, dynamic> _$AddToJson(Add instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull(r'$type', instance.$type);
  val['protocol'] = instance.protocol;
  val['versionTag'] = instance.versionTag;
  return val;
}

AddVersion _$AddVersionFromJson(Map<String, dynamic> json) {
  return AddVersion(
    json['protocol'] == null
        ? null
        : StudyProtocol.fromJson(json['protocol'] as Map<String, dynamic>),
    json['versionTag'] as String,
  )..$type = json[r'$type'] as String;
}

Map<String, dynamic> _$AddVersionToJson(AddVersion instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull(r'$type', instance.$type);
  val['protocol'] = instance.protocol;
  val['versionTag'] = instance.versionTag;
  return val;
}

UpdateParticipantDataConfiguration _$UpdateParticipantDataConfigurationFromJson(
    Map<String, dynamic> json) {
  return UpdateParticipantDataConfiguration(
    json['protocolId'] == null
        ? null
        : StudyProtocolId.fromJson(json['protocolId'] as Map<String, dynamic>),
    json['versionTag'] as String,
    (json['expectedParticipantData'] as List)
        ?.map((e) => e == null
            ? null
            : ParticipantAttribute.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  )..$type = json[r'$type'] as String;
}

Map<String, dynamic> _$UpdateParticipantDataConfigurationToJson(
    UpdateParticipantDataConfiguration instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull(r'$type', instance.$type);
  val['protocolId'] = instance.protocolId;
  val['versionTag'] = instance.versionTag;
  val['expectedParticipantData'] = instance.expectedParticipantData;
  return val;
}

GetBy _$GetByFromJson(Map<String, dynamic> json) {
  return GetBy(
    json['protocolId'] == null
        ? null
        : StudyProtocolId.fromJson(json['protocolId'] as Map<String, dynamic>),
    json['versionTag'] as String,
  )..$type = json[r'$type'] as String;
}

Map<String, dynamic> _$GetByToJson(GetBy instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull(r'$type', instance.$type);
  val['protocolId'] = instance.protocolId;
  writeNotNull('versionTag', instance.versionTag);
  return val;
}

GetAllFor _$GetAllForFromJson(Map<String, dynamic> json) {
  return GetAllFor(
    json['ownerId'] as String,
  )..$type = json[r'$type'] as String;
}

Map<String, dynamic> _$GetAllForToJson(GetAllFor instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull(r'$type', instance.$type);
  val['ownerId'] = instance.ownerId;
  return val;
}

GetVersionHistoryFor _$GetVersionHistoryForFromJson(Map<String, dynamic> json) {
  return GetVersionHistoryFor(
    json['protocolId'] == null
        ? null
        : StudyProtocolId.fromJson(json['protocolId'] as Map<String, dynamic>),
  )..$type = json[r'$type'] as String;
}

Map<String, dynamic> _$GetVersionHistoryForToJson(
    GetVersionHistoryFor instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull(r'$type', instance.$type);
  val['protocolId'] = instance.protocolId;
  return val;
}

CreateCustomProtocol _$CreateCustomProtocolFromJson(Map<String, dynamic> json) {
  return CreateCustomProtocol(
    json['ownerId'] as String,
    json['name'] as String,
    json['description'] as String,
    json['customProtocol'] as String,
  )..$type = json[r'$type'] as String;
}

Map<String, dynamic> _$CreateCustomProtocolToJson(
    CreateCustomProtocol instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull(r'$type', instance.$type);
  val['ownerId'] = instance.ownerId;
  val['name'] = instance.name;
  val['description'] = instance.description;
  val['customProtocol'] = instance.customProtocol;
  return val;
}
