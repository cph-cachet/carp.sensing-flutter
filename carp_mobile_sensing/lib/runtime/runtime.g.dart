// GENERATED CODE - DO NOT MODIFY BY HAND

part of runtime;

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserTaskSnapshotList _$UserTaskSnapshotListFromJson(Map<String, dynamic> json) {
  return UserTaskSnapshotList()
    ..$type = json[r'$type'] as String?
    ..snapshot = (json['snapshot'] as List<dynamic>)
        .map((e) => UserTaskSnapshot.fromJson(e as Map<String, dynamic>))
        .toList();
}

Map<String, dynamic> _$UserTaskSnapshotListToJson(
    UserTaskSnapshotList instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull(r'$type', instance.$type);
  val['snapshot'] = instance.snapshot;
  return val;
}

UserTaskSnapshot _$UserTaskSnapshotFromJson(Map<String, dynamic> json) {
  return UserTaskSnapshot(
    AppTask.fromJson(json['task'] as Map<String, dynamic>),
    _$enumDecode(_$UserTaskStateEnumMap, json['state']),
    DateTime.parse(json['enqueued'] as String),
  )..$type = json[r'$type'] as String?;
}

Map<String, dynamic> _$UserTaskSnapshotToJson(UserTaskSnapshot instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull(r'$type', instance.$type);
  val['task'] = instance.task;
  val['state'] = _$UserTaskStateEnumMap[instance.state];
  val['enqueued'] = instance.enqueued.toIso8601String();
  return val;
}

K _$enumDecode<K, V>(
  Map<K, V> enumValues,
  Object? source, {
  K? unknownValue,
}) {
  if (source == null) {
    throw ArgumentError(
      'A value must be provided. Supported values: '
      '${enumValues.values.join(', ')}',
    );
  }

  return enumValues.entries.singleWhere(
    (e) => e.value == source,
    orElse: () {
      if (unknownValue == null) {
        throw ArgumentError(
          '`$source` is not one of the supported values: '
          '${enumValues.values.join(', ')}',
        );
      }
      return MapEntry(unknownValue, enumValues.values.first);
    },
  ).key;
}

const _$UserTaskStateEnumMap = {
  UserTaskState.initialized: 'initialized',
  UserTaskState.enqueued: 'enqueued',
  UserTaskState.dequeued: 'dequeued',
  UserTaskState.started: 'started',
  UserTaskState.canceled: 'canceled',
  UserTaskState.done: 'done',
  UserTaskState.expired: 'expired',
  UserTaskState.undefined: 'undefined',
};
