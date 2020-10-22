// GENERATED CODE - DO NOT MODIFY BY HAND

part of carp_domain;

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

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

DeviceRegistration _$DeviceRegistrationFromJson(Map<String, dynamic> json) {
  return DeviceRegistration(
    json['deviceId'] as String,
    json['registrationCreationDate'] as int,
  )..$type = json[r'$type'] as String;
}

Map<String, dynamic> _$DeviceRegistrationToJson(DeviceRegistration instance) =>
    <String, dynamic>{
      r'$type': instance.$type,
      'registrationCreationDate': instance.registrationCreationDate,
      'deviceId': instance.deviceId,
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
    json['deviceDeploymentLastUpdateDate'] as int,
  )..$type = json[r'$type'] as String;
}

Map<String, dynamic> _$DeploymentSuccessfulToJson(
        DeploymentSuccessful instance) =>
    <String, dynamic>{
      r'$type': instance.$type,
      'studyDeploymentId': instance.studyDeploymentId,
      'masterDeviceRoleName': instance.masterDeviceRoleName,
      'deviceDeploymentLastUpdateDate': instance.deviceDeploymentLastUpdateDate,
    };

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

DeviceInvitation _$DeviceInvitationFromJson(Map<String, dynamic> json) {
  return DeviceInvitation()
    ..$type = json[r'$type'] as String
    ..deviceRoleName = json['deviceRoleName'] as String
    ..isRegistered = json['isRegistered'] as bool;
}

Map<String, dynamic> _$DeviceInvitationToJson(DeviceInvitation instance) {
  final val = <String, dynamic>{
    r'$type': instance.$type,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('deviceRoleName', instance.deviceRoleName);
  writeNotNull('isRegistered', instance.isRegistered);
  return val;
}

MasterDeviceDeployment _$MasterDeviceDeploymentFromJson(
    Map<String, dynamic> json) {
  return MasterDeviceDeployment()
    ..configuration = json['configuration'] == null
        ? null
        : DeviceRegistration.fromJson(
            json['configuration'] as Map<String, dynamic>)
    ..connectedDevices = (json['connectedDevices'] as List)
        ?.map((e) => e == null
            ? null
            : DeviceDescriptor.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..connectedDeviceConfigurations =
        (json['connectedDeviceConfigurations'] as Map<String, dynamic>)?.map(
      (k, e) => MapEntry(
          k,
          e == null
              ? null
              : DeviceRegistration.fromJson(e as Map<String, dynamic>)),
    )
    ..tasks =
        (json['tasks'] as List)?.map((e) => e as Map<String, dynamic>)?.toList()
    ..triggers = (json['triggers'] as Map<String, dynamic>)?.map(
      (k, e) => MapEntry(k, e as Map<String, dynamic>),
    )
    ..triggeredTasks = (json['triggeredTasks'] as List)
        ?.map((e) => e as Map<String, dynamic>)
        ?.toList()
    ..lastUpdateDate = json['lastUpdateDate'] as int;
}

Map<String, dynamic> _$MasterDeviceDeploymentToJson(
    MasterDeviceDeployment instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('configuration', instance.configuration);
  writeNotNull('connectedDevices', instance.connectedDevices);
  writeNotNull(
      'connectedDeviceConfigurations', instance.connectedDeviceConfigurations);
  writeNotNull('tasks', instance.tasks);
  writeNotNull('triggers', instance.triggers);
  writeNotNull('triggeredTasks', instance.triggeredTasks);
  writeNotNull('lastUpdateDate', instance.lastUpdateDate);
  return val;
}

TaskDescriptor _$TaskDescriptorFromJson(Map<String, dynamic> json) {
  return TaskDescriptor()
    ..$type = json[r'$type'] as String
    ..name = json['name'] as String
    ..measures = (json['measures'] as List)
        ?.map((e) =>
            e == null ? null : Measure.fromJson(e as Map<String, dynamic>))
        ?.toList();
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

CustomProtocolTask _$CustomProtocolTaskFromJson(Map<String, dynamic> json) {
  return CustomProtocolTask()
    ..$type = json[r'$type'] as String
    ..name = json['name'] as String
    ..measures = (json['measures'] as List)
        ?.map((e) =>
            e == null ? null : Measure.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..studyProtocol = json['studyProtocol'] as String;
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

TriggerDescriptor _$TriggerDescriptorFromJson(Map<String, dynamic> json) {
  return TriggerDescriptor()
    ..$type = json[r'$type'] as String
    ..sourceDeviceRoleName = json['sourceDeviceRoleName'] as String
    ..requiresMasterDevice = json['requiresMasterDevice'] as bool;
}

Map<String, dynamic> _$TriggerDescriptorToJson(TriggerDescriptor instance) {
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

TriggeredTask _$TriggeredTaskFromJson(Map<String, dynamic> json) {
  return TriggeredTask()
    ..task = json['task'] == null
        ? null
        : TaskDescriptor.fromJson(json['task'] as Map<String, dynamic>)
    ..targetDevice = json['targetDevice'] == null
        ? null
        : DeviceDescriptor.fromJson(
            json['targetDevice'] as Map<String, dynamic>);
}

Map<String, dynamic> _$TriggeredTaskToJson(TriggeredTask instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('task', instance.task);
  writeNotNull('targetDevice', instance.targetDevice);
  return val;
}

StudyDeploymentStatus _$StudyDeploymentStatusFromJson(
    Map<String, dynamic> json) {
  return StudyDeploymentStatus(
    json['studyDeploymentId'] as String,
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

DeviceDescriptor _$DeviceDescriptorFromJson(Map<String, dynamic> json) {
  return DeviceDescriptor()
    ..$type = json[r'$type'] as String
    ..studyDeploymentId = json['studyDeploymentId'] as String
    ..isMasterDevice = json['isMasterDevice'] as bool
    ..roleName = json['roleName'] as String
    ..samplingConfiguration =
        json['samplingConfiguration'] as Map<String, dynamic>;
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

  writeNotNull('studyDeploymentId', instance.studyDeploymentId);
  writeNotNull('isMasterDevice', instance.isMasterDevice);
  writeNotNull('roleName', instance.roleName);
  writeNotNull('samplingConfiguration', instance.samplingConfiguration);
  return val;
}
