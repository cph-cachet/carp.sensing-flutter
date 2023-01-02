// GENERATED CODE - DO NOT MODIFY BY HAND

part of carp_polar_package;

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PolarXYZ _$PolarXYZFromJson(Map<String, dynamic> json) => PolarXYZ(
      (json['x'] as num).toDouble(),
      (json['y'] as num).toDouble(),
      (json['z'] as num).toDouble(),
    );

Map<String, dynamic> _$PolarXYZToJson(PolarXYZ instance) => <String, dynamic>{
      'x': instance.x,
      'y': instance.y,
      'z': instance.z,
    };

PolarPPISample _$PolarPPISampleFromJson(Map<String, dynamic> json) =>
    PolarPPISample(
      json['ppi'] as int,
      json['errorEstimate'] as int,
      json['hr'] as int,
      json['blockerBit'] as bool,
      json['skinContactStatus'] as bool,
      json['skinContactSupported'] as bool,
    );

Map<String, dynamic> _$PolarPPISampleToJson(PolarPPISample instance) =>
    <String, dynamic>{
      'ppi': instance.ppi,
      'errorEstimate': instance.errorEstimate,
      'hr': instance.hr,
      'blockerBit': instance.blockerBit,
      'skinContactStatus': instance.skinContactStatus,
      'skinContactSupported': instance.skinContactSupported,
    };

PolarAccelerometer _$PolarAccelerometerFromJson(Map<String, dynamic> json) =>
    PolarAccelerometer(
      json['deviceIdentifier'] as String,
      json['deviceTimestamp'] as int?,
      (json['samples'] as List<dynamic>)
          .map((e) => PolarXYZ.fromJson(e as Map<String, dynamic>))
          .toList(),
    )
      ..$type = json['__type'] as String?
      ..sensorSpecificData = json['sensorSpecificData'] == null
          ? null
          : Data.fromJson(json['sensorSpecificData'] as Map<String, dynamic>);

Map<String, dynamic> _$PolarAccelerometerToJson(PolarAccelerometer instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('__type', instance.$type);
  writeNotNull('sensorSpecificData', instance.sensorSpecificData);
  val['deviceIdentifier'] = instance.deviceIdentifier;
  writeNotNull('deviceTimestamp', instance.deviceTimestamp);
  val['samples'] = instance.samples;
  return val;
}

PolarGyroscope _$PolarGyroscopeFromJson(Map<String, dynamic> json) =>
    PolarGyroscope(
      json['deviceIdentifier'] as String,
      json['deviceTimestamp'] as int?,
      (json['samples'] as List<dynamic>)
          .map((e) => PolarXYZ.fromJson(e as Map<String, dynamic>))
          .toList(),
    )
      ..$type = json['__type'] as String?
      ..sensorSpecificData = json['sensorSpecificData'] == null
          ? null
          : Data.fromJson(json['sensorSpecificData'] as Map<String, dynamic>);

Map<String, dynamic> _$PolarGyroscopeToJson(PolarGyroscope instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('__type', instance.$type);
  writeNotNull('sensorSpecificData', instance.sensorSpecificData);
  val['deviceIdentifier'] = instance.deviceIdentifier;
  writeNotNull('deviceTimestamp', instance.deviceTimestamp);
  val['samples'] = instance.samples;
  return val;
}

PolarMagnetometer _$PolarMagnetometerFromJson(Map<String, dynamic> json) =>
    PolarMagnetometer(
      json['deviceIdentifier'] as String,
      json['deviceTimestamp'] as int?,
      (json['samples'] as List<dynamic>)
          .map((e) => PolarXYZ.fromJson(e as Map<String, dynamic>))
          .toList(),
    )
      ..$type = json['__type'] as String?
      ..sensorSpecificData = json['sensorSpecificData'] == null
          ? null
          : Data.fromJson(json['sensorSpecificData'] as Map<String, dynamic>);

Map<String, dynamic> _$PolarMagnetometerToJson(PolarMagnetometer instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('__type', instance.$type);
  writeNotNull('sensorSpecificData', instance.sensorSpecificData);
  val['deviceIdentifier'] = instance.deviceIdentifier;
  writeNotNull('deviceTimestamp', instance.deviceTimestamp);
  val['samples'] = instance.samples;
  return val;
}

PolarECG _$PolarECGFromJson(Map<String, dynamic> json) => PolarECG(
      json['deviceIdentifier'] as String,
      json['deviceTimestamp'] as int?,
      (json['samples'] as List<dynamic>).map((e) => e as int).toList(),
    )
      ..$type = json['__type'] as String?
      ..sensorSpecificData = json['sensorSpecificData'] == null
          ? null
          : Data.fromJson(json['sensorSpecificData'] as Map<String, dynamic>);

Map<String, dynamic> _$PolarECGToJson(PolarECG instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('__type', instance.$type);
  writeNotNull('sensorSpecificData', instance.sensorSpecificData);
  val['deviceIdentifier'] = instance.deviceIdentifier;
  writeNotNull('deviceTimestamp', instance.deviceTimestamp);
  val['samples'] = instance.samples;
  return val;
}

