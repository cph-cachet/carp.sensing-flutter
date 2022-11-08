// GENERATED CODE - DO NOT MODIFY BY HAND

part of carp_core_common;

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ParticipantRole _$ParticipantRoleFromJson(Map<String, dynamic> json) =>
    ParticipantRole(
      json['role'] as String,
      json['isOptional'] as bool,
    );

Map<String, dynamic> _$ParticipantRoleToJson(ParticipantRole instance) =>
    <String, dynamic>{
      'role': instance.role,
      'isOptional': instance.isOptional,
    };

ExpectedParticipantData _$ExpectedParticipantDataFromJson(
        Map<String, dynamic> json) =>
    ExpectedParticipantData(
      json['attribute'] == null
          ? null
          : ParticipantAttribute.fromJson(
              json['attribute'] as Map<String, dynamic>),
      AssignedTo.fromJson(json['assignedTo'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ExpectedParticipantDataToJson(
    ExpectedParticipantData instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('attribute', instance.attribute);
  val['assignedTo'] = instance.assignedTo;
  return val;
}

ParticipantAttribute _$ParticipantAttributeFromJson(
        Map<String, dynamic> json) =>
    ParticipantAttribute(
      json['inputDataType'] == null
          ? null
          : DataType.fromJson(json['inputDataType'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ParticipantAttributeToJson(
    ParticipantAttribute instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('inputDataType', instance.inputDataType);
  return val;
}

AssignedTo _$AssignedToFromJson(Map<String, dynamic> json) => AssignedTo()
  ..roleNames =
      (json['roleNames'] as List<dynamic>).map((e) => e as String).toSet();

Map<String, dynamic> _$AssignedToToJson(AssignedTo instance) =>
    <String, dynamic>{
      'roleNames': instance.roleNames.toList(),
    };

Measure _$MeasureFromJson(Map<String, dynamic> json) => Measure(
      type: json['type'] as String,
    )
      ..$type = json['__type'] as String?
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

  writeNotNull('__type', instance.$type);
  val['type'] = instance.type;
  writeNotNull(
      'overrideSamplingConfiguration', instance.overrideSamplingConfiguration);
  return val;
}

TaskConfiguration _$TaskConfigurationFromJson(Map<String, dynamic> json) =>
    TaskConfiguration(
      name: json['name'] as String?,
      measures: (json['measures'] as List<dynamic>?)
          ?.map((e) => Measure.fromJson(e as Map<String, dynamic>))
          .toList(),
    )
      ..$type = json['__type'] as String?
      ..description = json['description'] as String?;

Map<String, dynamic> _$TaskConfigurationToJson(TaskConfiguration instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('__type', instance.$type);
  val['name'] = instance.name;
  writeNotNull('description', instance.description);
  writeNotNull('measures', instance.measures);
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
    )
      ..$type = json['__type'] as String?
      ..description = json['description'] as String?;

Map<String, dynamic> _$BackgroundTaskToJson(BackgroundTask instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('__type', instance.$type);
  val['name'] = instance.name;
  writeNotNull('description', instance.description);
  writeNotNull('measures', instance.measures);
  writeNotNull('duration', instance.duration?.inMicroseconds);
  return val;
}

CustomProtocolTask _$CustomProtocolTaskFromJson(Map<String, dynamic> json) =>
    CustomProtocolTask(
      name: json['name'] as String?,
      studyProtocol: json['studyProtocol'] as String,
    )
      ..$type = json['__type'] as String?
      ..description = json['description'] as String?
      ..measures = (json['measures'] as List<dynamic>?)
          ?.map((e) => Measure.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$CustomProtocolTaskToJson(CustomProtocolTask instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('__type', instance.$type);
  val['name'] = instance.name;
  writeNotNull('description', instance.description);
  writeNotNull('measures', instance.measures);
  val['studyProtocol'] = instance.studyProtocol;
  return val;
}

DeviceConfiguration _$DeviceConfigurationFromJson(Map<String, dynamic> json) =>
    DeviceConfiguration(
      roleName: json['roleName'] as String,
      isOptional: json['isOptional'] as bool? ?? false,
      supportedDataTypes: (json['supportedDataTypes'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    )
      ..$type = json['__type'] as String?
      ..defaultSamplingConfiguration =
          (json['defaultSamplingConfiguration'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(
            k, SamplingConfiguration.fromJson(e as Map<String, dynamic>)),
      );

Map<String, dynamic> _$DeviceConfigurationToJson(DeviceConfiguration instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('__type', instance.$type);
  val['roleName'] = instance.roleName;
  writeNotNull('isOptional', instance.isOptional);
  writeNotNull('supportedDataTypes', instance.supportedDataTypes);
  writeNotNull(
      'defaultSamplingConfiguration', instance.defaultSamplingConfiguration);
  return val;
}

PrimaryDeviceConfiguration _$PrimaryDeviceConfigurationFromJson(
        Map<String, dynamic> json) =>
    PrimaryDeviceConfiguration(
      roleName: json['roleName'] as String,
      supportedDataTypes: (json['supportedDataTypes'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    )
      ..$type = json['__type'] as String?
      ..isOptional = json['isOptional'] as bool?
      ..defaultSamplingConfiguration =
          (json['defaultSamplingConfiguration'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(
            k, SamplingConfiguration.fromJson(e as Map<String, dynamic>)),
      )
      ..isPrimaryDevice = json['isPrimaryDevice'] as bool;

Map<String, dynamic> _$PrimaryDeviceConfigurationToJson(
    PrimaryDeviceConfiguration instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('__type', instance.$type);
  val['roleName'] = instance.roleName;
  writeNotNull('isOptional', instance.isOptional);
  writeNotNull('supportedDataTypes', instance.supportedDataTypes);
  writeNotNull(
      'defaultSamplingConfiguration', instance.defaultSamplingConfiguration);
  val['isPrimaryDevice'] = instance.isPrimaryDevice;
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
      ..$type = json['__type'] as String?
      ..isOptional = json['isOptional'] as bool?
      ..defaultSamplingConfiguration =
          (json['defaultSamplingConfiguration'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(
            k, SamplingConfiguration.fromJson(e as Map<String, dynamic>)),
      )
      ..isPrimaryDevice = json['isPrimaryDevice'] as bool;

Map<String, dynamic> _$CustomProtocolDeviceToJson(
    CustomProtocolDevice instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('__type', instance.$type);
  val['roleName'] = instance.roleName;
  writeNotNull('isOptional', instance.isOptional);
  writeNotNull('supportedDataTypes', instance.supportedDataTypes);
  writeNotNull(
      'defaultSamplingConfiguration', instance.defaultSamplingConfiguration);
  val['isPrimaryDevice'] = instance.isPrimaryDevice;
  return val;
}

Smartphone _$SmartphoneFromJson(Map<String, dynamic> json) => Smartphone(
      roleName: json['roleName'] as String? ?? Smartphone.DEFAULT_ROLENAME,
      supportedDataTypes: (json['supportedDataTypes'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    )
      ..$type = json['__type'] as String?
      ..isOptional = json['isOptional'] as bool?
      ..defaultSamplingConfiguration =
          (json['defaultSamplingConfiguration'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(
            k, SamplingConfiguration.fromJson(e as Map<String, dynamic>)),
      )
      ..isPrimaryDevice = json['isPrimaryDevice'] as bool;

Map<String, dynamic> _$SmartphoneToJson(Smartphone instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('__type', instance.$type);
  val['roleName'] = instance.roleName;
  writeNotNull('isOptional', instance.isOptional);
  writeNotNull('supportedDataTypes', instance.supportedDataTypes);
  writeNotNull(
      'defaultSamplingConfiguration', instance.defaultSamplingConfiguration);
  val['isPrimaryDevice'] = instance.isPrimaryDevice;
  return val;
}

AltBeacon _$AltBeaconFromJson(Map<String, dynamic> json) => AltBeacon(
      roleName: json['roleName'] as String? ?? 'AltBeacon',
      supportedDataTypes: (json['supportedDataTypes'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    )
      ..$type = json['__type'] as String?
      ..isOptional = json['isOptional'] as bool?
      ..defaultSamplingConfiguration =
          (json['defaultSamplingConfiguration'] as Map<String, dynamic>?)?.map(
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

  writeNotNull('__type', instance.$type);
  val['roleName'] = instance.roleName;
  writeNotNull('isOptional', instance.isOptional);
  writeNotNull('supportedDataTypes', instance.supportedDataTypes);
  writeNotNull(
      'defaultSamplingConfiguration', instance.defaultSamplingConfiguration);
  return val;
}

DeviceRegistration _$DeviceRegistrationFromJson(Map<String, dynamic> json) =>
    DeviceRegistration(
      json['deviceId'] as String?,
      json['deviceDisplayName'] as String?,
      json['registrationCreatedOn'] == null
          ? null
          : DateTime.parse(json['registrationCreatedOn'] as String),
    )..$type = json['__type'] as String?;

Map<String, dynamic> _$DeviceRegistrationToJson(DeviceRegistration instance) =>
    <String, dynamic>{
      '__type': instance.$type,
      'deviceId': instance.deviceId,
      'deviceDisplayName': instance.deviceDisplayName,
      'registrationCreatedOn': instance.registrationCreatedOn.toIso8601String(),
    };

TriggerConfiguration _$TriggerConfigurationFromJson(
        Map<String, dynamic> json) =>
    TriggerConfiguration(
      sourceDeviceRoleName: json['sourceDeviceRoleName'] as String?,
    )..$type = json['__type'] as String?;

Map<String, dynamic> _$TriggerConfigurationToJson(
    TriggerConfiguration instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('__type', instance.$type);
  writeNotNull('sourceDeviceRoleName', instance.sourceDeviceRoleName);
  return val;
}

ElapsedTimeTrigger _$ElapsedTimeTriggerFromJson(Map<String, dynamic> json) =>
    ElapsedTimeTrigger(
      sourceDeviceRoleName: json['sourceDeviceRoleName'] as String?,
      elapsedTime: Duration(microseconds: json['elapsedTime'] as int),
    )..$type = json['__type'] as String?;

Map<String, dynamic> _$ElapsedTimeTriggerToJson(ElapsedTimeTrigger instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('__type', instance.$type);
  writeNotNull('sourceDeviceRoleName', instance.sourceDeviceRoleName);
  val['elapsedTime'] = instance.elapsedTime.inMicroseconds;
  return val;
}

ManualTrigger _$ManualTriggerFromJson(Map<String, dynamic> json) =>
    ManualTrigger(
      sourceDeviceRoleName: json['source_device_role_name'] as String?,
      label: json['label'] as String?,
      description: json['description'] as String?,
    )..$type = json['__type'] as String?;

Map<String, dynamic> _$ManualTriggerToJson(ManualTrigger instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('__type', instance.$type);
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
    )..$type = json['__type'] as String?;

Map<String, dynamic> _$ScheduledTriggerToJson(ScheduledTrigger instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('__type', instance.$type);
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
    SamplingConfiguration()..$type = json['__type'] as String?;

Map<String, dynamic> _$SamplingConfigurationToJson(
    SamplingConfiguration instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('__type', instance.$type);
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
    )..$type = json['__type'] as String?;

Map<String, dynamic> _$BatteryAwareSamplingConfigurationToJson(
    BatteryAwareSamplingConfiguration instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('__type', instance.$type);
  val['normal'] = instance.normal;
  val['low'] = instance.low;
  val['critical'] = instance.critical;
  return val;
}

GranularitySamplingConfiguration _$GranularitySamplingConfigurationFromJson(
        Map<String, dynamic> json) =>
    GranularitySamplingConfiguration(
      $enumDecode(_$GranularityEnumMap, json['granularity']),
    )..$type = json['__type'] as String?;

Map<String, dynamic> _$GranularitySamplingConfigurationToJson(
        GranularitySamplingConfiguration instance) =>
    <String, dynamic>{
      '__type': instance.$type,
      'granularity': _$GranularityEnumMap[instance.granularity]!,
    };

const _$GranularityEnumMap = {
  Granularity.Detailed: 'Detailed',
  Granularity.Balanced: 'Balanced',
  Granularity.Coarse: 'Coarse',
};

DataType _$DataTypeFromJson(Map<String, dynamic> json) => DataType(
      json['namespace'] as String,
      json['name'] as String,
    );

Map<String, dynamic> _$DataTypeToJson(DataType instance) => <String, dynamic>{
      'namespace': instance.namespace,
      'name': instance.name,
    };
