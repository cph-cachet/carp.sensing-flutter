// GENERATED CODE - DO NOT MODIFY BY HAND

part of movisens;

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MovisensMeasure _$MovisensMeasureFromJson(Map<String, dynamic> json) =>
    MovisensMeasure(
      type: json['type'] as String,
      name: json['name'] as String?,
      description: json['description'] as String?,
      enabled: json['enabled'] as bool? ?? true,
      address: json['address'] as String?,
      sensorLocation:
          $enumDecodeNullable(_$SensorLocationEnumMap, json['sensorLocation']),
      gender: $enumDecodeNullable(_$GenderEnumMap, json['gender']),
      deviceName: json['deviceName'] as String?,
      height: json['height'] as int?,
      weight: json['weight'] as int?,
      age: json['age'] as int?,
    )
      ..$type = json[r'$type'] as String?
      ..configuration = Map<String, String>.from(json['configuration'] as Map);

Map<String, dynamic> _$MovisensMeasureToJson(MovisensMeasure instance) {
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
  writeNotNull('address', instance.address);
  writeNotNull('deviceName', instance.deviceName);
  writeNotNull('weight', instance.weight);
  writeNotNull('height', instance.height);
  writeNotNull('age', instance.age);
  writeNotNull('gender', _$GenderEnumMap[instance.gender]);
  writeNotNull(
      'sensorLocation', _$SensorLocationEnumMap[instance.sensorLocation]);
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

MovisensDatum _$MovisensDatumFromJson(Map<String, dynamic> json) =>
    MovisensDatum()
      ..id = json['id'] as String?
      ..timestamp = DateTime.parse(json['timestamp'] as String)
      ..movisensTimestamp = json['movisens_timestamp'] as String?;

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
  return val;
}

MovisensMETLevelDatum _$MovisensMETLevelDatumFromJson(
        Map<String, dynamic> json) =>
    MovisensMETLevelDatum()
      ..id = json['id'] as String?
      ..timestamp = DateTime.parse(json['timestamp'] as String)
      ..movisensTimestamp = json['movisens_timestamp'] as String?
      ..format = DataFormat.fromJson(json['format'] as Map<String, dynamic>)
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
  val['format'] = instance.format;
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
      ..format = DataFormat.fromJson(json['format'] as Map<String, dynamic>)
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
  val['format'] = instance.format;
  writeNotNull('movement_acceleration', instance.movementAcceleration);
  return val;
}

MovisensTapMarkerDatum _$MovisensTapMarkerDatumFromJson(
        Map<String, dynamic> json) =>
    MovisensTapMarkerDatum()
      ..id = json['id'] as String?
      ..timestamp = DateTime.parse(json['timestamp'] as String)
      ..movisensTimestamp = json['movisens_timestamp'] as String?
      ..format = DataFormat.fromJson(json['format'] as Map<String, dynamic>)
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
  val['format'] = instance.format;
  writeNotNull('tap_marker', instance.tapMarker);
  return val;
}

MovisensBatteryLevelDatum _$MovisensBatteryLevelDatumFromJson(
        Map<String, dynamic> json) =>
    MovisensBatteryLevelDatum()
      ..id = json['id'] as String?
      ..timestamp = DateTime.parse(json['timestamp'] as String)
      ..movisensTimestamp = json['movisens_timestamp'] as String?
      ..format = DataFormat.fromJson(json['format'] as Map<String, dynamic>)
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
  val['format'] = instance.format;
  writeNotNull('battery_level', instance.batteryLevel);
  return val;
}

MovisensBodyPositionDatum _$MovisensBodyPositionDatumFromJson(
        Map<String, dynamic> json) =>
    MovisensBodyPositionDatum()
      ..id = json['id'] as String?
      ..timestamp = DateTime.parse(json['timestamp'] as String)
      ..movisensTimestamp = json['movisens_timestamp'] as String?
      ..format = DataFormat.fromJson(json['format'] as Map<String, dynamic>)
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
  val['format'] = instance.format;
  writeNotNull('body_position', instance.bodyPosition);
  return val;
}

