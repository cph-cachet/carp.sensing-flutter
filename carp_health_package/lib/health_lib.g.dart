// GENERATED CODE - DO NOT MODIFY BY HAND

part of health_lib;

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HealthMeasure _$HealthMeasureFromJson(Map<String, dynamic> json) {
  return HealthMeasure(
    json['type'] == null
        ? null
        : MeasureType.fromJson(json['type'] as Map<String, dynamic>),
    (json['health_data_types'] as List)
        ?.map((e) => _$enumDecodeNullable(_$HealthDataTypeEnumMap, e))
        ?.toList(),
    json['duration'] == null
        ? null
        : Duration(microseconds: json['duration'] as int),
    name: json['name'] as String,
    enabled: json['enabled'] as bool,
  )
    ..c__ = json['c__'] as String
    ..configuration = (json['configuration'] as Map<String, dynamic>)?.map(
      (k, e) => MapEntry(k, e as String),
    );
}

Map<String, dynamic> _$HealthMeasureToJson(HealthMeasure instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('c__', instance.c__);
  writeNotNull('type', instance.type);
  writeNotNull('configuration', instance.configuration);
  writeNotNull(
      'health_data_types',
      instance.healthDataTypes
          ?.map((e) => _$HealthDataTypeEnumMap[e])
          ?.toList());
  writeNotNull('duration', instance.duration?.inMicroseconds);
  writeNotNull('name', instance.name);
  writeNotNull('enabled', instance.enabled);
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

const _$HealthDataTypeEnumMap = {
  HealthDataType.BODY_FAT_PERCENTAGE: 'BODY_FAT_PERCENTAGE',
  HealthDataType.HEIGHT: 'HEIGHT',
  HealthDataType.WEIGHT: 'WEIGHT',
  HealthDataType.BODY_MASS_INDEX: 'BODY_MASS_INDEX',
  HealthDataType.WAIST_CIRCUMFERENCE: 'WAIST_CIRCUMFERENCE',
  HealthDataType.STEPS: 'STEPS',
  HealthDataType.BASAL_ENERGY_BURNED: 'BASAL_ENERGY_BURNED',
  HealthDataType.ACTIVE_ENERGY_BURNED: 'ACTIVE_ENERGY_BURNED',
  HealthDataType.HEART_RATE: 'HEART_RATE',
  HealthDataType.BODY_TEMPERATURE: 'BODY_TEMPERATURE',
  HealthDataType.BLOOD_PRESSURE_SYSTOLIC: 'BLOOD_PRESSURE_SYSTOLIC',
  HealthDataType.BLOOD_PRESSURE_DIASTOLIC: 'BLOOD_PRESSURE_DIASTOLIC',
  HealthDataType.RESTING_HEART_RATE: 'RESTING_HEART_RATE',
  HealthDataType.WALKING_HEART_RATE: 'WALKING_HEART_RATE',
  HealthDataType.BLOOD_OXYGEN: 'BLOOD_OXYGEN',
  HealthDataType.BLOOD_GLUCOSE: 'BLOOD_GLUCOSE',
  HealthDataType.ELECTRODERMAL_ACTIVITY: 'ELECTRODERMAL_ACTIVITY',
  HealthDataType.HIGH_HEART_RATE_EVENT: 'HIGH_HEART_RATE_EVENT',
  HealthDataType.LOW_HEART_RATE_EVENT: 'LOW_HEART_RATE_EVENT',
  HealthDataType.IRREGULAR_HEART_RATE_EVENT: 'IRREGULAR_HEART_RATE_EVENT',
};

HealthDatum _$HealthDatumFromJson(Map<String, dynamic> json) {
  return HealthDatum(
    (json['health_data'] as List)
        ?.map((e) => e as Map<String, dynamic>)
        ?.toList(),
  )
    ..id = json['id'] as String
    ..timestamp = json['timestamp'] == null
        ? null
        : DateTime.parse(json['timestamp'] as String);
}

Map<String, dynamic> _$HealthDatumToJson(HealthDatum instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  writeNotNull('timestamp', instance.timestamp?.toIso8601String());
  writeNotNull('health_data', instance.healthData);
  return val;
}
