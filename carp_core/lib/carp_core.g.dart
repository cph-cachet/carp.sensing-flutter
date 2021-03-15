// GENERATED CODE - DO NOT MODIFY BY HAND

part of carp_core;

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DataPoint _$DataPointFromJson(Map<String, dynamic> json) {
  return DataPoint(
    json['carp_header'] == null
        ? null
        : DataPointHeader.fromJson(json['carp_header'] as Map<String, dynamic>),
    json['carp_body'] == null
        ? null
        : Data.fromJson(json['carp_body'] as Map<String, dynamic>),
  )
    ..id = json['id'] as int
    ..createdByUserId = json['created_by_user_id'] as int
    ..studyId = json['study_id'] as String;
}

Map<String, dynamic> _$DataPointToJson(DataPoint instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  writeNotNull('created_by_user_id', instance.createdByUserId);
  writeNotNull('study_id', instance.studyId);
  writeNotNull('carp_header', instance.carpHeader);
  writeNotNull('carp_body', instance.carpBody);
  return val;
}

DataPointHeader _$DataPointHeaderFromJson(Map<String, dynamic> json) {
  return DataPointHeader(
    studyId: json['study_id'] as String,
    userId: json['user_id'] as String,
    dataFormat: json['data_format'] == null
        ? null
        : DataFormat.fromJson(json['data_format'] as Map<String, dynamic>),
    deviceRoleName: json['device_role_name'] as String,
    triggerId: json['trigger_id'] as String,
    startTime: json['start_time'] == null
        ? null
        : DateTime.parse(json['start_time'] as String),
    endTime: json['end_time'] == null
        ? null
        : DateTime.parse(json['end_time'] as String),
  )..uploadTime = json['upload_time'] == null
      ? null
      : DateTime.parse(json['upload_time'] as String);
}

Map<String, dynamic> _$DataPointHeaderToJson(DataPointHeader instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('study_id', instance.studyId);
  writeNotNull('device_role_name', instance.deviceRoleName);
  writeNotNull('trigger_id', instance.triggerId);
  writeNotNull('user_id', instance.userId);
  writeNotNull('upload_time', instance.uploadTime?.toIso8601String());
  writeNotNull('start_time', instance.startTime?.toIso8601String());
  writeNotNull('end_time', instance.endTime?.toIso8601String());
  writeNotNull('data_format', instance.dataFormat);
  return val;
}

