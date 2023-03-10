/*
 * Copyright 2021 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */
part of carp_services;

/// Provide a participation endpoint reference to a CARP web service.
///
/// According to CARP core, the protocol for using the
/// [deployment sub-system](https://github.com/cph-cachet/carp.core-kotlin/blob/develop/docs/carp-deployment.md) is:
///
///   - [getParticipantData()] - get participation data from this deployment.
///   - [setParticipantData()] - set participation data in this deployment
class ParticipationReference extends RPCCarpReference {
  String? _studyDeploymentId;

  /// The CARP study deployment ID.
  String? get studyDeploymentId =>
      _studyDeploymentId ?? service.app!.studyDeploymentId;

  ParticipationReference._(
      CarpParticipationService service, this._studyDeploymentId)
      : super._(service);

  /// The URL for the participation endpoint.
  ///
  /// {{PROTOCOL}}://{{SERVER_HOST}}:{{SERVER_PORT}}/api/participation-service
  @override
  String get rpcEndpointUri =>
      "${service.app!.uri.toString()}/api/participation-service";

  /// Get currently set data for all expected participant data in this study
  /// deployment with [studyDeploymentId].
  /// Data which is not set equals null.
  Future<ParticipantData> getParticipantData() async {
    ParticipantData data = ParticipantData.fromJson(
        await _rpc(GetParticipantData(studyDeploymentId!)));
    return data;
  }

  /// Set participant [data] for the given [inputDataType] in thsis study deployment.
  /// Returns all data for the specified study deployment, including the newly set data.
  Future<ParticipantData> setParticipantData(
      String inputDataType, ParticipantData data) async {
    ParticipantData newData = ParticipantData.fromJson(await _rpc(
        SetParticipantData(studyDeploymentId!, inputDataType, data)));
    return newData;
  }
}
