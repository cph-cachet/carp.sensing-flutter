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
      json['error_estimate'] as int,
      json['hr'] as int,
      json['blocker_bit'] as bool,
      json['skin_contact_status'] as bool,
      json['skin_contact_supported'] as bool,
    );

Map<String, dynamic> _$PolarPPISampleToJson(PolarPPISample instance) =>
    <String, dynamic>{
      'ppi': instance.ppi,
      'error_estimate': instance.errorEstimate,
      'hr': instance.hr,
      'blocker_bit': instance.blockerBit,
      'skin_contact_status': instance.skinContactStatus,
      'skin_contact_supported': instance.skinContactSupported,
    };

PolarAccelerometerDatum _$PolarAccelerometerDatumFromJson(
        Map<String, dynamic> json) =>
    PolarAccelerometerDatum(
      json['device_identifier'] as String,
      json['device_timestamp'] as int?,
      (json['samples'] as List<dynamic>)
          .map((e) => PolarXYZ.fromJson(e as Map<String, dynamic>))
          .toList(),
    )
      ..id = json['id'] as String?
      ..timestamp = DateTime.parse(json['timestamp'] as String);

Map<String, dynamic> _$PolarAccelerometerDatumToJson(
    PolarAccelerometerDatum instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  val['timestamp'] = instance.timestamp.toIso8601String();
  val['device_identifier'] = instance.deviceIdentifier;
  writeNotNull('device_timestamp', instance.deviceTimestamp);
  val['samples'] = instance.samples;
  return val;
}

PolarGyroscopeDatum _$PolarGyroscopeDatumFromJson(Map<String, dynamic> json) =>
    PolarGyroscopeDatum(
      json['device_identifier'] as String,
      json['device_timestamp'] as int?,
      (json['samples'] as List<dynamic>)
          .map((e) => PolarXYZ.fromJson(e as Map<String, dynamic>))
          .toList(),
    )
      ..id = json['id'] as String?
      ..timestamp = DateTime.parse(json['timestamp'] as String);

Map<String, dynamic> _$PolarGyroscopeDatumToJson(PolarGyroscopeDatum instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  val['timestamp'] = instance.timestamp.toIso8601String();
  val['device_identifier'] = instance.deviceIdentifier;
  writeNotNull('device_timestamp', instance.deviceTimestamp);
  val['samples'] = instance.samples;
  return val;
}

PolarMagnetometerDatum _$PolarMagnetometerDatumFromJson(
        Map<String, dynamic> json) =>
    PolarMagnetometerDatum(
      json['device_identifier'] as String,
      json['device_timestamp'] as int?,
      (json['samples'] as List<dynamic>)
          .map((e) => PolarXYZ.fromJson(e as Map<String, dynamic>))
          .toList(),
    )
      ..id = json['id'] as String?
      ..timestamp = DateTime.parse(json['timestamp'] as String);

Map<String, dynamic> _$PolarMagnetometerDatumToJson(
    PolarMagnetometerDatum instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  val['timestamp'] = instance.timestamp.toIso8601String();
  val['device_identifier'] = instance.deviceIdentifier;
  writeNotNull('device_timestamp', instance.deviceTimestamp);
  val['samples'] = instance.samples;
  return val;
}

PolarECGDatum _$PolarECGDatumFromJson(Map<String, dynamic> json) =>
    PolarECGDatum(
      json['device_identifier'] as String,
      json['device_timestamp'] as int?,
      (json['samples'] as List<dynamic>).map((e) => e as int).toList(),
    )
      ..id = json['id'] as String?
      ..timestamp = DateTime.parse(json['timestamp'] as String);

Map<String, dynamic> _$PolarECGDatumToJson(PolarECGDatum instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  val['timestamp'] = instance.timestamp.toIso8601String();
  val['device_identifier'] = instance.deviceIdentifier;
  writeNotNull('device_timestamp', instance.deviceTimestamp);
  val['samples'] = instance.samples;
  return val;
}

