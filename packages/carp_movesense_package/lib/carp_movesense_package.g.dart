// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'carp_movesense_package.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MovesenseDeviceInformation _$MovesenseDeviceInformationFromJson(
        Map<String, dynamic> json) =>
    MovesenseDeviceInformation(
      json['manufacturerName'] as String?,
      json['brandName'] as String?,
      json['productName'] as String?,
      json['variant'] as String?,
      json['design'] as String?,
      json['hardwareCompatibilityId'] as String?,
      json['serial'] as String?,
      json['pcbaSerial'] as String?,
      json['softwareVersion'] as String?,
      json['hardwareType'] as String?,
      json['additionalVersionInfo'] as String?,
      json['apiLevel'] as String?,
      json['address'] as String?,
    )
      ..$type = json['__type'] as String?
      ..sensorSpecificData = json['sensorSpecificData'] == null
          ? null
          : Data.fromJson(json['sensorSpecificData'] as Map<String, dynamic>);

Map<String, dynamic> _$MovesenseDeviceInformationToJson(
    MovesenseDeviceInformation instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('__type', instance.$type);
  writeNotNull('sensorSpecificData', instance.sensorSpecificData);
  writeNotNull('manufacturerName', instance.manufacturerName);
  writeNotNull('brandName', instance.brandName);
  writeNotNull('productName', instance.productName);
  writeNotNull('variant', instance.variant);
  writeNotNull('design', instance.design);
  writeNotNull('hardwareCompatibilityId', instance.hardwareCompatibilityId);
  writeNotNull('serial', instance.serial);
  writeNotNull('pcbaSerial', instance.pcbaSerial);
  writeNotNull('softwareVersion', instance.softwareVersion);
  writeNotNull('hardwareType', instance.hardwareType);
  writeNotNull('additionalVersionInfo', instance.additionalVersionInfo);
  writeNotNull('apiLevel', instance.apiLevel);
  writeNotNull('address', instance.address);
  return val;
}

MovesenseStateChange _$MovesenseStateChangeFromJson(
        Map<String, dynamic> json) =>
    MovesenseStateChange(
      $enumDecode(_$MovesenseDeviceStateEnumMap, json['state']),
      (json['timestamp'] as num?)?.toInt(),
    )
      ..$type = json['__type'] as String?
      ..sensorSpecificData = json['sensorSpecificData'] == null
          ? null
          : Data.fromJson(json['sensorSpecificData'] as Map<String, dynamic>);

Map<String, dynamic> _$MovesenseStateChangeToJson(
    MovesenseStateChange instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('__type', instance.$type);
  writeNotNull('sensorSpecificData', instance.sensorSpecificData);
  val['state'] = _$MovesenseDeviceStateEnumMap[instance.state]!;
  val['timestamp'] = instance.timestamp;
  return val;
}

const _$MovesenseDeviceStateEnumMap = {
  MovesenseDeviceState.unknown: 'unknown',
  MovesenseDeviceState.moving: 'moving',
  MovesenseDeviceState.notMoving: 'notMoving',
  MovesenseDeviceState.connected: 'connected',
  MovesenseDeviceState.disconnected: 'disconnected',
  MovesenseDeviceState.tap: 'tap',
  MovesenseDeviceState.doubleTap: 'doubleTap',
  MovesenseDeviceState.acceleration: 'acceleration',
  MovesenseDeviceState.freeFall: 'freeFall',
};

MovesenseHR _$MovesenseHRFromJson(Map<String, dynamic> json) => MovesenseHR(
      (json['hr'] as num).toDouble(),
      (json['rr'] as num?)?.toInt(),
    )
      ..$type = json['__type'] as String?
      ..sensorSpecificData = json['sensorSpecificData'] == null
          ? null
          : Data.fromJson(json['sensorSpecificData'] as Map<String, dynamic>);

Map<String, dynamic> _$MovesenseHRToJson(MovesenseHR instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('__type', instance.$type);
  writeNotNull('sensorSpecificData', instance.sensorSpecificData);
  val['hr'] = instance.hr;
  writeNotNull('rr', instance.rr);
  return val;
}

