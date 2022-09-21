// GENERATED CODE - DO NOT MODIFY BY HAND

part of carp_core_protocols;

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeviceDescriptor _$DeviceDescriptorFromJson(Map<String, dynamic> json) =>
    DeviceDescriptor(
      roleName: json['roleName'] as String,
      isMasterDevice: json['isMasterDevice'] as bool? ?? false,
      supportedDataTypes: (json['supportedDataTypes'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    )
      ..$type = json[r'$type'] as String?
      ..samplingConfiguration =
          (json['samplingConfiguration'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(
            k, SamplingConfiguration.fromJson(e as Map<String, dynamic>)),
      );

Map<String, dynamic> _$DeviceDescriptorToJson(DeviceDescriptor instance) {
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
  return val;
}

MasterDeviceDescriptor _$MasterDeviceDescriptorFromJson(
        Map<String, dynamic> json) =>
    MasterDeviceDescriptor(
      roleName: json['roleName'] as String,
      supportedDataTypes: (json['supportedDataTypes'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    )
      ..$type = json[r'$type'] as String?
      ..isMasterDevice = json['isMasterDevice'] as bool?
      ..samplingConfiguration =
          (json['samplingConfiguration'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(
            k, SamplingConfiguration.fromJson(e as Map<String, dynamic>)),
      );

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
  val['roleName'] = instance.roleName;
  writeNotNull('supportedDataTypes', instance.supportedDataTypes);
  val['samplingConfiguration'] = instance.samplingConfiguration;
  return val;
}

CustomProtocolDevice _$CustomProtocolDeviceFromJson(
        Map<String, dynamic> json) =>
    CustomProtocolDevice(
      roleName:
          json['roleName'] as String? ?? CustomProtocolDevice.DEFAULT_ROLENAME,
      supportedDataTypes: (json['supportedDataTypes'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    )
      ..$type = json[r'$type'] as String?
      ..isMasterDevice = json['isMasterDevice'] as bool?
      ..samplingConfiguration =
          (json['samplingConfiguration'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(
            k, SamplingConfiguration.fromJson(e as Map<String, dynamic>)),
      );

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
  val['roleName'] = instance.roleName;
  writeNotNull('supportedDataTypes', instance.supportedDataTypes);
  val['samplingConfiguration'] = instance.samplingConfiguration;
  return val;
}

Smartphone _$SmartphoneFromJson(Map<String, dynamic> json) => Smartphone(
      roleName: json['roleName'] as String? ?? Smartphone.DEFAULT_ROLENAME,
      supportedDataTypes: (json['supportedDataTypes'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    )
      ..$type = json[r'$type'] as String?
      ..isMasterDevice = json['isMasterDevice'] as bool?
      ..samplingConfiguration =
          (json['samplingConfiguration'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(
            k, SamplingConfiguration.fromJson(e as Map<String, dynamic>)),
      );

Map<String, dynamic> _$SmartphoneToJson(Smartphone instance) {
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
  return val;
}

AltBeacon _$AltBeaconFromJson(Map<String, dynamic> json) => AltBeacon(
      roleName: json['roleName'] as String? ?? 'AltBeacon',
      supportedDataTypes: (json['supportedDataTypes'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    )
      ..$type = json[r'$type'] as String?
      ..isMasterDevice = json['isMasterDevice'] as bool?
      ..samplingConfiguration =
          (json['samplingConfiguration'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(
            k, SamplingConfiguration.fromJson(e as Map<String, dynamic>)),
      );

Map<String, dynamic> _$AltBeaconToJson(AltBeacon instance) {
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
  return val;
}

DeviceConnection _$DeviceConnectionFromJson(Map<String, dynamic> json) =>
    DeviceConnection(
      json['roleName'] as String?,
      json['connectedToRoleName'] as String?,
    )..$type = json[r'$type'] as String?;

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

Measure _$MeasureFromJson(Map<String, dynamic> json) => Measure(
      type: json['type'] as String,
    )
      ..$type = json[r'$type'] as String?
      ..overrideSamplingConfiguration = json['overrideSamplingConfiguration'] ==
              null
          ? null
          : SamplingConfiguration.fromJson(
              json['overrideSamplingConfiguration'] as Map<String, dynamic>);

Map<String, dynamic> _$MeasureToJson(Measure instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull(r'$type', instance.$type);
  val['type'] = instance.type;
  writeNotNull(
      'overrideSamplingConfiguration', instance.overrideSamplingConfiguration);
  return val;
}

StudyProtocol _$StudyProtocolFromJson(Map<String, dynamic> json) =>
    StudyProtocol(
      ownerId: json['ownerId'] as String,
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
    )
      ..creationDate = DateTime.parse(json['creationDate'] as String)
      ..masterDevices = (json['masterDevices'] as List<dynamic>)
          .map(
              (e) => MasterDeviceDescriptor.fromJson(e as Map<String, dynamic>))
          .toList()
      ..connectedDevices = (json['connectedDevices'] as List<dynamic>)
          .map((e) => DeviceDescriptor.fromJson(e as Map<String, dynamic>))
          .toList()
      ..connections = (json['connections'] as List<dynamic>)
          .map((e) => DeviceConnection.fromJson(e as Map<String, dynamic>))
          .toList()
      ..triggers = (json['triggers'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, Trigger.fromJson(e as Map<String, dynamic>)),
      )
      ..tasks = (json['tasks'] as List<dynamic>)
          .map((e) => TaskDescriptor.fromJson(e as Map<String, dynamic>))
          .toSet()
      ..triggeredTasks = (json['triggeredTasks'] as List<dynamic>)
          .map((e) => TriggeredTask.fromJson(e as Map<String, dynamic>))
          .toList()
      ..expectedParticipantData =
          (json['expectedParticipantData'] as List<dynamic>?)
              ?.map((e) => e as Map<String, dynamic>)
              .toList();

Map<String, dynamic> _$StudyProtocolToJson(StudyProtocol instance) {
  final val = <String, dynamic>{
    'ownerId': instance.ownerId,
    'name': instance.name,
    'description': instance.description,
    'creationDate': instance.creationDate.toIso8601String(),
    'masterDevices': instance.masterDevices,
    'connectedDevices': instance.connectedDevices,
    'connections': instance.connections,
    'triggers': instance.triggers,
    'tasks': instance.tasks.toList(),
    'triggeredTasks': instance.triggeredTasks,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('expectedParticipantData', instance.expectedParticipantData);
  return val;
}

TaskDescriptor _$TaskDescriptorFromJson(Map<String, dynamic> json) =>
    TaskDescriptor(
      name: json['name'] as String?,
      measures: (json['measures'] as List<dynamic>?)
          ?.map((e) => Measure.fromJson(e as Map<String, dynamic>))
          .toList(),
    )..$type = json[r'$type'] as String?;

Map<String, dynamic> _$TaskDescriptorToJson(TaskDescriptor instance) {
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

BackgroundTask _$BackgroundTaskFromJson(Map<String, dynamic> json) =>
    BackgroundTask(
      name: json['name'] as String?,
      measures: (json['measures'] as List<dynamic>?)
          ?.map((e) => Measure.fromJson(e as Map<String, dynamic>))
          .toList(),
      duration: json['duration'] == null
          ? null
          : Duration(microseconds: json['duration'] as int),
    )..$type = json[r'$type'] as String?;

Map<String, dynamic> _$BackgroundTaskToJson(BackgroundTask instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull(r'$type', instance.$type);
  val['name'] = instance.name;
  val['measures'] = instance.measures;
  writeNotNull('duration', instance.duration?.inMicroseconds);
  return val;
}

CustomProtocolTask _$CustomProtocolTaskFromJson(Map<String, dynamic> json) =>
    CustomProtocolTask(
      name: json['name'] as String?,
      studyProtocol: json['studyProtocol'] as String,
    )
      ..$type = json[r'$type'] as String?
      ..measures = (json['measures'] as List<dynamic>)
          .map((e) => Measure.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$CustomProtocolTaskToJson(CustomProtocolTask instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull(r'$type', instance.$type);
  val['name'] = instance.name;
  val['measures'] = instance.measures;
  val['studyProtocol'] = instance.studyProtocol;
  return val;
}

TriggeredTask _$TriggeredTaskFromJson(Map<String, dynamic> json) =>
    TriggeredTask(
      json['triggerId'] as int,
    )
      ..taskName = json['taskName'] as String
      ..targetDeviceRoleName = json['targetDeviceRoleName'] as String?
      ..targetDeviceType = json['targetDeviceType'] as String?
      ..hasBeenScheduledUntil = json['hasBeenScheduledUntil'] == null
          ? null
          : DateTime.parse(json['hasBeenScheduledUntil'] as String);

Map<String, dynamic> _$TriggeredTaskToJson(TriggeredTask instance) {
  final val = <String, dynamic>{
    'triggerId': instance.triggerId,
    'taskName': instance.taskName,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('targetDeviceRoleName', instance.targetDeviceRoleName);
  writeNotNull('targetDeviceType', instance.targetDeviceType);
  writeNotNull('hasBeenScheduledUntil',
      instance.hasBeenScheduledUntil?.toIso8601String());
  return val;
}

Trigger _$TriggerFromJson(Map<String, dynamic> json) => Trigger(
      sourceDeviceRoleName: json['sourceDeviceRoleName'] as String?,
    )..$type = json[r'$type'] as String?;

Map<String, dynamic> _$TriggerToJson(Trigger instance) {
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

ElapsedTimeTrigger _$ElapsedTimeTriggerFromJson(Map<String, dynamic> json) =>
    ElapsedTimeTrigger(
      sourceDeviceRoleName: json['sourceDeviceRoleName'] as String?,
      elapsedTime: Duration(microseconds: json['elapsedTime'] as int),
    )..$type = json[r'$type'] as String?;

Map<String, dynamic> _$ElapsedTimeTriggerToJson(ElapsedTimeTrigger instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull(r'$type', instance.$type);
  writeNotNull('sourceDeviceRoleName', instance.sourceDeviceRoleName);
  val['elapsedTime'] = instance.elapsedTime.inMicroseconds;
  return val;
}

ManualTrigger _$ManualTriggerFromJson(Map<String, dynamic> json) =>
    ManualTrigger(
      sourceDeviceRoleName: json['source_device_role_name'] as String?,
      label: json['label'] as String?,
      description: json['description'] as String?,
    )..$type = json[r'$type'] as String?;

Map<String, dynamic> _$ManualTriggerToJson(ManualTrigger instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull(r'$type', instance.$type);
  writeNotNull('source_device_role_name', instance.sourceDeviceRoleName);
  writeNotNull('label', instance.label);
  writeNotNull('description', instance.description);
  return val;
}

ScheduledTrigger _$ScheduledTriggerFromJson(Map<String, dynamic> json) =>
    ScheduledTrigger(
      sourceDeviceRoleName: json['sourceDeviceRoleName'] as String?,
      time: TimeOfDay.fromJson(json['time'] as Map<String, dynamic>),
      recurrenceRule: RecurrenceRule.fromJson(
          json['recurrenceRule'] as Map<String, dynamic>),
    )..$type = json[r'$type'] as String?;

Map<String, dynamic> _$ScheduledTriggerToJson(ScheduledTrigger instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull(r'$type', instance.$type);
  writeNotNull('sourceDeviceRoleName', instance.sourceDeviceRoleName);
  val['time'] = instance.time;
  val['recurrenceRule'] = instance.recurrenceRule;
  return val;
}

TimeOfDay _$TimeOfDayFromJson(Map<String, dynamic> json) => TimeOfDay(
      hour: json['hour'] as int? ?? 0,
      minute: json['minute'] as int? ?? 0,
      second: json['second'] as int? ?? 0,
    );

Map<String, dynamic> _$TimeOfDayToJson(TimeOfDay instance) => <String, dynamic>{
      'hour': instance.hour,
      'minute': instance.minute,
      'second': instance.second,
    };

RecurrenceRule _$RecurrenceRuleFromJson(Map<String, dynamic> json) =>
    RecurrenceRule(
      $enumDecode(_$FrequencyEnumMap, json['frequency']),
      interval: json['interval'] as int? ?? 1,
      end: json['end'] == null
          ? null
          : End.fromJson(json['end'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$RecurrenceRuleToJson(RecurrenceRule instance) =>
    <String, dynamic>{
      'frequency': _$FrequencyEnumMap[instance.frequency]!,
      'interval': instance.interval,
      'end': instance.end,
    };

const _$FrequencyEnumMap = {
  Frequency.SECONDLY: 'SECONDLY',
  Frequency.MINUTELY: 'MINUTELY',
  Frequency.HOURLY: 'HOURLY',
  Frequency.DAILY: 'DAILY',
  Frequency.WEEKLY: 'WEEKLY',
  Frequency.MONTHLY: 'MONTHLY',
  Frequency.YEARLY: 'YEARLY',
};

End _$EndFromJson(Map<String, dynamic> json) => End(
      $enumDecode(_$EndTypeEnumMap, json['type']),
      elapsedTime: json['elapsedTime'] == null
          ? null
          : Duration(microseconds: json['elapsedTime'] as int),
      count: json['count'] as int?,
    );

Map<String, dynamic> _$EndToJson(End instance) {
  final val = <String, dynamic>{
    'type': _$EndTypeEnumMap[instance.type]!,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

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
        Map<String, dynamic> json) =>
    SamplingConfiguration()..$type = json[r'$type'] as String?;

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

BatteryAwareSamplingConfiguration _$BatteryAwareSamplingConfigurationFromJson(
        Map<String, dynamic> json) =>
    BatteryAwareSamplingConfiguration(
      normal: SamplingConfiguration.fromJson(
          json['normal'] as Map<String, dynamic>),
      low: SamplingConfiguration.fromJson(json['low'] as Map<String, dynamic>),
      critical: SamplingConfiguration.fromJson(
          json['critical'] as Map<String, dynamic>),
    )..$type = json[r'$type'] as String?;

Map<String, dynamic> _$BatteryAwareSamplingConfigurationToJson(
    BatteryAwareSamplingConfiguration instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull(r'$type', instance.$type);
  val['normal'] = instance.normal;
  val['low'] = instance.low;
  val['critical'] = instance.critical;
  return val;
}

GranularitySamplingConfiguration _$GranularitySamplingConfigurationFromJson(
        Map<String, dynamic> json) =>
    GranularitySamplingConfiguration(
      $enumDecode(_$GranularityEnumMap, json['granularity']),
    )..$type = json[r'$type'] as String?;

Map<String, dynamic> _$GranularitySamplingConfigurationToJson(
        GranularitySamplingConfiguration instance) =>
    <String, dynamic>{
      r'$type': instance.$type,
      'granularity': _$GranularityEnumMap[instance.granularity]!,
    };

const _$GranularityEnumMap = {
  Granularity.Detailed: 'Detailed',
  Granularity.Balanced: 'Balanced',
  Granularity.Coarse: 'Coarse',
};

StudyProtocolId _$StudyProtocolIdFromJson(Map<String, dynamic> json) =>
    StudyProtocolId(
      json['ownerId'] as String,
      json['name'] as String,
    );

Map<String, dynamic> _$StudyProtocolIdToJson(StudyProtocolId instance) =>
    <String, dynamic>{
      'ownerId': instance.ownerId,
      'name': instance.name,
    };

ParticipantAttribute _$ParticipantAttributeFromJson(
        Map<String, dynamic> json) =>
    ParticipantAttribute(
      json['inputType'] as String,
    );

Map<String, dynamic> _$ParticipantAttributeToJson(
        ParticipantAttribute instance) =>
    <String, dynamic>{
      'inputType': instance.inputType,
    };

ProtocolVersion _$ProtocolVersionFromJson(Map<String, dynamic> json) =>
    ProtocolVersion(
      json['tag'] as String,
    )..date = DateTime.parse(json['date'] as String);

Map<String, dynamic> _$ProtocolVersionToJson(ProtocolVersion instance) =>
    <String, dynamic>{
      'tag': instance.tag,
      'date': instance.date.toIso8601String(),
    };

Add _$AddFromJson(Map<String, dynamic> json) => Add(
      json['protocol'] == null
          ? null
          : StudyProtocol.fromJson(json['protocol'] as Map<String, dynamic>),
      json['versionTag'] as String?,
    )..$type = json[r'$type'] as String?;

Map<String, dynamic> _$AddToJson(Add instance) => <String, dynamic>{
      r'$type': instance.$type,
      'protocol': instance.protocol,
      'versionTag': instance.versionTag,
    };

AddVersion _$AddVersionFromJson(Map<String, dynamic> json) => AddVersion(
      json['protocol'] == null
          ? null
          : StudyProtocol.fromJson(json['protocol'] as Map<String, dynamic>),
      json['versionTag'] as String?,
    )..$type = json[r'$type'] as String?;

Map<String, dynamic> _$AddVersionToJson(AddVersion instance) =>
    <String, dynamic>{
      r'$type': instance.$type,
      'protocol': instance.protocol,
      'versionTag': instance.versionTag,
    };

UpdateParticipantDataConfiguration _$UpdateParticipantDataConfigurationFromJson(
        Map<String, dynamic> json) =>
    UpdateParticipantDataConfiguration(
      json['protocolId'] == null
          ? null
          : StudyProtocolId.fromJson(
              json['protocolId'] as Map<String, dynamic>),
      json['versionTag'] as String?,
      (json['expectedParticipantData'] as List<dynamic>?)
          ?.map((e) => ParticipantAttribute.fromJson(e as Map<String, dynamic>))
          .toList(),
    )..$type = json[r'$type'] as String?;

Map<String, dynamic> _$UpdateParticipantDataConfigurationToJson(
        UpdateParticipantDataConfiguration instance) =>
    <String, dynamic>{
      r'$type': instance.$type,
      'protocolId': instance.protocolId,
      'versionTag': instance.versionTag,
      'expectedParticipantData': instance.expectedParticipantData,
    };

GetBy _$GetByFromJson(Map<String, dynamic> json) => GetBy(
      json['protocolId'] == null
          ? null
          : StudyProtocolId.fromJson(
              json['protocolId'] as Map<String, dynamic>),
      json['versionTag'] as String?,
    )..$type = json[r'$type'] as String?;

Map<String, dynamic> _$GetByToJson(GetBy instance) {
  final val = <String, dynamic>{
    r'$type': instance.$type,
    'protocolId': instance.protocolId,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('versionTag', instance.versionTag);
  return val;
}

GetAllFor _$GetAllForFromJson(Map<String, dynamic> json) => GetAllFor(
      json['ownerId'] as String?,
    )..$type = json[r'$type'] as String?;

Map<String, dynamic> _$GetAllForToJson(GetAllFor instance) => <String, dynamic>{
      r'$type': instance.$type,
      'ownerId': instance.ownerId,
    };

GetVersionHistoryFor _$GetVersionHistoryForFromJson(
        Map<String, dynamic> json) =>
    GetVersionHistoryFor(
      json['protocolId'] == null
          ? null
          : StudyProtocolId.fromJson(
              json['protocolId'] as Map<String, dynamic>),
    )..$type = json[r'$type'] as String?;

Map<String, dynamic> _$GetVersionHistoryForToJson(
        GetVersionHistoryFor instance) =>
    <String, dynamic>{
      r'$type': instance.$type,
      'protocolId': instance.protocolId,
    };

CreateCustomProtocol _$CreateCustomProtocolFromJson(
        Map<String, dynamic> json) =>
    CreateCustomProtocol(
      json['ownerId'] as String?,
      json['name'] as String?,
      json['description'] as String?,
      json['customProtocol'] as String?,
    )..$type = json[r'$type'] as String?;

Map<String, dynamic> _$CreateCustomProtocolToJson(
        CreateCustomProtocol instance) =>
    <String, dynamic>{
      r'$type': instance.$type,
      'ownerId': instance.ownerId,
      'name': instance.name,
      'description': instance.description,
      'customProtocol': instance.customProtocol,
    };
