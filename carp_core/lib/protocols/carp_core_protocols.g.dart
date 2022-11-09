// GENERATED CODE - DO NOT MODIFY BY HAND

part of carp_core_protocols;

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StudyProtocol _$StudyProtocolFromJson(Map<String, dynamic> json) =>
    StudyProtocol(
      ownerId: json['ownerId'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
    )
      ..id = json['id'] as String
      ..createdOn = DateTime.parse(json['createdOn'] as String)
      ..version = json['version'] as int
      ..primaryDevices = (json['primaryDevices'] as List<dynamic>)
          .map((e) =>
              PrimaryDeviceConfiguration.fromJson(e as Map<String, dynamic>))
          .toSet()
      ..connectedDevices = (json['connectedDevices'] as List<dynamic>?)
          ?.map((e) => DeviceConfiguration.fromJson(e as Map<String, dynamic>))
          .toSet()
      ..connections = (json['connections'] as List<dynamic>?)
          ?.map((e) => DeviceConnection.fromJson(e as Map<String, dynamic>))
          .toList()
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
      ..participantRoles = (json['participantRoles'] as List<dynamic>?)
          ?.map((e) => ParticipantRole.fromJson(e as Map<String, dynamic>))
          .toSet()
      ..assignedDevices =
          (json['assignedDevices'] as Map<String, dynamic>?)?.map(
        (k, e) =>
            MapEntry(k, (e as List<dynamic>).map((e) => e as String).toSet()),
      )
      ..expectedParticipantData =
          (json['expectedParticipantData'] as List<dynamic>?)
              ?.map((e) =>
                  ExpectedParticipantData.fromJson(e as Map<String, dynamic>))
              .toSet()
      ..applicationData = json['applicationData'] as Map<String, dynamic>?;

Map<String, dynamic> _$StudyProtocolToJson(StudyProtocol instance) {
  final val = <String, dynamic>{
    'id': instance.id,
    'createdOn': instance.createdOn.toIso8601String(),
    'version': instance.version,
    'ownerId': instance.ownerId,
    'name': instance.name,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('description', instance.description);
  val['primaryDevices'] = instance.primaryDevices.toList();
  writeNotNull('connectedDevices', instance.connectedDevices?.toList());
  writeNotNull('connections', instance.connections);
  val['tasks'] = instance.tasks.toList();
  val['triggers'] = instance.triggers;
  val['taskControls'] = instance.taskControls.toList();
  writeNotNull('participantRoles', instance.participantRoles?.toList());
  writeNotNull('assignedDevices',
      instance.assignedDevices?.map((k, e) => MapEntry(k, e.toList())));
  writeNotNull(
      'expectedParticipantData', instance.expectedParticipantData?.toList());
  writeNotNull('applicationData', instance.applicationData);
  return val;
}

DeviceConnection _$DeviceConnectionFromJson(Map<String, dynamic> json) =>
    DeviceConnection(
      json['roleName'] as String?,
      json['connectedToRoleName'] as String?,
    );

Map<String, dynamic> _$DeviceConnectionToJson(DeviceConnection instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('roleName', instance.roleName);
  writeNotNull('connectedToRoleName', instance.connectedToRoleName);
  return val;
}

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
    )..$type = json['__type'] as String?;

Map<String, dynamic> _$AddToJson(Add instance) => <String, dynamic>{
      '__type': instance.$type,
      'protocol': instance.protocol,
      'versionTag': instance.versionTag,
    };

AddVersion _$AddVersionFromJson(Map<String, dynamic> json) => AddVersion(
      json['protocol'] == null
          ? null
          : StudyProtocol.fromJson(json['protocol'] as Map<String, dynamic>),
      json['versionTag'] as String?,
    )..$type = json['__type'] as String?;

Map<String, dynamic> _$AddVersionToJson(AddVersion instance) =>
    <String, dynamic>{
      '__type': instance.$type,
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
    )..$type = json['__type'] as String?;

Map<String, dynamic> _$UpdateParticipantDataConfigurationToJson(
        UpdateParticipantDataConfiguration instance) =>
    <String, dynamic>{
      '__type': instance.$type,
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
    )..$type = json['__type'] as String?;

Map<String, dynamic> _$GetByToJson(GetBy instance) {
  final val = <String, dynamic>{
    '__type': instance.$type,
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
    )..$type = json['__type'] as String?;

Map<String, dynamic> _$GetAllForToJson(GetAllFor instance) => <String, dynamic>{
      '__type': instance.$type,
      'ownerId': instance.ownerId,
    };

GetVersionHistoryFor _$GetVersionHistoryForFromJson(
        Map<String, dynamic> json) =>
    GetVersionHistoryFor(
      json['protocolId'] == null
          ? null
          : StudyProtocolId.fromJson(
              json['protocolId'] as Map<String, dynamic>),
    )..$type = json['__type'] as String?;

Map<String, dynamic> _$GetVersionHistoryForToJson(
        GetVersionHistoryFor instance) =>
    <String, dynamic>{
      '__type': instance.$type,
      'protocolId': instance.protocolId,
    };

CreateCustomProtocol _$CreateCustomProtocolFromJson(
        Map<String, dynamic> json) =>
    CreateCustomProtocol(
      json['ownerId'] as String?,
      json['name'] as String?,
      json['description'] as String?,
      json['customProtocol'] as String?,
    )..$type = json['__type'] as String?;

Map<String, dynamic> _$CreateCustomProtocolToJson(
        CreateCustomProtocol instance) =>
    <String, dynamic>{
      '__type': instance.$type,
      'ownerId': instance.ownerId,
      'name': instance.name,
      'description': instance.description,
      'customProtocol': instance.customProtocol,
    };
