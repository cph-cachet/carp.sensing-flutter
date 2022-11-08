// GENERATED CODE - DO NOT MODIFY BY HAND

part of carp_core_data;

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DataStreamsConfiguration _$DataStreamsConfigurationFromJson(
        Map<String, dynamic> json) =>
    DataStreamsConfiguration(
      json['studyDeploymentId'] as String,
      (json['expectedDataStreams'] as List<dynamic>)
          .map((e) => ExpectedDataStream.fromJson(e as Map<String, dynamic>))
          .toSet(),
    );

Map<String, dynamic> _$DataStreamsConfigurationToJson(
        DataStreamsConfiguration instance) =>
    <String, dynamic>{
      'studyDeploymentId': instance.studyDeploymentId,
      'expectedDataStreams': instance.expectedDataStreams.toList(),
    };

ExpectedDataStream _$ExpectedDataStreamFromJson(Map<String, dynamic> json) =>
    ExpectedDataStream(
      json['deviceRoleName'] as String,
      json['dataType'] as String,
    );

Map<String, dynamic> _$ExpectedDataStreamToJson(ExpectedDataStream instance) =>
    <String, dynamic>{
      'deviceRoleName': instance.deviceRoleName,
      'dataType': instance.dataType,
    };

DataStreamId _$DataStreamIdFromJson(Map<String, dynamic> json) => DataStreamId(
      json['studyDeploymentId'] as String,
      json['deviceRoleName'] as String,
      json['dataType'] as String,
    );

Map<String, dynamic> _$DataStreamIdToJson(DataStreamId instance) =>
    <String, dynamic>{
      'studyDeploymentId': instance.studyDeploymentId,
      'deviceRoleName': instance.deviceRoleName,
      'dataType': instance.dataType,
    };

DataStreamBatch _$DataStreamBatchFromJson(Map<String, dynamic> json) =>
    DataStreamBatch(
      DataStreamId.fromJson(json['dataStream'] as Map<String, dynamic>),
      json['firstSequenceId'] as int,
      (json['measurements'] as List<dynamic>)
          .map((e) => Measurement.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['triggerIds'] as List<dynamic>).map((e) => e as int).toList(),
    );

Map<String, dynamic> _$DataStreamBatchToJson(DataStreamBatch instance) =>
    <String, dynamic>{
      'dataStream': instance.dataStream,
      'firstSequenceId': instance.firstSequenceId,
      'measurements': instance.measurements,
      'triggerIds': instance.triggerIds,
    };

Measurement _$MeasurementFromJson(Map<String, dynamic> json) => Measurement(
      sensorStartTime: json['sensorStartTime'] as int,
      sensorEndTime: json['sensorEndTime'] as int?,
      data: Data.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MeasurementToJson(Measurement instance) {
  final val = <String, dynamic>{
    'sensorStartTime': instance.sensorStartTime,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('sensorEndTime', instance.sensorEndTime);
  val['data'] = instance.data;
  return val;
}

Data _$DataFromJson(Map<String, dynamic> json) =>
    Data()..$type = json['__type'] as String?;

Map<String, dynamic> _$DataToJson(Data instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('__type', instance.$type);
  return val;
}

Geolocation _$GeolocationFromJson(Map<String, dynamic> json) => Geolocation(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    )
      ..$type = json['__type'] as String?
      ..sensorSpecificData = json['sensor_specific_data'] == null
          ? null
          : Data.fromJson(json['sensor_specific_data'] as Map<String, dynamic>);

Map<String, dynamic> _$GeolocationToJson(Geolocation instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('__type', instance.$type);
  writeNotNull('sensor_specific_data', instance.sensorSpecificData);
  val['latitude'] = instance.latitude;
  val['longitude'] = instance.longitude;
  return val;
}

SignalStrength _$SignalStrengthFromJson(Map<String, dynamic> json) =>
    SignalStrength(
      rssi: json['rssi'] as int,
    )
      ..$type = json['__type'] as String?
      ..sensorSpecificData = json['sensor_specific_data'] == null
          ? null
          : Data.fromJson(json['sensor_specific_data'] as Map<String, dynamic>);

Map<String, dynamic> _$SignalStrengthToJson(SignalStrength instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('__type', instance.$type);
  writeNotNull('sensor_specific_data', instance.sensorSpecificData);
  val['rssi'] = instance.rssi;
  return val;
}
