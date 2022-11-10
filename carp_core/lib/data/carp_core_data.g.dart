// GENERATED CODE - DO NOT MODIFY BY HAND

part of carp_core_data;

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DataStreamsConfiguration _$DataStreamsConfigurationFromJson(
        Map<String, dynamic> json) =>
    DataStreamsConfiguration(
      studyDeploymentId: json['studyDeploymentId'] as String,
      expectedDataStreams: (json['expectedDataStreams'] as List<dynamic>)
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
      deviceRoleName: json['deviceRoleName'] as String,
      dataType: json['dataType'] as String,
    );

Map<String, dynamic> _$ExpectedDataStreamToJson(ExpectedDataStream instance) =>
    <String, dynamic>{
      'deviceRoleName': instance.deviceRoleName,
      'dataType': instance.dataType,
    };

DataStreamId _$DataStreamIdFromJson(Map<String, dynamic> json) => DataStreamId(
      studyDeploymentId: json['studyDeploymentId'] as String,
      deviceRoleName: json['deviceRoleName'] as String,
      dataType: json['dataType'] as String,
    );

Map<String, dynamic> _$DataStreamIdToJson(DataStreamId instance) =>
    <String, dynamic>{
      'studyDeploymentId': instance.studyDeploymentId,
      'deviceRoleName': instance.deviceRoleName,
      'dataType': instance.dataType,
    };

DataStreamBatch _$DataStreamBatchFromJson(Map<String, dynamic> json) =>
    DataStreamBatch(
      dataStream:
          DataStreamId.fromJson(json['dataStream'] as Map<String, dynamic>),
      firstSequenceId: json['firstSequenceId'] as int,
      measurements: (json['measurements'] as List<dynamic>)
          .map((e) => Measurement.fromJson(e as Map<String, dynamic>))
          .toList(),
      triggerIds:
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
