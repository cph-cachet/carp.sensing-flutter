// GENERATED CODE - DO NOT MODIFY BY HAND

part of movisens;

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MovisensDatum _$MovisensDatumFromJson(Map<String, dynamic> json) =>
    MovisensDatum()
      ..id = json['id'] as String?
      ..timestamp = DateTime.parse(json['timestamp'] as String)
      ..movisensTimestamp = json['movisens_timestamp'] as String?
      ..movisensDeviceName = json['movisens_device_name'] as String?;

Map<String, dynamic> _$MovisensDatumToJson(MovisensDatum instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  val['timestamp'] = instance.timestamp.toIso8601String();
  writeNotNull('movisens_timestamp', instance.movisensTimestamp);
  writeNotNull('movisens_device_name', instance.movisensDeviceName);
  return val;
}

MovisensMETLevelDatum _$MovisensMETLevelDatumFromJson(
        Map<String, dynamic> json) =>
    MovisensMETLevelDatum()
      ..id = json['id'] as String?
      ..timestamp = DateTime.parse(json['timestamp'] as String)
      ..movisensTimestamp = json['movisens_timestamp'] as String?
      ..movisensDeviceName = json['movisens_device_name'] as String?
      ..sedentary = json['sedentary'] as String?
      ..light = json['light'] as String?
      ..moderate = json['moderate'] as String?
      ..vigorous = json['vigorous'] as String?;

Map<String, dynamic> _$MovisensMETLevelDatumToJson(
    MovisensMETLevelDatum instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  val['timestamp'] = instance.timestamp.toIso8601String();
  writeNotNull('movisens_timestamp', instance.movisensTimestamp);
  writeNotNull('movisens_device_name', instance.movisensDeviceName);
  writeNotNull('sedentary', instance.sedentary);
  writeNotNull('light', instance.light);
  writeNotNull('moderate', instance.moderate);
  writeNotNull('vigorous', instance.vigorous);
  return val;
}

MovisensMovementAccelerationDatum _$MovisensMovementAccelerationDatumFromJson(
        Map<String, dynamic> json) =>
    MovisensMovementAccelerationDatum()
      ..id = json['id'] as String?
      ..timestamp = DateTime.parse(json['timestamp'] as String)
      ..movisensTimestamp = json['movisens_timestamp'] as String?
      ..movisensDeviceName = json['movisens_device_name'] as String?
      ..movementAcceleration = json['movement_acceleration'] as String?;

Map<String, dynamic> _$MovisensMovementAccelerationDatumToJson(
    MovisensMovementAccelerationDatum instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  val['timestamp'] = instance.timestamp.toIso8601String();
  writeNotNull('movisens_timestamp', instance.movisensTimestamp);
  writeNotNull('movisens_device_name', instance.movisensDeviceName);
  writeNotNull('movement_acceleration', instance.movementAcceleration);
  return val;
}

MovisensTapMarkerDatum _$MovisensTapMarkerDatumFromJson(
        Map<String, dynamic> json) =>
    MovisensTapMarkerDatum()
      ..id = json['id'] as String?
      ..timestamp = DateTime.parse(json['timestamp'] as String)
      ..movisensTimestamp = json['movisens_timestamp'] as String?
      ..movisensDeviceName = json['movisens_device_name'] as String?
      ..tapMarker = json['tap_marker'] as String?;

Map<String, dynamic> _$MovisensTapMarkerDatumToJson(
    MovisensTapMarkerDatum instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  val['timestamp'] = instance.timestamp.toIso8601String();
  writeNotNull('movisens_timestamp', instance.movisensTimestamp);
  writeNotNull('movisens_device_name', instance.movisensDeviceName);
  writeNotNull('tap_marker', instance.tapMarker);
  return val;
}

MovisensBatteryLevelDatum _$MovisensBatteryLevelDatumFromJson(
        Map<String, dynamic> json) =>
    MovisensBatteryLevelDatum()
      ..id = json['id'] as String?
      ..timestamp = DateTime.parse(json['timestamp'] as String)
      ..movisensTimestamp = json['movisens_timestamp'] as String?
      ..movisensDeviceName = json['movisens_device_name'] as String?
      ..batteryLevel = json['battery_level'] as String?;

