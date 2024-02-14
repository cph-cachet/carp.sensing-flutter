// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'carp_movesense_package.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MovesenseStateChange _$MovesenseStateChangeFromJson(
        Map<String, dynamic> json) =>
    MovesenseStateChange(
      $enumDecode(_$MovesenseDeviceStateEnumMap, json['state']),
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
      (json['rr'] as List<dynamic>?)?.map((e) => e as int).toList() ?? const [],
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
  val['rr'] = instance.rr;
  return val;
}

MovesenseECG _$MovesenseECGFromJson(Map<String, dynamic> json) => MovesenseECG(
      (json['samples'] as List<dynamic>).map((e) => e as int).toList(),
      json['timestamp'] as int,
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

MovesenseDevice _$MovesenseDeviceFromJson(Map<String, dynamic> json) =>
    MovesenseDevice(
      roleName:
          json['roleName'] as String? ?? MovesenseDevice.DEFAULT_ROLE_NAME,
      isOptional: json['isOptional'] as bool? ?? true,
      name: json['name'] as String?,
      address: json['address'] as String?,
      serial: json['serial'] as String?,
      deviceType:
          $enumDecodeNullable(_$MovesenseDeviceTypeEnumMap, json['deviceType']),
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
  writeNotNull('deviceType', _$MovesenseDeviceTypeEnumMap[instance.deviceType]);
  return val;
}

const _$MovesenseDeviceTypeEnumMap = {
  MovesenseDeviceType.UNKNOWN: 'UNKNOWN',
  MovesenseDeviceType.MD: 'MD',
  MovesenseDeviceType.ACTIVE: 'ACTIVE',
  MovesenseDeviceType.FLASH: 'FLASH',
};