MovesenseECG _$MovesenseECGFromJson(Map<String, dynamic> json) => MovesenseECG(
      (json['timestamp'] as num).toInt(),
      (json['samples'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList(),
    )
      ..$type = json['__type'] as String?
      ..sensorSpecificData = json['sensorSpecificData'] == null
          ? null
          : Data.fromJson(json['sensorSpecificData'] as Map<String, dynamic>);

Map<String, dynamic> _$MovesenseECGToJson(MovesenseECG instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('__type', instance.$type);
  writeNotNull('sensorSpecificData', instance.sensorSpecificData);
  val['timestamp'] = instance.timestamp;
  val['samples'] = instance.samples;
  return val;
}

MovesenseTemperature _$MovesenseTemperatureFromJson(
        Map<String, dynamic> json) =>
    MovesenseTemperature(
      (json['timestamp'] as num).toInt(),
      (json['measurement'] as num).toInt(),
    )
      ..$type = json['__type'] as String?
      ..sensorSpecificData = json['sensorSpecificData'] == null
          ? null
          : Data.fromJson(json['sensorSpecificData'] as Map<String, dynamic>);

Map<String, dynamic> _$MovesenseTemperatureToJson(
    MovesenseTemperature instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('__type', instance.$type);
  writeNotNull('sensorSpecificData', instance.sensorSpecificData);
  val['timestamp'] = instance.timestamp;
  val['measurement'] = instance.measurement;
  return val;
}

MovesenseIMU _$MovesenseIMUFromJson(Map<String, dynamic> json) => MovesenseIMU(
      (json['timestamp'] as num).toInt(),
      (json['accelerometer'] as List<dynamic>)
          .map((e) =>
              MovesenseAccelerometerSample.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['gyroscope'] as List<dynamic>)
          .map((e) =>
              MovesenseGyroscopeSample.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['magnetometer'] as List<dynamic>)
          .map((e) =>
              MovesenseMagnetometerSample.fromJson(e as Map<String, dynamic>))
          .toList(),
    )
      ..$type = json['__type'] as String?
      ..sensorSpecificData = json['sensorSpecificData'] == null
          ? null
          : Data.fromJson(json['sensorSpecificData'] as Map<String, dynamic>);

Map<String, dynamic> _$MovesenseIMUToJson(MovesenseIMU instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('__type', instance.$type);
  writeNotNull('sensorSpecificData', instance.sensorSpecificData);
  val['timestamp'] = instance.timestamp;
  val['accelerometer'] = instance.accelerometer;
  val['gyroscope'] = instance.gyroscope;
  val['magnetometer'] = instance.magnetometer;
  return val;
}

MovesenseAccelerometerSample _$MovesenseAccelerometerSampleFromJson(
        Map<String, dynamic> json) =>
    MovesenseAccelerometerSample(
      json['x'] as num,
      json['y'] as num,
      json['z'] as num,
    );

Map<String, dynamic> _$MovesenseAccelerometerSampleToJson(
        MovesenseAccelerometerSample instance) =>
    <String, dynamic>{
      'x': instance.x,
      'y': instance.y,
      'z': instance.z,
    };

MovesenseGyroscopeSample _$MovesenseGyroscopeSampleFromJson(
        Map<String, dynamic> json) =>
    MovesenseGyroscopeSample(
      json['x'] as num,
      json['y'] as num,
      json['z'] as num,
    );

Map<String, dynamic> _$MovesenseGyroscopeSampleToJson(
        MovesenseGyroscopeSample instance) =>
    <String, dynamic>{
      'x': instance.x,
      'y': instance.y,
      'z': instance.z,
    };

MovesenseMagnetometerSample _$MovesenseMagnetometerSampleFromJson(
        Map<String, dynamic> json) =>
    MovesenseMagnetometerSample(
      json['x'] as num,
      json['y'] as num,
      json['z'] as num,
    );

Map<String, dynamic> _$MovesenseMagnetometerSampleToJson(
        MovesenseMagnetometerSample instance) =>
    <String, dynamic>{
      'x': instance.x,
      'y': instance.y,
      'z': instance.z,
    };

MovesenseDevice _$MovesenseDeviceFromJson(Map<String, dynamic> json) =>
    MovesenseDevice(
      roleName:
          json['roleName'] as String? ?? MovesenseDevice.DEFAULT_ROLE_NAME,
      isOptional: json['isOptional'] as bool? ?? true,
      name: json['name'] as String?,
      address: json['address'] as String?,
      serial: json['serial'] as String?,
      deviceType: $enumDecodeNullable(
              _$MovesenseDeviceTypeEnumMap, json['deviceType']) ??
          MovesenseDeviceType.UNKNOWN,
    )
      ..$type = json['__type'] as String?
      ..defaultSamplingConfiguration =
          (json['defaultSamplingConfiguration'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(
            k, SamplingConfiguration.fromJson(e as Map<String, dynamic>)),
      );

Map<String, dynamic> _$MovesenseDeviceToJson(MovesenseDevice instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('__type', instance.$type);
  val['roleName'] = instance.roleName;
  writeNotNull('isOptional', instance.isOptional);
  writeNotNull(
      'defaultSamplingConfiguration', instance.defaultSamplingConfiguration);
  writeNotNull('address', instance.address);
  writeNotNull('serial', instance.serial);
  writeNotNull('name', instance.name);
  val['deviceType'] = _$MovesenseDeviceTypeEnumMap[instance.deviceType]!;
  return val;
}

const _$MovesenseDeviceTypeEnumMap = {
  MovesenseDeviceType.UNKNOWN: 'UNKNOWN',
  MovesenseDeviceType.MD: 'MD',
  MovesenseDeviceType.HR_PLUS: 'HR_PLUS',
  MovesenseDeviceType.HR2: 'HR2',
  MovesenseDeviceType.FLASH: 'FLASH',
};
