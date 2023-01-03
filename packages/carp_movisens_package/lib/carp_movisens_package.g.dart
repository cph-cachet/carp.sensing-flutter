// GENERATED CODE - DO NOT MODIFY BY HAND

part of carp_movisens_package;

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MovisensData _$MovisensDataFromJson(Map<String, dynamic> json) => MovisensData(
      deviceId: json['deviceId'] as String,
      type:
          $enumDecode(_$MovisensBluetoothCharacteristicsEnumMap, json['type']),
      timestamp: json['timestamp'] == null
          ? null
          : DateTime.parse(json['timestamp'] as String),
    )..$type = json['__type'] as String?;

Map<String, dynamic> _$MovisensDataToJson(MovisensData instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('__type', instance.$type);
  val['timestamp'] = instance.timestamp.toIso8601String();
  val['deviceId'] = instance.deviceId;
  val['type'] = _$MovisensBluetoothCharacteristicsEnumMap[instance.type]!;
  return val;
}

const _$MovisensBluetoothCharacteristicsEnumMap = {
  MovisensBluetoothCharacteristics.light: 'light',
  MovisensBluetoothCharacteristics.lightBuffered: 'lightBuffered',
  MovisensBluetoothCharacteristics.lightRGB: 'lightRGB',
  MovisensBluetoothCharacteristics.lightRGBBuffered: 'lightRGBBuffered',
  MovisensBluetoothCharacteristics.lightRGBWaiting: 'lightRGBWaiting',
  MovisensBluetoothCharacteristics.lightWaiting: 'lightWaiting',
  MovisensBluetoothCharacteristics.sensorTemperature: 'sensorTemperature',
  MovisensBluetoothCharacteristics.sensorTemperatureBuffered:
      'sensorTemperatureBuffered',
  MovisensBluetoothCharacteristics.sensorTemperatureWaiting:
      'sensorTemperatureWaiting',
  MovisensBluetoothCharacteristics.edaSclMean: 'edaSclMean',
  MovisensBluetoothCharacteristics.edaSclMeanBuffered: 'edaSclMeanBuffered',
  MovisensBluetoothCharacteristics.edaSclMeanWaiting: 'edaSclMeanWaiting',
  MovisensBluetoothCharacteristics.hrMean: 'hrMean',
  MovisensBluetoothCharacteristics.hrMeanBuffered: 'hrMeanBuffered',
  MovisensBluetoothCharacteristics.hrMeanWaiting: 'hrMeanWaiting',
  MovisensBluetoothCharacteristics.hrvIsValid: 'hrvIsValid',
  MovisensBluetoothCharacteristics.hrvIsValidBuffered: 'hrvIsValidBuffered',
  MovisensBluetoothCharacteristics.hrvIsValidWaiting: 'hrvIsValidWaiting',
  MovisensBluetoothCharacteristics.rmssd: 'rmssd',
  MovisensBluetoothCharacteristics.rmssdBuffered: 'rmssdBuffered',
  MovisensBluetoothCharacteristics.rmssdWaiting: 'rmssdWaiting',
  MovisensBluetoothCharacteristics.tapMarker: 'tapMarker',
  MovisensBluetoothCharacteristics.batteryLevelBuffered: 'batteryLevelBuffered',
  MovisensBluetoothCharacteristics.batteryLevelWaiting: 'batteryLevelWaiting',
  MovisensBluetoothCharacteristics.charging: 'charging',
  MovisensBluetoothCharacteristics.chargingBuffered: 'chargingBuffered',
  MovisensBluetoothCharacteristics.chargingWaiting: 'chargingWaiting',
  MovisensBluetoothCharacteristics.ageFloat: 'ageFloat',
  MovisensBluetoothCharacteristics.sensorLocation: 'sensorLocation',
  MovisensBluetoothCharacteristics.bodyPosition: 'bodyPosition',
  MovisensBluetoothCharacteristics.bodyPositionBuffered: 'bodyPositionBuffered',
  MovisensBluetoothCharacteristics.bodyPositionWaiting: 'bodyPositionWaiting',
  MovisensBluetoothCharacteristics.inclination: 'inclination',
  MovisensBluetoothCharacteristics.inclinationBuffered: 'inclinationBuffered',
  MovisensBluetoothCharacteristics.inclinationWaiting: 'inclinationWaiting',
  MovisensBluetoothCharacteristics.met: 'met',
  MovisensBluetoothCharacteristics.metBuffered: 'metBuffered',
  MovisensBluetoothCharacteristics.metLevel: 'metLevel',
  MovisensBluetoothCharacteristics.metLevelBuffered: 'metLevelBuffered',
  MovisensBluetoothCharacteristics.metLevelWaiting: 'metLevelWaiting',
  MovisensBluetoothCharacteristics.metWaiting: 'metWaiting',
  MovisensBluetoothCharacteristics.movementAcceleration: 'movementAcceleration',
  MovisensBluetoothCharacteristics.movementAccelerationBuffered:
      'movementAccelerationBuffered',
  MovisensBluetoothCharacteristics.movementAccelerationWaiting:
      'movementAccelerationWaiting',
  MovisensBluetoothCharacteristics.steps: 'steps',
  MovisensBluetoothCharacteristics.stepsBuffered: 'stepsBuffered',
  MovisensBluetoothCharacteristics.stepsWaiting: 'stepsWaiting',
  MovisensBluetoothCharacteristics.respiratoryMovement: 'respiratoryMovement',
  MovisensBluetoothCharacteristics.activatedBufferedCharacteristics:
      'activatedBufferedCharacteristics',
  MovisensBluetoothCharacteristics.commandResult: 'commandResult',
  MovisensBluetoothCharacteristics.currentTimeMs: 'currentTimeMs',
  MovisensBluetoothCharacteristics.customData: 'customData',
  MovisensBluetoothCharacteristics.dataAvailable: 'dataAvailable',
  MovisensBluetoothCharacteristics.deleteData: 'deleteData',
  MovisensBluetoothCharacteristics.measurementEnabled: 'measurementEnabled',
  MovisensBluetoothCharacteristics.measurementStartTime: 'measurementStartTime',
  MovisensBluetoothCharacteristics.measurementStatus: 'measurementStatus',
  MovisensBluetoothCharacteristics.saveEnergy: 'saveEnergy',
  MovisensBluetoothCharacteristics.sendBufferedData: 'sendBufferedData',
  MovisensBluetoothCharacteristics.startMeasurement: 'startMeasurement',
  MovisensBluetoothCharacteristics.status: 'status',
  MovisensBluetoothCharacteristics.storageLevel: 'storageLevel',
  MovisensBluetoothCharacteristics.timeZoneId: 'timeZoneId',
  MovisensBluetoothCharacteristics.timeZoneOffset: 'timeZoneOffset',
  MovisensBluetoothCharacteristics.skinTemperature: 'skinTemperature',
  MovisensBluetoothCharacteristics.skinTemperature1sBuffered:
      'skinTemperature1sBuffered',
  MovisensBluetoothCharacteristics.skinTemperatureBuffered:
      'skinTemperatureBuffered',
  MovisensBluetoothCharacteristics.skinTemperatureWaiting:
      'skinTemperatureWaiting',
};

