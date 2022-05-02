// GENERATED CODE - DO NOT MODIFY BY HAND

part of domain;

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SmartphoneStudyProtocol _$SmartphoneStudyProtocolFromJson(
        Map<String, dynamic> json) =>
    SmartphoneStudyProtocol(
      ownerId: json['ownerId'] as String,
      name: json['name'] as String,
      protocolDescription: json['protocolDescription'] == null
          ? null
          : StudyDescription.fromJson(
              json['protocolDescription'] as Map<String, dynamic>),
      dataEndPoint: json['dataEndPoint'] == null
          ? null
          : DataEndPoint.fromJson(json['dataEndPoint'] as Map<String, dynamic>),
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
              .toList()
      ..description = json['description'] as String;

Map<String, dynamic> _$SmartphoneStudyProtocolToJson(
    SmartphoneStudyProtocol instance) {
  final val = <String, dynamic>{
    'ownerId': instance.ownerId,
    'name': instance.name,
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
  writeNotNull('protocolDescription', instance.protocolDescription);
  val['description'] = instance.description;
  writeNotNull('dataEndPoint', instance.dataEndPoint);
  return val;
}

StudyDescription _$StudyDescriptionFromJson(Map<String, dynamic> json) =>
    StudyDescription(
      title: json['title'] as String,
      description: json['description'] as String,
      purpose: json['purpose'] as String,
      studyDescriptionUrl: json['studyDescriptionUrl'] as String?,
      privacyPolicyUrl: json['privacyPolicyUrl'] as String?,
      responsible: json['responsible'] == null
          ? null
          : StudyResponsible.fromJson(
              json['responsible'] as Map<String, dynamic>),
    )..$type = json[r'$type'] as String?;

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
  writeNotNull('studyDescriptionUrl', instance.studyDescriptionUrl);
  writeNotNull('privacyPolicyUrl', instance.privacyPolicyUrl);
  writeNotNull('responsible', instance.responsible);
  return val;
}

StudyResponsible _$StudyResponsibleFromJson(Map<String, dynamic> json) =>
    StudyResponsible(
      id: json['id'] as String,
      name: json['name'] as String,
      title: json['title'] as String,
      email: json['email'] as String,
      affiliation: json['affiliation'] as String,
      address: json['address'] as String,
    )..$type = json[r'$type'] as String?;

Map<String, dynamic> _$StudyResponsibleToJson(StudyResponsible instance) {
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

FileDataEndPoint _$FileDataEndPointFromJson(Map<String, dynamic> json) =>
    FileDataEndPoint(
      type: json['type'] as String? ?? DataEndPointTypes.FILE,
      dataFormat: json['dataFormat'] as String? ?? NameSpace.CARP,
      bufferSize: json['bufferSize'] as int? ?? 500 * 1000,
      zip: json['zip'] as bool? ?? true,
      encrypt: json['encrypt'] as bool? ?? false,
      publicKey: json['publicKey'] as String?,
    )..$type = json[r'$type'] as String?;

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

PersistentSamplingConfiguration _$PersistentSamplingConfigurationFromJson(
        Map<String, dynamic> json) =>
    PersistentSamplingConfiguration()
      ..$type = json[r'$type'] as String?
      ..lastTime = json['lastTime'] == null
          ? null
          : DateTime.parse(json['lastTime'] as String);

Map<String, dynamic> _$PersistentSamplingConfigurationToJson(
    PersistentSamplingConfiguration instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull(r'$type', instance.$type);
  writeNotNull('lastTime', instance.lastTime?.toIso8601String());
  return val;
}

IntervalSamplingConfiguration _$IntervalSamplingConfigurationFromJson(
        Map<String, dynamic> json) =>
    IntervalSamplingConfiguration(
      interval: Duration(microseconds: json['interval'] as int),
    )
      ..$type = json[r'$type'] as String?
      ..lastTime = json['lastTime'] == null
          ? null
          : DateTime.parse(json['lastTime'] as String);

Map<String, dynamic> _$IntervalSamplingConfigurationToJson(
    IntervalSamplingConfiguration instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull(r'$type', instance.$type);
  writeNotNull('lastTime', instance.lastTime?.toIso8601String());
  val['interval'] = instance.interval.inMicroseconds;
  return val;
}

PeriodicSamplingConfiguration _$PeriodicSamplingConfigurationFromJson(
        Map<String, dynamic> json) =>
    PeriodicSamplingConfiguration(
      interval: Duration(microseconds: json['interval'] as int),
      duration: Duration(microseconds: json['duration'] as int),
    )
      ..$type = json[r'$type'] as String?
      ..lastTime = json['lastTime'] == null
          ? null
          : DateTime.parse(json['lastTime'] as String);

Map<String, dynamic> _$PeriodicSamplingConfigurationToJson(
    PeriodicSamplingConfiguration instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull(r'$type', instance.$type);
  writeNotNull('lastTime', instance.lastTime?.toIso8601String());
  val['interval'] = instance.interval.inMicroseconds;
  val['duration'] = instance.duration.inMicroseconds;
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

ConnectableDeviceDescriptor _$ConnectableDeviceDescriptorFromJson(
        Map<String, dynamic> json) =>
    ConnectableDeviceDescriptor(
      deviceType: json['deviceType'] as String,
      roleName: json['roleName'] as String,
      supportedDataTypes: (json['supportedDataTypes'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      name: json['name'] as String?,
    )
      ..$type = json[r'$type'] as String?
      ..isMasterDevice = json['isMasterDevice'] as bool?
      ..samplingConfiguration =
          (json['samplingConfiguration'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(
            k, SamplingConfiguration.fromJson(e as Map<String, dynamic>)),
      )
      ..collectingMeasureTypes =
          (json['collectingMeasureTypes'] as List<dynamic>)
              .map((e) => e as String)
              .toList();

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

SmartphoneDeployment _$SmartphoneDeploymentFromJson(
        Map<String, dynamic> json) =>
    SmartphoneDeployment(
      studyDeploymentId: json['studyDeploymentId'] as String?,
      deviceDescriptor: MasterDeviceDescriptor.fromJson(
          json['deviceDescriptor'] as Map<String, dynamic>),
      configuration: DeviceRegistration.fromJson(
          json['configuration'] as Map<String, dynamic>),
      connectedDevices: (json['connectedDevices'] as List<dynamic>?)
              ?.map((e) => DeviceDescriptor.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      connectedDeviceConfigurations: (json['connectedDeviceConfigurations']
                  as Map<String, dynamic>?)
              ?.map(
            (k, e) => MapEntry(
                k,
                e == null
                    ? null
                    : DeviceRegistration.fromJson(e as Map<String, dynamic>)),
          ) ??
          const {},
      tasks: (json['tasks'] as List<dynamic>?)
              ?.map((e) => TaskDescriptor.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      triggers: (json['triggers'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, Trigger.fromJson(e as Map<String, dynamic>)),
          ) ??
          const {},
      triggeredTasks: (json['triggeredTasks'] as List<dynamic>?)
              ?.map((e) => TriggeredTask.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      protocolDescription: json['protocolDescription'] == null
          ? null
          : StudyDescription.fromJson(
              json['protocolDescription'] as Map<String, dynamic>),
      dataEndPoint: json['dataEndPoint'] == null
          ? null
          : DataEndPoint.fromJson(json['dataEndPoint'] as Map<String, dynamic>),
    )
      ..lastUpdateDate = DateTime.parse(json['lastUpdateDate'] as String)
      ..deployed = json['deployed'] == null
          ? null
          : DateTime.parse(json['deployed'] as String)
      ..userId = json['userId'] as String?;

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

  writeNotNull('deployed', instance.deployed?.toIso8601String());
  writeNotNull('userId', instance.userId);
  writeNotNull('protocolDescription', instance.protocolDescription);
  writeNotNull('dataEndPoint', instance.dataEndPoint);
  return val;
}

AutomaticTask _$AutomaticTaskFromJson(Map<String, dynamic> json) =>
    AutomaticTask(
      name: json['name'] as String?,
    )
      ..$type = json[r'$type'] as String?
      ..measures = (json['measures'] as List<dynamic>)
          .map((e) => Measure.fromJson(e as Map<String, dynamic>))
          .toList();

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

AppTask _$AppTaskFromJson(Map<String, dynamic> json) => AppTask(
      name: json['name'] as String?,
      type: json['type'] as String,
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      instructions: json['instructions'] as String? ?? '',
      minutesToComplete: json['minutes_to_complete'] as int?,
      expire: json['expire'] == null
          ? null
          : Duration(microseconds: json['expire'] as int),
      notification: json['notification'] as bool? ?? false,
    )
      ..$type = json[r'$type'] as String?
      ..measures = (json['measures'] as List<dynamic>)
          .map((e) => Measure.fromJson(e as Map<String, dynamic>))
          .toList();

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

ImmediateTrigger _$ImmediateTriggerFromJson(Map<String, dynamic> json) =>
    ImmediateTrigger()
      ..$type = json[r'$type'] as String?
      ..sourceDeviceRoleName = json['sourceDeviceRoleName'] as String?;

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

OneTimeTrigger _$OneTimeTriggerFromJson(Map<String, dynamic> json) =>
    OneTimeTrigger()
      ..$type = json[r'$type'] as String?
      ..sourceDeviceRoleName = json['sourceDeviceRoleName'] as String?
      ..triggerTimestamp = json['triggerTimestamp'] == null
          ? null
          : DateTime.parse(json['triggerTimestamp'] as String);

Map<String, dynamic> _$OneTimeTriggerToJson(OneTimeTrigger instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull(r'$type', instance.$type);
  writeNotNull('sourceDeviceRoleName', instance.sourceDeviceRoleName);
  writeNotNull(
      'triggerTimestamp', instance.triggerTimestamp?.toIso8601String());
  return val;
}

PassiveTrigger _$PassiveTriggerFromJson(Map<String, dynamic> json) =>
    PassiveTrigger()
      ..$type = json[r'$type'] as String?
      ..sourceDeviceRoleName = json['sourceDeviceRoleName'] as String?;

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

DelayedTrigger _$DelayedTriggerFromJson(Map<String, dynamic> json) =>
    DelayedTrigger(
      delay: Duration(microseconds: json['delay'] as int),
    )
      ..$type = json[r'$type'] as String?
      ..sourceDeviceRoleName = json['sourceDeviceRoleName'] as String?;

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

IntervalTrigger _$IntervalTriggerFromJson(Map<String, dynamic> json) =>
    IntervalTrigger(
      period: Duration(microseconds: json['period'] as int),
    )
      ..$type = json[r'$type'] as String?
      ..sourceDeviceRoleName = json['sourceDeviceRoleName'] as String?;

Map<String, dynamic> _$IntervalTriggerToJson(IntervalTrigger instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull(r'$type', instance.$type);
  writeNotNull('sourceDeviceRoleName', instance.sourceDeviceRoleName);
  val['period'] = instance.period.inMicroseconds;
  return val;
}

PeriodicTrigger _$PeriodicTriggerFromJson(Map<String, dynamic> json) =>
    PeriodicTrigger(
      period: Duration(microseconds: json['period'] as int),
      duration: Duration(microseconds: json['duration'] as int),
    )
      ..$type = json[r'$type'] as String?
      ..sourceDeviceRoleName = json['sourceDeviceRoleName'] as String?;

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

DateTimeTrigger _$DateTimeTriggerFromJson(Map<String, dynamic> json) =>
    DateTimeTrigger(
      schedule: DateTime.parse(json['schedule'] as String),
      duration: json['duration'] == null
          ? null
          : Duration(microseconds: json['duration'] as int),
    )
      ..$type = json[r'$type'] as String?
      ..sourceDeviceRoleName = json['sourceDeviceRoleName'] as String?;

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

Time _$TimeFromJson(Map<String, dynamic> json) => Time(
      hour: json['hour'] as int? ?? 0,
      minute: json['minute'] as int? ?? 0,
      second: json['second'] as int? ?? 0,
    )..$type = json[r'$type'] as String?;

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
        Map<String, dynamic> json) =>
    RecurrentScheduledTrigger(
      type: $enumDecode(_$RecurrentTypeEnumMap, json['type']),
      time: Time.fromJson(json['time'] as Map<String, dynamic>),
      end: json['end'] == null ? null : DateTime.parse(json['end'] as String),
      separationCount: json['separationCount'] as int? ?? 0,
      maxNumberOfSampling: json['maxNumberOfSampling'] as int?,
      dayOfWeek: json['dayOfWeek'] as int?,
      weekOfMonth: json['weekOfMonth'] as int?,
      dayOfMonth: json['dayOfMonth'] as int?,
      remember: json['remember'] as bool? ?? false,
      triggerId: json['triggerId'] as String?,
      duration: json['duration'] == null
          ? null
          : Duration(microseconds: json['duration'] as int),
    )
      ..$type = json[r'$type'] as String?
      ..sourceDeviceRoleName = json['sourceDeviceRoleName'] as String?
      ..period = Duration(microseconds: json['period'] as int);

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

CronScheduledTrigger _$CronScheduledTriggerFromJson(
        Map<String, dynamic> json) =>
    CronScheduledTrigger(
      duration: json['duration'] == null
          ? null
          : Duration(microseconds: json['duration'] as int),
    )
      ..$type = json[r'$type'] as String?
      ..sourceDeviceRoleName = json['sourceDeviceRoleName'] as String?
      ..cronExpression = json['cronExpression'] as String;

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

SamplingEventTrigger _$SamplingEventTriggerFromJson(
        Map<String, dynamic> json) =>
    SamplingEventTrigger(
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

ConditionalEvent _$ConditionalEventFromJson(Map<String, dynamic> json) =>
    ConditionalEvent(
      json['condition'] as Map<String, dynamic>,
    )..$type = json[r'$type'] as String?;

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
        Map<String, dynamic> json) =>
    ConditionalSamplingEventTrigger(
      measureType: json['measureType'] as String,
    )
      ..$type = json[r'$type'] as String?
      ..sourceDeviceRoleName = json['sourceDeviceRoleName'] as String?;

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

ConditionalPeriodicTrigger _$ConditionalPeriodicTriggerFromJson(
        Map<String, dynamic> json) =>
    ConditionalPeriodicTrigger(
      period: Duration(microseconds: json['period'] as int),
    )
      ..$type = json[r'$type'] as String?
      ..sourceDeviceRoleName = json['sourceDeviceRoleName'] as String?;

Map<String, dynamic> _$ConditionalPeriodicTriggerToJson(
    ConditionalPeriodicTrigger instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull(r'$type', instance.$type);
  writeNotNull('sourceDeviceRoleName', instance.sourceDeviceRoleName);
  val['period'] = instance.period.inMicroseconds;
  return val;
}

RandomRecurrentTrigger _$RandomRecurrentTriggerFromJson(
        Map<String, dynamic> json) =>
    RandomRecurrentTrigger(
      minNumberOfTriggers: json['minNumberOfTriggers'] as int? ?? 0,
      maxNumberOfTriggers: json['maxNumberOfTriggers'] as int? ?? 1,
      startTime: Time.fromJson(json['startTime'] as Map<String, dynamic>),
      endTime: Time.fromJson(json['endTime'] as Map<String, dynamic>),
      duration: json['duration'] == null
          ? null
          : Duration(microseconds: json['duration'] as int),
    )
      ..$type = json[r'$type'] as String?
      ..sourceDeviceRoleName = json['sourceDeviceRoleName'] as String?
      ..lastTriggerTimestamp = json['lastTriggerTimestamp'] == null
          ? null
          : DateTime.parse(json['lastTriggerTimestamp'] as String);

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
  writeNotNull(
      'lastTriggerTimestamp', instance.lastTriggerTimestamp?.toIso8601String());
  return val;
}

Datum _$DatumFromJson(Map<String, dynamic> json) => Datum()
  ..id = json['id'] as String?
  ..timestamp = DateTime.parse(json['timestamp'] as String);

Map<String, dynamic> _$DatumToJson(Datum instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  val['timestamp'] = instance.timestamp.toIso8601String();
  return val;
}

StringDatum _$StringDatumFromJson(Map<String, dynamic> json) => StringDatum(
      json['str'] as String,
    )
      ..id = json['id'] as String?
      ..timestamp = DateTime.parse(json['timestamp'] as String);

Map<String, dynamic> _$StringDatumToJson(StringDatum instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  val['timestamp'] = instance.timestamp.toIso8601String();
  val['str'] = instance.str;
  return val;
}

MapDatum _$MapDatumFromJson(Map<String, dynamic> json) => MapDatum(
      Map<String, String>.from(json['map'] as Map),
    )
      ..id = json['id'] as String?
      ..timestamp = DateTime.parse(json['timestamp'] as String);

Map<String, dynamic> _$MapDatumToJson(MapDatum instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  val['timestamp'] = instance.timestamp.toIso8601String();
  val['map'] = instance.map;
  return val;
}

ErrorDatum _$ErrorDatumFromJson(Map<String, dynamic> json) => ErrorDatum(
      json['message'] as String,
    )
      ..id = json['id'] as String?
      ..timestamp = DateTime.parse(json['timestamp'] as String);

Map<String, dynamic> _$ErrorDatumToJson(ErrorDatum instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  val['timestamp'] = instance.timestamp.toIso8601String();
  val['message'] = instance.message;
  return val;
}

FileDatum _$FileDatumFromJson(Map<String, dynamic> json) => FileDatum(
      filename: json['filename'] as String,
      upload: json['upload'] as bool? ?? true,
    )
      ..id = json['id'] as String?
      ..timestamp = DateTime.parse(json['timestamp'] as String)
      ..metadata = (json['metadata'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      );

Map<String, dynamic> _$FileDatumToJson(FileDatum instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  val['timestamp'] = instance.timestamp.toIso8601String();
  val['filename'] = instance.filename;
  val['upload'] = instance.upload;
  writeNotNull('metadata', instance.metadata);
  return val;
}

MultiDatum _$MultiDatumFromJson(Map<String, dynamic> json) => MultiDatum()
  ..id = json['id'] as String?
  ..timestamp = DateTime.parse(json['timestamp'] as String)
  ..data = (json['data'] as List<dynamic>)
      .map((e) => Datum.fromJson(e as Map<String, dynamic>))
      .toList();

Map<String, dynamic> _$MultiDatumToJson(MultiDatum instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  val['timestamp'] = instance.timestamp.toIso8601String();
  val['data'] = instance.data;
  return val;
}
