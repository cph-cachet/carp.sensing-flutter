// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'survey.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RPAppTask _$RPAppTaskFromJson(Map<String, dynamic> json) => RPAppTask(
      name: json['name'] as String?,
      measures: (json['measures'] as List<dynamic>?)
          ?.map((e) => Measure.fromJson(e as Map<String, dynamic>))
          .toList(),
      type: json['type'] as String,
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      instructions: json['instructions'] as String? ?? '',
      minutesToComplete: json['minutesToComplete'] as int?,
      expire: json['expire'] == null
          ? null
          : Duration(microseconds: json['expire'] as int),
      notification: json['notification'] as bool? ?? false,
      rpTask: RPTask.fromJson(json['rpTask'] as Map<String, dynamic>),
    )..$type = json['__type'] as String?;

Map<String, dynamic> _$RPAppTaskToJson(RPAppTask instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('__type', instance.$type);
  val['name'] = instance.name;
  writeNotNull('measures', instance.measures);
  val['type'] = instance.type;
  val['title'] = instance.title;
  val['description'] = instance.description;
  val['instructions'] = instance.instructions;
  writeNotNull('minutesToComplete', instance.minutesToComplete);
  writeNotNull('expire', instance.expire?.inMicroseconds);
  val['notification'] = instance.notification;
  val['rpTask'] = instance.rpTask;
  return val;
}

RPTaskResultData _$RPTaskResultDataFromJson(Map<String, dynamic> json) =>
    RPTaskResultData(
      json['survey_result'] == null
          ? null
          : RPTaskResult.fromJson(
              json['survey_result'] as Map<String, dynamic>),
    )..$type = json['__type'] as String?;

Map<String, dynamic> _$RPTaskResultDataToJson(RPTaskResultData instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('__type', instance.$type);
  writeNotNull('survey_result', instance.surveyResult);
  return val;
}
