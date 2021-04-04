// GENERATED CODE - DO NOT MODIFY BY HAND

part of movisens;

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MovisensMeasure _$MovisensMeasureFromJson(Map<String, dynamic> json) {
  return MovisensMeasure(
    type: json['type'] as String,
    measureDescription:
        (json['measure_description'] as Map<String, dynamic>)?.map(
      (k, e) => MapEntry(
          k,
          e == null
              ? null
              : MeasureDescription.fromJson(e as Map<String, dynamic>)),
    ),
    enabled: json['enabled'],
    address: json['address'] as String,
    sensorLocation:
        _$enumDecodeNullable(_$SensorLocationEnumMap, json['sensor_location']),
    gender: _$enumDecodeNullable(_$GenderEnumMap, json['gender']),
    deviceName: json['device_name'] as String,
    height: json['height'] as int,
    weight: json['weight'] as int,
    age: json['age'] as int,
  )
    ..$type = json[r'$type'] as String
    ..configuration = (json['configuration'] as Map<String, dynamic>)?.map(
      (k, e) => MapEntry(k, e as String),
    );
}

Map<String, dynamic> _$MovisensMeasureToJson(MovisensMeasure instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull(r'$type', instance.$type);
  writeNotNull('type', instance.type);
  writeNotNull('measure_description', instance.measureDescription);
  writeNotNull('enabled', instance.enabled);
  writeNotNull('configuration', instance.configuration);
  writeNotNull('address', instance.address);
  writeNotNull('device_name', instance.deviceName);
  writeNotNull('weight', instance.weight);
  writeNotNull('height', instance.height);
  writeNotNull('age', instance.age);
  writeNotNull('gender', _$GenderEnumMap[instance.gender]);
  writeNotNull(
      'sensor_location', _$SensorLocationEnumMap[instance.sensorLocation]);
  return val;
}

T _$enumDecode<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }

  final value = enumValues.entries
      .singleWhere((e) => e.value == source, orElse: () => null)
      ?.key;

  if (value == null && unknownValue == null) {
    throw ArgumentError('`$source` is not one of the supported values: '
        '${enumValues.values.join(', ')}');
  }
  return value ?? unknownValue;
}

T _$enumDecodeNullable<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source, unknownValue: unknownValue);
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

MovisensDatum _$MovisensDatumFromJson(Map<String, dynamic> json) {
  return MovisensDatum()
    ..id = json['id'] as String
    ..timestamp = json['timestamp'] == null
        ? null
        : DateTime.parse(json['timestamp'] as String)
    ..movisensTimestamp = json['movisens_timestamp'] as String;
}

Map<String, dynamic> _$MovisensDatumToJson(MovisensDatum instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  writeNotNull('timestamp', instance.timestamp?.toIso8601String());
  writeNotNull('movisens_timestamp', instance.movisensTimestamp);
  return val;
}

MovisensMETLevelDatum _$MovisensMETLevelDatumFromJson(
    Map<String, dynamic> json) {
  return MovisensMETLevelDatum()
    ..id = json['id'] as String
    ..timestamp = json['timestamp'] == null
        ? null
        : DateTime.parse(json['timestamp'] as String)
    ..movisensTimestamp = json['movisens_timestamp'] as String
    ..format = json['format'] == null
        ? null
        : DataFormat.fromJson(json['format'] as Map<String, dynamic>)
    ..sedentary = json['sedentary'] as String
    ..light = json['light'] as String
    ..moderate = json['moderate'] as String
    ..vigorous = json['vigorous'] as String;
}

Map<String, dynamic> _$MovisensMETLevelDatumToJson(
    MovisensMETLevelDatum instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  writeNotNull('timestamp', instance.timestamp?.toIso8601String());
  writeNotNull('movisens_timestamp', instance.movisensTimestamp);
  writeNotNull('format', instance.format);
  writeNotNull('sedentary', instance.sedentary);
  writeNotNull('light', instance.light);
  writeNotNull('moderate', instance.moderate);
  writeNotNull('vigorous', instance.vigorous);
  return val;
}

MovisensMovementAccelerationDatum _$MovisensMovementAccelerationDatumFromJson(
    Map<String, dynamic> json) {
  return MovisensMovementAccelerationDatum()
    ..id = json['id'] as String
    ..timestamp = json['timestamp'] == null
        ? null
        : DateTime.parse(json['timestamp'] as String)
    ..movisensTimestamp = json['movisens_timestamp'] as String
    ..movementAcceleration = json['movement_acceleration'] as String
    ..format = json['format'] == null
        ? null
        : DataFormat.fromJson(json['format'] as Map<String, dynamic>);
}

