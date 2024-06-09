// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trigger_example.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RemoteTrigger _$RemoteTriggerFromJson(Map<String, dynamic> json) =>
    RemoteTrigger(
      uri: json['uri'] as String,
      interval: json['interval'] == null
          ? const Duration(minutes: 10)
          : Duration(microseconds: (json['interval'] as num).toInt()),
    )
      ..$type = json['__type'] as String?
      ..sourceDeviceRoleName = json['sourceDeviceRoleName'] as String?;

Map<String, dynamic> _$RemoteTriggerToJson(RemoteTrigger instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('__type', instance.$type);
  writeNotNull('sourceDeviceRoleName', instance.sourceDeviceRoleName);
  val['uri'] = instance.uri;
  val['interval'] = instance.interval.inMicroseconds;
  return val;
}
