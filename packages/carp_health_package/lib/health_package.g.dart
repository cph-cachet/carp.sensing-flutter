// GENERATED CODE - DO NOT MODIFY BY HAND

part of health_package;

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HealthMeasure _$HealthMeasureFromJson(Map<String, dynamic> json) =>
    HealthMeasure(
      type: json['type'] as String,
      name: json['name'] as String?,
      description: json['description'] as String?,
      enabled: json['enabled'] as bool? ?? true,
      history: json['history'] == null
          ? null
          : Duration(microseconds: json['history'] as int),
      healthDataType:
          $enumDecode(_$HealthDataTypeEnumMap, json['healthDataType']),
    )
      ..$type = json[r'$type'] as String?
      ..configuration = Map<String, String>.from(json['configuration'] as Map);

Map<String, dynamic> _$HealthMeasureToJson(HealthMeasure instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull(r'$type', instance.$type);
  val['type'] = instance.type;
  writeNotNull('name', instance.name);
  writeNotNull('description', instance.description);
  val['enabled'] = instance.enabled;
  val['configuration'] = instance.configuration;
  val['history'] = instance.history.inMicroseconds;
  val['healthDataType'] = _$HealthDataTypeEnumMap[instance.healthDataType];
  return val;
}

const _$HealthDataTypeEnumMap = {
  HealthDataType.ACTIVE_ENERGY_BURNED: 'ACTIVE_ENERGY_BURNED',
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
};

HealthDatum _$HealthDatumFromJson(Map<String, dynamic> json) => HealthDatum(
      json['value'] as num,
      json['unit'] as String,
      json['data_type'] as String,
      DateTime.parse(json['date_from'] as String),
      DateTime.parse(json['date_to'] as String),
      json['platform'] as String,
      json['device_id'] as String,
      json['uuid'] as String,
    )
      ..id = json['id'] as String?
      ..timestamp = DateTime.parse(json['timestamp'] as String);

Map<String, dynamic> _$HealthDatumToJson(HealthDatum instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  val['timestamp'] = instance.timestamp.toIso8601String();
  val['value'] = instance.value;
  val['unit'] = instance.unit;
  val['date_from'] = instance.dateFrom.toIso8601String();
  val['date_to'] = instance.dateTo.toIso8601String();
  val['data_type'] = instance.dataType;
  val['platform'] = instance.platform;
  val['device_id'] = instance.deviceId;
  val['uuid'] = instance.uuid;
  return val;
}
