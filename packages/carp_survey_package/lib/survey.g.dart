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
      minutesToComplete: (json['minutesToComplete'] as num?)?.toInt(),
      expire: json['expire'] == null
          ? null
          : Duration(microseconds: (json['expire'] as num).toInt()),
      notification: json['notification'] as bool? ?? false,
      rpTask: RPTask.fromJson(json['rpTask'] as Map<String, dynamic>),
    )..$type = json['__type'] as String?;

Map<String, dynamic> _$RPAppTaskToJson(RPAppTask instance) => <String, dynamic>{
      if (instance.$type case final value?) '__type': value,
      'name': instance.name,
      if (instance.measures?.map((e) => e.toJson()).toList() case final value?)
        'measures': value,
      'type': instance.type,
      'title': instance.title,
      'description': instance.description,
      'instructions': instance.instructions,
      if (instance.minutesToComplete case final value?)
        'minutesToComplete': value,
      if (instance.expire?.inMicroseconds case final value?) 'expire': value,
      'notification': instance.notification,
      'rpTask': instance.rpTask.toJson(),
    };

RPTaskResultData _$RPTaskResultDataFromJson(Map<String, dynamic> json) =>
    RPTaskResultData(
      $enumDecodeNullable(_$SurveyStatusEnumMap, json['status']) ??
          SurveyStatus.unknown,
      json['result'] == null
          ? null
          : RPTaskResult.fromJson(json['result'] as Map<String, dynamic>),
    )..$type = json['__type'] as String?;

Map<String, dynamic> _$RPTaskResultDataToJson(RPTaskResultData instance) =>
    <String, dynamic>{
      if (instance.$type case final value?) '__type': value,
      'status': _$SurveyStatusEnumMap[instance.status]!,
      if (instance.result?.toJson() case final value?) 'result': value,
    };

const _$SurveyStatusEnumMap = {
  SurveyStatus.unknown: 'unknown',
  SurveyStatus.submitted: 'submitted',
  SurveyStatus.canceled: 'canceled',
};
