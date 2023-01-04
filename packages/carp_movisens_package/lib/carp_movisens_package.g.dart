// GENERATED CODE - DO NOT MODIFY BY HAND

part of carp_movisens_package;

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MovisensData _$MovisensDataFromJson(Map<String, dynamic> json) => MovisensData(
      deviceId: json['deviceId'] as String,
      type: json['type'] as String,
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
  val['type'] = instance.type;
  return val;
}

MovisensStepCount _$MovisensStepCountFromJson(Map<String, dynamic> json) =>
    MovisensStepCount(
      deviceId: json['deviceId'] as String,
      type: json['type'] as String,
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
  val['type'] = instance.type;
  val['steps'] = instance.steps;
  return val;
}

MovisensBodyPosition _$MovisensBodyPositionFromJson(
        Map<String, dynamic> json) =>
    MovisensBodyPosition(
      deviceId: json['deviceId'] as String,
      type: json['type'] as String,
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
  val['type'] = instance.type;
  val['bodyPosition'] = instance.bodyPosition;
  return val;
}

MovisensInclination _$MovisensInclinationFromJson(Map<String, dynamic> json) =>
    MovisensInclination(
      deviceId: json['deviceId'] as String,
      type: json['type'] as String,
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
  val['type'] = instance.type;
  val['x'] = instance.x;
  val['y'] = instance.y;
  val['z'] = instance.z;
  return val;
}

MovisensMovementAcceleration _$MovisensMovementAccelerationFromJson(
        Map<String, dynamic> json) =>
    MovisensMovementAcceleration(
      deviceId: json['deviceId'] as String,
      type: json['type'] as String,
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
  val['type'] = instance.type;
  val['movementAcceleration'] = instance.movementAcceleration;
  return val;
}

MovisensMET _$MovisensMETFromJson(Map<String, dynamic> json) => MovisensMET(
      deviceId: json['deviceId'] as String,
      type: json['type'] as String,
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
  val['type'] = instance.type;
  val['met'] = instance.met;
  return val;
}

MovisensMETLevel _$MovisensMETLevelFromJson(Map<String, dynamic> json) =>
    MovisensMETLevel(
      deviceId: json['deviceId'] as String,
      type: json['type'] as String,
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
  val['type'] = instance.type;
  val['sedentary'] = instance.sedentary;
  val['light'] = instance.light;
  val['moderate'] = instance.moderate;
  val['vigorous'] = instance.vigorous;
  return val;
}

MovisensHR _$MovisensHRFromJson(Map<String, dynamic> json) => MovisensHR(
      deviceId: json['deviceId'] as String,
      type: json['type'] as String,
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
  val['type'] = instance.type;
  val['hr'] = instance.hr;
  return val;
}

MovisensHRV _$MovisensHRVFromJson(Map<String, dynamic> json) => MovisensHRV(
      deviceId: json['deviceId'] as String,
      type: json['type'] as String,
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
  val['type'] = instance.type;
  val['hrv'] = instance.hrv;
  return val;
}

MovisensIsHrvValid _$MovisensIsHrvValidFromJson(Map<String, dynamic> json) =>
    MovisensIsHrvValid(
      deviceId: json['deviceId'] as String,
      type: json['type'] as String,
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
  val['type'] = instance.type;
  val['isHrvValid'] = instance.isHrvValid;
  return val;
}

MovisensEDA _$MovisensEDAFromJson(Map<String, dynamic> json) => MovisensEDA(
      deviceId: json['deviceId'] as String,
      type: json['type'] as String,
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
  val['type'] = instance.type;
  val['edaSclMean'] = instance.edaSclMean;
  return val;
}

MovisensSkinTemperature _$MovisensSkinTemperatureFromJson(
        Map<String, dynamic> json) =>
    MovisensSkinTemperature(
      deviceId: json['deviceId'] as String,
      type: json['type'] as String,
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
  val['type'] = instance.type;
  val['skinTemperature'] = instance.skinTemperature;
  return val;
}

MovisensTapMarker _$MovisensTapMarkerFromJson(Map<String, dynamic> json) =>
    MovisensTapMarker(
      deviceId: json['deviceId'] as String,
      type: json['type'] as String,
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
  val['type'] = instance.type;
  val['tapMarker'] = instance.tapMarker;
  return val;
}

MovisensDevice _$MovisensDeviceFromJson(Map<String, dynamic> json) =>
    MovisensDevice(
      roleName: json['roleName'] as String?,
      deviceName: json['deviceName'] as String,
      sensorLocation: $enumDecodeNullable(
              _$SensorLocationEnumMap, json['sensorLocation']) ??
          SensorLocation.Chest,
      sex: $enumDecodeNullable(_$SexEnumMap, json['sex']) ?? Sex.Male,
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
  val['sex'] = _$SexEnumMap[instance.sex]!;
  return val;
}

const _$SensorLocationEnumMap = {
  SensorLocation.RightSideHip: 'RightSideHip',
  SensorLocation.Chest: 'Chest',
  SensorLocation.RightWrist: 'RightWrist',
  SensorLocation.LeftWrist: 'LeftWrist',
  SensorLocation.LeftAnkle: 'LeftAnkle',
  SensorLocation.RightAnkle: 'RightAnkle',
  SensorLocation.RightThigh: 'RightThigh',
  SensorLocation.LeftThigh: 'LeftThigh',
  SensorLocation.RightUpperArm: 'RightUpperArm',
  SensorLocation.LeftUpperArm: 'LeftUpperArm',
  SensorLocation.LeftSideHip: 'LeftSideHip',
};

const _$SexEnumMap = {
  Sex.Male: 'Male',
  Sex.Female: 'Female',
  Sex.Intersex: 'Intersex',
};
