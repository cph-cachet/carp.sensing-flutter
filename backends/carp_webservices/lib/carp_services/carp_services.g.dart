// GENERATED CODE - DO NOT MODIFY BY HAND

part of carp_services;

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DataPoint _$DataPointFromJson(Map<String, dynamic> json) => DataPoint(
      DataPointHeader.fromJson(json['carp_header'] as Map<String, dynamic>),
    )
      ..id = json['id'] as int?
      ..createdByUserId = json['created_by_user_id'] as int?
      ..studyId = json['study_id'] as String?
      ..carpBody = json['carp_body'] as Map<String, dynamic>?;

Map<String, dynamic> _$DataPointToJson(DataPoint instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  writeNotNull('created_by_user_id', instance.createdByUserId);
  writeNotNull('study_id', instance.studyId);
  val['carp_header'] = instance.carpHeader;
  writeNotNull('carp_body', instance.carpBody);
  return val;
}

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

Map<String, dynamic> _$DataPointHeaderToJson(DataPointHeader instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('study_id', instance.studyId);
  writeNotNull('device_role_name', instance.deviceRoleName);
  writeNotNull('trigger_id', instance.triggerId);
  writeNotNull('user_id', instance.userId);
  writeNotNull('upload_time', instance.uploadTime?.toIso8601String());
  writeNotNull('start_time', instance.startTime?.toIso8601String());
  writeNotNull('end_time', instance.endTime?.toIso8601String());
  writeNotNull('data_format', instance.dataFormat);
  return val;
}
