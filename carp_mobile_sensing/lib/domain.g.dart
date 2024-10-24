// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'domain.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SmartphoneApplicationData _$SmartphoneApplicationDataFromJson(
        Map<String, dynamic> json) =>
    SmartphoneApplicationData(
      studyDescription: json['studyDescription'] == null
          ? null
          : StudyDescription.fromJson(
              json['studyDescription'] as Map<String, dynamic>),
      dataEndPoint: json['dataEndPoint'] == null
          ? null
          : DataEndPoint.fromJson(json['dataEndPoint'] as Map<String, dynamic>),
      privacySchemaName: json['privacySchemaName'] as String?,
      applicationData: json['applicationData'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$SmartphoneApplicationDataToJson(
    SmartphoneApplicationData instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('studyDescription', instance.studyDescription?.toJson());
  writeNotNull('dataEndPoint', instance.dataEndPoint?.toJson());
  writeNotNull('privacySchemaName', instance.privacySchemaName);
  writeNotNull('applicationData', instance.applicationData);
  return val;
}

SmartphoneStudyProtocol _$SmartphoneStudyProtocolFromJson(
        Map<String, dynamic> json) =>
    SmartphoneStudyProtocol(
      ownerId: json['ownerId'] as String?,
      name: json['name'] as String,
    )
      ..applicationData = json['applicationData'] as Map<String, dynamic>?
      ..id = json['id'] as String
      ..createdOn = DateTime.parse(json['createdOn'] as String)
      ..version = (json['version'] as num).toInt()
      ..description = json['description'] as String
      ..participantRoles = (json['participantRoles'] as List<dynamic>?)
          ?.map((e) => ParticipantRole.fromJson(e as Map<String, dynamic>))
          .toSet()
      ..primaryDevices = (json['primaryDevices'] as List<dynamic>)
          .map((e) => PrimaryDeviceConfiguration<DeviceRegistration>.fromJson(
              e as Map<String, dynamic>))
          .toSet()
      ..connectedDevices = (json['connectedDevices'] as List<dynamic>?)
          ?.map((e) => DeviceConfiguration<DeviceRegistration>.fromJson(
              e as Map<String, dynamic>))
          .toSet()
      ..connections = (json['connections'] as List<dynamic>?)
          ?.map((e) => DeviceConnection.fromJson(e as Map<String, dynamic>))
          .toList()
      ..assignedDevices =
          (json['assignedDevices'] as Map<String, dynamic>?)?.map(
        (k, e) =>
            MapEntry(k, (e as List<dynamic>).map((e) => e as String).toSet()),
      )
      ..tasks = (json['tasks'] as List<dynamic>)
          .map((e) => TaskConfiguration.fromJson(e as Map<String, dynamic>))
          .toSet()
      ..triggers = (json['triggers'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(
            k, TriggerConfiguration.fromJson(e as Map<String, dynamic>)),
      )
      ..taskControls = (json['taskControls'] as List<dynamic>)
          .map((e) => TaskControl.fromJson(e as Map<String, dynamic>))
          .toSet()
      ..expectedParticipantData =
          (json['expectedParticipantData'] as List<dynamic>?)
              ?.map((e) =>
                  ExpectedParticipantData.fromJson(e as Map<String, dynamic>))
              .toSet();

Map<String, dynamic> _$SmartphoneStudyProtocolToJson(
    SmartphoneStudyProtocol instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('applicationData', instance.applicationData);
  val['id'] = instance.id;
  val['createdOn'] = instance.createdOn.toIso8601String();
  val['version'] = instance.version;
  val['description'] = instance.description;
  val['ownerId'] = instance.ownerId;
  val['name'] = instance.name;
  writeNotNull('participantRoles',
      instance.participantRoles?.map((e) => e.toJson()).toList());
  val['primaryDevices'] =
      instance.primaryDevices.map((e) => e.toJson()).toList();
  writeNotNull('connectedDevices',
      instance.connectedDevices?.map((e) => e.toJson()).toList());
  writeNotNull(
      'connections', instance.connections?.map((e) => e.toJson()).toList());
  writeNotNull('assignedDevices',
      instance.assignedDevices?.map((k, e) => MapEntry(k, e.toList())));
  val['tasks'] = instance.tasks.map((e) => e.toJson()).toList();
  val['triggers'] = instance.triggers.map((k, e) => MapEntry(k, e.toJson()));
  val['taskControls'] = instance.taskControls.map((e) => e.toJson()).toList();
  writeNotNull('expectedParticipantData',
      instance.expectedParticipantData?.map((e) => e.toJson()).toList());
  return val;
}

StudyDescription _$StudyDescriptionFromJson(Map<String, dynamic> json) =>
    StudyDescription(
      title: json['title'] as String,
      description: json['description'] as String?,
      purpose: json['purpose'] as String?,
      studyDescriptionUrl: json['studyDescriptionUrl'] as String?,
      privacyPolicyUrl: json['privacyPolicyUrl'] as String?,
      responsible: json['responsible'] == null
          ? null
          : StudyResponsible.fromJson(
              json['responsible'] as Map<String, dynamic>),
    )..$type = json['__type'] as String?;

Map<String, dynamic> _$StudyDescriptionToJson(StudyDescription instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('__type', instance.$type);
  val['title'] = instance.title;
  writeNotNull('description', instance.description);
  writeNotNull('purpose', instance.purpose);
  writeNotNull('studyDescriptionUrl', instance.studyDescriptionUrl);
  writeNotNull('privacyPolicyUrl', instance.privacyPolicyUrl);
  writeNotNull('responsible', instance.responsible?.toJson());
  return val;
}

StudyResponsible _$StudyResponsibleFromJson(Map<String, dynamic> json) =>
    StudyResponsible(
      id: json['id'] as String,
      name: json['name'] as String,
      title: json['title'] as String?,
      email: json['email'] as String?,
      affiliation: json['affiliation'] as String?,
      address: json['address'] as String?,
    )..$type = json['__type'] as String?;

Map<String, dynamic> _$StudyResponsibleToJson(StudyResponsible instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('__type', instance.$type);
  val['id'] = instance.id;
  val['name'] = instance.name;
  writeNotNull('title', instance.title);
  writeNotNull('email', instance.email);
  writeNotNull('address', instance.address);
  writeNotNull('affiliation', instance.affiliation);
  return val;
}

DataEndPoint _$DataEndPointFromJson(Map<String, dynamic> json) => DataEndPoint(
      type: json['type'] as String,
      dataFormat: json['dataFormat'] as String? ?? NameSpace.CARP,
    )..$type = json['__type'] as String?;

Map<String, dynamic> _$DataEndPointToJson(DataEndPoint instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('__type', instance.$type);
  val['type'] = instance.type;
  val['dataFormat'] = instance.dataFormat;
  return val;
}

FileDataEndPoint _$FileDataEndPointFromJson(Map<String, dynamic> json) =>
    FileDataEndPoint(
      type: json['type'] as String? ?? DataEndPointTypes.FILE,
      dataFormat: json['dataFormat'] as String? ?? NameSpace.CARP,
      bufferSize: (json['bufferSize'] as num?)?.toInt() ?? 500 * 1000,
      zip: json['zip'] as bool? ?? true,
      encrypt: json['encrypt'] as bool? ?? false,
      publicKey: json['publicKey'] as String?,
    )..$type = json['__type'] as String?;

Map<String, dynamic> _$FileDataEndPointToJson(FileDataEndPoint instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('__type', instance.$type);
  val['type'] = instance.type;
  val['dataFormat'] = instance.dataFormat;
  val['bufferSize'] = instance.bufferSize;
  val['zip'] = instance.zip;
  val['encrypt'] = instance.encrypt;
  writeNotNull('publicKey', instance.publicKey);
  return val;
}

SQLiteDataEndPoint _$SQLiteDataEndPointFromJson(Map<String, dynamic> json) =>
    SQLiteDataEndPoint(
      type: json['type'] as String? ?? DataEndPointTypes.SQLITE,
      dataFormat: json['dataFormat'] as String? ?? NameSpace.CARP,
    )..$type = json['__type'] as String?;

Map<String, dynamic> _$SQLiteDataEndPointToJson(SQLiteDataEndPoint instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('__type', instance.$type);
  val['type'] = instance.type;
  val['dataFormat'] = instance.dataFormat;
  return val;
}

PersistentSamplingConfiguration _$PersistentSamplingConfigurationFromJson(
        Map<String, dynamic> json) =>
    PersistentSamplingConfiguration()
      ..$type = json['__type'] as String?
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

  writeNotNull('__type', instance.$type);
  writeNotNull('lastTime', instance.lastTime?.toIso8601String());
  return val;
}

HistoricSamplingConfiguration _$HistoricSamplingConfigurationFromJson(
        Map<String, dynamic> json) =>
    HistoricSamplingConfiguration(
      past: json['past'] == null
          ? null
          : Duration(microseconds: (json['past'] as num).toInt()),
      future: json['future'] == null
          ? null
          : Duration(microseconds: (json['future'] as num).toInt()),
    )
      ..$type = json['__type'] as String?
      ..lastTime = json['lastTime'] == null
          ? null
          : DateTime.parse(json['lastTime'] as String);

Map<String, dynamic> _$HistoricSamplingConfigurationToJson(
    HistoricSamplingConfiguration instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('__type', instance.$type);
  writeNotNull('lastTime', instance.lastTime?.toIso8601String());
  val['past'] = instance.past.inMicroseconds;
  val['future'] = instance.future.inMicroseconds;
  return val;
}

IntervalSamplingConfiguration _$IntervalSamplingConfigurationFromJson(
        Map<String, dynamic> json) =>
    IntervalSamplingConfiguration(
      interval: Duration(microseconds: (json['interval'] as num).toInt()),
    )
      ..$type = json['__type'] as String?
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

  writeNotNull('__type', instance.$type);
  writeNotNull('lastTime', instance.lastTime?.toIso8601String());
  val['interval'] = instance.interval.inMicroseconds;
  return val;
}

PeriodicSamplingConfiguration _$PeriodicSamplingConfigurationFromJson(
        Map<String, dynamic> json) =>
    PeriodicSamplingConfiguration(
      interval: Duration(microseconds: (json['interval'] as num).toInt()),
      duration: Duration(microseconds: (json['duration'] as num).toInt()),
    )
      ..$type = json['__type'] as String?
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

  writeNotNull('__type', instance.$type);
  writeNotNull('lastTime', instance.lastTime?.toIso8601String());
  val['interval'] = instance.interval.inMicroseconds;
  val['duration'] = instance.duration.inMicroseconds;
  return val;
}

