/*
 * Copyright 2021 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of carp_backend;

/// A local (in-memory) [DeploymentService] that works with the [CarpStudyProtocolManager]
/// to handle a [MasterDeviceDeployment] based on a [CAMSStudyProtocol], which is
/// store as a custom protocol on the CARP server.
///
/// This deployment service basically reads a [CAMSStudyProtocol] as a custom
/// protocol from the CARP web server, and translate this into a [MasterDeviceDeployment]
/// which can be used on this phone. It also adds a [CarpDataEndPoint] to the
/// device deployment, which makes sure that data is stored back on the CARP server.
///
/// Its main responsibility is to:
///  - retrieve the custom protocol from the CARP server
///  - transform it into a study deployment
///  - add a [CarpDataEndPoint] to the deployment
///
/// The [CarpDataEndPoint] is the following:
///
/// ´´´dart
///    CarpDataEndPoint(
///       uploadMethod: CarpUploadMethod.BATCH_DATA_POINT,
///       name: CarpService().app.name,
///       uri: CarpService().app.uri.toString(),
///       bufferSize: 500 * 1000,
///       deleteWhenUploaded: true,
///    );
/// ````
///
/// Hence, data is uploaded in batches using a local file (500 KB) as a buffer,
/// which is deleted once uploaded.
/// If another data enpoint is needed, this can be changed in the deployment
/// before it is deployed and started on the local phone.
class CustomProtocolDeploymentService implements DeploymentService {
  static final CustomProtocolDeploymentService _instance =
      CustomProtocolDeploymentService._();
  final StreamController<CarpBackendEvents> _eventController =
      StreamController.broadcast();

  CustomProtocolDeploymentService._() {
    manager.initialize();
  }
  factory CustomProtocolDeploymentService() => _instance;

  CarpStudyProtocolManager manager = CarpStudyProtocolManager();
  CAMSStudyProtocol protocol;
  Stream get carpBackendEvents => _eventController.stream;

  void addCarpBackendEvent(CarpBackendEvents event) =>
      _eventController.add(event);

  void checkConfigured() {
    if (!CarpService().isConfigured)
      throw CARPBackendException(
          "CARP Service has not been configured - call 'CarpService().configure()' first.");
    if (!CarpService().authenticated)
      throw CARPBackendException(
          "No user is authenticated - call 'CarpService().authenticate()' first.");

    if (!CarpDeploymentService().isConfigured) {
      CarpDeploymentService().configureFrom(CarpService());
      _eventController.add(CarpBackendEvents.Initialized);
    }
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
    StudyDeploymentStatus status = await CarpDeploymentService()
        .getStudyDeploymentStatus(studyDeploymentId);
    _eventController.add(CarpBackendEvents.DeploymentStatusRetrieved);
    return status;
  }

  @override
  Future<MasterDeviceDeployment> getDeviceDeploymentFor(
      String studyDeploymentId, String masterDeviceRoleName) async {
    checkConfigured();

    // get the protocol from the study protocol manager
    protocol = await manager.getStudyProtocol(studyDeploymentId);
    _eventController.add(CarpBackendEvents.ProtocolRetrieved);

    // configure a data endpoint which can send data back to CARP
    // note that files must not be zipped.
    DataEndPoint dataEndPoint = CarpDataEndPoint(
      uploadMethod: CarpUploadMethod.BATCH_DATA_POINT,
      name: CarpService().app.name,
      uri: CarpService().app.uri.toString(),
      bufferSize: 500 * 1000,
      zip: false,
      deleteWhenUploaded: true,
    );

    CAMSMasterDeviceDeployment deployment =
        CAMSMasterDeviceDeployment.fromCAMSStudyProtocol(
      studyDeploymentId: studyDeploymentId,
      masterDeviceRoleName: masterDeviceRoleName,
      dataEndPoint: dataEndPoint,
      protocol: protocol,
    );
    _eventController.add(CarpBackendEvents.DeploymentRetrieved);

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
