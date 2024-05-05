/*
 * Copyright 2022 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of '../carp_core_data.dart';

abstract class DataStreamServiceRequest extends ServiceRequest {
  final String _infrastructurePackageNamespace =
      'dk.cachet.carp.data.infrastructure';

  @override
  String get apiVersion => DataStreamService.API_VERSION;

  DataStreamServiceRequest() : super();

  @override
  String get jsonType =>
      '$_infrastructurePackageNamespace.DataStreamServiceRequest.$runtimeType';
}

@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class OpenDataStreams extends DataStreamServiceRequest {
  DataStreamsConfiguration configuration;
  OpenDataStreams(this.configuration) : super();

  @override
  Function get fromJsonFunction => _$OpenDataStreamsFromJson;
  factory OpenDataStreams.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson(json) as OpenDataStreams;
  @override
  Map<String, dynamic> toJson() => _$OpenDataStreamsToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class AppendToDataStreams extends DataStreamServiceRequest {
  String studyDeploymentId;
  List<DataStreamBatch> batch = [];

  AppendToDataStreams(this.studyDeploymentId, this.batch) : super();

  @override
  Function get fromJsonFunction => _$AppendToDataStreamsFromJson;
  factory AppendToDataStreams.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson(json) as AppendToDataStreams;
  @override
  Map<String, dynamic> toJson() => _$AppendToDataStreamsToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class GetDataStream extends DataStreamServiceRequest {
  DataStreamId dataStream;
  int fromSequenceId;
  int? toSequenceIdInclusive;

  GetDataStream(
    this.dataStream,
    this.fromSequenceId, [
    this.toSequenceIdInclusive,
  ]) : super();

  @override
  Function get fromJsonFunction => _$GetDataStreamFromJson;
  factory GetDataStream.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson(json) as GetDataStream;
  @override
  Map<String, dynamic> toJson() => _$GetDataStreamToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class CloseDataStreams extends DataStreamServiceRequest {
  List<String> studyDeploymentIds;
  CloseDataStreams(this.studyDeploymentIds) : super();

  @override
  Function get fromJsonFunction => _$CloseDataStreamsFromJson;
  factory CloseDataStreams.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson(json) as CloseDataStreams;
  @override
  Map<String, dynamic> toJson() => _$CloseDataStreamsToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class RemoveDataStreams extends DataStreamServiceRequest {
  List<String> studyDeploymentIds;
  RemoveDataStreams(this.studyDeploymentIds) : super();

  @override
  Function get fromJsonFunction => _$RemoveDataStreamsFromJson;
  factory RemoveDataStreams.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson(json) as RemoveDataStreams;
  @override
  Map<String, dynamic> toJson() => _$RemoveDataStreamsToJson(this);
}
