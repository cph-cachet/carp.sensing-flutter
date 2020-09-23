// GENERATED CODE - DO NOT MODIFY BY HAND

part of carp_services;

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CARPDataPoint _$CARPDataPointFromJson(Map<String, dynamic> json) {
  return CARPDataPoint(
    json['carp_header'] == null
        ? null
        : CARPDataPointHeader.fromJson(
            json['carp_header'] as Map<String, dynamic>),
    json['carp_body'] as Map<String, dynamic>,
  )
    ..id = json['id'] as int
    ..studyId = json['study_id'] as String
    ..createdByUserId = json['created_by_user_id'] as int;
}

Map<String, dynamic> _$CARPDataPointToJson(CARPDataPoint instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  writeNotNull('study_id', instance.studyId);
  writeNotNull('created_by_user_id', instance.createdByUserId);
  writeNotNull('carp_header', instance.carpHeader);
  writeNotNull('carp_body', instance.carpBody);
  return val;
}

CARPDataPointHeader _$CARPDataPointHeaderFromJson(Map<String, dynamic> json) {
  return CARPDataPointHeader(
    json['study_id'] as String,
    json['user_id'] as String,
    deviceRoleName: json['device_role_name'] as String,
    triggerId: json['trigger_id'] as String,
    startTime: json['start_time'] == null
        ? null
        : DateTime.parse(json['start_time'] as String),
    endTime: json['end_time'] == null
        ? null
        : DateTime.parse(json['end_time'] as String),
  )
    ..uploadTime = json['upload_time'] == null
        ? null
        : DateTime.parse(json['upload_time'] as String)
    ..dataFormat = json['data_format'] == null
        ? null
        : DataFormat.fromJson(json['data_format'] as Map<String, dynamic>);
}

Map<String, dynamic> _$CARPDataPointHeaderToJson(CARPDataPointHeader instance) {
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

StudyDeploymentStatus _$StudyDeploymentStatusFromJson(
    Map<String, dynamic> json) {
  return StudyDeploymentStatus(
    json['study_deployment_id'] as String,
  )
    ..$type = json[r'$type'] as String
    ..devicesStatus = (json['devices_status'] as List)
        ?.map((e) => e == null
            ? null
            : DeviceDeploymentStatus.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..startTime = json['start_time'] == null
        ? null
        : DateTime.parse(json['start_time'] as String);
}

Map<String, dynamic> _$StudyDeploymentStatusToJson(
    StudyDeploymentStatus instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull(r'$type', instance.$type);
  writeNotNull('study_deployment_id', instance.studyDeploymentId);
  writeNotNull('devices_status', instance.devicesStatus);
  writeNotNull('start_time', instance.startTime?.toIso8601String());
  return val;
}

DeviceDeploymentStatus _$DeviceDeploymentStatusFromJson(
    Map<String, dynamic> json) {
  return DeviceDeploymentStatus()
    ..$type = json[r'$type'] as String
    ..device = json['device'] == null
        ? null
        : DeviceDescriptor.fromJson(json['device'] as Map<String, dynamic>)
    ..requiresDeployment = json['requires_deployment'] as bool
    ..remainingDevicesToRegisterToObtainDeployment =
        (json['remaining_devices_to_register_to_obtain_deployment'] as List)
            ?.map((e) => e as String)
            ?.toList()
    ..remainingDevicesToRegisterBeforeDeployment =
        (json['remaining_devices_to_register_before_deployment'] as List)
            ?.map((e) => e as String)
            ?.toList();
}

Map<String, dynamic> _$DeviceDeploymentStatusToJson(
    DeviceDeploymentStatus instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull(r'$type', instance.$type);
  writeNotNull('device', instance.device);
  writeNotNull('requires_deployment', instance.requiresDeployment);
  writeNotNull('remaining_devices_to_register_to_obtain_deployment',
      instance.remainingDevicesToRegisterToObtainDeployment);
  writeNotNull('remaining_devices_to_register_before_deployment',
      instance.remainingDevicesToRegisterBeforeDeployment);
  return val;
}

DeviceDescriptor _$DeviceDescriptorFromJson(Map<String, dynamic> json) {
  return DeviceDescriptor()..$type = json[r'$type'] as String;
}

Map<String, dynamic> _$DeviceDescriptorToJson(DeviceDescriptor instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull(r'$type', instance.$type);
  return val;
}
