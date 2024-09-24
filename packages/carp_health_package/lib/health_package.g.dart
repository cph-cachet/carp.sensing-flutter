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
          : Duration(microseconds: (json['past'] as num).toInt()),
      healthDataTypes: (json['healthDataTypes'] as List<dynamic>)
          .map((e) => $enumDecode(_$HealthDataTypeEnumMap, e))
          .toList(),
    )
      ..$type = json['__type'] as String?
      ..lastTime = json['lastTime'] == null
          ? null
          : DateTime.parse(json['lastTime'] as String)
      ..future = Duration(microseconds: (json['future'] as num).toInt());

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
  HealthDataType.ATRIAL_FIBRILLATION_BURDEN: 'ATRIAL_FIBRILLATION_BURDEN',
  HealthDataType.AUDIOGRAM: 'AUDIOGRAM',
  HealthDataType.BASAL_ENERGY_BURNED: 'BASAL_ENERGY_BURNED',
  HealthDataType.BLOOD_GLUCOSE: 'BLOOD_GLUCOSE',
  HealthDataType.BLOOD_OXYGEN: 'BLOOD_OXYGEN',
  HealthDataType.BLOOD_PRESSURE_DIASTOLIC: 'BLOOD_PRESSURE_DIASTOLIC',
  HealthDataType.BLOOD_PRESSURE_SYSTOLIC: 'BLOOD_PRESSURE_SYSTOLIC',
  HealthDataType.BODY_FAT_PERCENTAGE: 'BODY_FAT_PERCENTAGE',
  HealthDataType.BODY_MASS_INDEX: 'BODY_MASS_INDEX',
  HealthDataType.BODY_TEMPERATURE: 'BODY_TEMPERATURE',
  HealthDataType.BODY_WATER_MASS: 'BODY_WATER_MASS',
  HealthDataType.DIETARY_CARBS_CONSUMED: 'DIETARY_CARBS_CONSUMED',
  HealthDataType.DIETARY_CAFFEINE: 'DIETARY_CAFFEINE',
  HealthDataType.DIETARY_ENERGY_CONSUMED: 'DIETARY_ENERGY_CONSUMED',
  HealthDataType.DIETARY_FATS_CONSUMED: 'DIETARY_FATS_CONSUMED',
  HealthDataType.DIETARY_PROTEIN_CONSUMED: 'DIETARY_PROTEIN_CONSUMED',
  HealthDataType.DIETARY_FIBER: 'DIETARY_FIBER',
  HealthDataType.DIETARY_SUGAR: 'DIETARY_SUGAR',
  HealthDataType.DIETARY_FAT_MONOUNSATURATED: 'DIETARY_FAT_MONOUNSATURATED',
  HealthDataType.DIETARY_FAT_POLYUNSATURATED: 'DIETARY_FAT_POLYUNSATURATED',
  HealthDataType.DIETARY_FAT_SATURATED: 'DIETARY_FAT_SATURATED',
  HealthDataType.DIETARY_CHOLESTEROL: 'DIETARY_CHOLESTEROL',
  HealthDataType.DIETARY_VITAMIN_A: 'DIETARY_VITAMIN_A',
  HealthDataType.DIETARY_THIAMIN: 'DIETARY_THIAMIN',
  HealthDataType.DIETARY_RIBOFLAVIN: 'DIETARY_RIBOFLAVIN',
  HealthDataType.DIETARY_NIACIN: 'DIETARY_NIACIN',
  HealthDataType.DIETARY_PANTOTHENIC_ACID: 'DIETARY_PANTOTHENIC_ACID',
  HealthDataType.DIETARY_VITAMIN_B6: 'DIETARY_VITAMIN_B6',
  HealthDataType.DIETARY_BIOTIN: 'DIETARY_BIOTIN',
  HealthDataType.DIETARY_VITAMIN_B12: 'DIETARY_VITAMIN_B12',
  HealthDataType.DIETARY_VITAMIN_C: 'DIETARY_VITAMIN_C',
  HealthDataType.DIETARY_VITAMIN_D: 'DIETARY_VITAMIN_D',
  HealthDataType.DIETARY_VITAMIN_E: 'DIETARY_VITAMIN_E',
  HealthDataType.DIETARY_VITAMIN_K: 'DIETARY_VITAMIN_K',
  HealthDataType.DIETARY_FOLATE: 'DIETARY_FOLATE',
  HealthDataType.DIETARY_CALCIUM: 'DIETARY_CALCIUM',
  HealthDataType.DIETARY_CHLORIDE: 'DIETARY_CHLORIDE',
  HealthDataType.DIETARY_IRON: 'DIETARY_IRON',
  HealthDataType.DIETARY_MAGNESIUM: 'DIETARY_MAGNESIUM',
  HealthDataType.DIETARY_PHOSPHORUS: 'DIETARY_PHOSPHORUS',
  HealthDataType.DIETARY_POTASSIUM: 'DIETARY_POTASSIUM',
  HealthDataType.DIETARY_SODIUM: 'DIETARY_SODIUM',
  HealthDataType.DIETARY_ZINC: 'DIETARY_ZINC',
  HealthDataType.DIETARY_CHROMIUM: 'DIETARY_CHROMIUM',
  HealthDataType.DIETARY_COPPER: 'DIETARY_COPPER',
  HealthDataType.DIETARY_IODINE: 'DIETARY_IODINE',
  HealthDataType.DIETARY_MANGANESE: 'DIETARY_MANGANESE',
  HealthDataType.DIETARY_MOLYBDENUM: 'DIETARY_MOLYBDENUM',
  HealthDataType.DIETARY_SELENIUM: 'DIETARY_SELENIUM',
  HealthDataType.FORCED_EXPIRATORY_VOLUME: 'FORCED_EXPIRATORY_VOLUME',
  HealthDataType.HEART_RATE: 'HEART_RATE',
  HealthDataType.HEART_RATE_VARIABILITY_SDNN: 'HEART_RATE_VARIABILITY_SDNN',
  HealthDataType.HEART_RATE_VARIABILITY_RMSSD: 'HEART_RATE_VARIABILITY_RMSSD',
  HealthDataType.HEIGHT: 'HEIGHT',
  HealthDataType.INSULIN_DELIVERY: 'INSULIN_DELIVERY',
  HealthDataType.RESTING_HEART_RATE: 'RESTING_HEART_RATE',
  HealthDataType.RESPIRATORY_RATE: 'RESPIRATORY_RATE',
  HealthDataType.PERIPHERAL_PERFUSION_INDEX: 'PERIPHERAL_PERFUSION_INDEX',
  HealthDataType.STEPS: 'STEPS',
  HealthDataType.WAIST_CIRCUMFERENCE: 'WAIST_CIRCUMFERENCE',
  HealthDataType.WALKING_HEART_RATE: 'WALKING_HEART_RATE',
  HealthDataType.WEIGHT: 'WEIGHT',
  HealthDataType.DISTANCE_WALKING_RUNNING: 'DISTANCE_WALKING_RUNNING',
  HealthDataType.DISTANCE_SWIMMING: 'DISTANCE_SWIMMING',
  HealthDataType.DISTANCE_CYCLING: 'DISTANCE_CYCLING',
  HealthDataType.FLIGHTS_CLIMBED: 'FLIGHTS_CLIMBED',
  HealthDataType.DISTANCE_DELTA: 'DISTANCE_DELTA',
  HealthDataType.MINDFULNESS: 'MINDFULNESS',
  HealthDataType.WATER: 'WATER',
  HealthDataType.SLEEP_ASLEEP: 'SLEEP_ASLEEP',
  HealthDataType.SLEEP_AWAKE_IN_BED: 'SLEEP_AWAKE_IN_BED',
  HealthDataType.SLEEP_AWAKE: 'SLEEP_AWAKE',
  HealthDataType.SLEEP_DEEP: 'SLEEP_DEEP',
  HealthDataType.SLEEP_IN_BED: 'SLEEP_IN_BED',
  HealthDataType.SLEEP_LIGHT: 'SLEEP_LIGHT',
  HealthDataType.SLEEP_OUT_OF_BED: 'SLEEP_OUT_OF_BED',
  HealthDataType.SLEEP_REM: 'SLEEP_REM',
  HealthDataType.SLEEP_SESSION: 'SLEEP_SESSION',
  HealthDataType.SLEEP_UNKNOWN: 'SLEEP_UNKNOWN',
  HealthDataType.EXERCISE_TIME: 'EXERCISE_TIME',
  HealthDataType.WORKOUT: 'WORKOUT',
  HealthDataType.HEADACHE_NOT_PRESENT: 'HEADACHE_NOT_PRESENT',
  HealthDataType.HEADACHE_MILD: 'HEADACHE_MILD',
  HealthDataType.HEADACHE_MODERATE: 'HEADACHE_MODERATE',
  HealthDataType.HEADACHE_SEVERE: 'HEADACHE_SEVERE',
  HealthDataType.HEADACHE_UNSPECIFIED: 'HEADACHE_UNSPECIFIED',
  HealthDataType.NUTRITION: 'NUTRITION',
  HealthDataType.GENDER: 'GENDER',
  HealthDataType.BIRTH_DATE: 'BIRTH_DATE',
  HealthDataType.BLOOD_TYPE: 'BLOOD_TYPE',
  HealthDataType.MENSTRUATION_FLOW: 'MENSTRUATION_FLOW',
  HealthDataType.HIGH_HEART_RATE_EVENT: 'HIGH_HEART_RATE_EVENT',
  HealthDataType.LOW_HEART_RATE_EVENT: 'LOW_HEART_RATE_EVENT',
  HealthDataType.IRREGULAR_HEART_RATE_EVENT: 'IRREGULAR_HEART_RATE_EVENT',
  HealthDataType.ELECTRODERMAL_ACTIVITY: 'ELECTRODERMAL_ACTIVITY',
  HealthDataType.ELECTROCARDIOGRAM: 'ELECTROCARDIOGRAM',
  HealthDataType.TOTAL_CALORIES_BURNED: 'TOTAL_CALORIES_BURNED',
};

HealthData _$HealthDataFromJson(Map<String, dynamic> json) => HealthData(
      json['uuid'] as String,
      _healthValueFromJson(json['value']),
      json['unit'] as String,
      json['data_type'] as String,
      DateTime.parse(json['date_from'] as String),
      DateTime.parse(json['date_to'] as String),
      $enumDecode(_$HealthPlatformEnumMap, json['platform']),
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
  val['platform'] = _$HealthPlatformEnumMap[instance.platform]!;
  val['device_id'] = instance.deviceId;
  val['source_id'] = instance.sourceId;
  val['source_name'] = instance.sourceName;
  return val;
}

const _$HealthPlatformEnumMap = {
  HealthPlatform.APPLE_HEALTH: 'APPLE_HEALTH',
  HealthPlatform.GOOGLE_HEALTH_CONNECT: 'GOOGLE_HEALTH_CONNECT',
};

HealthService _$HealthServiceFromJson(Map<String, dynamic> json) =>
    HealthService(
      roleName: json['roleName'] as String? ?? HealthService.DEFAULT_ROLE_NAME,
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
      'defaultSamplingConfiguration',
      instance.defaultSamplingConfiguration
          ?.map((k, e) => MapEntry(k, e.toJson())));
  return val;
}