PolarPPG _$PolarPPGFromJson(Map<String, dynamic> json) => PolarPPG(
      json['deviceIdentifier'] as String,
      json['deviceTimestamp'] as int?,
      $enumDecode(_$OhrDataTypeEnumMap, json['type']),
      (json['samples'] as List<dynamic>)
          .map((e) => (e as List<dynamic>).map((e) => e as int).toList())
          .toList(),
    )
      ..$type = json['__type'] as String?
      ..sensorSpecificData = json['sensorSpecificData'] == null
          ? null
          : Data.fromJson(json['sensorSpecificData'] as Map<String, dynamic>);

Map<String, dynamic> _$PolarPPGToJson(PolarPPG instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('__type', instance.$type);
  writeNotNull('sensorSpecificData', instance.sensorSpecificData);
  val['deviceIdentifier'] = instance.deviceIdentifier;
  writeNotNull('deviceTimestamp', instance.deviceTimestamp);
  val['type'] = _$OhrDataTypeEnumMap[instance.type]!;
  val['samples'] = instance.samples;
  return val;
}

const _$OhrDataTypeEnumMap = {
  OhrDataType.ppg3_ambient1: 'ppg3_ambient1',
  OhrDataType.unknown: 'unknown',
};

PolarPPI _$PolarPPIFromJson(Map<String, dynamic> json) => PolarPPI(
      json['deviceIdentifier'] as String,
      json['deviceTimestamp'] as int?,
      (json['samples'] as List<dynamic>)
          .map((e) => PolarPPISample.fromJson(e as Map<String, dynamic>))
          .toList(),
    )
      ..$type = json['__type'] as String?
      ..sensorSpecificData = json['sensorSpecificData'] == null
          ? null
          : Data.fromJson(json['sensorSpecificData'] as Map<String, dynamic>);

Map<String, dynamic> _$PolarPPIToJson(PolarPPI instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('__type', instance.$type);
  writeNotNull('sensorSpecificData', instance.sensorSpecificData);
  val['deviceIdentifier'] = instance.deviceIdentifier;
  writeNotNull('deviceTimestamp', instance.deviceTimestamp);
  val['samples'] = instance.samples;
  return val;
}

PolarHR _$PolarHRFromJson(Map<String, dynamic> json) => PolarHR(
      json['deviceIdentifier'] as String,
      json['deviceTimestamp'] as int?,
      json['hr'] as int,
      (json['rrs'] as List<dynamic>).map((e) => e as int).toList(),
      (json['rrsMs'] as List<dynamic>).map((e) => e as int).toList(),
      json['contactStatus'] as bool,
      json['contactStatusSupported'] as bool,
    )
      ..$type = json['__type'] as String?
      ..sensorSpecificData = json['sensorSpecificData'] == null
          ? null
          : Data.fromJson(json['sensorSpecificData'] as Map<String, dynamic>);

Map<String, dynamic> _$PolarHRToJson(PolarHR instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('__type', instance.$type);
  writeNotNull('sensorSpecificData', instance.sensorSpecificData);
  val['deviceIdentifier'] = instance.deviceIdentifier;
  writeNotNull('deviceTimestamp', instance.deviceTimestamp);
  val['hr'] = instance.hr;
  val['rrs'] = instance.rrs;
  val['rrsMs'] = instance.rrsMs;
  val['contactStatus'] = instance.contactStatus;
  val['contactStatusSupported'] = instance.contactStatusSupported;
  return val;
}

PolarDevice _$PolarDeviceFromJson(Map<String, dynamic> json) => PolarDevice(
      roleName: json['roleName'] as String? ?? PolarDevice.DEFAULT_ROLENAME,
      polarDeviceType: $enumDecodeNullable(
          _$PolarDeviceTypeEnumMap, json['polarDeviceType']),
      identifier: json['identifier'] as String?,
      name: json['name'] as String?,
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
      )
      ..settings = json['settings'] == null
          ? null
          : PolarSensorSetting.fromJson(
              json['settings'] as Map<String, dynamic>)
      ..address = json['address'] as String?
      ..rssi = json['rssi'] as int?;

Map<String, dynamic> _$PolarDeviceToJson(PolarDevice instance) {
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
  writeNotNull('settings', instance.settings);
  writeNotNull('identifier', instance.identifier);
  writeNotNull('address', instance.address);
  writeNotNull(
      'polarDeviceType', _$PolarDeviceTypeEnumMap[instance.polarDeviceType]);
  writeNotNull('name', instance.name);
  writeNotNull('rssi', instance.rssi);
  return val;
}

const _$PolarDeviceTypeEnumMap = {
  PolarDeviceType.UNKNOWN: 'UNKNOWN',
  PolarDeviceType.H9: 'H9',
  PolarDeviceType.H10: 'H10',
  PolarDeviceType.SENSE: 'SENSE',
};
