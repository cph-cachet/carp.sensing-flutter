// GENERATED CODE - DO NOT MODIFY BY HAND

part of carp_core_deployment;

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PrimaryDeviceDeployment _$PrimaryDeviceDeploymentFromJson(
        Map<String, dynamic> json) =>
    PrimaryDeviceDeployment(
      deviceConfiguration: PrimaryDeviceConfiguration.fromJson(
          json['deviceConfiguration'] as Map<String, dynamic>),
      registration: DeviceRegistration.fromJson(
          json['registration'] as Map<String, dynamic>),
      connectedDevices: (json['connectedDevices'] as List<dynamic>?)
              ?.map((e) =>
                  DeviceConfiguration.fromJson(e as Map<String, dynamic>))
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
    )
      ..applicationData = json['applicationData'] as String?
      ..lastUpdateDate = DateTime.parse(json['lastUpdateDate'] as String);

Map<String, dynamic> _$PrimaryDeviceDeploymentToJson(
    PrimaryDeviceDeployment instance) {
  final val = <String, dynamic>{
    'deviceConfiguration': instance.deviceConfiguration,
    'registration': instance.registration,
    'connectedDevices': instance.connectedDevices.toList(),
    'connectedDeviceRegistrations': instance.connectedDeviceRegistrations,
    'tasks': instance.tasks.toList(),
    'triggers': instance.triggers,
    'taskControls': instance.taskControls.toList(),
    'expectedParticipantData': instance.expectedParticipantData.toList(),
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('applicationData', instance.applicationData);
  val['lastUpdateDate'] = instance.lastUpdateDate.toIso8601String();
  return val;
}

DeviceDeploymentStatus _$DeviceDeploymentStatusFromJson(
        Map<String, dynamic> json) =>
    DeviceDeploymentStatus(
      device:
          DeviceConfiguration.fromJson(json['device'] as Map<String, dynamic>),
    )
      ..$type = json['__type'] as String?
      ..requiresDeployment = json['requiresDeployment'] as bool
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
  val['device'] = instance.device;
  val['requiresDeployment'] = instance.requiresDeployment;
  writeNotNull('remainingDevicesToRegisterToObtainDeployment',
      instance.remainingDevicesToRegisterToObtainDeployment);
  writeNotNull('remainingDevicesToRegisterBeforeDeployment',
      instance.remainingDevicesToRegisterBeforeDeployment);
  return val;
}

DeviceInvitation _$DeviceInvitationFromJson(Map<String, dynamic> json) =>
    DeviceInvitation()
      ..deviceRoleName = json['deviceRoleName'] as String
      ..isRegistered = json['isRegistered'] as bool;

Map<String, dynamic> _$DeviceInvitationToJson(DeviceInvitation instance) =>
    <String, dynamic>{
      'deviceRoleName': instance.deviceRoleName,
      'isRegistered': instance.isRegistered,
    };

