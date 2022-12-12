/*
 * Copyright 2022 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of carp_services;

/// A [DataStreamService] that talks to the CARP Web Services.
class CarpDataStreamService extends CarpBaseService
    implements DataStreamService {
  static final CarpDataStreamService _instance = CarpDataStreamService._();

  CarpDataStreamService._();

  /// Returns the singleton default instance of the [CarpDataStreamService].
  /// Before this instance can be used, it must be configured using the
  /// [configure] method.
  factory CarpDataStreamService() => _instance;

  String get rpcEndpointName => "data-stream-service";

  /// Gets a [DataStreamReference] for a [studyDeploymentId].
  /// If the [studyDeploymentId] is not provided, the study deployment id
  /// specified in the [CarpApp] is used.
  DataStreamReference stream([String? studyDeploymentId]) =>
      DataStreamReference._(this, studyDeploymentId ?? app!.studyDeploymentId!);

  @override
  Future<void> openDataStreams(DataStreamsConfiguration configuration) async =>
      throw CarpServiceException(
          message:
              'Opening data streams is not supported from the client side.');

  @override
  Future<void> appendToDataStreams(
    String studyDeploymentId,
    List<DataStreamBatch> batch,
  ) async =>
      await _rpc(AppendToDataStreams(studyDeploymentId, batch));

  @override
  Future<List<DataStreamBatch>> getDataStream(
    DataStreamId dataStream,
    int fromSequenceId, [
    int? toSequenceIdInclusive,
  ]) async {
    Map<String, dynamic> responseJson = await _rpc(GetDataStream(
      dataStream,
      fromSequenceId,
      toSequenceIdInclusive,
    ));

    // we expect a list of 'items'
    List<dynamic> items = json.decode(responseJson['items']);
    List<DataStreamBatch> batchList = [];
    items.forEach((item) => batchList.add(DataStreamBatch.fromJson(item)));

    return batchList;
  }

  @override
  Future<void> closeDataStreams(List<String> studyDeploymentIds) async =>
      throw CarpServiceException(
          message:
              'Closing data streams is not supported from the client side.');

  @override
  Future<Set<String>> removeDataStreams(
          List<String> studyDeploymentIds) async =>
      throw CarpServiceException(
          message:
              'Removing data streams is not supported from the client side.');
}
