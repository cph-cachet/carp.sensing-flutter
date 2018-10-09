// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'carp_datapoint.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CARPDataPoint _$CARPDataPointFromJson(Map<String, dynamic> json) {
  return CARPDataPoint(
      json['carp_header'] == null
          ? null
          : CARPDataPointHeader.fromJson(
              json['carp_header'] as Map<String, dynamic>),
      json['carp_body'] == null
          ? null
          : Datum.fromJson(json['carp_body'] as Map<String, dynamic>));
}

Map<String, dynamic> _$CARPDataPointToJson(CARPDataPoint instance) {
  var val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('carp_header', instance.carpHeader);
  writeNotNull('carp_body', instance.carpBody);
  return val;
}

CARPDataPointHeader _$CARPDataPointHeaderFromJson(Map<String, dynamic> json) {
  return CARPDataPointHeader(
      json['study_id'] as String, json['user_id'] as String,
      deviceRoleName: json['device_role_name'] as String,
      triggerId: json['trigger_id'] as String,
      startTime: json['start_time'] == null
          ? null
          : DateTime.parse(json['start_time'] as String),
      endTime: json['end_time'] == null
          ? null
          : DateTime.parse(json['end_time'] as String))
    ..dataFormat = json['data_format'] == null
        ? null
        : CARPDataFormat.fromJson(json['data_format'] as Map<String, dynamic>)
    ..uploadTime = json['upload_time'] == null
        ? null
        : DateTime.parse(json['upload_time'] as String);
}

Map<String, dynamic> _$CARPDataPointHeaderToJson(CARPDataPointHeader instance) {
  var val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('study_id', instance.studyId);
  writeNotNull('device_role_name', instance.deviceRoleName);
  writeNotNull('trigger_id', instance.triggerId);
  writeNotNull('user_id', instance.userId);
  writeNotNull('data_format', instance.dataFormat);
  writeNotNull('upload_time', instance.uploadTime?.toIso8601String());
  writeNotNull('start_time', instance.startTime?.toIso8601String());
  writeNotNull('end_time', instance.endTime?.toIso8601String());
  return val;
}

CARPDataFormat _$CARPDataFormatFromJson(Map<String, dynamic> json) {
  return CARPDataFormat(json['namepace'] as String, json['name'] as String);
}

Map<String, dynamic> _$CARPDataFormatToJson(CARPDataFormat instance) {
  var val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('namepace', instance.namepace);
  writeNotNull('name', instance.name);
  return val;
}