StudyDeploymentStatus _$StudyDeploymentStatusFromJson(
        Map<String, dynamic> json) =>
    StudyDeploymentStatus(
      studyDeploymentId: json['studyDeploymentId'] as String,
      devicesStatus: (json['devicesStatus'] as List<dynamic>?)
              ?.map((e) =>
                  DeviceDeploymentStatus.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    )
      ..$type = json['__type'] as String?
      ..startTime = json['startTime'] == null
          ? null
          : DateTime.parse(json['startTime'] as String);

Map<String, dynamic> _$StudyDeploymentStatusToJson(
    StudyDeploymentStatus instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('__type', instance.$type);
  val['studyDeploymentId'] = instance.studyDeploymentId;
  val['devicesStatus'] = instance.devicesStatus;
  writeNotNull('startTime', instance.startTime?.toIso8601String());
  return val;
}

ParticipantData _$ParticipantDataFromJson(Map<String, dynamic> json) =>
    ParticipantData(
      studyDeploymentId: json['studyDeploymentId'] as String,
      data: json['data'] as Map<String, dynamic>,
    );

Map<String, dynamic> _$ParticipantDataToJson(ParticipantData instance) =>
    <String, dynamic>{
      'studyDeploymentId': instance.studyDeploymentId,
      'data': instance.data,
    };

EmailAccountIdentity _$EmailAccountIdentityFromJson(
        Map<String, dynamic> json) =>
    EmailAccountIdentity(
      json['emailAddress'] as String,
    )..$type = json['__type'] as String?;

Map<String, dynamic> _$EmailAccountIdentityToJson(
    EmailAccountIdentity instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('__type', instance.$type);
  val['emailAddress'] = instance.emailAddress;
  return val;
}

Participation _$ParticipationFromJson(Map<String, dynamic> json) =>
    Participation(
      json['studyDeploymentId'] as String,
      json['id'] as String,
    )..isRegistered = json['isRegistered'] as bool?;

Map<String, dynamic> _$ParticipationToJson(Participation instance) {
  final val = <String, dynamic>{
    'studyDeploymentId': instance.studyDeploymentId,
    'id': instance.id,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('isRegistered', instance.isRegistered);
  return val;
}

StudyInvitation _$StudyInvitationFromJson(Map<String, dynamic> json) =>
    StudyInvitation(
      json['name'] as String,
      json['description'] as String,
    )..applicationData = json['applicationData'] as String?;

Map<String, dynamic> _$StudyInvitationToJson(StudyInvitation instance) {
  final val = <String, dynamic>{
    'name': instance.name,
    'description': instance.description,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('applicationData', instance.applicationData);
  return val;
}

ActiveParticipationInvitation _$ActiveParticipationInvitationFromJson(
        Map<String, dynamic> json) =>
    ActiveParticipationInvitation(
      Participation.fromJson(json['participation'] as Map<String, dynamic>),
      StudyInvitation.fromJson(json['invitation'] as Map<String, dynamic>),
    )..devices = (json['devices'] as List<dynamic>?)
        ?.map((e) => DeviceInvitation.fromJson(e as Map<String, dynamic>))
        .toList();

Map<String, dynamic> _$ActiveParticipationInvitationToJson(
    ActiveParticipationInvitation instance) {
  final val = <String, dynamic>{
    'participation': instance.participation,
    'invitation': instance.invitation,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('devices', instance.devices);
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

CreateStudyDeployment _$CreateStudyDeploymentFromJson(
        Map<String, dynamic> json) =>
    CreateStudyDeployment(
      StudyProtocol.fromJson(json['protocol'] as Map<String, dynamic>),
    )..$type = json['__type'] as String?;

Map<String, dynamic> _$CreateStudyDeploymentToJson(
        CreateStudyDeployment instance) =>
    <String, dynamic>{
      '__type': instance.$type,
      'protocol': instance.protocol,
    };

GetStudyDeploymentStatus _$GetStudyDeploymentStatusFromJson(
        Map<String, dynamic> json) =>
    GetStudyDeploymentStatus(
      json['studyDeploymentId'] as String?,
    )..$type = json['__type'] as String?;

Map<String, dynamic> _$GetStudyDeploymentStatusToJson(
        GetStudyDeploymentStatus instance) =>
    <String, dynamic>{
      '__type': instance.$type,
      'studyDeploymentId': instance.studyDeploymentId,
    };

GetStudyDeploymentStatusList _$GetStudyDeploymentStatusListFromJson(
        Map<String, dynamic> json) =>
    GetStudyDeploymentStatusList(
      (json['studyDeploymentIds'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    )
      ..$type = json['__type'] as String?
      ..studyDeploymentId = json['studyDeploymentId'] as String?;

Map<String, dynamic> _$GetStudyDeploymentStatusListToJson(
        GetStudyDeploymentStatusList instance) =>
    <String, dynamic>{
      '__type': instance.$type,
      'studyDeploymentId': instance.studyDeploymentId,
      'studyDeploymentIds': instance.studyDeploymentIds,
    };

RegisterDevice _$RegisterDeviceFromJson(Map<String, dynamic> json) =>
    RegisterDevice(
      json['studyDeploymentId'] as String?,
      json['deviceRoleName'] as String,
      DeviceRegistration.fromJson(json['registration'] as Map<String, dynamic>),
    )..$type = json['__type'] as String?;

Map<String, dynamic> _$RegisterDeviceToJson(RegisterDevice instance) =>
    <String, dynamic>{
      '__type': instance.$type,
      'studyDeploymentId': instance.studyDeploymentId,
      'deviceRoleName': instance.deviceRoleName,
      'registration': instance.registration,
    };

UnregisterDevice _$UnregisterDeviceFromJson(Map<String, dynamic> json) =>
    UnregisterDevice(
      json['studyDeploymentId'] as String?,
      json['deviceRoleName'] as String,
    )..$type = json['__type'] as String?;

Map<String, dynamic> _$UnregisterDeviceToJson(UnregisterDevice instance) =>
    <String, dynamic>{
      '__type': instance.$type,
      'studyDeploymentId': instance.studyDeploymentId,
      'deviceRoleName': instance.deviceRoleName,
    };

GetDeviceDeploymentFor _$GetDeviceDeploymentForFromJson(
        Map<String, dynamic> json) =>
    GetDeviceDeploymentFor(
      json['studyDeploymentId'] as String?,
      json['masterDeviceRoleName'] as String,
    )..$type = json['__type'] as String?;

Map<String, dynamic> _$GetDeviceDeploymentForToJson(
        GetDeviceDeploymentFor instance) =>
    <String, dynamic>{
      '__type': instance.$type,
      'studyDeploymentId': instance.studyDeploymentId,
      'masterDeviceRoleName': instance.masterDeviceRoleName,
    };

DeploymentSuccessful _$DeploymentSuccessfulFromJson(
        Map<String, dynamic> json) =>
    DeploymentSuccessful(
      json['studyDeploymentId'] as String,
      json['masterDeviceRoleName'] as String,
      DateTime.parse(json['deviceDeploymentLastUpdateDate'] as String),
    )..$type = json['__type'] as String?;

Map<String, dynamic> _$DeploymentSuccessfulToJson(
        DeploymentSuccessful instance) =>
    <String, dynamic>{
      '__type': instance.$type,
      'studyDeploymentId': instance.studyDeploymentId,
      'masterDeviceRoleName': instance.masterDeviceRoleName,
      'deviceDeploymentLastUpdateDate':
          instance.deviceDeploymentLastUpdateDate?.toIso8601String(),
    };

Stop _$StopFromJson(Map<String, dynamic> json) => Stop(
      json['studyDeploymentId'] as String?,
    )..$type = json['__type'] as String?;

Map<String, dynamic> _$StopToJson(Stop instance) => <String, dynamic>{
      '__type': instance.$type,
      'studyDeploymentId': instance.studyDeploymentId,
    };

GetActiveParticipationInvitations _$GetActiveParticipationInvitationsFromJson(
        Map<String, dynamic> json) =>
    GetActiveParticipationInvitations(
      json['accountId'] as String,
    )..$type = json['__type'] as String?;

Map<String, dynamic> _$GetActiveParticipationInvitationsToJson(
        GetActiveParticipationInvitations instance) =>
    <String, dynamic>{
      '__type': instance.$type,
      'accountId': instance.accountId,
    };

GetParticipantData _$GetParticipantDataFromJson(Map<String, dynamic> json) =>
    GetParticipantData(
      json['studyDeploymentId'] as String?,
    )..$type = json['__type'] as String?;

Map<String, dynamic> _$GetParticipantDataToJson(GetParticipantData instance) =>
    <String, dynamic>{
      '__type': instance.$type,
      'studyDeploymentId': instance.studyDeploymentId,
    };

GetParticipantDataList _$GetParticipantDataListFromJson(
        Map<String, dynamic> json) =>
    GetParticipantDataList(
      (json['studyDeploymentIds'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    )
      ..$type = json['__type'] as String?
      ..studyDeploymentId = json['studyDeploymentId'] as String?;

Map<String, dynamic> _$GetParticipantDataListToJson(
        GetParticipantDataList instance) =>
    <String, dynamic>{
      '__type': instance.$type,
      'studyDeploymentId': instance.studyDeploymentId,
      'studyDeploymentIds': instance.studyDeploymentIds,
    };

SetParticipantData _$SetParticipantDataFromJson(Map<String, dynamic> json) =>
    SetParticipantData(
      json['studyDeploymentId'] as String?,
      json['inputDataType'] as String,
    )
      ..$type = json['__type'] as String?
      ..data = json['data'] as Map<String, dynamic>;

Map<String, dynamic> _$SetParticipantDataToJson(SetParticipantData instance) =>
    <String, dynamic>{
      '__type': instance.$type,
      'studyDeploymentId': instance.studyDeploymentId,
      'inputDataType': instance.inputDataType,
      'data': instance.data,
    };
