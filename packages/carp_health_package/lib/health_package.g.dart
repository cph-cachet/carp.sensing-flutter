// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'health_package.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HealthSamplingConfiguration _$HealthSamplingConfigurationFromJson(
        Map<String, dynamic> json) =>
    HealthSamplingConfiguration(
      past: json['past'] == null
          ? null
          : Duration(microseconds: json['past'] as int),
      healthDataTypes: (json['healthDataTypes'] as List<dynamic>)
          .map((e) => $enumDecode(_$HealthDataTypeEnumMap, e))
          .toList(),
    )
      ..$type = json['__type'] as String?
      ..lastTime = json['lastTime'] == null
          ? null
          : DateTime.parse(json['lastTime'] as String)
      ..future = Duration(microseconds: json['future'] as int);

Map<String, dynamic> _$HealthSamplingConfigurationToJson(
    HealthSamplingConfiguration instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('__type', instance.$type);
  writeNotNull('lastTime', instance.lastTime?.toIso8601String());
  val['past'] = instance.past.inMicroseconds;
  val['future'] = instance.future.inMicroseconds;
  val['healthDataTypes'] =
      instance.healthDataTypes.map((e) => _$HealthDataTypeEnumMap[e]!).toList();
  return val;
}

const _$HealthDataTypeEnumMap = {
  HealthDataType.ACTIVE_ENERGY_BURNED: 'ACTIVE_ENERGY_BURNED',
  HealthDataType.AUDIOGRAM: 'AUDIOGRAM',
  HealthDataType.BASAL_ENERGY_BURNED: 'BASAL_ENERGY_BURNED',
  HealthDataType.BLOOD_GLUCOSE: 'BLOOD_GLUCOSE',
  HealthDataType.BLOOD_OXYGEN: 'BLOOD_OXYGEN',
  HealthDataType.BLOOD_PRESSURE_DIASTOLIC: 'BLOOD_PRESSURE_DIASTOLIC',
  HealthDataType.BLOOD_PRESSURE_SYSTOLIC: 'BLOOD_PRESSURE_SYSTOLIC',
  HealthDataType.BODY_FAT_PERCENTAGE: 'BODY_FAT_PERCENTAGE',
  HealthDataType.BODY_MASS_INDEX: 'BODY_MASS_INDEX',
  HealthDataType.BODY_TEMPERATURE: 'BODY_TEMPERATURE',
  HealthDataType.DIETARY_CARBS_CONSUMED: 'DIETARY_CARBS_CONSUMED',
  HealthDataType.DIETARY_ENERGY_CONSUMED: 'DIETARY_ENERGY_CONSUMED',
  HealthDataType.DIETARY_FATS_CONSUMED: 'DIETARY_FATS_CONSUMED',
  HealthDataType.DIETARY_PROTEIN_CONSUMED: 'DIETARY_PROTEIN_CONSUMED',
  HealthDataType.FORCED_EXPIRATORY_VOLUME: 'FORCED_EXPIRATORY_VOLUME',
  HealthDataType.HEART_RATE: 'HEART_RATE',
  HealthDataType.HEART_RATE_VARIABILITY_SDNN: 'HEART_RATE_VARIABILITY_SDNN',
  HealthDataType.HEIGHT: 'HEIGHT',
  HealthDataType.RESTING_HEART_RATE: 'RESTING_HEART_RATE',
  HealthDataType.RESPIRATORY_RATE: 'RESPIRATORY_RATE',
  HealthDataType.PERIPHERAL_PERFUSION_INDEX: 'PERIPHERAL_PERFUSION_INDEX',
  HealthDataType.STEPS: 'STEPS',
  HealthDataType.WAIST_CIRCUMFERENCE: 'WAIST_CIRCUMFERENCE',
  HealthDataType.WALKING_HEART_RATE: 'WALKING_HEART_RATE',
  HealthDataType.WEIGHT: 'WEIGHT',
  HealthDataType.DISTANCE_WALKING_RUNNING: 'DISTANCE_WALKING_RUNNING',
  HealthDataType.FLIGHTS_CLIMBED: 'FLIGHTS_CLIMBED',
  HealthDataType.MOVE_MINUTES: 'MOVE_MINUTES',
  HealthDataType.DISTANCE_DELTA: 'DISTANCE_DELTA',
  HealthDataType.MINDFULNESS: 'MINDFULNESS',
  HealthDataType.WATER: 'WATER',
  HealthDataType.SLEEP_IN_BED: 'SLEEP_IN_BED',
  HealthDataType.SLEEP_ASLEEP: 'SLEEP_ASLEEP',
  HealthDataType.SLEEP_AWAKE: 'SLEEP_AWAKE',
  HealthDataType.SLEEP_LIGHT: 'SLEEP_LIGHT',
  HealthDataType.SLEEP_DEEP: 'SLEEP_DEEP',
  HealthDataType.SLEEP_REM: 'SLEEP_REM',
  HealthDataType.SLEEP_OUT_OF_BED: 'SLEEP_OUT_OF_BED',
  HealthDataType.SLEEP_SESSION: 'SLEEP_SESSION',
  HealthDataType.EXERCISE_TIME: 'EXERCISE_TIME',
  HealthDataType.WORKOUT: 'WORKOUT',
  HealthDataType.HEADACHE_NOT_PRESENT: 'HEADACHE_NOT_PRESENT',
  HealthDataType.HEADACHE_MILD: 'HEADACHE_MILD',
  HealthDataType.HEADACHE_MODERATE: 'HEADACHE_MODERATE',
  HealthDataType.HEADACHE_SEVERE: 'HEADACHE_SEVERE',
  HealthDataType.HEADACHE_UNSPECIFIED: 'HEADACHE_UNSPECIFIED',
  HealthDataType.HIGH_HEART_RATE_EVENT: 'HIGH_HEART_RATE_EVENT',
  HealthDataType.LOW_HEART_RATE_EVENT: 'LOW_HEART_RATE_EVENT',
  HealthDataType.IRREGULAR_HEART_RATE_EVENT: 'IRREGULAR_HEART_RATE_EVENT',
  HealthDataType.ELECTRODERMAL_ACTIVITY: 'ELECTRODERMAL_ACTIVITY',
  HealthDataType.ELECTROCARDIOGRAM: 'ELECTROCARDIOGRAM',
};

