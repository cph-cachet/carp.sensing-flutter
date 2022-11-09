/*
 * Copyright 2022 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of carp_core_data;

/// Configures [expectedDataStreams] for a study deployment.
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class DataStreamsConfiguration {
  String studyDeploymentId;
  Set<ExpectedDataStream> expectedDataStreams;

  DataStreamsConfiguration({
    required this.studyDeploymentId,
    required this.expectedDataStreams,
  });
  factory DataStreamsConfiguration.fromJson(Map<String, dynamic> json) =>
      _$DataStreamsConfigurationFromJson(json);
  Map<String, dynamic> toJson() => _$DataStreamsConfigurationToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class ExpectedDataStream {
  String deviceRoleName;
  String dataType;

  ExpectedDataStream({
    required this.deviceRoleName,
    required this.dataType,
  });
  factory ExpectedDataStream.fromJson(Map<String, dynamic> json) =>
      _$ExpectedDataStreamFromJson(json);
  Map<String, dynamic> toJson() => _$ExpectedDataStreamToJson(this);
}

/// Identifies a data stream of collected [dataType] data on the device with
/// [deviceRoleName] in a deployed study protocol with [studyDeploymentId].
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class DataStreamId {
  String studyDeploymentId;
  String deviceRoleName;
  String dataType;

  DataStreamId({
    required this.studyDeploymentId,
    required this.deviceRoleName,
    required this.dataType,
  });
  factory DataStreamId.fromJson(Map<String, dynamic> json) =>
      _$DataStreamIdFromJson(json);
  Map<String, dynamic> toJson() => _$DataStreamIdToJson(this);
}

/// A collection of non-overlapping, ordered, data stream [sequences].
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class DataStreamBatch {
  DataStreamId dataStream;
  int firstSequenceId;
  List<Measurement> measurements;
  List<int> triggerIds;

  DataStreamBatch({
    required this.dataStream,
    required this.firstSequenceId,
    required this.measurements,
    required this.triggerIds,
  });
  factory DataStreamBatch.fromJson(Map<String, dynamic> json) =>
      _$DataStreamBatchFromJson(json);
  Map<String, dynamic> toJson() => _$DataStreamBatchToJson(this);
}

/// The result of a measurement of [data] of a given [dataType] at a specific
/// point or interval in time.
/// When [sensorEndTime] is set, the [data] pertains to an interval in time;
/// otherwise, a point in time.
///
/// The unit of [sensorStartTime] and [sensorEndTime] is fully determined by the
/// sensor that collected the data.
/// For example, it could be a simple clock increment since the device powered up.
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class Measurement {
  int sensorStartTime;
  int? sensorEndTime;

  @JsonKey(ignore: true)
  DataType? dataType;

  Data data;

  Measurement({
    required this.sensorStartTime,
    this.sensorEndTime,
    this.dataType,
    required this.data,
  });
  factory Measurement.fromJson(Map<String, dynamic> json) =>
      _$MeasurementFromJson(json);
  Map<String, dynamic> toJson() => _$MeasurementToJson(this);
}
