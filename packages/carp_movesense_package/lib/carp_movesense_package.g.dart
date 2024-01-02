// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'carp_movesense_package.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MovesenseHRSample _$MovesenseHRSampleFromJson(Map<String, dynamic> json) =>
    MovesenseHRSample(
      (json['hr'] as num).toDouble(),
    );

Map<String, dynamic> _$MovesenseHRSampleToJson(MovesenseHRSample instance) =>
    <String, dynamic>{
      'hr': instance.hr,
    };

MovesenseHR _$MovesenseHRFromJson(Map<String, dynamic> json) => MovesenseHR(
      samples: (json['samples'] as List<dynamic>)
          .map((e) => MovesenseHRSample.fromJson(e as Map<String, dynamic>))
          .toList(),
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
  val['samples'] = instance.samples;
  return val;
}

MovesenseDevice _$MovesenseDeviceFromJson(Map<String, dynamic> json) =>
    MovesenseDevice(
      roleName: json['roleName'] as String? ?? MovesenseDevice.DEFAULT_ROLENAME,
      name: json['name'] as String?,
      identifier: json['identifier'] as String?,
    )
      ..$type = json['__type'] as String?
      ..isOptional = json['isOptional'] as bool?
      ..defaultSamplingConfiguration =
          (json['defaultSamplingConfiguration'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(
            k, SamplingConfiguration.fromJson(e as Map<String, dynamic>)),
      )
      ..address = json['address'] as String?
      ..serial = json['serial'] as String?;

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
  writeNotNull('identifier', instance.identifier);
  return val;
}