HealthData _$HealthDataFromJson(Map<String, dynamic> json) => HealthData(
      json['uuid'] as String,
      _healthValueFromJson(json['value']),
      json['unit'] as String,
      json['data_type'] as String,
      DateTime.parse(json['date_from'] as String),
      DateTime.parse(json['date_to'] as String),
      json['platform'] as String,
      json['device_id'] as String,
      json['source_id'] as String,
      json['source_name'] as String,
    )..$type = json['__type'] as String?;

Map<String, dynamic> _$HealthDataToJson(HealthData instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('__type', instance.$type);
  val['uuid'] = instance.uuid;
  val['value'] = instance.value;
  val['unit'] = instance.unit;
  val['date_from'] = instance.dateFrom.toIso8601String();
  val['date_to'] = instance.dateTo.toIso8601String();
  val['data_type'] = instance.dataType;
  val['platform'] = instance.platform;
  val['device_id'] = instance.deviceId;
  val['source_id'] = instance.sourceId;
  val['source_name'] = instance.sourceName;
  return val;
}

HealthService _$HealthServiceFromJson(Map<String, dynamic> json) =>
    HealthService(
      roleName: json['roleName'] as String?,
      types: (json['types'] as List<dynamic>)
          .map((e) => $enumDecode(_$HealthDataTypeEnumMap, e))
          .toList(),
      useHealthConnectIfAvailable:
          json['useHealthConnectIfAvailable'] as bool? ?? false,
    )
      ..$type = json['__type'] as String?
      ..isOptional = json['isOptional'] as bool?
      ..defaultSamplingConfiguration =
          (json['defaultSamplingConfiguration'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(
            k, SamplingConfiguration.fromJson(e as Map<String, dynamic>)),
      );

Map<String, dynamic> _$HealthServiceToJson(HealthService instance) {
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
  val['types'] =
      instance.types.map((e) => _$HealthDataTypeEnumMap[e]!).toList();
  val['useHealthConnectIfAvailable'] = instance.useHealthConnectIfAvailable;
  return val;
}
