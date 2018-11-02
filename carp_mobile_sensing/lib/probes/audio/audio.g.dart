// GENERATED CODE - DO NOT MODIFY BY HAND

part of audio;

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AudioDatum _$AudioDatumFromJson(Map<String, dynamic> json) {
  return AudioDatum(filePath: json['file_path'] as String)
    ..$ = json[r'$'] as String
    ..id = json['id'] as String
    ..timestamp = json['timestamp'] == null
        ? null
        : DateTime.parse(json['timestamp'] as String)
    ..deviceInfo = json['device_info'] == null
        ? null
        : DeviceInfo.fromJson(json['device_info'] as Map<String, dynamic>)
    ..audioBytes =
        (json['audio_bytes'] as List)?.map((e) => e as int)?.toList();
}

Map<String, dynamic> _$AudioDatumToJson(AudioDatum instance) {
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
  writeNotNull('file_path', instance.filePath);
  writeNotNull('audio_bytes', instance.audioBytes);
  return val;
}