MovisensStepCount _$MovisensStepCountFromJson(Map<String, dynamic> json) =>
    MovisensStepCount(
      deviceId: json['deviceId'] as String,
      type:
          $enumDecode(_$MovisensBluetoothCharacteristicsEnumMap, json['type']),
      timestamp: json['timestamp'] == null
          ? null
          : DateTime.parse(json['timestamp'] as String),
      steps: json['steps'] as int,
    )..$type = json['__type'] as String?;

Map<String, dynamic> _$MovisensStepCountToJson(MovisensStepCount instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('__type', instance.$type);
  val['timestamp'] = instance.timestamp.toIso8601String();
  val['deviceId'] = instance.deviceId;
  val['type'] = _$MovisensBluetoothCharacteristicsEnumMap[instance.type]!;
  val['steps'] = instance.steps;
  return val;
}

MovisensBodyPosition _$MovisensBodyPositionFromJson(
        Map<String, dynamic> json) =>
    MovisensBodyPosition(
      deviceId: json['deviceId'] as String,
      type:
          $enumDecode(_$MovisensBluetoothCharacteristicsEnumMap, json['type']),
      timestamp: json['timestamp'] == null
          ? null
          : DateTime.parse(json['timestamp'] as String),
      bodyPosition: json['bodyPosition'] as String,
    )..$type = json['__type'] as String?;

