// GENERATED CODE - DO NOT MODIFY BY HAND

part of survey;

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RPTaskMeasure _$RPTaskMeasureFromJson(Map<String, dynamic> json) {
  return RPTaskMeasure(
    json['type'] == null
        ? null
        : MeasureType.fromJson(json['type'] as Map<String, dynamic>),
    name: json['name'] as String,
    enabled: json['enabled'] as bool,
    notification: json['notification'] as bool,
  )
    ..c__ = json['c__'] as String
    ..configuration = (json['configuration'] as Map<String, dynamic>)?.map(
      (k, e) => MapEntry(k, e as String),
    );
}

Map<String, dynamic> _$RPTaskMeasureToJson(RPTaskMeasure instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('c__', instance.c__);
  writeNotNull('type', instance.type);
  writeNotNull('name', instance.name);
  writeNotNull('enabled', instance.enabled);
  writeNotNull('configuration', instance.configuration);
  writeNotNull('notification', instance.notification);
  return val;
}

RPTaskResultDatum _$RPTaskResultDatumFromJson(Map<String, dynamic> json) {
  return RPTaskResultDatum(
    json['survey_result'] == null
        ? null
        : RPTaskResult.fromJson(json['survey_result'] as Map<String, dynamic>),
  )
    ..id = json['id'] as String
    ..timestamp = json['timestamp'] == null
        ? null
        : DateTime.parse(json['timestamp'] as String);
}

Map<String, dynamic> _$RPTaskResultDatumToJson(RPTaskResultDatum instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  writeNotNull('timestamp', instance.timestamp?.toIso8601String());
  writeNotNull('survey_result', instance.surveyResult);
  return val;
}
