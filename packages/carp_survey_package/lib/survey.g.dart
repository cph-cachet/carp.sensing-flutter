// GENERATED CODE - DO NOT MODIFY BY HAND

part of survey;

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RPTaskMeasure _$RPTaskMeasureFromJson(Map<String, dynamic> json) =>
    RPTaskMeasure(
      type: json['type'] as String,
      name: json['name'] as String?,
      description: json['description'] as String?,
      enabled: json['enabled'] as bool? ?? true,
      surveyTask: RPTask.fromJson(json['surveyTask'] as Map<String, dynamic>),
    )
      ..$type = json[r'$type'] as String?
      ..configuration = Map<String, String>.from(json['configuration'] as Map);

Map<String, dynamic> _$RPTaskMeasureToJson(RPTaskMeasure instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull(r'$type', instance.$type);
  val['type'] = instance.type;
  writeNotNull('name', instance.name);
  writeNotNull('description', instance.description);
  val['enabled'] = instance.enabled;
  val['configuration'] = instance.configuration;
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