Map<String, dynamic> _$MovisensBodyPositionToJson(
    MovisensBodyPosition instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('__type', instance.$type);
  val['timestamp'] = instance.timestamp.toIso8601String();
  val['deviceId'] = instance.deviceId;
  val['type'] = _$MovisensBluetoothCharacteristicsEnumMap[instance.type]!;
  val['bodyPosition'] = instance.bodyPosition;
  return val;
}

MovisensInclination _$MovisensInclinationFromJson(Map<String, dynamic> json) =>
    MovisensInclination(
      deviceId: json['deviceId'] as String,
      type:
          $enumDecode(_$MovisensBluetoothCharacteristicsEnumMap, json['type']),
      timestamp: json['timestamp'] == null
          ? null
          : DateTime.parse(json['timestamp'] as String),
      x: json['x'] as int,
      y: json['y'] as int,
      z: json['z'] as int,
    )..$type = json['__type'] as String?;

Map<String, dynamic> _$MovisensInclinationToJson(MovisensInclination instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('__type', instance.$type);
  val['timestamp'] = instance.timestamp.toIso8601String();
  val['deviceId'] = instance.deviceId;
  val['type'] = _$MovisensBluetoothCharacteristicsEnumMap[instance.type]!;
  val['x'] = instance.x;
  val['y'] = instance.y;
  val['z'] = instance.z;
  return val;
}

MovisensMovementAcceleration _$MovisensMovementAccelerationFromJson(
        Map<String, dynamic> json) =>
    MovisensMovementAcceleration(
      deviceId: json['deviceId'] as String,
      type:
          $enumDecode(_$MovisensBluetoothCharacteristicsEnumMap, json['type']),
      timestamp: json['timestamp'] == null
          ? null
          : DateTime.parse(json['timestamp'] as String),
      movementAcceleration: (json['movementAcceleration'] as num).toDouble(),
    )..$type = json['__type'] as String?;

Map<String, dynamic> _$MovisensMovementAccelerationToJson(
    MovisensMovementAcceleration instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('__type', instance.$type);
  val['timestamp'] = instance.timestamp.toIso8601String();
  val['deviceId'] = instance.deviceId;
  val['type'] = _$MovisensBluetoothCharacteristicsEnumMap[instance.type]!;
  val['movementAcceleration'] = instance.movementAcceleration;
  return val;
}

MovisensMET _$MovisensMETFromJson(Map<String, dynamic> json) => MovisensMET(
      deviceId: json['deviceId'] as String,
      type:
          $enumDecode(_$MovisensBluetoothCharacteristicsEnumMap, json['type']),
      timestamp: json['timestamp'] == null
          ? null
          : DateTime.parse(json['timestamp'] as String),
      met: json['met'] as int,
    )..$type = json['__type'] as String?;

Map<String, dynamic> _$MovisensMETToJson(MovisensMET instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('__type', instance.$type);
  val['timestamp'] = instance.timestamp.toIso8601String();
  val['deviceId'] = instance.deviceId;
  val['type'] = _$MovisensBluetoothCharacteristicsEnumMap[instance.type]!;
  val['met'] = instance.met;
  return val;
}

MovisensMETLevel _$MovisensMETLevelFromJson(Map<String, dynamic> json) =>
    MovisensMETLevel(
      deviceId: json['deviceId'] as String,
      type:
          $enumDecode(_$MovisensBluetoothCharacteristicsEnumMap, json['type']),
      timestamp: json['timestamp'] == null
          ? null
          : DateTime.parse(json['timestamp'] as String),
      sedentary: json['sedentary'] as int,
      light: json['light'] as int,
      moderate: json['moderate'] as int,
      vigorous: json['vigorous'] as int,
    )..$type = json['__type'] as String?;

