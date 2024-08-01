/*
 * Copyright 2022 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of 'carp_services.dart';

/// A [DataStreamService] that talks to the CARP Web Services.
class CarpDataStreamService extends CarpBaseService
    implements DataStreamService {
  static const String DATA_STREAM_ENDPOINT_NAME = "data-stream-service";
  static const String DATA_STREAM_ZIP_ENDPOINT_NAME = "data-stream-service-zip";

  static final CarpDataStreamService _instance = CarpDataStreamService._();

  CarpDataStreamService._();

  /// Returns the singleton default instance of the [CarpDataStreamService].
  /// Before this instance can be used, it must be configured using the
  /// [configure] method.
  factory CarpDataStreamService() => _instance;

  @override
  String get rpcEndpointName => DATA_STREAM_ENDPOINT_NAME;

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
    List<DataStreamBatch> batch, [
    bool zip = true,
  ]) async {
    final payload = AppendToDataStreams(studyDeploymentId, batch);

    if (!zip) {
      await _rpc(payload);
    } else {
      // if uploading zipped, create a multiparty request with
      // the zipped file and POST it as a byte file

      _endpointName = DATA_STREAM_ZIP_ENDPOINT_NAME;
      var request = http.MultipartRequest("POST", Uri.parse(rpcEndpointUri));
      request.headers['Authorization'] = headers['Authorization']!;
      request.headers['Content-Type'] = 'multipart/form-data';
      request.headers['cache-control'] = 'no-cache';

      var body = zipJson(payload.toJson());
      var file = http.MultipartFile.fromBytes('file', body);
      request.files.add(file);

      await _send(request);
    }
  }

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
    List<dynamic> items = responseJson['items'] as List<dynamic>;

    return (items.isEmpty)
        ? []
        : items
            .map((item) =>
                DataStreamBatch.fromJson(item as Map<String, dynamic>))
            .toList();
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