Map<String, dynamic> _$MovisensBatteryLevelDatumToJson(
    MovisensBatteryLevelDatum instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  val['timestamp'] = instance.timestamp.toIso8601String();
  writeNotNull('movisens_timestamp', instance.movisensTimestamp);
  writeNotNull('movisens_device_name', instance.movisensDeviceName);
  writeNotNull('battery_level', instance.batteryLevel);
  return val;
}

MovisensBodyPositionDatum _$MovisensBodyPositionDatumFromJson(
        Map<String, dynamic> json) =>
    MovisensBodyPositionDatum()
      ..id = json['id'] as String?
      ..timestamp = DateTime.parse(json['timestamp'] as String)
      ..movisensTimestamp = json['movisens_timestamp'] as String?
      ..movisensDeviceName = json['movisens_device_name'] as String?
      ..bodyPosition = json['body_position'] as String?;

Map<String, dynamic> _$MovisensBodyPositionDatumToJson(
    MovisensBodyPositionDatum instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  val['timestamp'] = instance.timestamp.toIso8601String();
  writeNotNull('movisens_timestamp', instance.movisensTimestamp);
  writeNotNull('movisens_device_name', instance.movisensDeviceName);
  writeNotNull('body_position', instance.bodyPosition);
  return val;
}

MovisensMETDatum _$MovisensMETDatumFromJson(Map<String, dynamic> json) =>
    MovisensMETDatum()
      ..id = json['id'] as String?
      ..timestamp = DateTime.parse(json['timestamp'] as String)
      ..movisensTimestamp = json['movisens_timestamp'] as String?
      ..movisensDeviceName = json['movisens_device_name'] as String?
      ..met = json['met'] as String?;

Map<String, dynamic> _$MovisensMETDatumToJson(MovisensMETDatum instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  val['timestamp'] = instance.timestamp.toIso8601String();
  writeNotNull('movisens_timestamp', instance.movisensTimestamp);
  writeNotNull('movisens_device_name', instance.movisensDeviceName);
  writeNotNull('met', instance.met);
  return val;
}

MovisensHRDatum _$MovisensHRDatumFromJson(Map<String, dynamic> json) =>
    MovisensHRDatum()
      ..id = json['id'] as String?
      ..timestamp = DateTime.parse(json['timestamp'] as String)
      ..movisensTimestamp = json['movisens_timestamp'] as String?
      ..movisensDeviceName = json['movisens_device_name'] as String?
      ..hr = json['hr'] as String?;

Map<String, dynamic> _$MovisensHRDatumToJson(MovisensHRDatum instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  val['timestamp'] = instance.timestamp.toIso8601String();
  writeNotNull('movisens_timestamp', instance.movisensTimestamp);
  writeNotNull('movisens_device_name', instance.movisensDeviceName);
  writeNotNull('hr', instance.hr);
  return val;
}

MovisensHRVDatum _$MovisensHRVDatumFromJson(Map<String, dynamic> json) =>
    MovisensHRVDatum()
      ..id = json['id'] as String?
      ..timestamp = DateTime.parse(json['timestamp'] as String)
      ..movisensTimestamp = json['movisens_timestamp'] as String?
      ..movisensDeviceName = json['movisens_device_name'] as String?
      ..hrv = json['hrv'] as String?;

Map<String, dynamic> _$MovisensHRVDatumToJson(MovisensHRVDatum instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  val['timestamp'] = instance.timestamp.toIso8601String();
  writeNotNull('movisens_timestamp', instance.movisensTimestamp);
  writeNotNull('movisens_device_name', instance.movisensDeviceName);
  writeNotNull('hrv', instance.hrv);
  return val;
}

MovisensIsHrvValidDatum _$MovisensIsHrvValidDatumFromJson(
        Map<String, dynamic> json) =>
    MovisensIsHrvValidDatum()
      ..id = json['id'] as String?
      ..timestamp = DateTime.parse(json['timestamp'] as String)
      ..movisensTimestamp = json['movisens_timestamp'] as String?
      ..movisensDeviceName = json['movisens_device_name'] as String?
      ..isHrvValid = json['is_hrv_valid'] as String?;

Map<String, dynamic> _$MovisensIsHrvValidDatumToJson(
    MovisensIsHrvValidDatum instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  val['timestamp'] = instance.timestamp.toIso8601String();
  writeNotNull('movisens_timestamp', instance.movisensTimestamp);
  writeNotNull('movisens_device_name', instance.movisensDeviceName);
  writeNotNull('is_hrv_valid', instance.isHrvValid);
  return val;
}