Map<String, dynamic> _$MovisensMETLevelToJson(MovisensMETLevel instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('__type', instance.$type);
  val['timestamp'] = instance.timestamp.toIso8601String();
  val['deviceId'] = instance.deviceId;
  val['type'] = _$MovisensBluetoothCharacteristicsEnumMap[instance.type]!;
  val['sedentary'] = instance.sedentary;
  val['light'] = instance.light;
  val['moderate'] = instance.moderate;
  val['vigorous'] = instance.vigorous;
  return val;
}

MovisensHR _$MovisensHRFromJson(Map<String, dynamic> json) => MovisensHR(
      deviceId: json['deviceId'] as String,
      type:
          $enumDecode(_$MovisensBluetoothCharacteristicsEnumMap, json['type']),
      timestamp: json['timestamp'] == null
          ? null
          : DateTime.parse(json['timestamp'] as String),
      hr: json['hr'] as int,
    )..$type = json['__type'] as String?;

Map<String, dynamic> _$MovisensHRToJson(MovisensHR instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('__type', instance.$type);
  val['timestamp'] = instance.timestamp.toIso8601String();
  val['deviceId'] = instance.deviceId;
  val['type'] = _$MovisensBluetoothCharacteristicsEnumMap[instance.type]!;
  val['hr'] = instance.hr;
  return val;
}

MovisensHRV _$MovisensHRVFromJson(Map<String, dynamic> json) => MovisensHRV(
      deviceId: json['deviceId'] as String,
      type:
          $enumDecode(_$MovisensBluetoothCharacteristicsEnumMap, json['type']),
      timestamp: json['timestamp'] == null
          ? null
          : DateTime.parse(json['timestamp'] as String),
      hrv: json['hrv'] as int,
    )..$type = json['__type'] as String?;

Map<String, dynamic> _$MovisensHRVToJson(MovisensHRV instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('__type', instance.$type);
  val['timestamp'] = instance.timestamp.toIso8601String();
  val['deviceId'] = instance.deviceId;
  val['type'] = _$MovisensBluetoothCharacteristicsEnumMap[instance.type]!;
  val['hrv'] = instance.hrv;
  return val;
}

MovisensIsHrvValid _$MovisensIsHrvValidFromJson(Map<String, dynamic> json) =>
    MovisensIsHrvValid(
      deviceId: json['deviceId'] as String,
      type:
          $enumDecode(_$MovisensBluetoothCharacteristicsEnumMap, json['type']),
      timestamp: json['timestamp'] == null
          ? null
          : DateTime.parse(json['timestamp'] as String),
      isHrvValid: json['isHrvValid'] as bool,
    )..$type = json['__type'] as String?;

Map<String, dynamic> _$MovisensIsHrvValidToJson(MovisensIsHrvValid instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('__type', instance.$type);
  val['timestamp'] = instance.timestamp.toIso8601String();
  val['deviceId'] = instance.deviceId;
  val['type'] = _$MovisensBluetoothCharacteristicsEnumMap[instance.type]!;
  val['isHrvValid'] = instance.isHrvValid;
  return val;
}

MovisensTapMarker _$MovisensTapMarkerFromJson(Map<String, dynamic> json) =>
    MovisensTapMarker(
      deviceId: json['deviceId'] as String,
      type:
          $enumDecode(_$MovisensBluetoothCharacteristicsEnumMap, json['type']),
      timestamp: json['timestamp'] == null
          ? null
          : DateTime.parse(json['timestamp'] as String),
      tapMarker: json['tapMarker'] as int,
    )..$type = json['__type'] as String?;

Map<String, dynamic> _$MovisensTapMarkerToJson(MovisensTapMarker instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('__type', instance.$type);
  val['timestamp'] = instance.timestamp.toIso8601String();
  val['deviceId'] = instance.deviceId;
  val['type'] = _$MovisensBluetoothCharacteristicsEnumMap[instance.type]!;
  val['tapMarker'] = instance.tapMarker;
  return val;
}