Map<String, dynamic> _$MovisensMovementAccelerationDatumToJson(
    MovisensMovementAccelerationDatum instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  writeNotNull('timestamp', instance.timestamp?.toIso8601String());
  writeNotNull('movisens_timestamp', instance.movisensTimestamp);
  writeNotNull('movement_acceleration', instance.movementAcceleration);
  writeNotNull('format', instance.format);
  return val;
}

MovisensTapMarkerDatum _$MovisensTapMarkerDatumFromJson(
    Map<String, dynamic> json) {
  return MovisensTapMarkerDatum()
    ..id = json['id'] as String
    ..timestamp = json['timestamp'] == null
        ? null
        : DateTime.parse(json['timestamp'] as String)
    ..movisensTimestamp = json['movisens_timestamp'] as String
    ..tapMarker = json['tap_marker'] as String
    ..format = json['format'] == null
        ? null
        : DataFormat.fromJson(json['format'] as Map<String, dynamic>);
}

Map<String, dynamic> _$MovisensTapMarkerDatumToJson(
    MovisensTapMarkerDatum instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  writeNotNull('timestamp', instance.timestamp?.toIso8601String());
  writeNotNull('movisens_timestamp', instance.movisensTimestamp);
  writeNotNull('tap_marker', instance.tapMarker);
  writeNotNull('format', instance.format);
  return val;
}

MovisensBatteryLevelDatum _$MovisensBatteryLevelDatumFromJson(
    Map<String, dynamic> json) {
  return MovisensBatteryLevelDatum()
    ..id = json['id'] as String
    ..timestamp = json['timestamp'] == null
        ? null
        : DateTime.parse(json['timestamp'] as String)
    ..movisensTimestamp = json['movisens_timestamp'] as String
    ..batteryLevel = json['battery_level'] as String
    ..format = json['format'] == null
        ? null
        : DataFormat.fromJson(json['format'] as Map<String, dynamic>);
}

Map<String, dynamic> _$MovisensBatteryLevelDatumToJson(
    MovisensBatteryLevelDatum instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  writeNotNull('timestamp', instance.timestamp?.toIso8601String());
  writeNotNull('movisens_timestamp', instance.movisensTimestamp);
  writeNotNull('battery_level', instance.batteryLevel);
  writeNotNull('format', instance.format);
  return val;
}

MovisensBodyPositionDatum _$MovisensBodyPositionDatumFromJson(
    Map<String, dynamic> json) {
  return MovisensBodyPositionDatum()
    ..id = json['id'] as String
    ..timestamp = json['timestamp'] == null
        ? null
        : DateTime.parse(json['timestamp'] as String)
    ..movisensTimestamp = json['movisens_timestamp'] as String
    ..bodyPosition = json['body_position'] as String
    ..format = json['format'] == null
        ? null
        : DataFormat.fromJson(json['format'] as Map<String, dynamic>);
}

Map<String, dynamic> _$MovisensBodyPositionDatumToJson(
    MovisensBodyPositionDatum instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  writeNotNull('timestamp', instance.timestamp?.toIso8601String());
  writeNotNull('movisens_timestamp', instance.movisensTimestamp);
  writeNotNull('body_position', instance.bodyPosition);
  writeNotNull('format', instance.format);
  return val;
}

MovisensMETDatum _$MovisensMETDatumFromJson(Map<String, dynamic> json) {
  return MovisensMETDatum()
    ..id = json['id'] as String
    ..timestamp = json['timestamp'] == null
        ? null
        : DateTime.parse(json['timestamp'] as String)
    ..movisensTimestamp = json['movisens_timestamp'] as String
    ..met = json['met'] as String
    ..format = json['format'] == null
        ? null
        : DataFormat.fromJson(json['format'] as Map<String, dynamic>);
}

Map<String, dynamic> _$MovisensMETDatumToJson(MovisensMETDatum instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  writeNotNull('timestamp', instance.timestamp?.toIso8601String());
  writeNotNull('movisens_timestamp', instance.movisensTimestamp);
  writeNotNull('met', instance.met);
  writeNotNull('format', instance.format);
  return val;
}

MovisensHRDatum _$MovisensHRDatumFromJson(Map<String, dynamic> json) {
  return MovisensHRDatum()
    ..id = json['id'] as String
    ..timestamp = json['timestamp'] == null
        ? null
        : DateTime.parse(json['timestamp'] as String)
    ..movisensTimestamp = json['movisens_timestamp'] as String
    ..hr = json['hr'] as String
    ..format = json['format'] == null
        ? null
        : DataFormat.fromJson(json['format'] as Map<String, dynamic>);
}

Map<String, dynamic> _$MovisensHRDatumToJson(MovisensHRDatum instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  writeNotNull('timestamp', instance.timestamp?.toIso8601String());
  writeNotNull('movisens_timestamp', instance.movisensTimestamp);
  writeNotNull('hr', instance.hr);
  writeNotNull('format', instance.format);
  return val;
}

