// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pedometer_datum.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PedometerDatum _$PedometerDatumFromJson(Map<String, dynamic> json) {
  return PedometerDatum()
    ..$ = json[r'$'] as String
    ..id = json['id'] as String
    ..timestamp = json['timestamp'] == null
        ? null
        : DateTime.parse(json['timestamp'] as String)
    ..deviceInfo = json['device_info'] == null
        ? null
        : DeviceInfo.fromJson(json['device_info'] as Map<String, dynamic>)
    ..startTime = json['start_time'] == null
        ? null
        : DateTime.parse(json['start_time'] as String)
    ..endTime = json['end_time'] == null
        ? null
        : DateTime.parse(json['end_time'] as String)
    ..stepCount = json['step_count'] as int;
}

Map<String, dynamic> _$PedometerDatumToJson(PedometerDatum instance) {
  var val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull(r'$', instance.$);
  writeNotNull('id', instance.id);
  writeNotNull('timestamp', instance.timestamp?.toIso8601String());
  writeNotNull('device_info', instance.deviceInfo);
  writeNotNull('start_time', instance.startTime?.toIso8601String());
  writeNotNull('end_time', instance.endTime?.toIso8601String());
  writeNotNull('step_count', instance.stepCount);
  return val;
}