MovisensStepCountDatum _$MovisensStepCountDatumFromJson(
        Map<String, dynamic> json) =>
    MovisensStepCountDatum()
      ..id = json['id'] as String?
      ..timestamp = DateTime.parse(json['timestamp'] as String)
      ..movisensTimestamp = json['movisens_timestamp'] as String?
      ..movisensDeviceName = json['movisens_device_name'] as String?
      ..stepCount = json['step_count'] as String?;

Map<String, dynamic> _$MovisensStepCountDatumToJson(
    MovisensStepCountDatum instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  val['timestamp'] = instance.timestamp.toIso8601String();
  writeNotNull('movisens_timestamp', instance.movisensTimestamp);
  writeNotNull('movisens_device_name', instance.movisensDeviceName);
  writeNotNull('step_count', instance.stepCount);
  return val;
}

MovisensConnectionStatusDatum _$MovisensConnectionStatusDatumFromJson(
        Map<String, dynamic> json) =>
    MovisensConnectionStatusDatum()
      ..id = json['id'] as String?
      ..timestamp = DateTime.parse(json['timestamp'] as String)
      ..movisensTimestamp = json['movisens_timestamp'] as String?
      ..movisensDeviceName = json['movisens_device_name'] as String?
      ..connectionStatus = json['connection_status'] as String?;

Map<String, dynamic> _$MovisensConnectionStatusDatumToJson(
    MovisensConnectionStatusDatum instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  val['timestamp'] = instance.timestamp.toIso8601String();
  writeNotNull('movisens_timestamp', instance.movisensTimestamp);
  writeNotNull('movisens_device_name', instance.movisensDeviceName);
  writeNotNull('connection_status', instance.connectionStatus);
  return val;
}

MovisensDevice _$MovisensDeviceFromJson(Map<String, dynamic> json) =>
    MovisensDevice(
      roleName: json['roleName'] as String?,
      address: json['address'] as String,
      sensorName: json['sensorName'] as String,
      sensorLocation: $enumDecodeNullable(
              _$SensorLocationEnumMap, json['sensorLocation']) ??
          SensorLocation.chest,
      gender:
          $enumDecodeNullable(_$GenderEnumMap, json['gender']) ?? Gender.male,
      height: json['height'] as int? ?? 178,
      weight: json['weight'] as int? ?? 78,
      age: json['age'] as int? ?? 25,
    )
      ..$type = json[r'$type'] as String?
      ..isMasterDevice = json['isMasterDevice'] as bool?
      ..supportedDataTypes = (json['supportedDataTypes'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList()
      ..samplingConfiguration =
          (json['samplingConfiguration'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(
            k, SamplingConfiguration.fromJson(e as Map<String, dynamic>)),
      );

Map<String, dynamic> _$MovisensDeviceToJson(MovisensDevice instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull(r'$type', instance.$type);
  writeNotNull('isMasterDevice', instance.isMasterDevice);
  val['roleName'] = instance.roleName;
  writeNotNull('supportedDataTypes', instance.supportedDataTypes);
  val['samplingConfiguration'] = instance.samplingConfiguration;
  val['address'] = instance.address;
  val['sensorName'] = instance.sensorName;
  val['sensorLocation'] = _$SensorLocationEnumMap[instance.sensorLocation]!;
  val['weight'] = instance.weight;
  val['height'] = instance.height;
  val['age'] = instance.age;
  val['gender'] = _$GenderEnumMap[instance.gender]!;
  return val;
}

const _$SensorLocationEnumMap = {
  SensorLocation.left_ankle: 'left_ankle',
  SensorLocation.left_hip: 'left_hip',
  SensorLocation.left_thigh: 'left_thigh',
  SensorLocation.left_upper_arm: 'left_upper_arm',
  SensorLocation.left_wrist: 'left_wrist',
  SensorLocation.right_ankle: 'right_ankle',
  SensorLocation.right_hip: 'right_hip',
  SensorLocation.right_thigh: 'right_thigh',
  SensorLocation.right_upper_arm: 'right_upper_arm',
  SensorLocation.right_wrist: 'right_wrist',
  SensorLocation.chest: 'chest',
};

const _$GenderEnumMap = {
  Gender.male: 'male',
  Gender.female: 'female',
};
