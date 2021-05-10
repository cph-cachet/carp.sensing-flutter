// GENERATED CODE - DO NOT MODIFY BY HAND

part of carp_core_deployment;

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

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
    dataEndPoint: json['dataEndPoint'] == null
        ? null
        : DataEndPoint.fromJson(json['dataEndPoint'] as Map<String, dynamic>),
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
  writeNotNull('dataEndPoint', instance.dataEndPoint);
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

Map<String, dynamic> _$DeviceRegistrationToJson(DeviceRegistration instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull(r'$type', instance.$type);
  val['registrationCreationDate'] =
      instance.registrationCreationDate?.toIso8601String();
  val['deviceId'] = instance.deviceId;
  return val;
}

DeviceDeploymentStatus _$DeviceDeploymentStatusFromJson(
    Map<String, dynamic> json) {
  return DeviceDeploymentStatus(
    device: json['device'] == null
        ? null
        : DeviceDescriptor.fromJson(json['device'] as Map<String, dynamic>),
  )
    ..$type = json[r'$type'] as String
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
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull(r'$type', instance.$type);
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
    devicesStatus: (json['devicesStatus'] as List)
        ?.map((e) => e == null
            ? null
            : DeviceDeploymentStatus.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  )
    ..$type = json[r'$type'] as String
    ..startTime = json['startTime'] == null
        ? null
        : DateTime.parse(json['startTime'] as String);
}

Map<String, dynamic> _$StudyDeploymentStatusToJson(
    StudyDeploymentStatus instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull(r'$type', instance.$type);
  writeNotNull('studyDeploymentId', instance.studyDeploymentId);
  writeNotNull('devicesStatus', instance.devicesStatus);
  writeNotNull('startTime', instance.startTime?.toIso8601String());
  return val;
}

