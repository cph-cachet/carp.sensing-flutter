// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'carp_services.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DataPoint _$DataPointFromJson(Map<String, dynamic> json) => DataPoint(
      DataPointHeader.fromJson(json['carp_header'] as Map<String, dynamic>),
    )
      ..id = (json['id'] as num?)?.toInt()
      ..createdByUserId = (json['created_by_user_id'] as num?)?.toInt()
      ..studyId = json['study_id'] as String?
      ..carpBody = json['carp_body'] as Map<String, dynamic>?;

Map<String, dynamic> _$DataPointToJson(DataPoint instance) => <String, dynamic>{
      if (instance.id case final value?) 'id': value,
      if (instance.createdByUserId case final value?)
        'created_by_user_id': value,
      if (instance.studyId case final value?) 'study_id': value,
      'carp_header': instance.carpHeader.toJson(),
      if (instance.carpBody case final value?) 'carp_body': value,
    };

DataPointHeader _$DataPointHeaderFromJson(Map<String, dynamic> json) =>
    DataPointHeader(
      studyId: json['study_id'] as String?,
      userId: json['user_id'] as String?,
      dataFormat: json['data_format'] == null
          ? null
          : DataType.fromJson(json['data_format'] as Map<String, dynamic>),
      deviceRoleName: json['device_role_name'] as String?,
      triggerId: json['trigger_id'] as String?,
      startTime: json['start_time'] == null
          ? null
          : DateTime.parse(json['start_time'] as String),
      endTime: json['end_time'] == null
          ? null
          : DateTime.parse(json['end_time'] as String),
    )..uploadTime = json['upload_time'] == null
        ? null
        : DateTime.parse(json['upload_time'] as String);

Map<String, dynamic> _$DataPointHeaderToJson(DataPointHeader instance) =>
    <String, dynamic>{
      if (instance.studyId case final value?) 'study_id': value,
      if (instance.deviceRoleName case final value?) 'device_role_name': value,
      if (instance.triggerId case final value?) 'trigger_id': value,
      if (instance.userId case final value?) 'user_id': value,
      if (instance.uploadTime?.toIso8601String() case final value?)
        'upload_time': value,
      if (instance.startTime?.toIso8601String() case final value?)
        'start_time': value,
      if (instance.endTime?.toIso8601String() case final value?)
        'end_time': value,
      if (instance.dataFormat?.toJson() case final value?) 'data_format': value,
    };
