// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'carp_core_deployment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PrimaryDeviceDeployment _$PrimaryDeviceDeploymentFromJson(
        Map<String, dynamic> json) =>
    PrimaryDeviceDeployment(
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
    )..applicationData = json['applicationData'] as Map<String, dynamic>?;

Map<String, dynamic> _$PrimaryDeviceDeploymentToJson(
    PrimaryDeviceDeployment instance) {
  final val = <String, dynamic>{
    'deviceConfiguration': instance.deviceConfiguration.toJson(),
    'registration': instance.registration.toJson(),
    'connectedDevices':
        instance.connectedDevices.map((e) => e.toJson()).toList(),
    'connectedDeviceRegistrations': instance.connectedDeviceRegistrations
        .map((k, e) => MapEntry(k, e?.toJson())),
    'tasks': instance.tasks.map((e) => e.toJson()).toList(),
    'triggers': instance.triggers.map((k, e) => MapEntry(k, e.toJson())),
    'taskControls': instance.taskControls.map((e) => e.toJson()).toList(),
    'expectedParticipantData':
        instance.expectedParticipantData.map((e) => e.toJson()).toList(),
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('applicationData', instance.applicationData);
  return val;
}

DeviceDeploymentStatus _$DeviceDeploymentStatusFromJson(
        Map<String, dynamic> json) =>
    DeviceDeploymentStatus(
      device: DeviceConfiguration<DeviceRegistration>.fromJson(
          json['device'] as Map<String, dynamic>),
    )
      ..$type = json['__type'] as String?
      ..canBeDeployed = json['canBeDeployed'] as bool?
      ..remainingDevicesToRegisterToObtainDeployment =
          (json['remainingDevicesToRegisterToObtainDeployment']
                  as List<dynamic>?)
              ?.map((e) => e as String)
              .toList()
      ..remainingDevicesToRegisterBeforeDeployment =
          (json['remainingDevicesToRegisterBeforeDeployment'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList();

Map<String, dynamic> _$DeviceDeploymentStatusToJson(
    DeviceDeploymentStatus instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('__type', instance.$type);
  val['device'] = instance.device.toJson();
  writeNotNull('canBeDeployed', instance.canBeDeployed);
  writeNotNull('remainingDevicesToRegisterToObtainDeployment',
      instance.remainingDevicesToRegisterToObtainDeployment);
  writeNotNull('remainingDevicesToRegisterBeforeDeployment',
      instance.remainingDevicesToRegisterBeforeDeployment);
  return val;
}

AssignedPrimaryDevice _$AssignedPrimaryDeviceFromJson(
        Map<String, dynamic> json) =>
    AssignedPrimaryDevice(
      device: PrimaryDeviceConfiguration<DeviceRegistration>.fromJson(
          json['device'] as Map<String, dynamic>),
      registration: json['registration'] == null
          ? null
          : DeviceRegistration.fromJson(
              json['registration'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AssignedPrimaryDeviceToJson(
    AssignedPrimaryDevice instance) {
  final val = <String, dynamic>{
    'device': instance.device.toJson(),
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('registration', instance.registration?.toJson());
  return val;
}

StudyDeploymentStatus _$StudyDeploymentStatusFromJson(
        Map<String, dynamic> json) =>
    StudyDeploymentStatus(
      studyDeploymentId: json['studyDeploymentId'] as String,
      deviceStatusList: (json['deviceStatusList'] as List<dynamic>?)
              ?.map((e) =>
                  DeviceDeploymentStatus.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    )
      ..$type = json['__type'] as String?
      ..createdOn = DateTime.parse(json['createdOn'] as String)
      ..participantStatusList = (json['participantStatusList'] as List<dynamic>)
          .map((e) => ParticipantStatus.fromJson(e as Map<String, dynamic>))
          .toList()
      ..startedOn = json['startedOn'] == null
          ? null
          : DateTime.parse(json['startedOn'] as String);

Map<String, dynamic> _$StudyDeploymentStatusToJson(
    StudyDeploymentStatus instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('__type', instance.$type);
  val['createdOn'] = instance.createdOn.toIso8601String();
  val['studyDeploymentId'] = instance.studyDeploymentId;
  val['deviceStatusList'] =
      instance.deviceStatusList.map((e) => e.toJson()).toList();
  val['participantStatusList'] =
      instance.participantStatusList.map((e) => e.toJson()).toList();
  writeNotNull('startedOn', instance.startedOn?.toIso8601String());
  return val;
}

ParticipantData _$ParticipantDataFromJson(Map<String, dynamic> json) =>
    ParticipantData(
      studyDeploymentId: json['studyDeploymentId'] as String,
      common: (json['common'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(
                k, e == null ? null : Data.fromJson(e as Map<String, dynamic>)),
          ) ??
          const {},
      roles: (json['roles'] as List<dynamic>?)
              ?.map((e) => RoleData.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$ParticipantDataToJson(ParticipantData instance) =>
    <String, dynamic>{
      'studyDeploymentId': instance.studyDeploymentId,
      'common': instance.common.map((k, e) => MapEntry(k, e?.toJson())),
      'roles': instance.roles.map((e) => e.toJson()).toList(),
    };

RoleData _$RoleDataFromJson(Map<String, dynamic> json) => RoleData(
      roleName: json['roleName'] as String,
      data: (json['data'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(
                k, e == null ? null : Data.fromJson(e as Map<String, dynamic>)),
          ) ??
          const {},
    );

Map<String, dynamic> _$RoleDataToJson(RoleData instance) => <String, dynamic>{
      'roleName': instance.roleName,
      'data': instance.data.map((k, e) => MapEntry(k, e?.toJson())),
    };

ParticipantInvitation _$ParticipantInvitationFromJson(
        Map<String, dynamic> json) =>
    ParticipantInvitation(
      participantId: json['participantId'] as String?,
      assignedRoles:
          AssignedTo.fromJson(json['assignedRoles'] as Map<String, dynamic>),
      identity:
          AccountIdentity.fromJson(json['identity'] as Map<String, dynamic>),
      invitation:
          StudyInvitation.fromJson(json['invitation'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ParticipantInvitationToJson(
        ParticipantInvitation instance) =>
    <String, dynamic>{
      'participantId': instance.participantId,
      'assignedRoles': instance.assignedRoles.toJson(),
      'identity': instance.identity.toJson(),
      'invitation': instance.invitation.toJson(),
    };

Participation _$ParticipationFromJson(Map<String, dynamic> json) =>
    Participation(
      json['studyDeploymentId'] as String,
      json['participantId'] as String,
      AssignedTo.fromJson(json['assignedRoles'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ParticipationToJson(Participation instance) =>
    <String, dynamic>{
      'studyDeploymentId': instance.studyDeploymentId,
      'participantId': instance.participantId,
      'assignedRoles': instance.assignedRoles.toJson(),
    };

StudyInvitation _$StudyInvitationFromJson(Map<String, dynamic> json) =>
    StudyInvitation(
      json['name'] as String,
      json['description'] as String?,
      json['applicationData'] as String?,
    );

Map<String, dynamic> _$StudyInvitationToJson(StudyInvitation instance) {
  final val = <String, dynamic>{
    'name': instance.name,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('description', instance.description);
  writeNotNull('applicationData', instance.applicationData);
  return val;
}

ActiveParticipationInvitation _$ActiveParticipationInvitationFromJson(
        Map<String, dynamic> json) =>
    ActiveParticipationInvitation(
      Participation.fromJson(json['participation'] as Map<String, dynamic>),
      StudyInvitation.fromJson(json['invitation'] as Map<String, dynamic>),
    )..assignedDevices = (json['assignedDevices'] as List<dynamic>?)
        ?.map((e) => AssignedPrimaryDevice.fromJson(e as Map<String, dynamic>))
        .toList();

Map<String, dynamic> _$ActiveParticipationInvitationToJson(
    ActiveParticipationInvitation instance) {
  final val = <String, dynamic>{
    'participation': instance.participation.toJson(),
    'invitation': instance.invitation.toJson(),
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('assignedDevices',
      instance.assignedDevices?.map((e) => e.toJson()).toList());
  return val;
}

ParticipantStatus _$ParticipantStatusFromJson(Map<String, dynamic> json) =>
    ParticipantStatus(
      json['participantId'] as String,
      AssignedTo.fromJson(
          json['assignedParticipantRoles'] as Map<String, dynamic>),
      (json['assignedPrimaryDeviceRoleNames'] as List<dynamic>)
          .map((e) => e as String)
          .toSet(),
    );

Map<String, dynamic> _$ParticipantStatusToJson(ParticipantStatus instance) =>
    <String, dynamic>{
      'participantId': instance.participantId,
      'assignedParticipantRoles': instance.assignedParticipantRoles.toJson(),
      'assignedPrimaryDeviceRoleNames':
          instance.assignedPrimaryDeviceRoleNames.toList(),
    };

CreateStudyDeployment _$CreateStudyDeploymentFromJson(
        Map<String, dynamic> json) =>
    CreateStudyDeployment(
      StudyProtocol.fromJson(json['protocol'] as Map<String, dynamic>),
      (json['invitations'] as List<dynamic>)
          .map((e) => ParticipantInvitation.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['connectedDevicePreregistrations'] as Map<String, dynamic>?)?.map(
        (k, e) =>
            MapEntry(k, DeviceRegistration.fromJson(e as Map<String, dynamic>)),
      ),
    )
      ..$type = json['__type'] as String?
      ..apiVersion = json['apiVersion'] as String;

Map<String, dynamic> _$CreateStudyDeploymentToJson(
    CreateStudyDeployment instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('__type', instance.$type);
  val['apiVersion'] = instance.apiVersion;
  val['protocol'] = instance.protocol.toJson();
  val['invitations'] = instance.invitations.map((e) => e.toJson()).toList();
  writeNotNull(
      'connectedDevicePreregistrations',
      instance.connectedDevicePreregistrations
          ?.map((k, e) => MapEntry(k, e.toJson())));
  return val;
}

GetStudyDeploymentStatus _$GetStudyDeploymentStatusFromJson(
        Map<String, dynamic> json) =>
    GetStudyDeploymentStatus(
      json['studyDeploymentId'] as String?,
    )
      ..$type = json['__type'] as String?
      ..apiVersion = json['apiVersion'] as String;

Map<String, dynamic> _$GetStudyDeploymentStatusToJson(
    GetStudyDeploymentStatus instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('__type', instance.$type);
  val['apiVersion'] = instance.apiVersion;
  writeNotNull('studyDeploymentId', instance.studyDeploymentId);
  return val;
}

GetStudyDeploymentStatusList _$GetStudyDeploymentStatusListFromJson(
        Map<String, dynamic> json) =>
    GetStudyDeploymentStatusList(
      (json['studyDeploymentIds'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    )
      ..$type = json['__type'] as String?
      ..apiVersion = json['apiVersion'] as String
      ..studyDeploymentId = json['studyDeploymentId'] as String?;

Map<String, dynamic> _$GetStudyDeploymentStatusListToJson(
    GetStudyDeploymentStatusList instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('__type', instance.$type);
  val['apiVersion'] = instance.apiVersion;
  writeNotNull('studyDeploymentId', instance.studyDeploymentId);
  val['studyDeploymentIds'] = instance.studyDeploymentIds;
  return val;
}

RegisterDevice _$RegisterDeviceFromJson(Map<String, dynamic> json) =>
    RegisterDevice(
      json['studyDeploymentId'] as String?,
      json['deviceRoleName'] as String,
      DeviceRegistration.fromJson(json['registration'] as Map<String, dynamic>),
    )
      ..$type = json['__type'] as String?
      ..apiVersion = json['apiVersion'] as String;

Map<String, dynamic> _$RegisterDeviceToJson(RegisterDevice instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('__type', instance.$type);
  val['apiVersion'] = instance.apiVersion;
  writeNotNull('studyDeploymentId', instance.studyDeploymentId);
  val['deviceRoleName'] = instance.deviceRoleName;
  val['registration'] = instance.registration.toJson();
  return val;
}

UnregisterDevice _$UnregisterDeviceFromJson(Map<String, dynamic> json) =>
    UnregisterDevice(
      json['studyDeploymentId'] as String?,
      json['deviceRoleName'] as String,
    )
      ..$type = json['__type'] as String?
      ..apiVersion = json['apiVersion'] as String;

Map<String, dynamic> _$UnregisterDeviceToJson(UnregisterDevice instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('__type', instance.$type);
  val['apiVersion'] = instance.apiVersion;
  writeNotNull('studyDeploymentId', instance.studyDeploymentId);
  val['deviceRoleName'] = instance.deviceRoleName;
  return val;
}

GetDeviceDeploymentFor _$GetDeviceDeploymentForFromJson(
        Map<String, dynamic> json) =>
    GetDeviceDeploymentFor(
      json['studyDeploymentId'] as String?,
      json['primaryDeviceRoleName'] as String,
    )
      ..$type = json['__type'] as String?
      ..apiVersion = json['apiVersion'] as String;

Map<String, dynamic> _$GetDeviceDeploymentForToJson(
    GetDeviceDeploymentFor instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('__type', instance.$type);
  val['apiVersion'] = instance.apiVersion;
  writeNotNull('studyDeploymentId', instance.studyDeploymentId);
  val['primaryDeviceRoleName'] = instance.primaryDeviceRoleName;
  return val;
}

DeviceDeployed _$DeviceDeployedFromJson(Map<String, dynamic> json) =>
    DeviceDeployed(
      json['studyDeploymentId'] as String?,
      json['primaryDeviceRoleName'] as String,
      DateTime.parse(json['deviceDeploymentLastUpdatedOn'] as String),
    )
      ..$type = json['__type'] as String?
      ..apiVersion = json['apiVersion'] as String;

Map<String, dynamic> _$DeviceDeployedToJson(DeviceDeployed instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('__type', instance.$type);
  val['apiVersion'] = instance.apiVersion;
  writeNotNull('studyDeploymentId', instance.studyDeploymentId);
  val['primaryDeviceRoleName'] = instance.primaryDeviceRoleName;
  val['deviceDeploymentLastUpdatedOn'] =
      instance.deviceDeploymentLastUpdatedOn.toIso8601String();
  return val;
}

Stop _$StopFromJson(Map<String, dynamic> json) => Stop(
      json['studyDeploymentId'] as String?,
    )
      ..$type = json['__type'] as String?
      ..apiVersion = json['apiVersion'] as String;

Map<String, dynamic> _$StopToJson(Stop instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('__type', instance.$type);
  val['apiVersion'] = instance.apiVersion;
  writeNotNull('studyDeploymentId', instance.studyDeploymentId);
  return val;
}

GetActiveParticipationInvitations _$GetActiveParticipationInvitationsFromJson(
        Map<String, dynamic> json) =>
    GetActiveParticipationInvitations(
      json['accountId'] as String,
    )
      ..$type = json['__type'] as String?
      ..apiVersion = json['apiVersion'] as String;

Map<String, dynamic> _$GetActiveParticipationInvitationsToJson(
    GetActiveParticipationInvitations instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('__type', instance.$type);
  val['apiVersion'] = instance.apiVersion;
  val['accountId'] = instance.accountId;
  return val;
}

GetParticipantData _$GetParticipantDataFromJson(Map<String, dynamic> json) =>
    GetParticipantData(
      json['studyDeploymentId'] as String?,
    )
      ..$type = json['__type'] as String?
      ..apiVersion = json['apiVersion'] as String;

Map<String, dynamic> _$GetParticipantDataToJson(GetParticipantData instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('__type', instance.$type);
  writeNotNull('studyDeploymentId', instance.studyDeploymentId);
  val['apiVersion'] = instance.apiVersion;
  return val;
}

GetParticipantDataList _$GetParticipantDataListFromJson(
        Map<String, dynamic> json) =>
    GetParticipantDataList(
      (json['studyDeploymentIds'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    )
      ..$type = json['__type'] as String?
      ..studyDeploymentId = json['studyDeploymentId'] as String?
      ..apiVersion = json['apiVersion'] as String;

Map<String, dynamic> _$GetParticipantDataListToJson(
    GetParticipantDataList instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('__type', instance.$type);
  writeNotNull('studyDeploymentId', instance.studyDeploymentId);
  val['apiVersion'] = instance.apiVersion;
  val['studyDeploymentIds'] = instance.studyDeploymentIds;
  return val;
}

SetParticipantData _$SetParticipantDataFromJson(Map<String, dynamic> json) =>
    SetParticipantData(
      json['studyDeploymentId'] as String?,
      (json['data'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(
            k, e == null ? null : Data.fromJson(e as Map<String, dynamic>)),
      ),
      json['inputByParticipantRole'] as String?,
    )
      ..$type = json['__type'] as String?
      ..apiVersion = json['apiVersion'] as String;

Map<String, dynamic> _$SetParticipantDataToJson(SetParticipantData instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('__type', instance.$type);
  writeNotNull('studyDeploymentId', instance.studyDeploymentId);
  val['apiVersion'] = instance.apiVersion;
  writeNotNull('inputByParticipantRole', instance.inputByParticipantRole);
  writeNotNull('data', instance.data?.map((k, e) => MapEntry(k, e?.toJson())));
  return val;
}