MovisensMETDatum _$MovisensMETDatumFromJson(Map<String, dynamic> json) =>
    MovisensMETDatum()
      ..id = json['id'] as String?
      ..timestamp = DateTime.parse(json['timestamp'] as String)
      ..movisensTimestamp = json['movisens_timestamp'] as String?
      ..format = DataFormat.fromJson(json['format'] as Map<String, dynamic>)
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
  val['format'] = instance.format;
  writeNotNull('met', instance.met);
  return val;
}

MovisensHRDatum _$MovisensHRDatumFromJson(Map<String, dynamic> json) =>
    MovisensHRDatum()
      ..id = json['id'] as String?
      ..timestamp = DateTime.parse(json['timestamp'] as String)
      ..movisensTimestamp = json['movisens_timestamp'] as String?
      ..format = DataFormat.fromJson(json['format'] as Map<String, dynamic>)
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
  val['format'] = instance.format;
  writeNotNull('hr', instance.hr);
  return val;
}

MovisensHRVDatum _$MovisensHRVDatumFromJson(Map<String, dynamic> json) =>
    MovisensHRVDatum()
      ..id = json['id'] as String?
      ..timestamp = DateTime.parse(json['timestamp'] as String)
      ..movisensTimestamp = json['movisens_timestamp'] as String?
      ..format = DataFormat.fromJson(json['format'] as Map<String, dynamic>)
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
  val['format'] = instance.format;
  writeNotNull('hrv', instance.hrv);
  return val;
}

MovisensIsHrvValidDatum _$MovisensIsHrvValidDatumFromJson(
        Map<String, dynamic> json) =>
    MovisensIsHrvValidDatum()
      ..id = json['id'] as String?
      ..timestamp = DateTime.parse(json['timestamp'] as String)
      ..movisensTimestamp = json['movisens_timestamp'] as String?
      ..format = DataFormat.fromJson(json['format'] as Map<String, dynamic>)
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
  val['format'] = instance.format;
  writeNotNull('is_hrv_valid', instance.isHrvValid);
  return val;
}

MovisensStepCountDatum _$MovisensStepCountDatumFromJson(
        Map<String, dynamic> json) =>
    MovisensStepCountDatum()
      ..id = json['id'] as String?
      ..timestamp = DateTime.parse(json['timestamp'] as String)
      ..movisensTimestamp = json['movisens_timestamp'] as String?
      ..format = DataFormat.fromJson(json['format'] as Map<String, dynamic>)
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
  val['format'] = instance.format;
  writeNotNull('step_count', instance.stepCount);
  return val;
}

MovisensConnectionStatusDatum _$MovisensConnectionStatusDatumFromJson(
        Map<String, dynamic> json) =>
    MovisensConnectionStatusDatum()
      ..id = json['id'] as String?
      ..timestamp = DateTime.parse(json['timestamp'] as String)
      ..movisensTimestamp = json['movisens_timestamp'] as String?
      ..format = DataFormat.fromJson(json['format'] as Map<String, dynamic>)
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
  val['format'] = instance.format;
  writeNotNull('connection_status', instance.connectionStatus);
  return val;
}

MovisensDeviceDescriptor _$MovisensDeviceDescriptorFromJson(
        Map<String, dynamic> json) =>
    MovisensDeviceDescriptor(
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

Map<String, dynamic> _$MovisensDeviceDescriptorToJson(
    MovisensDeviceDescriptor instance) {
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
  val['weight'] = instance.weight;
  val['height'] = instance.height;
  val['age'] = instance.age;
  val['gender'] = _$GenderEnumMap[instance.gender];
  val['sensorLocation'] = _$SensorLocationEnumMap[instance.sensorLocation];
  return val;
}