PolarPPGDatum _$PolarPPGDatumFromJson(Map<String, dynamic> json) =>
    PolarPPGDatum(
      json['device_identifier'] as String,
      json['device_timestamp'] as int?,
      $enumDecode(_$OhrDataTypeEnumMap, json['type']),
      (json['samples'] as List<dynamic>)
          .map((e) => (e as List<dynamic>).map((e) => e as int).toList())
          .toList(),
    )
      ..id = json['id'] as String?
      ..timestamp = DateTime.parse(json['timestamp'] as String);

Map<String, dynamic> _$PolarPPGDatumToJson(PolarPPGDatum instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  val['timestamp'] = instance.timestamp.toIso8601String();
  val['device_identifier'] = instance.deviceIdentifier;
  writeNotNull('device_timestamp', instance.deviceTimestamp);
  val['type'] = _$OhrDataTypeEnumMap[instance.type]!;
  val['samples'] = instance.samples;
  return val;
}

const _$OhrDataTypeEnumMap = {
  OhrDataType.ppg3_ambient1: 'ppg3_ambient1',
  OhrDataType.unknown: 'unknown',
};

PolarPPIDatum _$PolarPPIDatumFromJson(Map<String, dynamic> json) =>
    PolarPPIDatum(
      json['device_identifier'] as String,
      json['device_timestamp'] as int?,
      (json['samples'] as List<dynamic>)
          .map((e) => PolarPPISample.fromJson(e as Map<String, dynamic>))
          .toList(),
    )
      ..id = json['id'] as String?
      ..timestamp = DateTime.parse(json['timestamp'] as String);

Map<String, dynamic> _$PolarPPIDatumToJson(PolarPPIDatum instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  val['timestamp'] = instance.timestamp.toIso8601String();
  val['device_identifier'] = instance.deviceIdentifier;
  writeNotNull('device_timestamp', instance.deviceTimestamp);
  val['samples'] = instance.samples;
  return val;
}

PolarHRDatum _$PolarHRDatumFromJson(Map<String, dynamic> json) => PolarHRDatum(
      json['device_identifier'] as String,
      json['device_timestamp'] as int?,
      json['hr'] as int,
      (json['rrs'] as List<dynamic>).map((e) => e as int).toList(),
      (json['rrs_ms'] as List<dynamic>).map((e) => e as int).toList(),
      json['contact_status'] as bool,
      json['contact_status_supported'] as bool,
    )
      ..id = json['id'] as String?
      ..timestamp = DateTime.parse(json['timestamp'] as String);

Map<String, dynamic> _$PolarHRDatumToJson(PolarHRDatum instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  val['timestamp'] = instance.timestamp.toIso8601String();
  val['device_identifier'] = instance.deviceIdentifier;
  writeNotNull('device_timestamp', instance.deviceTimestamp);
  val['hr'] = instance.hr;
  val['rrs'] = instance.rrs;
  val['rrs_ms'] = instance.rrsMs;
  val['contact_status'] = instance.contactStatus;
  val['contact_status_supported'] = instance.contactStatusSupported;
  return val;
}

PolarDevice _$PolarDeviceFromJson(Map<String, dynamic> json) => PolarDevice(
      roleName: json['roleName'] as String?,
      polarDeviceType: $enumDecodeNullable(
          _$PolarDeviceTypeEnumMap, json['polarDeviceType']),
      identifier: json['identifier'] as String?,
      name: json['name'] as String?,
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

  writeNotNull(r'$type', instance.$type);
  writeNotNull('isMasterDevice', instance.isMasterDevice);
  val['roleName'] = instance.roleName;
  writeNotNull('supportedDataTypes', instance.supportedDataTypes);
  val['samplingConfiguration'] = instance.samplingConfiguration;
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
  PolarDeviceType.H9: 'H9',
  PolarDeviceType.H10: 'H10',
  PolarDeviceType.PVS: 'PVS',
};
