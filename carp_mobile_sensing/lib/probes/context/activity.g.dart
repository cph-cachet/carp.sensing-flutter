// GENERATED CODE - DO NOT MODIFY BY HAND

part of activity;

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ActivityDatum _$ActivityDatumFromJson(Map<String, dynamic> json) {
  return ActivityDatum()
    ..id = json['id'] as String
    ..timestamp = json['timestamp'] == null
        ? null
        : DateTime.parse(json['timestamp'] as String)
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

  writeNotNull('id', instance.id);
  writeNotNull('timestamp', instance.timestamp?.toIso8601String());
  writeNotNull('confidence', instance.confidence);
  writeNotNull('type', instance.type);
  return val;
}
