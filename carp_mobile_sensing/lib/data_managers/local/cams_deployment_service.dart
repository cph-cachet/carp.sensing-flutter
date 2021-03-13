/*
 * Copyright 2021 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of managers;

/// A local (in-memory) implementation of a [DeploymentService] useful in
/// CAMS studies to be deployed locally on this phone.
class CAMSDeploymentService implements DeploymentService {
  /// The default rolename for this master phone device.
  static const String DEFAULT_MASTER_DEVICE_ROLENAME = 'phone';

  // key = studyDeploymentId
  final Map<String, StudyDeployment> _repository = {};

  static CAMSDeploymentService _instance = CAMSDeploymentService._();
  CAMSDeploymentService._();

  /// Get the singlton [CAMSDeploymentService].
  factory CAMSDeploymentService() => _instance;

  Future<StudyDeploymentStatus> createStudyDeployment(
      StudyProtocol protocol) async {
    StudyDeployment deployment = StudyDeployment(protocol);
    _repository[deployment.studyDeploymentId] = deployment;

    // make sure to register this phone as a master device
    deployment.registerDevice(
        MasterDeviceDescriptor(roleName: DEFAULT_MASTER_DEVICE_ROLENAME),
        DeviceRegistration());

    // set the deployment status to "invited" as the initial status.
    deployment.status.status = StudyDeploymentStatusTypes.Invited;

    return deployment.status;
  }

  Future<Set<String>> removeStudyDeployments(
      Set<String> studyDeploymentIds) async {
    Set<String> removedKeys = {};
    studyDeploymentIds.forEach((key) {
      if (_repository.containsKey(key)) {
        _repository.remove(key);
        removedKeys.add(key);
      }
    });
    return removedKeys;
  }

  Future<StudyDeploymentStatus> getStudyDeploymentStatus(
          String studyDeploymentId) async =>
      _repository[studyDeploymentId]?.status;

  @override
  Future<StudyDeploymentStatus> registerDevice(String studyDeploymentId,
      String deviceRoleName, DeviceRegistration registration) async {
    StudyDeployment deployment = _repository[studyDeploymentId];

    // check if already registered
    DeviceDescriptor device = deployment.registeredDevices.keys.firstWhere(
        (descriptor) => descriptor.roleName == deviceRoleName,
        orElse: () => null);

    if (device == null) {
      // If not already registered, register device
      device ??= DeviceDescriptor(roleName: deviceRoleName);
      deployment.registerDevice(device, registration);
    }
    return deployment.status;
  }

  @override
  Future<StudyDeploymentStatus> unregisterDevice(
      String studyDeploymentId, String deviceRoleName) async {
    StudyDeployment deployment = _repository[studyDeploymentId];
    DeviceDescriptor device = deployment.registeredDevices.keys
        .firstWhere((descriptor) => descriptor.roleName == deviceRoleName);

    deployment.unregisterDevice(device);

    return deployment.status;
  }

  /// Get a deployment configuration for a master device with
  /// [studyDeploymentId].
  ///
  /// If [masterDeviceRoleName] is `null` then [DEFAULT_MASTER_DEVICE_ROLENAME]
  /// is used.
  @override
  Future<CAMSMasterDeviceDeployment> getDeviceDeploymentFor(
      String studyDeploymentId, String masterDeviceRoleName) async {
    masterDeviceRoleName ??= DEFAULT_MASTER_DEVICE_ROLENAME;
    StudyDeployment deployment = _repository[studyDeploymentId];
    DeviceDescriptor device = deployment.registeredDevices.keys.firstWhere(
        (descriptor) => descriptor.roleName == masterDeviceRoleName);

    assert(device.isMasterDevice,
        "The specified '$masterDeviceRoleName' device is not registered as a master device");

    MasterDeviceDeployment deviceDeployment =
        deployment.getDeviceDeploymentFor(device);

    CAMSStudyProtocol protocol = (deployment.protocol is CAMSStudyProtocol)
        ? deployment.protocol as CAMSStudyProtocol
        : null;

    return CAMSMasterDeviceDeployment.fromMasterDeviceDeployment(
      studyId: '',
      studyDeploymentId: studyDeploymentId,
      name: deployment.protocol.name,
      title: protocol?.title ?? '',
      description: deployment.protocol.description,
      purpose: protocol?.purpose ?? '',
      owner: protocol?.owner ?? null,
      masterDeviceDeployment: deviceDeployment,
    );
  }

  /// Get a deployment configuration for this master device (phone)
  /// for [studyDeploymentId].
  Future<CAMSMasterDeviceDeployment> getDeviceDeployment(
          String studyDeploymentId) async =>
      await getDeviceDeploymentFor(studyDeploymentId, null);

  @override
  Future<StudyDeploymentStatus> deploymentSuccessfulFor(
    String studyDeploymentId,
    String masterDeviceRoleName, {
    DateTime deviceDeploymentLastUpdateDate,
  }) async {
    masterDeviceRoleName ??= DEFAULT_MASTER_DEVICE_ROLENAME;
    deviceDeploymentLastUpdateDate ??= DateTime.now();

    StudyDeployment deployment = _repository[studyDeploymentId];
    DeviceDescriptor device = deployment.registeredDevices.keys.firstWhere(
        (descriptor) => descriptor.roleName == masterDeviceRoleName,
        orElse: () => null);

    print('>> $device');
    assert(device != null && device.isMasterDevice,
        "The specified device with rolename '$masterDeviceRoleName' is not a master device.");

    deployment.deviceDeployed(
        (device as MasterDeviceDescriptor), deviceDeploymentLastUpdateDate);

    return deployment.status;
  }

  /// Mark the study deployment with [studyDeploymentId] as deployed successfully
  /// to this master device (phone), i.e., that the study deployment was loaded
  /// on the device and that the necessary runtime is available to run it.
  Future<StudyDeploymentStatus> deploymentSuccessful(
    String studyDeploymentId, {
    DateTime deviceDeploymentLastUpdateDate,
  }) async =>
      deploymentSuccessfulFor(studyDeploymentId, null,
          deviceDeploymentLastUpdateDate: deviceDeploymentLastUpdateDate);

  @override
  Future<StudyDeploymentStatus> stop(String studyDeploymentId) async {
    StudyDeployment deployment = _repository[studyDeploymentId];
    deployment.stop();
    return deployment.status;
  }
}
