// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'carp_core_protocols.dart';

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
      ..version = (json['version'] as num).toInt()
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
              .toSet()
      ..applicationData = json['applicationData'] as Map<String, dynamic>?;

Map<String, dynamic> _$StudyProtocolToJson(StudyProtocol instance) =>
    <String, dynamic>{
      'id': instance.id,
      'createdOn': instance.createdOn.toIso8601String(),
      'version': instance.version,
      'ownerId': instance.ownerId,
      'name': instance.name,
      if (instance.description case final value?) 'description': value,
      if (instance.participantRoles?.map((e) => e.toJson()).toList()
          case final value?)
        'participantRoles': value,
      'primaryDevices': instance.primaryDevices.map((e) => e.toJson()).toList(),
      if (instance.connectedDevices?.map((e) => e.toJson()).toList()
          case final value?)
        'connectedDevices': value,
      if (instance.connections?.map((e) => e.toJson()).toList()
          case final value?)
        'connections': value,
      if (instance.assignedDevices?.map((k, e) => MapEntry(k, e.toList()))
          case final value?)
        'assignedDevices': value,
      'tasks': instance.tasks.map((e) => e.toJson()).toList(),
      'triggers': instance.triggers.map((k, e) => MapEntry(k, e.toJson())),
      'taskControls': instance.taskControls.map((e) => e.toJson()).toList(),
      if (instance.expectedParticipantData?.map((e) => e.toJson()).toList()
          case final value?)
        'expectedParticipantData': value,
      if (instance.applicationData case final value?) 'applicationData': value,
    };

DeviceConnection _$DeviceConnectionFromJson(Map<String, dynamic> json) =>
    DeviceConnection(
      json['roleName'] as String?,
      json['connectedToRoleName'] as String?,
    );

Map<String, dynamic> _$DeviceConnectionToJson(DeviceConnection instance) =>
    <String, dynamic>{
      if (instance.roleName case final value?) 'roleName': value,
      if (instance.connectedToRoleName case final value?)
        'connectedToRoleName': value,
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
      StudyProtocol.fromJson(json['protocol'] as Map<String, dynamic>),
      json['versionTag'] as String?,
    )
      ..$type = json['__type'] as String?
      ..apiVersion = json['apiVersion'] as String;

Map<String, dynamic> _$AddToJson(Add instance) => <String, dynamic>{
      if (instance.$type case final value?) '__type': value,
      'apiVersion': instance.apiVersion,
      'protocol': instance.protocol.toJson(),
      if (instance.versionTag case final value?) 'versionTag': value,
    };

AddVersion _$AddVersionFromJson(Map<String, dynamic> json) => AddVersion(
      StudyProtocol.fromJson(json['protocol'] as Map<String, dynamic>),
      json['versionTag'] as String?,
    )
      ..$type = json['__type'] as String?
      ..apiVersion = json['apiVersion'] as String;

Map<String, dynamic> _$AddVersionToJson(AddVersion instance) =>
    <String, dynamic>{
      if (instance.$type case final value?) '__type': value,
      'apiVersion': instance.apiVersion,
      'protocol': instance.protocol.toJson(),
      if (instance.versionTag case final value?) 'versionTag': value,
    };

UpdateParticipantDataConfiguration _$UpdateParticipantDataConfigurationFromJson(
        Map<String, dynamic> json) =>
    UpdateParticipantDataConfiguration(
      json['protocolId'] as String,
      json['versionTag'] as String?,
      (json['expectedParticipantData'] as List<dynamic>?)
          ?.map((e) =>
              ExpectedParticipantData.fromJson(e as Map<String, dynamic>))
          .toList(),
    )
      ..$type = json['__type'] as String?
      ..apiVersion = json['apiVersion'] as String;

Map<String, dynamic> _$UpdateParticipantDataConfigurationToJson(
        UpdateParticipantDataConfiguration instance) =>
    <String, dynamic>{
      if (instance.$type case final value?) '__type': value,
      'apiVersion': instance.apiVersion,
      'protocolId': instance.protocolId,
      if (instance.versionTag case final value?) 'versionTag': value,
      if (instance.expectedParticipantData?.map((e) => e.toJson()).toList()
          case final value?)
        'expectedParticipantData': value,
    };

GetBy _$GetByFromJson(Map<String, dynamic> json) => GetBy(
      json['protocolId'] as String,
      json['versionTag'] as String?,
    )
      ..$type = json['__type'] as String?
      ..apiVersion = json['apiVersion'] as String;

Map<String, dynamic> _$GetByToJson(GetBy instance) => <String, dynamic>{
      if (instance.$type case final value?) '__type': value,
      'apiVersion': instance.apiVersion,
      'protocolId': instance.protocolId,
      if (instance.versionTag case final value?) 'versionTag': value,
    };

GetAllForOwner _$GetAllForOwnerFromJson(Map<String, dynamic> json) =>
    GetAllForOwner(
      json['ownerId'] as String,
    )
      ..$type = json['__type'] as String?
      ..apiVersion = json['apiVersion'] as String;

Map<String, dynamic> _$GetAllForOwnerToJson(GetAllForOwner instance) =>
    <String, dynamic>{
      if (instance.$type case final value?) '__type': value,
      'apiVersion': instance.apiVersion,
      'ownerId': instance.ownerId,
    };

GetVersionHistoryFor _$GetVersionHistoryForFromJson(
        Map<String, dynamic> json) =>
    GetVersionHistoryFor(
      json['protocolId'] as String,
    )
      ..$type = json['__type'] as String?
      ..apiVersion = json['apiVersion'] as String;

Map<String, dynamic> _$GetVersionHistoryForToJson(
        GetVersionHistoryFor instance) =>
    <String, dynamic>{
      if (instance.$type case final value?) '__type': value,
      'apiVersion': instance.apiVersion,
      'protocolId': instance.protocolId,
    };

CreateCustomProtocol _$CreateCustomProtocolFromJson(
        Map<String, dynamic> json) =>
    CreateCustomProtocol(
      json['ownerId'] as String,
      json['name'] as String,
      json['description'] as String,
      json['customProtocol'] as String,
    )
      ..$type = json['__type'] as String?
      ..apiVersion = json['apiVersion'] as String;

Map<String, dynamic> _$CreateCustomProtocolToJson(
        CreateCustomProtocol instance) =>
    <String, dynamic>{
      if (instance.$type case final value?) '__type': value,
      'apiVersion': instance.apiVersion,
      'ownerId': instance.ownerId,
      'name': instance.name,
      'description': instance.description,
      'customProtocol': instance.customProtocol,
    };
