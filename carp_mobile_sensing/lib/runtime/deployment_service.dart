/*
 * Copyright 2021 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of runtime;

/// A local (in-memory) implementation of a [DeploymentService] useful in
/// CAMS studies to be deployed locally on this phone.
class SmartphoneDeploymentService implements DeploymentService {
  // key = studyDeploymentId
  final Map<String, StudyDeployment> _repository = {};

  static final SmartphoneDeploymentService _instance =
      SmartphoneDeploymentService._();
  SmartphoneDeploymentService._();

  /// Get the singlton [SmartphoneDeploymentService].
  factory SmartphoneDeploymentService() => _instance;

  /// The device description for this phone.
  Smartphone thisPhone = Smartphone();

  /// Create a new [StudyDeployment] based on a [StudyProtocol].
  /// [studyDeploymentId] specify the study deployment id.
  /// If not specified, an UUID v1 id is generated.
  @override
  Future<StudyDeploymentStatus> createStudyDeployment(
    StudyProtocol protocol, [
    String? studyDeploymentId,
  ]) async {
    StudyDeployment deployment = StudyDeployment(protocol, studyDeploymentId);
    _repository[deployment.studyDeploymentId] = deployment;

    // make sure to register this phone as a master device
    deployment.registerDevice(thisPhone, DeviceRegistration());

    // set the deployment status to "invited" as the initial status.
    deployment.status.status = StudyDeploymentStatusTypes.Invited;

    return deployment.status;
  }

  @override
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

  @override
  Future<StudyDeploymentStatus> getStudyDeploymentStatus(
          String studyDeploymentId) async =>
      _repository[studyDeploymentId]!.status;

  @override
  Future<StudyDeploymentStatus> registerDevice(
    String studyDeploymentId,
    String deviceRoleName,
    DeviceRegistration registration,
  ) async {
    StudyDeployment deployment = _repository[studyDeploymentId]!;

    // check if already registered - if not register device
    DeviceDescriptor device = deployment.registeredDevices.keys.firstWhere(
        (descriptor) => descriptor.roleName == deviceRoleName,
        orElse: () => DeviceDescriptor(roleName: deviceRoleName));

    deployment.registerDevice(device, registration);

    return deployment.status;
  }

  @override
  Future<StudyDeploymentStatus> unregisterDevice(
    String studyDeploymentId,
    String deviceRoleName,
  ) async {
    StudyDeployment deployment = _repository[studyDeploymentId]!;
    DeviceDescriptor device = deployment.registeredDevices.keys
        .firstWhere((descriptor) => descriptor.roleName == deviceRoleName);

    deployment.unregisterDevice(device);

    return deployment.status;
  }

  @override
  Future<CAMSMasterDeviceDeployment> getDeviceDeploymentFor(
    String studyDeploymentId,
    String masterDeviceRoleName,
  ) async {
    StudyDeployment deployment = _repository[studyDeploymentId]!;
    DeviceDescriptor device = deployment.registeredDevices.keys.firstWhere(
        (descriptor) => descriptor.roleName == masterDeviceRoleName);

    assert(device.isMasterDevice!,
        "The specified '$masterDeviceRoleName' device is not registered as a master device");

    MasterDeviceDeployment deviceDeployment =
        deployment.getDeviceDeploymentFor(device as MasterDeviceDescriptor);

    // this local deployment service use a file dataendpoint per default
    deviceDeployment.dataEndPoint = FileDataEndPoint(
      bufferSize: 500 * 1000,
      zip: true,
      encrypt: false,
    );

    return CAMSMasterDeviceDeployment.fromMasterDeviceDeployment(
      studyDeploymentId: studyDeploymentId,
      masterDeviceDeployment: deviceDeployment,
    );
  }

  /// Get a deployment configuration for this master device (phone)
  /// for [studyDeploymentId].
  ///
  /// The default data endpoint is set to a [FileDataEndPoint], i.e. storing
  /// the data locally on the phone as zipped files.
  Future<CAMSMasterDeviceDeployment> getDeviceDeployment(
          String studyDeploymentId) async =>
      await getDeviceDeploymentFor(studyDeploymentId, thisPhone.roleName);

  @override
  Future<StudyDeploymentStatus> deploymentSuccessfulFor(
    String studyDeploymentId,
    String masterDeviceRoleName,
    DateTime? deviceDeploymentLastUpdateDate,
  ) async {
    deviceDeploymentLastUpdateDate ??= DateTime.now();

    StudyDeployment deployment = _repository[studyDeploymentId]!;
    DeviceDescriptor device = deployment.registeredDevices.keys.firstWhere(
        (descriptor) => descriptor.roleName == masterDeviceRoleName);

    assert(device.isMasterDevice!,
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
    DateTime? deviceDeploymentLastUpdateDate,
  }) async =>
      deploymentSuccessfulFor(
        studyDeploymentId,
        thisPhone.roleName,
        deviceDeploymentLastUpdateDate,
      );

  /// Stop the study deployment with [studyDeploymentId].
  @override
  Future<StudyDeploymentStatus> stop(String studyDeploymentId) async {
    StudyDeployment deployment = _repository[studyDeploymentId]!;
    deployment.stop();
    return deployment.status;
  }

  @override
  Future<List<StudyDeploymentStatus>> getStudyDeploymentStatusList(
      List<String> studyDeploymentIds) {
    // TODO: implement getStudyDeploymentStatusList
    throw UnimplementedError();
  }

  @override
  String toString() => runtimeType.toString();
}