ParticipantData _$ParticipantDataFromJson(Map<String, dynamic> json) {
  return ParticipantData(
    studyDeploymentId: json['studyDeploymentId'] as String,
    data: json['data'] as Map<String, dynamic>,
  );
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

EmailAccountIdentity _$EmailAccountIdentityFromJson(Map<String, dynamic> json) {
  return EmailAccountIdentity(
    json['emailAddress'] as String,
  )..$type = json[r'$type'] as String;
}

Map<String, dynamic> _$EmailAccountIdentityToJson(
    EmailAccountIdentity instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull(r'$type', instance.$type);
  writeNotNull('emailAddress', instance.emailAddress);
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

DataEndPoint _$DataEndPointFromJson(Map<String, dynamic> json) {
  return DataEndPoint(
    type: json['type'] as String,
    dataFormat: json['dataFormat'] as String,
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
  writeNotNull('dataFormat', instance.dataFormat);
  return val;
}

CreateStudyDeployment _$CreateStudyDeploymentFromJson(
    Map<String, dynamic> json) {
  return CreateStudyDeployment(
    json['protocol'] == null
        ? null
        : StudyProtocol.fromJson(json['protocol'] as Map<String, dynamic>),
  )
    ..$type = json[r'$type'] as String
    ..studyDeploymentId = json['studyDeploymentId'] as String;
}

Map<String, dynamic> _$CreateStudyDeploymentToJson(
    CreateStudyDeployment instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull(r'$type', instance.$type);
  val['studyDeploymentId'] = instance.studyDeploymentId;
  val['protocol'] = instance.protocol;
  return val;
}

GetStudyDeploymentStatus _$GetStudyDeploymentStatusFromJson(
    Map<String, dynamic> json) {
  return GetStudyDeploymentStatus(
    json['studyDeploymentId'] as String,
  )..$type = json[r'$type'] as String;
}

Map<String, dynamic> _$GetStudyDeploymentStatusToJson(
    GetStudyDeploymentStatus instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull(r'$type', instance.$type);
  val['studyDeploymentId'] = instance.studyDeploymentId;
  return val;
}

GetStudyDeploymentStatusList _$GetStudyDeploymentStatusListFromJson(
    Map<String, dynamic> json) {
  return GetStudyDeploymentStatusList(
    (json['studyDeploymentIds'] as List)?.map((e) => e as String)?.toList(),
  )
    ..$type = json[r'$type'] as String
    ..studyDeploymentId = json['studyDeploymentId'] as String;
}

Map<String, dynamic> _$GetStudyDeploymentStatusListToJson(
    GetStudyDeploymentStatusList instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull(r'$type', instance.$type);
  val['studyDeploymentId'] = instance.studyDeploymentId;
  val['studyDeploymentIds'] = instance.studyDeploymentIds;
  return val;
}

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

Map<String, dynamic> _$RegisterDeviceToJson(RegisterDevice instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull(r'$type', instance.$type);
  val['studyDeploymentId'] = instance.studyDeploymentId;
  val['deviceRoleName'] = instance.deviceRoleName;
  val['registration'] = instance.registration;
  return val;
}

UnregisterDevice _$UnregisterDeviceFromJson(Map<String, dynamic> json) {
  return UnregisterDevice(
    json['studyDeploymentId'] as String,
    json['deviceRoleName'] as String,
  )..$type = json[r'$type'] as String;
}

Map<String, dynamic> _$UnregisterDeviceToJson(UnregisterDevice instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull(r'$type', instance.$type);
  val['studyDeploymentId'] = instance.studyDeploymentId;
  val['deviceRoleName'] = instance.deviceRoleName;
  return val;
}

GetDeviceDeploymentFor _$GetDeviceDeploymentForFromJson(
    Map<String, dynamic> json) {
  return GetDeviceDeploymentFor(
    json['studyDeploymentId'] as String,
    json['masterDeviceRoleName'] as String,
  )..$type = json[r'$type'] as String;
}

Map<String, dynamic> _$GetDeviceDeploymentForToJson(
    GetDeviceDeploymentFor instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull(r'$type', instance.$type);
  val['studyDeploymentId'] = instance.studyDeploymentId;
  val['masterDeviceRoleName'] = instance.masterDeviceRoleName;
  return val;
}

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
    DeploymentSuccessful instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull(r'$type', instance.$type);
  val['studyDeploymentId'] = instance.studyDeploymentId;
  val['masterDeviceRoleName'] = instance.masterDeviceRoleName;
  val['deviceDeploymentLastUpdateDate'] =
      instance.deviceDeploymentLastUpdateDate?.toIso8601String();
  return val;
}

GetActiveParticipationInvitations _$GetActiveParticipationInvitationsFromJson(
    Map<String, dynamic> json) {
  return GetActiveParticipationInvitations(
    json['accountId'] as String,
  )..$type = json[r'$type'] as String;
}

Map<String, dynamic> _$GetActiveParticipationInvitationsToJson(
    GetActiveParticipationInvitations instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull(r'$type', instance.$type);
  val['accountId'] = instance.accountId;
  return val;
}

GetParticipantData _$GetParticipantDataFromJson(Map<String, dynamic> json) {
  return GetParticipantData(
    json['studyDeploymentId'] as String,
  )..$type = json[r'$type'] as String;
}

Map<String, dynamic> _$GetParticipantDataToJson(GetParticipantData instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull(r'$type', instance.$type);
  val['studyDeploymentId'] = instance.studyDeploymentId;
  return val;
}

GetParticipantDataList _$GetParticipantDataListFromJson(
    Map<String, dynamic> json) {
  return GetParticipantDataList(
    (json['studyDeploymentIds'] as List)?.map((e) => e as String)?.toList(),
  )
    ..$type = json[r'$type'] as String
    ..studyDeploymentId = json['studyDeploymentId'] as String;
}

Map<String, dynamic> _$GetParticipantDataListToJson(
    GetParticipantDataList instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull(r'$type', instance.$type);
  val['studyDeploymentId'] = instance.studyDeploymentId;
  val['studyDeploymentIds'] = instance.studyDeploymentIds;
  return val;
}

SetParticipantData _$SetParticipantDataFromJson(Map<String, dynamic> json) {
  return SetParticipantData(
    json['studyDeploymentId'] as String,
    json['inputDataType'] as String,
    json['data'] == null
        ? null
        : ParticipantData.fromJson(json['data'] as Map<String, dynamic>),
  )..$type = json[r'$type'] as String;
}

Map<String, dynamic> _$SetParticipantDataToJson(SetParticipantData instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull(r'$type', instance.$type);
  val['studyDeploymentId'] = instance.studyDeploymentId;
  val['inputDataType'] = instance.inputDataType;
  val['data'] = instance.data;
  return val;
}
