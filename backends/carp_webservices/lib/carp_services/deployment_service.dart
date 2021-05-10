/*
 * Copyright 2021 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of carp_services;

/// A [DeploymentService] that talks to the CARP backend server(s).
class CarpDeploymentService extends CarpBaseService
    implements DeploymentService {
  static CarpDeploymentService _instance = CarpDeploymentService._();

  CarpDeploymentService._();

  /// Returns the singleton default instance of the [CarpDeploymentService].
  /// Before this instance can be used, it must be configured using the [configure] method.
  factory CarpDeploymentService() => _instance;

  String get rpcEndpointName => "deployment-service";

  /// Gets a [DeploymentReference] for a [studyDeploymentId].
  /// If the [studyDeploymentId] is not provided, the study deployment id
  /// specified in the [CarpApp] is used.
  DeploymentReference deployment([String studyDeploymentId]) =>
      DeploymentReference._(this, studyDeploymentId);

  /// Create a new deployment in CANS based on a [StudyProtocol].
  /// The [studyDeploymentId] is ignored, since CANS generated its own
  /// study deployment id.
  @override
  Future<StudyDeploymentStatus> createStudyDeployment(
    StudyProtocol protocol, [
    String studyDeploymentId,
  ]) async {
    assert(protocol != null, 'Cannot deploy a null study protocol.');

    return StudyDeploymentStatus
        .fromJson(await _rpc(CreateStudyDeployment(protocol)));
  }

  @override
  Future<Set<String>> removeStudyDeployments(Set<String> studyDeploymentIds) =>
      throw CarpServiceException(
          message:
              'Removing study deployments is not supported from the client side.');

  @override
  Future<StudyDeploymentStatus> getStudyDeploymentStatus(
          String studyDeploymentId) async =>
      StudyDeploymentStatus
          .fromJson(await _rpc(GetStudyDeploymentStatus(studyDeploymentId)));

  @override
  Future<List<StudyDeploymentStatus>> getStudyDeploymentStatusList(
      List<String> studyDeploymentIds) async {
    assert(studyDeploymentIds != null,
        'List of studyDeploymentIds cannot be null.');

    Map<String, dynamic> responseJson =
        await _rpc(GetStudyDeploymentStatusList(studyDeploymentIds));

    // we expect a list of 'items'
    List<dynamic> items = json.decode(responseJson['items']);
    List<StudyDeploymentStatus> statuss = [];
    items.forEach((item) => statuss.add(StudyDeploymentStatus.fromJson(item)));

    return statuss;
  }

  @override
  Future<StudyDeploymentStatus> registerDevice(
    String studyDeploymentId,
    String deviceRoleName,
    DeviceRegistration registration,
  ) async =>
      StudyDeploymentStatus.fromJson(await _rpc(RegisterDevice(
        studyDeploymentId,
        deviceRoleName,
        registration,
      )));

  @override
  Future<StudyDeploymentStatus> unregisterDevice(
          String studyDeploymentId, String deviceRoleName) async =>
      StudyDeploymentStatus.fromJson(
          await _rpc(UnregisterDevice(studyDeploymentId, deviceRoleName)));

  @override
  Future<MasterDeviceDeployment> getDeviceDeploymentFor(
          String studyDeploymentId, String masterDeviceRoleName) async =>
      MasterDeviceDeployment.fromJson(await _rpc(
          GetDeviceDeploymentFor(studyDeploymentId, masterDeviceRoleName)));

  @override
  Future<StudyDeploymentStatus> deploymentSuccessfulFor(
    String studyDeploymentId,
    String masterDeviceRoleName,
    DateTime deviceDeploymentLastUpdateDate,
  ) async =>
      StudyDeploymentStatus.fromJson(await _rpc(DeploymentSuccessful(
        studyDeploymentId,
        masterDeviceRoleName,
        deviceDeploymentLastUpdateDate,
      )));

  @override
  Future<StudyDeploymentStatus> stop(String studyDeploymentId) =>
      throw CarpServiceException(
          message:
              'Stopping study deployments is not supported from the client side.');
}
