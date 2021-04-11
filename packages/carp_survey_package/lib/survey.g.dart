// GENERATED CODE - DO NOT MODIFY BY HAND

part of survey;

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RPTaskMeasure _$RPTaskMeasureFromJson(Map<String, dynamic> json) {
  return RPTaskMeasure(
    type: json['type'] as String,
    measureDescription:
        (json['measureDescription'] as Map<String, dynamic>)?.map(
      (k, e) => MapEntry(
          k,
          e == null
              ? null
              : MeasureDescription.fromJson(e as Map<String, dynamic>)),
    ),
    enabled: json['enabled'] as bool,
  )
    ..$type = json[r'$type'] as String
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

  writeNotNull(r'$type', instance.$type);
  writeNotNull('type', instance.type);
  writeNotNull('measureDescription', instance.measureDescription);
  writeNotNull('enabled', instance.enabled);
  writeNotNull('configuration', instance.configuration);
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