DataFormat _$DataFormatFromJson(Map<String, dynamic> json) {
  return DataFormat(
    json['namespace'] as String,
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

  writeNotNull('namespace', instance.namespace);
  writeNotNull('name', instance.name);
  return val;
}

DataType _$DataTypeFromJson(Map<String, dynamic> json) {
  return DataType(
    json['namespace'] as String,
    json['name'] as String,
  );
}

Map<String, dynamic> _$DataTypeToJson(DataType instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('namespace', instance.namespace);
  writeNotNull('name', instance.name);
  return val;
}

Data _$DataFromJson(Map<String, dynamic> json) {
  return Data();
}

Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic>{};

MasterDeviceDeployment _$MasterDeviceDeploymentFromJson(
    Map<String, dynamic> json) {
  return MasterDeviceDeployment(
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
  )..lastUpdateDate = json['lastUpdateDate'] == null
      ? null
      : DateTime.parse(json['lastUpdateDate'] as String);
}

Map<String, dynamic> _$MasterDeviceDeploymentToJson(
    MasterDeviceDeployment instance) {
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
  return val;
}

DeviceRegistration _$DeviceRegistrationFromJson(Map<String, dynamic> json) {
  return DeviceRegistration(
    json['deviceId'] as String,
    json['registrationCreationDate'] == null
        ? null
        : DateTime.parse(json['registrationCreationDate'] as String),
  )..$type = json[r'$type'] as String;
}

Map<String, dynamic> _$DeviceRegistrationToJson(DeviceRegistration instance) =>
    <String, dynamic>{
      r'$type': instance.$type,
      'registrationCreationDate':
          instance.registrationCreationDate?.toIso8601String(),
      'deviceId': instance.deviceId,
    };

DeviceDeploymentStatus _$DeviceDeploymentStatusFromJson(
    Map<String, dynamic> json) {
  return DeviceDeploymentStatus()
    ..$type = json[r'$type'] as String
    ..studyDeploymentId = json['studyDeploymentId'] as String
    ..device = json['device'] == null
        ? null
        : DeviceDescriptor.fromJson(json['device'] as Map<String, dynamic>)
    ..requiresDeployment = json['requiresDeployment'] as bool
    ..remainingDevicesToRegisterToObtainDeployment =
        (json['remainingDevicesToRegisterToObtainDeployment'] as List)
            ?.map((e) => e as String)
            ?.toList()
    ..remainingDevicesToRegisterBeforeDeployment =
        (json['remainingDevicesToRegisterBeforeDeployment'] as List)
            ?.map((e) => e as String)
            ?.toList();
}

Map<String, dynamic> _$DeviceDeploymentStatusToJson(
    DeviceDeploymentStatus instance) {
  final val = <String, dynamic>{
    r'$type': instance.$type,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('studyDeploymentId', instance.studyDeploymentId);
  writeNotNull('device', instance.device);
  writeNotNull('requiresDeployment', instance.requiresDeployment);
  writeNotNull('remainingDevicesToRegisterToObtainDeployment',
      instance.remainingDevicesToRegisterToObtainDeployment);
  writeNotNull('remainingDevicesToRegisterBeforeDeployment',
      instance.remainingDevicesToRegisterBeforeDeployment);
  return val;
}

DeviceInvitation _$DeviceInvitationFromJson(Map<String, dynamic> json) {
  return DeviceInvitation()
    ..deviceRoleName = json['deviceRoleName'] as String
    ..isRegistered = json['isRegistered'] as bool;
}

Map<String, dynamic> _$DeviceInvitationToJson(DeviceInvitation instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('deviceRoleName', instance.deviceRoleName);
  writeNotNull('isRegistered', instance.isRegistered);
  return val;
}

StudyDeploymentStatus _$StudyDeploymentStatusFromJson(
    Map<String, dynamic> json) {
  return StudyDeploymentStatus(
    studyDeploymentId: json['studyDeploymentId'] as String,
  )
    ..$type = json[r'$type'] as String
    ..devicesStatus = (json['devicesStatus'] as List)
        ?.map((e) => e == null
            ? null
            : DeviceDeploymentStatus.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..startTime = json['startTime'] as int;
}

Map<String, dynamic> _$StudyDeploymentStatusToJson(
    StudyDeploymentStatus instance) {
  final val = <String, dynamic>{
    r'$type': instance.$type,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('studyDeploymentId', instance.studyDeploymentId);
  writeNotNull('devicesStatus', instance.devicesStatus);
  writeNotNull('startTime', instance.startTime);
  return val;
}

Participation _$ParticipationFromJson(Map<String, dynamic> json) {
  return Participation()
    ..studyDeploymentId = json['studyDeploymentId'] as String
    ..id = json['id'] as String
    ..isRegistered = json['isRegistered'] as bool;
}

Map<String, dynamic> _$ParticipationToJson(Participation instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('studyDeploymentId', instance.studyDeploymentId);
  writeNotNull('id', instance.id);
  writeNotNull('isRegistered', instance.isRegistered);
  return val;
}

StudyInvitation _$StudyInvitationFromJson(Map<String, dynamic> json) {
  return StudyInvitation()
    ..name = json['name'] as String
    ..description = json['description'] as String
    ..applicationData = json['applicationData'] as String;
}

Map<String, dynamic> _$StudyInvitationToJson(StudyInvitation instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('name', instance.name);
  writeNotNull('description', instance.description);
  writeNotNull('applicationData', instance.applicationData);
  return val;
}

ActiveParticipationInvitation _$ActiveParticipationInvitationFromJson(
    Map<String, dynamic> json) {
  return ActiveParticipationInvitation()
    ..participation = json['participation'] == null
        ? null
        : Participation.fromJson(json['participation'] as Map<String, dynamic>)
    ..invitation = json['invitation'] == null
        ? null
        : StudyInvitation.fromJson(json['invitation'] as Map<String, dynamic>)
    ..devices = (json['devices'] as List)
        ?.map((e) => e == null
            ? null
            : DeviceInvitation.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$ActiveParticipationInvitationToJson(
    ActiveParticipationInvitation instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('participation', instance.participation);
  writeNotNull('invitation', instance.invitation);
  writeNotNull('devices', instance.devices);
  return val;
}

ParticipantData _$ParticipantDataFromJson(Map<String, dynamic> json) {
  return ParticipantData()
    ..studyDeploymentId = json['studyDeploymentId'] as String
    ..data = json['data'] as Map<String, dynamic>;
}

Map<String, dynamic> _$ParticipantDataToJson(ParticipantData instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('studyDeploymentId', instance.studyDeploymentId);
  writeNotNull('data', instance.data);
  return val;
}

DeploymentServiceRequest _$DeploymentServiceRequestFromJson(
    Map<String, dynamic> json) {
  return DeploymentServiceRequest(
    json['studyDeploymentId'] as String,
  )..$type = json[r'$type'] as String;
}

Map<String, dynamic> _$DeploymentServiceRequestToJson(
        DeploymentServiceRequest instance) =>
    <String, dynamic>{
      r'$type': instance.$type,
      'studyDeploymentId': instance.studyDeploymentId,
    };

GetActiveParticipationInvitations _$GetActiveParticipationInvitationsFromJson(
    Map<String, dynamic> json) {
  return GetActiveParticipationInvitations(
    json['accountId'] as String,
  )..$type = json[r'$type'] as String;
}

Map<String, dynamic> _$GetActiveParticipationInvitationsToJson(
        GetActiveParticipationInvitations instance) =>
    <String, dynamic>{
      r'$type': instance.$type,
      'accountId': instance.accountId,
    };

GetStudyDeploymentStatus _$GetStudyDeploymentStatusFromJson(
    Map<String, dynamic> json) {
  return GetStudyDeploymentStatus(
    json['studyDeploymentId'] as String,
  )..$type = json[r'$type'] as String;
}

Map<String, dynamic> _$GetStudyDeploymentStatusToJson(
        GetStudyDeploymentStatus instance) =>
    <String, dynamic>{
      r'$type': instance.$type,
      'studyDeploymentId': instance.studyDeploymentId,
    };

RegisterDevice _$RegisterDeviceFromJson(Map<String, dynamic> json) {
  return RegisterDevice(
    json['studyDeploymentId'] as String,
    json['deviceRoleName'] as String,
    json['registration'] == null
        ? null
        : DeviceRegistration.fromJson(
            json['registration'] as Map<String, dynamic>),
  )..$type = json[r'$type'] as String;
}

Map<String, dynamic> _$RegisterDeviceToJson(RegisterDevice instance) =>
    <String, dynamic>{
      r'$type': instance.$type,
      'studyDeploymentId': instance.studyDeploymentId,
      'deviceRoleName': instance.deviceRoleName,
      'registration': instance.registration,
    };

UnregisterDevice _$UnregisterDeviceFromJson(Map<String, dynamic> json) {
  return UnregisterDevice(
    json['studyDeploymentId'] as String,
    json['deviceRoleName'] as String,
  )..$type = json[r'$type'] as String;
}

Map<String, dynamic> _$UnregisterDeviceToJson(UnregisterDevice instance) =>
    <String, dynamic>{
      r'$type': instance.$type,
      'studyDeploymentId': instance.studyDeploymentId,
      'deviceRoleName': instance.deviceRoleName,
    };

GetDeviceDeploymentFor _$GetDeviceDeploymentForFromJson(
    Map<String, dynamic> json) {
  return GetDeviceDeploymentFor(
    json['studyDeploymentId'] as String,
    json['masterDeviceRoleName'] as String,
  )..$type = json[r'$type'] as String;
}

Map<String, dynamic> _$GetDeviceDeploymentForToJson(
        GetDeviceDeploymentFor instance) =>
    <String, dynamic>{
      r'$type': instance.$type,
      'studyDeploymentId': instance.studyDeploymentId,
      'masterDeviceRoleName': instance.masterDeviceRoleName,
    };

DeploymentSuccessful _$DeploymentSuccessfulFromJson(Map<String, dynamic> json) {
  return DeploymentSuccessful(
    json['studyDeploymentId'] as String,
    json['masterDeviceRoleName'] as String,
    json['deviceDeploymentLastUpdateDate'] == null
        ? null
        : DateTime.parse(json['deviceDeploymentLastUpdateDate'] as String),
  )..$type = json[r'$type'] as String;
}

Map<String, dynamic> _$DeploymentSuccessfulToJson(
        DeploymentSuccessful instance) =>
    <String, dynamic>{
      r'$type': instance.$type,
      'studyDeploymentId': instance.studyDeploymentId,
      'masterDeviceRoleName': instance.masterDeviceRoleName,
      'deviceDeploymentLastUpdateDate':
          instance.deviceDeploymentLastUpdateDate?.toIso8601String(),
    };

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
  final val = <String, dynamic>{
    r'$type': instance.$type,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

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
  final val = <String, dynamic>{
    r'$type': instance.$type,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

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
  final val = <String, dynamic>{
    r'$type': instance.$type,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('isMasterDevice', instance.isMasterDevice);
  writeNotNull('roleName', instance.roleName);
  writeNotNull('supportedDataTypes', instance.supportedDataTypes);
  writeNotNull('samplingConfiguration', instance.samplingConfiguration);
  return val;
}

Measure _$MeasureFromJson(Map<String, dynamic> json) {
  return Measure(
    type: json['type'] as String,
  )..$type = json[r'$type'] as String;
}

Map<String, dynamic> _$MeasureToJson(Measure instance) {
  final val = <String, dynamic>{
    r'$type': instance.$type,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('type', instance.type);
  return val;
}

DataTypeMeasure _$DataTypeMeasureFromJson(Map<String, dynamic> json) {
  return DataTypeMeasure(
    type: json['type'] as String,
  )..$type = json[r'$type'] as String;
}

Map<String, dynamic> _$DataTypeMeasureToJson(DataTypeMeasure instance) {
  final val = <String, dynamic>{
    r'$type': instance.$type,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

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
  final val = <String, dynamic>{
    r'$type': instance.$type,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('type', instance.type);
  writeNotNull('duration', instance.duration);
  return val;
}

StudyProtocol _$StudyProtocolFromJson(Map<String, dynamic> json) {
  return StudyProtocol(
    owner: json['owner'] == null
        ? null
        : ProtocolOwner.fromJson(json['owner'] as Map<String, dynamic>),
    name: json['name'] as String,
    description: json['description'] as String,
  )
    ..$type = json[r'$type'] as String
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

Map<String, dynamic> _$StudyProtocolToJson(StudyProtocol instance) {
  final val = <String, dynamic>{
    r'$type': instance.$type,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('owner', instance.owner);
  writeNotNull('name', instance.name);
  writeNotNull('description', instance.description);
  writeNotNull('masterDevices', instance.masterDevices);
  writeNotNull('connectedDevices', instance.connectedDevices);
  writeNotNull('triggers', instance.triggers);
  writeNotNull('tasks', instance.tasks);
  writeNotNull('triggeredTasks', instance.triggeredTasks);
  return val;
}

ProtocolOwner _$ProtocolOwnerFromJson(Map<String, dynamic> json) {
  return ProtocolOwner(
    id: json['id'] as String,
    name: json['name'] as String,
    title: json['title'] as String,
    email: json['email'] as String,
    affiliation: json['affiliation'] as String,
    address: json['address'] as String,
  )..$type = json[r'$type'] as String;
}

Map<String, dynamic> _$ProtocolOwnerToJson(ProtocolOwner instance) {
  final val = <String, dynamic>{
    r'$type': instance.$type,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  writeNotNull('name', instance.name);
  writeNotNull('title', instance.title);
  writeNotNull('email', instance.email);
  writeNotNull('address', instance.address);
  writeNotNull('affiliation', instance.affiliation);
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
  final val = <String, dynamic>{
    r'$type': instance.$type,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

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
  final val = <String, dynamic>{
    r'$type': instance.$type,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

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
  final val = <String, dynamic>{
    r'$type': instance.$type,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

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
    ..destinationDeviceRoleName = json['destinationDeviceRoleName'] as String;
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
  writeNotNull('destinationDeviceRoleName', instance.destinationDeviceRoleName);
  return val;
}

Trigger _$TriggerFromJson(Map<String, dynamic> json) {
  return Trigger()
    ..$type = json[r'$type'] as String
    ..sourceDeviceRoleName = json['sourceDeviceRoleName'] as String
    ..requiresMasterDevice = json['requiresMasterDevice'] as bool;
}

Map<String, dynamic> _$TriggerToJson(Trigger instance) {
  final val = <String, dynamic>{
    r'$type': instance.$type,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

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
  final val = <String, dynamic>{
    r'$type': instance.$type,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

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
  final val = <String, dynamic>{
    r'$type': instance.$type,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

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
        : RecurrenceRule.fromJson(
            json['recurrenceRule'] as Map<String, dynamic>),
  )
    ..$type = json[r'$type'] as String
    ..sourceDeviceRoleName = json['sourceDeviceRoleName'] as String
    ..requiresMasterDevice = json['requiresMasterDevice'] as bool;
}

Map<String, dynamic> _$ScheduledTriggerToJson(ScheduledTrigger instance) {
  final val = <String, dynamic>{
    r'$type': instance.$type,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

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
        SamplingConfiguration instance) =>
    <String, dynamic>{
      r'$type': instance.$type,
    };
