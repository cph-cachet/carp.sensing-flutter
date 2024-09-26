/*
 * Copyright 2021 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of 'carp_services.dart';

/// Provide a participation endpoint reference to a CARP web service.
///
/// According to CARP core, the protocol for using the
/// [deployment sub-system](https://github.com/cph-cachet/carp.core-kotlin/blob/develop/docs/carp-deployment.md) is:
///
///   - [getParticipantData()] - get participation data from this deployment.
///   - [setParticipantData()] - set participation data in this deployment
class ParticipationReference extends RPCCarpReference {
  final String? _studyDeploymentId;

  /// The CARP study deployment ID.
  String? get studyDeploymentId =>
      _studyDeploymentId ?? service.app.studyDeploymentId;

  ParticipationReference._(
    CarpParticipationService service,
    this._studyDeploymentId,
  ) : super._(service);

  /// The URL for the participation endpoint.
  ///
  /// {{PROTOCOL}}://{{SERVER_HOST}}:{{SERVER_PORT}}/api/participation-service
  @override
  String get rpcEndpointUri =>
      "${service.app.uri.toString()}/api/participation-service";

  /// Get currently set data for all expected participant data in this study
  /// deployment with [studyDeploymentId].
  /// Data which is not set equals null.
  Future<ParticipantData> getParticipantData() async =>
      ParticipantData.fromJson(
          await _rpc(GetParticipantData(studyDeploymentId!)));

  /// Set participant [data] for the given [inputByParticipantRole] in this
  /// study deployment.
  /// If [inputByParticipantRole] is null, all roles can set it.
  ///
  /// Returns all data for the specified study deployment, including the newly set data.
  Future<ParticipantData> setParticipantData(
    Map<String, Data> data, [
    String? inputByParticipantRole,
  ]) async =>
      ParticipantData.fromJson(await _rpc(SetParticipantData(
          studyDeploymentId!, data, inputByParticipantRole)));

  /// Get informed consent data for all participants (by role name) in this study
  /// deployment with [studyDeploymentId].
  /// Informed consent which is not set equals null.
  Future<Map<String, InformedConsentInput?>> getInformedConsent() async {
    Map<String, InformedConsentInput?> map = {};

    ParticipantData data = ParticipantData.fromJson(
        await _rpc(GetParticipantData(studyDeploymentId!)));

    for (var roleData in data.roles) {
      if (roleData.data.containsKey(InformedConsentInput.type)) {
        map[roleData.roleName] = roleData.data[InformedConsentInput.type] !=
                null
            ? roleData.data[InformedConsentInput.type] as InformedConsentInput
            : null;
      } else {
        map[roleData.roleName] = null;
      }
    }

    return map;
  }

  /// Get the informed consent uploaded by a participant with [roleName] in
  /// this study deployment with [studyDeploymentId].
  /// Returns null if not available.
  Future<InformedConsentInput?> getInformedConsentByRole(
          String roleName) async =>
      (await getInformedConsent())[roleName];

  /// Set informed [consent] for the given [inputByParticipantRole] in this
  /// study deployment.
  Future<void> setInformedConsent(
    InformedConsentInput consent,
    String inputByParticipantRole,
  ) async {
    ParticipantData.fromJson(await _rpc(SetParticipantData(
      studyDeploymentId!,
      {InformedConsentInput.type: consent},
      inputByParticipantRole,
    )));
  }

  /// Remove the informed for the given [inputByParticipantRole] in this
  /// study deployment.
  Future<void> removeInformedConsent(String inputByParticipantRole) async {
    ParticipantData.fromJson(await _rpc(SetParticipantData(
      studyDeploymentId!,
      {InformedConsentInput.type: null},
      inputByParticipantRole,
    )));
  }
}