MovisensHRVDatum _$MovisensHRVDatumFromJson(Map<String, dynamic> json) {
  return MovisensHRVDatum()
    ..id = json['id'] as String
    ..timestamp = json['timestamp'] == null
        ? null
        : DateTime.parse(json['timestamp'] as String)
    ..movisensTimestamp = json['movisens_timestamp'] as String
    ..hrv = json['hrv'] as String
    ..format = json['format'] == null
        ? null
        : DataFormat.fromJson(json['format'] as Map<String, dynamic>);
}

Map<String, dynamic> _$MovisensHRVDatumToJson(MovisensHRVDatum instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  writeNotNull('timestamp', instance.timestamp?.toIso8601String());
  writeNotNull('movisens_timestamp', instance.movisensTimestamp);
  writeNotNull('hrv', instance.hrv);
  writeNotNull('format', instance.format);
  return val;
}

MovisensIsHrvValidDatum _$MovisensIsHrvValidDatumFromJson(
    Map<String, dynamic> json) {
  return MovisensIsHrvValidDatum()
    ..id = json['id'] as String
    ..timestamp = json['timestamp'] == null
        ? null
        : DateTime.parse(json['timestamp'] as String)
    ..movisensTimestamp = json['movisens_timestamp'] as String
    ..isHrvValid = json['is_hrv_valid'] as String
    ..format = json['format'] == null
        ? null
        : DataFormat.fromJson(json['format'] as Map<String, dynamic>);
}

Map<String, dynamic> _$MovisensIsHrvValidDatumToJson(
    MovisensIsHrvValidDatum instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  writeNotNull('timestamp', instance.timestamp?.toIso8601String());
  writeNotNull('movisens_timestamp', instance.movisensTimestamp);
  writeNotNull('is_hrv_valid', instance.isHrvValid);
  writeNotNull('format', instance.format);
  return val;
}

MovisensStepCountDatum _$MovisensStepCountDatumFromJson(
    Map<String, dynamic> json) {
  return MovisensStepCountDatum()
    ..id = json['id'] as String
    ..timestamp = json['timestamp'] == null
        ? null
        : DateTime.parse(json['timestamp'] as String)
    ..movisensTimestamp = json['movisens_timestamp'] as String
    ..stepCount = json['step_count'] as String
    ..format = json['format'] == null
        ? null
        : DataFormat.fromJson(json['format'] as Map<String, dynamic>);
}

Map<String, dynamic> _$MovisensStepCountDatumToJson(
    MovisensStepCountDatum instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  writeNotNull('timestamp', instance.timestamp?.toIso8601String());
  writeNotNull('movisens_timestamp', instance.movisensTimestamp);
  writeNotNull('step_count', instance.stepCount);
  writeNotNull('format', instance.format);
  return val;
}

MovisensConnectionStatusDatum _$MovisensConnectionStatusDatumFromJson(
    Map<String, dynamic> json) {
  return MovisensConnectionStatusDatum()
    ..id = json['id'] as String
    ..timestamp = json['timestamp'] == null
        ? null
        : DateTime.parse(json['timestamp'] as String)
    ..movisensTimestamp = json['movisens_timestamp'] as String
    ..connectionStatus = json['connection_status'] as String
    ..format = json['format'] == null
        ? null
        : DataFormat.fromJson(json['format'] as Map<String, dynamic>);
}

Map<String, dynamic> _$MovisensConnectionStatusDatumToJson(
    MovisensConnectionStatusDatum instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  writeNotNull('timestamp', instance.timestamp?.toIso8601String());
  writeNotNull('movisens_timestamp', instance.movisensTimestamp);
  writeNotNull('connection_status', instance.connectionStatus);
  writeNotNull('format', instance.format);
  return val;
}

MovisensDevice _$MovisensDeviceFromJson(Map<String, dynamic> json) {
  return MovisensDevice(
    roleName: json['roleName'] as String,
    supportedDataTypes:
        (json['supportedDataTypes'] as List)?.map((e) => e as String)?.toList(),
  )
    ..$type = json[r'$type'] as String
    ..isMasterDevice = json['isMasterDevice'] as bool
    ..samplingConfiguration =
        (json['samplingConfiguration'] as Map<String, dynamic>)?.map(
      (k, e) => MapEntry(
          k,
          e == null
              ? null
              : SamplingConfiguration.fromJson(e as Map<String, dynamic>)),
    );
}

Map<String, dynamic> _$MovisensDeviceToJson(MovisensDevice instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull(r'$type', instance.$type);
  writeNotNull('isMasterDevice', instance.isMasterDevice);
  writeNotNull('roleName', instance.roleName);
  writeNotNull('supportedDataTypes', instance.supportedDataTypes);
  writeNotNull('samplingConfiguration', instance.samplingConfiguration);
  return val;
}
