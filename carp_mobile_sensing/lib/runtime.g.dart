// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'runtime.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserTaskSnapshot _$UserTaskSnapshotFromJson(Map<String, dynamic> json) =>
    UserTaskSnapshot(
      json['id'] as String,
      AppTask.fromJson(json['task'] as Map<String, dynamic>),
      $enumDecode(_$UserTaskStateEnumMap, json['state']),
      DateTime.parse(json['enqueued'] as String),
      DateTime.parse(json['triggerTime'] as String),
      json['doneTime'] == null
          ? null
          : DateTime.parse(json['doneTime'] as String),
      json['hasNotificationBeenCreated'] as bool,
      json['studyDeploymentId'] as String?,
      json['deviceRoleName'] as String?,
    )..$type = json['__type'] as String?;

Map<String, dynamic> _$UserTaskSnapshotToJson(UserTaskSnapshot instance) =>
    <String, dynamic>{
      if (instance.$type case final value?) '__type': value,
      'id': instance.id,
      'task': instance.task.toJson(),
      'state': _$UserTaskStateEnumMap[instance.state]!,
      'enqueued': instance.enqueued.toIso8601String(),
      'triggerTime': instance.triggerTime.toIso8601String(),
      if (instance.doneTime?.toIso8601String() case final value?)
        'doneTime': value,
      'hasNotificationBeenCreated': instance.hasNotificationBeenCreated,
      if (instance.studyDeploymentId case final value?)
        'studyDeploymentId': value,
      if (instance.deviceRoleName case final value?) 'deviceRoleName': value,
    };

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
