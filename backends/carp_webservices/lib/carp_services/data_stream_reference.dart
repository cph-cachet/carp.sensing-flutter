/*
 * Copyright 2022 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */
part of carp_services;

/// Provides a reference to the data stream endpoint in a CARP web service.
///
/// Used to:
/// - append data to the stream.
/// - get data from the stream.
class DataStreamReference extends RPCCarpReference {
  /// The CARP study deployment ID.
  String studyDeploymentId;

  DataStreamReference._(CarpDataStreamService service, this.studyDeploymentId)
      : super._(service);

  /// The URL for the data stream service endpoint.
  ///
  /// {{PROTOCOL}}://{{SERVER_HOST}}:{{SERVER_PORT}}/api/data-stream-service
  @override
  String get rpcEndpointUri =>
      "${service.app!.uri.toString()}/api/data-stream-service";

  /// Append a [batch] of data measures to this data stream.
  Future<void> append(
    List<DataStreamBatch> batch,
  ) async =>
      await _rpc(AppendToDataStreams(studyDeploymentId, batch));
}
