// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'carp_core_data.dart';

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
          (json['triggerIds'] as List<dynamic>).map((e) => e as int).toSet(),
    );

Map<String, dynamic> _$DataStreamBatchToJson(DataStreamBatch instance) =>
    <String, dynamic>{
      'dataStream': instance.dataStream,
      'firstSequenceId': instance.firstSequenceId,
      'measurements': instance.measurements,
      'triggerIds': instance.triggerIds.toList(),
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

OpenDataStreams _$OpenDataStreamsFromJson(Map<String, dynamic> json) =>
    OpenDataStreams(
      DataStreamsConfiguration.fromJson(
          json['configuration'] as Map<String, dynamic>),
    )
      ..$type = json['__type'] as String?
      ..apiVersion = json['apiVersion'] as String;

Map<String, dynamic> _$OpenDataStreamsToJson(OpenDataStreams instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('__type', instance.$type);
  val['apiVersion'] = instance.apiVersion;
  val['configuration'] = instance.configuration;
  return val;
}

AppendToDataStreams _$AppendToDataStreamsFromJson(Map<String, dynamic> json) =>
    AppendToDataStreams(
      json['studyDeploymentId'] as String,
      (json['batch'] as List<dynamic>)
          .map((e) => DataStreamBatch.fromJson(e as Map<String, dynamic>))
          .toList(),
    )
      ..$type = json['__type'] as String?
      ..apiVersion = json['apiVersion'] as String;

Map<String, dynamic> _$AppendToDataStreamsToJson(AppendToDataStreams instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('__type', instance.$type);
  val['apiVersion'] = instance.apiVersion;
  val['studyDeploymentId'] = instance.studyDeploymentId;
  val['batch'] = instance.batch;
  return val;
}

GetDataStream _$GetDataStreamFromJson(Map<String, dynamic> json) =>
    GetDataStream(
      DataStreamId.fromJson(json['dataStream'] as Map<String, dynamic>),
      json['fromSequenceId'] as int,
      json['toSequenceIdInclusive'] as int?,
    )
      ..$type = json['__type'] as String?
      ..apiVersion = json['apiVersion'] as String;

Map<String, dynamic> _$GetDataStreamToJson(GetDataStream instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('__type', instance.$type);
  val['apiVersion'] = instance.apiVersion;
  val['dataStream'] = instance.dataStream;
  val['fromSequenceId'] = instance.fromSequenceId;
  writeNotNull('toSequenceIdInclusive', instance.toSequenceIdInclusive);
  return val;
}

CloseDataStreams _$CloseDataStreamsFromJson(Map<String, dynamic> json) =>
    CloseDataStreams(
      (json['studyDeploymentIds'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    )
      ..$type = json['__type'] as String?
      ..apiVersion = json['apiVersion'] as String;

Map<String, dynamic> _$CloseDataStreamsToJson(CloseDataStreams instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('__type', instance.$type);
  val['apiVersion'] = instance.apiVersion;
  val['studyDeploymentIds'] = instance.studyDeploymentIds;
  return val;
}

RemoveDataStreams _$RemoveDataStreamsFromJson(Map<String, dynamic> json) =>
    RemoveDataStreams(
      (json['studyDeploymentIds'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    )
      ..$type = json['__type'] as String?
      ..apiVersion = json['apiVersion'] as String;

Map<String, dynamic> _$RemoveDataStreamsToJson(RemoveDataStreams instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('__type', instance.$type);
  val['apiVersion'] = instance.apiVersion;
  val['studyDeploymentIds'] = instance.studyDeploymentIds;
  return val;
}