OnlineService<TRegistration> _$OnlineServiceFromJson<
        TRegistration extends DeviceRegistration>(Map<String, dynamic> json) =>
    OnlineService<TRegistration>(
      roleName: json['roleName'] as String,
      isOptional: json['isOptional'] as bool? ?? true,
    )
      ..$type = json['__type'] as String?
      ..defaultSamplingConfiguration =
          (json['defaultSamplingConfiguration'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(
            k, SamplingConfiguration.fromJson(e as Map<String, dynamic>)),
      );

Map<String, dynamic>
    _$OnlineServiceToJson<TRegistration extends DeviceRegistration>(
        OnlineService<TRegistration> instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('__type', instance.$type);
  val['roleName'] = instance.roleName;
  writeNotNull('isOptional', instance.isOptional);
  writeNotNull(
      'defaultSamplingConfiguration',
      instance.defaultSamplingConfiguration
          ?.map((k, e) => MapEntry(k, e.toJson())));
  return val;
}

SmartphoneDeployment _$SmartphoneDeploymentFromJson(
        Map<String, dynamic> json) =>
    SmartphoneDeployment(
      studyId: json['studyId'] as String?,
      studyDeploymentId: json['studyDeploymentId'] as String?,
      deviceConfiguration:
          PrimaryDeviceConfiguration<DeviceRegistration>.fromJson(
              json['deviceConfiguration'] as Map<String, dynamic>),
      registration: DeviceRegistration.fromJson(
          json['registration'] as Map<String, dynamic>),
      connectedDevices: (json['connectedDevices'] as List<dynamic>?)
              ?.map((e) => DeviceConfiguration<DeviceRegistration>.fromJson(
                  e as Map<String, dynamic>))
              .toSet() ??
          const {},
      connectedDeviceRegistrations: (json['connectedDeviceRegistrations']
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
              ?.map(
                  (e) => TaskConfiguration.fromJson(e as Map<String, dynamic>))
              .toSet() ??
          const {},
      triggers: (json['triggers'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(
                k, TriggerConfiguration.fromJson(e as Map<String, dynamic>)),
          ) ??
          const {},
      taskControls: (json['taskControls'] as List<dynamic>?)
              ?.map((e) => TaskControl.fromJson(e as Map<String, dynamic>))
              .toSet() ??
          const {},
      expectedParticipantData: (json['expectedParticipantData']
                  as List<dynamic>?)
              ?.map((e) =>
                  ExpectedParticipantData.fromJson(e as Map<String, dynamic>))
              .toSet() ??
          const {},
      participantId: json['participantId'] as String?,
      participantRoleName: json['participantRoleName'] as String?,
    )
      ..applicationData = json['applicationData'] as Map<String, dynamic>?
      ..deployed = json['deployed'] == null
          ? null
          : DateTime.parse(json['deployed'] as String)
      ..status = $enumDecode(_$StudyStatusEnumMap, json['status']);

Map<String, dynamic> _$SmartphoneDeploymentToJson(
    SmartphoneDeployment instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('applicationData', instance.applicationData);
  val['deviceConfiguration'] = instance.deviceConfiguration.toJson();
  val['registration'] = instance.registration.toJson();
  val['connectedDevices'] =
      instance.connectedDevices.map((e) => e.toJson()).toList();
  val['connectedDeviceRegistrations'] = instance.connectedDeviceRegistrations
      .map((k, e) => MapEntry(k, e?.toJson()));
  val['tasks'] = instance.tasks.map((e) => e.toJson()).toList();
  val['triggers'] = instance.triggers.map((k, e) => MapEntry(k, e.toJson()));
  val['taskControls'] = instance.taskControls.map((e) => e.toJson()).toList();
  val['expectedParticipantData'] =
      instance.expectedParticipantData.map((e) => e.toJson()).toList();
  writeNotNull('studyId', instance.studyId);
  val['studyDeploymentId'] = instance.studyDeploymentId;
  writeNotNull('participantId', instance.participantId);
  writeNotNull('participantRoleName', instance.participantRoleName);
  writeNotNull('deployed', instance.deployed?.toIso8601String());
  val['status'] = _$StudyStatusEnumMap[instance.status]!;
  return val;
}

const _$StudyStatusEnumMap = {
  StudyStatus.DeploymentNotStarted: 'DeploymentNotStarted',
  StudyStatus.DeploymentStatusAvailable: 'DeploymentStatusAvailable',
  StudyStatus.Deploying: 'Deploying',
  StudyStatus.AwaitingOtherDeviceRegistrations:
      'AwaitingOtherDeviceRegistrations',
  StudyStatus.AwaitingDeviceDeployment: 'AwaitingDeviceDeployment',
  StudyStatus.DeviceDeploymentReceived: 'DeviceDeploymentReceived',
  StudyStatus.RegisteringDevices: 'RegisteringDevices',
  StudyStatus.Deployed: 'Deployed',
  StudyStatus.Running: 'Running',
  StudyStatus.Stopped: 'Stopped',
  StudyStatus.DeploymentNotAvailable: 'DeploymentNotAvailable',
};

AppTask _$AppTaskFromJson(Map<String, dynamic> json) => AppTask(
      name: json['name'] as String?,
      measures: (json['measures'] as List<dynamic>?)
          ?.map((e) => Measure.fromJson(e as Map<String, dynamic>))
          .toList(),
      type: json['type'] as String,
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      instructions: json['instructions'] as String? ?? '',
      minutesToComplete: (json['minutesToComplete'] as num?)?.toInt(),
      expire: json['expire'] == null
          ? null
          : Duration(microseconds: (json['expire'] as num).toInt()),
      notification: json['notification'] as bool? ?? false,
    )..$type = json['__type'] as String?;

Map<String, dynamic> _$AppTaskToJson(AppTask instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('__type', instance.$type);
  val['name'] = instance.name;
  writeNotNull('measures', instance.measures?.map((e) => e.toJson()).toList());
  val['type'] = instance.type;
  val['title'] = instance.title;
  val['description'] = instance.description;
  val['instructions'] = instance.instructions;
  writeNotNull('minutesToComplete', instance.minutesToComplete);
  writeNotNull('expire', instance.expire?.inMicroseconds);
  val['notification'] = instance.notification;
  return val;
}

FunctionTask _$FunctionTaskFromJson(Map<String, dynamic> json) => FunctionTask(
      name: json['name'] as String?,
      description: json['description'] as String?,
    )
      ..$type = json['__type'] as String?
      ..measures = (json['measures'] as List<dynamic>?)
          ?.map((e) => Measure.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$FunctionTaskToJson(FunctionTask instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('__type', instance.$type);
  val['name'] = instance.name;
  writeNotNull('measures', instance.measures?.map((e) => e.toJson()).toList());
  writeNotNull('description', instance.description);
  return val;
}

NoOpTrigger _$NoOpTriggerFromJson(Map<String, dynamic> json) => NoOpTrigger()
  ..$type = json['__type'] as String?
  ..sourceDeviceRoleName = json['sourceDeviceRoleName'] as String?;

Map<String, dynamic> _$NoOpTriggerToJson(NoOpTrigger instance) {
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

ImmediateTrigger _$ImmediateTriggerFromJson(Map<String, dynamic> json) =>
    ImmediateTrigger()
      ..$type = json['__type'] as String?
      ..sourceDeviceRoleName = json['sourceDeviceRoleName'] as String?;

Map<String, dynamic> _$ImmediateTriggerToJson(ImmediateTrigger instance) {
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

OneTimeTrigger _$OneTimeTriggerFromJson(Map<String, dynamic> json) =>
    OneTimeTrigger()
      ..$type = json['__type'] as String?
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

  writeNotNull('__type', instance.$type);
  writeNotNull('sourceDeviceRoleName', instance.sourceDeviceRoleName);
  writeNotNull(
      'triggerTimestamp', instance.triggerTimestamp?.toIso8601String());
  return val;
}

PassiveTrigger _$PassiveTriggerFromJson(Map<String, dynamic> json) =>
    PassiveTrigger()
      ..$type = json['__type'] as String?
      ..sourceDeviceRoleName = json['sourceDeviceRoleName'] as String?;

Map<String, dynamic> _$PassiveTriggerToJson(PassiveTrigger instance) {
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

DelayedTrigger _$DelayedTriggerFromJson(Map<String, dynamic> json) =>
    DelayedTrigger(
      delay: Duration(microseconds: (json['delay'] as num).toInt()),
    )
      ..$type = json['__type'] as String?
      ..sourceDeviceRoleName = json['sourceDeviceRoleName'] as String?;

Map<String, dynamic> _$DelayedTriggerToJson(DelayedTrigger instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('__type', instance.$type);
  writeNotNull('sourceDeviceRoleName', instance.sourceDeviceRoleName);
  val['delay'] = instance.delay.inMicroseconds;
  return val;
}

PeriodicTrigger _$PeriodicTriggerFromJson(Map<String, dynamic> json) =>
    PeriodicTrigger(
      period: Duration(microseconds: (json['period'] as num).toInt()),
    )
      ..$type = json['__type'] as String?
      ..sourceDeviceRoleName = json['sourceDeviceRoleName'] as String?;

Map<String, dynamic> _$PeriodicTriggerToJson(PeriodicTrigger instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('__type', instance.$type);
  writeNotNull('sourceDeviceRoleName', instance.sourceDeviceRoleName);
  val['period'] = instance.period.inMicroseconds;
  return val;
}

DateTimeTrigger _$DateTimeTriggerFromJson(Map<String, dynamic> json) =>
    DateTimeTrigger(
      schedule: DateTime.parse(json['schedule'] as String),
    )
      ..$type = json['__type'] as String?
      ..sourceDeviceRoleName = json['sourceDeviceRoleName'] as String?;

Map<String, dynamic> _$DateTimeTriggerToJson(DateTimeTrigger instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('__type', instance.$type);
  writeNotNull('sourceDeviceRoleName', instance.sourceDeviceRoleName);
  val['schedule'] = instance.schedule.toIso8601String();
  return val;
}

RecurrentScheduledTrigger _$RecurrentScheduledTriggerFromJson(
        Map<String, dynamic> json) =>
    RecurrentScheduledTrigger(
      type: $enumDecode(_$RecurrentTypeEnumMap, json['type']),
      time: TimeOfDay.fromJson(json['time'] as Map<String, dynamic>),
      end: json['end'] == null ? null : DateTime.parse(json['end'] as String),
      separationCount: (json['separationCount'] as num?)?.toInt() ?? 0,
      maxNumberOfSampling: (json['maxNumberOfSampling'] as num?)?.toInt(),
      dayOfWeek: (json['dayOfWeek'] as num?)?.toInt(),
      weekOfMonth: (json['weekOfMonth'] as num?)?.toInt(),
      dayOfMonth: (json['dayOfMonth'] as num?)?.toInt(),
    )
      ..$type = json['__type'] as String?
      ..sourceDeviceRoleName = json['sourceDeviceRoleName'] as String?
      ..period = Duration(microseconds: (json['period'] as num).toInt());

Map<String, dynamic> _$RecurrentScheduledTriggerToJson(
    RecurrentScheduledTrigger instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('__type', instance.$type);
  writeNotNull('sourceDeviceRoleName', instance.sourceDeviceRoleName);
  val['type'] = _$RecurrentTypeEnumMap[instance.type]!;
  val['time'] = instance.time.toJson();
  writeNotNull('end', instance.end?.toIso8601String());
  val['separationCount'] = instance.separationCount;
  writeNotNull('maxNumberOfSampling', instance.maxNumberOfSampling);
  writeNotNull('dayOfWeek', instance.dayOfWeek);
  writeNotNull('weekOfMonth', instance.weekOfMonth);
  writeNotNull('dayOfMonth', instance.dayOfMonth);
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
    CronScheduledTrigger()
      ..$type = json['__type'] as String?
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

  writeNotNull('__type', instance.$type);
  writeNotNull('sourceDeviceRoleName', instance.sourceDeviceRoleName);
  val['cronExpression'] = instance.cronExpression;
  return val;
}

SamplingEventTrigger _$SamplingEventTriggerFromJson(
        Map<String, dynamic> json) =>
    SamplingEventTrigger(
      measureType: json['measureType'] as String,
      triggerCondition: json['triggerCondition'] == null
          ? null
          : Data.fromJson(json['triggerCondition'] as Map<String, dynamic>),
    )
      ..$type = json['__type'] as String?
      ..sourceDeviceRoleName = json['sourceDeviceRoleName'] as String?;

Map<String, dynamic> _$SamplingEventTriggerToJson(
    SamplingEventTrigger instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('__type', instance.$type);
  writeNotNull('sourceDeviceRoleName', instance.sourceDeviceRoleName);
  val['measureType'] = instance.measureType;
  writeNotNull('triggerCondition', instance.triggerCondition?.toJson());
  return val;
}

ConditionalSamplingEventTrigger _$ConditionalSamplingEventTriggerFromJson(
        Map<String, dynamic> json) =>
    ConditionalSamplingEventTrigger(
      measureType: json['measureType'] as String,
    )
      ..$type = json['__type'] as String?
      ..sourceDeviceRoleName = json['sourceDeviceRoleName'] as String?;

Map<String, dynamic> _$ConditionalSamplingEventTriggerToJson(
    ConditionalSamplingEventTrigger instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('__type', instance.$type);
  writeNotNull('sourceDeviceRoleName', instance.sourceDeviceRoleName);
  val['measureType'] = instance.measureType;
  return val;
}

ConditionalPeriodicTrigger _$ConditionalPeriodicTriggerFromJson(
        Map<String, dynamic> json) =>
    ConditionalPeriodicTrigger(
      period: Duration(microseconds: (json['period'] as num).toInt()),
    )
      ..$type = json['__type'] as String?
      ..sourceDeviceRoleName = json['sourceDeviceRoleName'] as String?;

Map<String, dynamic> _$ConditionalPeriodicTriggerToJson(
    ConditionalPeriodicTrigger instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('__type', instance.$type);
  writeNotNull('sourceDeviceRoleName', instance.sourceDeviceRoleName);
  val['period'] = instance.period.inMicroseconds;
  return val;
}

RandomRecurrentTrigger _$RandomRecurrentTriggerFromJson(
        Map<String, dynamic> json) =>
    RandomRecurrentTrigger(
      minNumberOfTriggers: (json['minNumberOfTriggers'] as num?)?.toInt() ?? 0,
      maxNumberOfTriggers: (json['maxNumberOfTriggers'] as num?)?.toInt() ?? 1,
      startTime: TimeOfDay.fromJson(json['startTime'] as Map<String, dynamic>),
      endTime: TimeOfDay.fromJson(json['endTime'] as Map<String, dynamic>),
    )
      ..$type = json['__type'] as String?
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

  writeNotNull('__type', instance.$type);
  writeNotNull('sourceDeviceRoleName', instance.sourceDeviceRoleName);
  val['startTime'] = instance.startTime.toJson();
  val['endTime'] = instance.endTime.toJson();
  val['minNumberOfTriggers'] = instance.minNumberOfTriggers;
  val['maxNumberOfTriggers'] = instance.maxNumberOfTriggers;
  writeNotNull(
      'lastTriggerTimestamp', instance.lastTriggerTimestamp?.toIso8601String());
  return val;
}

UserTaskTrigger _$UserTaskTriggerFromJson(Map<String, dynamic> json) =>
    UserTaskTrigger(
      taskName: json['taskName'] as String,
      triggerCondition:
          $enumDecode(_$UserTaskStateEnumMap, json['triggerCondition']),
    )
      ..$type = json['__type'] as String?
      ..sourceDeviceRoleName = json['sourceDeviceRoleName'] as String?;

Map<String, dynamic> _$UserTaskTriggerToJson(UserTaskTrigger instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('__type', instance.$type);
  writeNotNull('sourceDeviceRoleName', instance.sourceDeviceRoleName);
  val['taskName'] = instance.taskName;
  val['triggerCondition'] = _$UserTaskStateEnumMap[instance.triggerCondition]!;
  return val;
}

const _$UserTaskStateEnumMap = {
  UserTaskState.initialized: 'initialized',
  UserTaskState.enqueued: 'enqueued',
  UserTaskState.dequeued: 'dequeued',
  UserTaskState.notified: 'notified',
  UserTaskState.started: 'started',
  UserTaskState.canceled: 'canceled',
  UserTaskState.done: 'done',
  UserTaskState.expired: 'expired',
  UserTaskState.undefined: 'undefined',
};

FileData _$FileDataFromJson(Map<String, dynamic> json) => FileData(
      filename: json['filename'] as String,
      upload: json['upload'] as bool? ?? true,
    )
      ..$type = json['__type'] as String?
      ..metadata = (json['metadata'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      );

Map<String, dynamic> _$FileDataToJson(FileData instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('__type', instance.$type);
  val['filename'] = instance.filename;
  val['upload'] = instance.upload;
  writeNotNull('metadata', instance.metadata);
  return val;
}

Heartbeat _$HeartbeatFromJson(Map<String, dynamic> json) => Heartbeat(
      period: (json['period'] as num).toInt(),
      deviceType: json['deviceType'] as String,
      deviceRoleName: json['deviceRoleName'] as String,
    )..$type = json['__type'] as String?;

Map<String, dynamic> _$HeartbeatToJson(Heartbeat instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('__type', instance.$type);
  val['period'] = instance.period;
  val['deviceType'] = instance.deviceType;
  val['deviceRoleName'] = instance.deviceRoleName;
  return val;
}