MovisensEDA _$MovisensEDAFromJson(Map<String, dynamic> json) => MovisensEDA(
      deviceId: json['deviceId'] as String,
      type:
          $enumDecode(_$MovisensBluetoothCharacteristicsEnumMap, json['type']),
      timestamp: json['timestamp'] == null
          ? null
          : DateTime.parse(json['timestamp'] as String),
      edaSclMean: (json['edaSclMean'] as num).toDouble(),
    )..$type = json['__type'] as String?;

Map<String, dynamic> _$MovisensEDAToJson(MovisensEDA instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('__type', instance.$type);
  val['timestamp'] = instance.timestamp.toIso8601String();
  val['deviceId'] = instance.deviceId;
  val['type'] = _$MovisensBluetoothCharacteristicsEnumMap[instance.type]!;
  val['edaSclMean'] = instance.edaSclMean;
  return val;
}

MovisensSkinTemperature _$MovisensSkinTemperatureFromJson(
        Map<String, dynamic> json) =>
    MovisensSkinTemperature(
      deviceId: json['deviceId'] as String,
      type:
          $enumDecode(_$MovisensBluetoothCharacteristicsEnumMap, json['type']),
      timestamp: json['timestamp'] == null
          ? null
          : DateTime.parse(json['timestamp'] as String),
      skinTemperature: (json['skinTemperature'] as num).toDouble(),
    )..$type = json['__type'] as String?;

Map<String, dynamic> _$MovisensSkinTemperatureToJson(
    MovisensSkinTemperature instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('__type', instance.$type);
  val['timestamp'] = instance.timestamp.toIso8601String();
  val['deviceId'] = instance.deviceId;
  val['type'] = _$MovisensBluetoothCharacteristicsEnumMap[instance.type]!;
  val['skinTemperature'] = instance.skinTemperature;
  return val;
}

MovisensDevice _$MovisensDeviceFromJson(Map<String, dynamic> json) =>
    MovisensDevice(
      roleName: json['roleName'] as String?,
      deviceName: json['deviceName'] as String,
      sensorLocation: $enumDecodeNullable(
              _$SensorLocationEnumMap, json['sensorLocation']) ??
          movisens.SensorLocation.chest,
      gender:
          $enumDecodeNullable(_$GenderEnumMap, json['gender']) ?? Gender.male,
      height: json['height'] as int? ?? 178,
      weight: json['weight'] as int? ?? 78,
      age: json['age'] as int? ?? 25,
    )
      ..$type = json['__type'] as String?
      ..isOptional = json['isOptional'] as bool?
      ..supportedDataTypes = (json['supportedDataTypes'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList()
      ..defaultSamplingConfiguration =
          (json['defaultSamplingConfiguration'] as Map<String, dynamic>?)?.map(
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

  writeNotNull('__type', instance.$type);
  val['roleName'] = instance.roleName;
  writeNotNull('isOptional', instance.isOptional);
  writeNotNull('supportedDataTypes', instance.supportedDataTypes);
  writeNotNull(
      'defaultSamplingConfiguration', instance.defaultSamplingConfiguration);
  val['deviceName'] = instance.deviceName;
  val['sensorLocation'] = _$SensorLocationEnumMap[instance.sensorLocation]!;
  val['weight'] = instance.weight;
  val['height'] = instance.height;
  val['age'] = instance.age;
  val['gender'] = _$GenderEnumMap[instance.gender]!;
  return val;
}

const _$SensorLocationEnumMap = {
  SensorLocation.rightSideHip: 'rightSideHip',
  SensorLocation.chest: 'chest',
  SensorLocation.rightWrist: 'rightWrist',
  SensorLocation.leftWrist: 'leftWrist',
  SensorLocation.leftAnkle: 'leftAnkle',
  SensorLocation.rightAnkle: 'rightAnkle',
  SensorLocation.rightThigh: 'rightThigh',
  SensorLocation.leftThigh: 'leftThigh',
  SensorLocation.rightUpperArm: 'rightUpperArm',
  SensorLocation.leftUpperArm: 'leftUpperArm',
  SensorLocation.leftSideHip: 'leftSideHip',
};

const _$GenderEnumMap = {
  Gender.male: 'male',
  Gender.female: 'female',
};
