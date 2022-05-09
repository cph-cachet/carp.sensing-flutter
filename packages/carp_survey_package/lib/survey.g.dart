// GENERATED CODE - DO NOT MODIFY BY HAND

part of survey;

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RPTaskSamplingConfiguration _$RPTaskSamplingConfigurationFromJson(
        Map<String, dynamic> json) =>
    RPTaskSamplingConfiguration(
      surveyTask: RPTask.fromJson(json['surveyTask'] as Map<String, dynamic>),
    )
      ..$type = json[r'$type'] as String?
      ..lastTime = json['lastTime'] == null
          ? null
          : DateTime.parse(json['lastTime'] as String);

Map<String, dynamic> _$RPTaskSamplingConfigurationToJson(
    RPTaskSamplingConfiguration instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull(r'$type', instance.$type);
  writeNotNull('lastTime', instance.lastTime?.toIso8601String());
  val['surveyTask'] = instance.surveyTask;
  return val;
}

RPTaskResultDatum _$RPTaskResultDatumFromJson(Map<String, dynamic> json) =>
    RPTaskResultDatum(
      json['survey_result'] == null
          ? null
          : RPTaskResult.fromJson(
              json['survey_result'] as Map<String, dynamic>),
    )
      ..id = json['id'] as String?
      ..timestamp = DateTime.parse(json['timestamp'] as String);

Map<String, dynamic> _$RPTaskResultDatumToJson(RPTaskResultDatum instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  val['timestamp'] = instance.timestamp.toIso8601String();
  writeNotNull('survey_result', instance.surveyResult);
  return val;
}
