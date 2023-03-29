/*
 * Copyright 2021 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of carp_services;

/// A [DeploymentService] that talks to the CARP Web Services.
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
  DeploymentReference deployment([String? studyDeploymentId]) =>
      DeploymentReference._(this, studyDeploymentId ?? app!.studyDeploymentId!);

  @override
  Future<StudyDeploymentStatus> createStudyDeployment(
    StudyProtocol protocol, [
    List<ParticipantInvitation> invitations = const [],
    String? id,
    Map<String, DeviceRegistration>? connectedDevicePreregistrations,
  ]) async =>
      StudyDeploymentStatus.fromJson(await _rpc(CreateStudyDeployment(
        protocol,
        invitations,
        connectedDevicePreregistrations,
      )));

  @override
  Future<Set<String>> removeStudyDeployments(Set<String> studyDeploymentIds) =>
      throw CarpServiceException(
          message:
              'Removing study deployments is not supported from the client side.');

  @override
  Future<StudyDeploymentStatus> getStudyDeploymentStatus(
          String studyDeploymentId) async =>
      StudyDeploymentStatus.fromJson(
          await _rpc(GetStudyDeploymentStatus(studyDeploymentId)));

  @override
  Future<List<StudyDeploymentStatus>> getStudyDeploymentStatusList(
      List<String> studyDeploymentIds) async {
    assert(studyDeploymentIds.length > 0,
        'List of studyDeploymentIds cannot be empty.');

    Map<String, dynamic> responseJson =
        await _rpc(GetStudyDeploymentStatusList(studyDeploymentIds));

    // we expect a list of 'items'
    List<dynamic> items = json.decode(responseJson['items']);
    List<StudyDeploymentStatus> statusList = [];
    items.forEach(
        (item) => statusList.add(StudyDeploymentStatus.fromJson(item)));

    return statusList;
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
  Future<SmartphoneDeployment> getDeviceDeploymentFor(
    String studyDeploymentId,
    String primaryDeviceRoleName,
  ) async {
    // downloading a PrimaryDeviceDeployment
    var deployment = PrimaryDeviceDeployment.fromJson(await _rpc(
        GetDeviceDeploymentFor(studyDeploymentId, primaryDeviceRoleName)));

    // converting it to a SmartphoneDeployment
    return SmartphoneDeployment.fromPrimaryDeviceDeployment(
      studyId: CarpService().app?.studyId,
      studyDeploymentId: studyDeploymentId,
      deployment: deployment,
    );
  }

  @override
  Future<StudyDeploymentStatus> deviceDeployed(
    String studyDeploymentId,
    String masterDeviceRoleName,
    DateTime deviceDeploymentLastUpdatedOn,
  ) async =>
      StudyDeploymentStatus.fromJson(await _rpc(DeviceDeployed(
        studyDeploymentId,
        masterDeviceRoleName,
        deviceDeploymentLastUpdatedOn,
      )));

  @override
  Future<StudyDeploymentStatus> stop(String studyDeploymentId) async =>
      StudyDeploymentStatus.fromJson(await _rpc(Stop(studyDeploymentId)));
}
