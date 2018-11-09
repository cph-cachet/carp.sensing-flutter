// GENERATED CODE - DO NOT MODIFY BY HAND

part of activity;

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ActivityDatum _$ActivityDatumFromJson(Map<String, dynamic> json) {
  return ActivityDatum()
    ..classname = json['classname'] as String
    ..id = json['id'] as String
    ..timestamp = json['timestamp'] == null
        ? null
        : DateTime.parse(json['timestamp'] as String)
    ..deviceInfo = json['device_info'] == null
        ? null
        : DeviceInfo.fromJson(json['device_info'] as Map<String, dynamic>)
    ..confidence = json['confidence'] as int
    ..type = json['type'] as String;
}

Map<String, dynamic> _$ActivityDatumToJson(ActivityDatum instance) {
  var val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('classname', instance.classname);
  writeNotNull('id', instance.id);
  writeNotNull('timestamp', instance.timestamp?.toIso8601String());
  writeNotNull('device_info', instance.deviceInfo);
  writeNotNull('confidence', instance.confidence);
  writeNotNull('type', instance.type);
  return val;
}
