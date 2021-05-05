/*
 * Copyright 2021 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of carp_backend;

/// A local (in-memory) [DeploymentService] that works with the [CARPStudyProtocolManager]
/// to handle a [MasterDeviceDeployment] based on a [CAMSStudyProtocol].
///
/// This deployment service basically reads a [CAMSStudyProtocol] as a custom
/// protocol from the CARP web server, and translate this into a [MasterDeviceDeployment]
/// which can be used on this phone. It also add a [CarpDataEndPoint] to the
/// device deployment, which makes sure that data is stored back on the CARP server.
///
/// Its main responsibility is to:
///  - retrieve the custom protocol from the CARP server
///  - transform it into a study deployment
///  - add a [CarpDataEndPoint] to the deployment
///
class CARPDeploymentService implements DeploymentService {
  CARPStudyProtocolManager manager = CARPStudyProtocolManager();
  CAMSStudyProtocol protocol;

  CARPDeploymentService();

  void checkConfigured() {
    if (!CarpService().isConfigured)
      throw CARPBackendException(
          "CARP Service has not been configured - call 'CarpService().configure()' first.");
    if (!CarpService().authenticated)
      throw CARPBackendException(
          "No user is authenticated - call 'CarpService().authenticate()' first.");

    if (!CANSDeploymentService().isConfigured)
      CANSDeploymentService().configureFrom(CarpService());
  }

  @override
  Future<StudyDeploymentStatus> createStudyDeployment(StudyProtocol protocol,
      [String studyDeploymentId]) {
    throw CARPBackendException(
        'Study protocols cannot be created in a CARPDeploymentService');
  }

  @override
  Future<StudyDeploymentStatus> getStudyDeploymentStatus(
      String studyDeploymentId) async {
    checkConfigured();
    return await CANSDeploymentService()
        .getStudyDeploymentStatus(studyDeploymentId);
  }

  @override
  Future<MasterDeviceDeployment> getDeviceDeploymentFor(
      String studyDeploymentId, String masterDeviceRoleName) async {
    checkConfigured();

    // get the protocol from the study protocol manager
    protocol = await manager.getStudyProtocol(studyDeploymentId);

    // configure a data endpoint which can send data back to CARP
    // note that files must not be zipped.
    DataEndPoint dataEndPoint = CarpDataEndPoint(
      uploadMethod: CarpUploadMethod.BATCH_DATA_POINT,
      name: CarpService().app.name,
      uri: CarpService().app.uri.toString(),
      bufferSize: 500 * 1000,
      deleteWhenUploaded: true,
    );

    CAMSMasterDeviceDeployment deployment =
        CAMSMasterDeviceDeployment.fromCAMSStudyProtocol(
      studyDeploymentId: studyDeploymentId,
      masterDeviceRoleName: masterDeviceRoleName,
      dataEndPoint: dataEndPoint,
      protocol: protocol,
    );

    return deployment;
  }

  @override
  Future<List<StudyDeploymentStatus>> getStudyDeploymentStatusList(
      List<String> studyDeploymentIds) {
    throw CARPBackendException(
        'getStudyDeploymentStatusList() is not supported.');
  }

  @override
  Future<StudyDeploymentStatus> registerDevice(String studyDeploymentId,
      String deviceRoleName, DeviceRegistration registration) {
    throw CARPBackendException(
        'registerDevice() is not supported. This happens automatically.');
  }

  @override
  Future<Set<String>> removeStudyDeployments(Set<String> studyDeploymentIds) {
    throw CARPBackendException('removeStudyDeployments() is not supported.');
  }

  @override
  Future<StudyDeploymentStatus> deploymentSuccessfulFor(
      String studyDeploymentId,
      String masterDeviceRoleName,
      DateTime deviceDeploymentLastUpdateDate) {
    throw CARPBackendException(
        'deploymentSuccessfulFor() is not supported. This happens automatically.');
  }

  @override
  Future<StudyDeploymentStatus> stop(String studyDeploymentId) {
    throw CARPBackendException('stop() is not supported.');
  }

  @override
  Future<StudyDeploymentStatus> unregisterDevice(
      String studyDeploymentId, String deviceRoleName) {
    throw CARPBackendException('unregisterDevice() is not supported.');
  }
}
