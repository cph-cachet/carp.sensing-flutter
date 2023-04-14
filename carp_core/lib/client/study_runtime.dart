/*
 * Copyright 2022 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of carp_core_client;

/// Manage data collection for a specific primary device [deployment] on a
/// client device.
class StudyRuntime<TRegistration extends DeviceRegistration> {
  final List<DeviceConfiguration> _remainingDevicesToRegister = [];
  Study? _study;
  TRegistration? _deviceRegistration;
  StudyStatus _status = StudyStatus.DeploymentNotStarted;
  final StreamController<StudyStatus> _statusEventsController =
      StreamController();

  /// The unique device registration for this device.
  /// Set in the [addStudy] method.
  TRegistration? get deviceRegistration => _deviceRegistration;

  /// The study for this study runtime.
  /// Set in the [addStudy] method.
  Study? get study => _study;

  /// The study deployment id for the [study] of this controller.
  String? get studyDeploymentId => study?.studyDeploymentId;

  /// The [PrimaryDeviceDeployment] for this study runtime.
  ///
  /// Is null if the deployment is not ready.
  /// Use the [tryDeployment] method to retrieve the [deployment] from
  /// the [deploymentService].
  PrimaryDeviceDeployment? deployment;

  /// The device registry that handles the devices used in this runtime.
  DeviceDataCollectorFactory deviceRegistry;

  /// The deployment service to use to retrieve and manage the study deployment.
  DeploymentService deploymentService;

  /// The latest known deployment status retrieved from the [deploymentService].
  /// Null if not know.
  StudyDeploymentStatus? deploymentStatus;

  /// The stream of [StudyStatus] events for this controller.
  Stream<StudyStatus> get statusEvents => _statusEventsController.stream;

  /// The status of the [study] running on this [StudyRuntime].
  StudyStatus? get status => _study?.status;
  set status(StudyStatus? newStatus) {
    if (newStatus != null) {
      _study?.status = newStatus;
      _statusEventsController.add(newStatus);
    }
  }

  /// Has this [StudyRuntime] been initialized?
  bool get isInitialized => (study != null);

  /// Has the device deployment been completed successfully?
  bool get isDeployed => (_status == StudyStatus.Deployed);

  /// Has the study and data collection been stopped?
  bool get isStopped => (_status == StudyStatus.Stopped);

  /// The list of devices that still remain to be registered before all devices
  /// in this study runtime is registered.
  List<DeviceConfiguration> get remainingDevicesToRegister =>
      _remainingDevicesToRegister;

  /// Create a new study runtime, specifying the [deploymentService] to use to
  /// retrieve and manage the study deployment with [studyDeploymentId] and the
  /// [deviceRegistry] to handle the devices used in this study deployment.
  StudyRuntime(this.deploymentService, this.deviceRegistry);

  /// Adds [study] this study runtime by specifying its [study] and
  /// [deviceRegistration].
  ///
  /// [deviceRegistration] is the device configuration for the device this study
  /// runtime runs on, identified by [Study.deviceRoleName] in the study deployment
  /// with [Study.studyDeploymentId].
  ///
  /// Call [tryDeployment] to subsequently deploy the study.
  Future<void> addStudy(
    Study study,
    TRegistration deviceRegistration,
  ) async {
    _study = study;
    _status = StudyStatus.DeploymentNotStarted;
    _deviceRegistration = deviceRegistration;
  }

  /// Get the status for a study deployment for the [study].
  /// Returns null if [studyDeploymentId] is not found.
  Future<StudyDeploymentStatus?> getStudyDeploymentStatus() async {
    try {
      deploymentStatus = await deploymentService
          .getStudyDeploymentStatus(study!.studyDeploymentId);
      status = StudyStatus.DeploymentStatusAvailable;
    } catch (error) {
      deploymentStatus = null;
    }
    if (deploymentStatus == null) {
      status = StudyStatus.DeploymentNotAvailable;
      print(
          "$runtimeType - Could not get deployment with id '${study!.studyDeploymentId}' from the deployment service: $deploymentService");
    }
    return deploymentStatus;
  }

  /// Tries to deploy the [study] if it's ready to be deployed by registering
  /// the client device using [deviceRegistration] and verifying the study is
  /// supported on this device.
  ///
  /// Deployment entails trying to retrieve the [deployment] from the [deploymentService],
  /// based on the [studyDeploymentId].
  ///
  /// In case already deployed, nothing happens.
  Future<StudyStatus> tryDeployment() async {
    assert(
        study != null,
        'Cannot deploy without a valid study deployment id and device role name. '
        "Call 'configure()' first.");

    // early out if already deployed.
    if (status!.index >= StudyStatus.Deployed.index) return status!;

    // check the status of this deployment.
    if (await getStudyDeploymentStatus() == null) return status!;

    status = StudyStatus.Deploying;

    // register the primary device for the given study deployment
    try {
      deploymentStatus = await deploymentService.registerDevice(
        study!.studyDeploymentId,
        study!.deviceRoleName,
        deviceRegistration!,
      );
    } catch (error) {
      // we only print a warning - this device may already be registered
      print(
          "$runtimeType - Error registering '${study!.deviceRoleName}' as primary device.\n$error");
    }

    // get the deployment from the deployment service
    deployment = await deploymentService.getDeviceDeploymentFor(
      study!.studyDeploymentId,
      study!.deviceRoleName,
    );
    status = StudyStatus.DeviceDeploymentReceived;

    deploymentStatus?.deviceStatusList.forEach((deviceStatus) {
      if (deviceStatus.status == DeviceDeploymentStatusTypes.Unregistered) {
        _remainingDevicesToRegister.add(deviceStatus.device);
      }
    });

    // mark this deployment as successful
    try {
      await deploymentService.deviceDeployed(
        study!.studyDeploymentId,
        study!.deviceRoleName,
        deployment?.lastUpdatedOn ?? DateTime.now(),
      );
    } catch (error) {
      // we only print a warning
      // see issue #50 - there is a bug in CAWS
      print(
          "$runtimeType - Error marking deployment '${study!.studyDeploymentId}' as deployed.\n$error");
    }
    print(
        "$runtimeType - Study deployment '${study!.studyDeploymentId}' successfully deployed.");

    return status = StudyStatus.Deployed;
  }

  /// Tries to register a connected device which is available
  /// in this device's [deviceRegistry] in the [deploymentService]
  Future<void> tryRegisterConnectedDevice(DeviceConfiguration device) async {
    assert(
        study != null,
        "Cannot register a device without a valid study deployment. "
        "Call 'configure()' first.");

    String deviceType = device.type;
    String? deviceRoleName = device.roleName;

    if (deviceRegistry.hasDevice(deviceType)) {
      DeviceDataCollector deviceManager = deviceRegistry.getDevice(deviceType)!;

      // create a registration based on the device manager's unique id and name of the device
      var registration = deviceManager.configuration?.createRegistration(
        deviceId: deviceManager.id,
        deviceDisplayName: deviceManager.displayName,
      );

      if (registration != null) {
        try {
          deploymentStatus = (await deploymentService.registerDevice(
            study!.studyDeploymentId,
            deviceRoleName,
            registration,
          ));
        } catch (error) {
          print("$runtimeType - failed to register device with role name "
              "'$deviceRoleName' for study deployment '${study!.studyDeploymentId}' "
              "at deployment service '$deploymentService'.\n"
              "Error: $error\n"
              "Continuing without registration.");
        }
      }
    }
  }

  /// Tries to register the connected devices which still need to be registered
  /// in the [deploymentService].
  ///
  /// This is a convenient method for synchronizing the devices needed for a
  /// deployment and the available devices on this phone.
  Future<void> tryRegisterRemainingDevicesToRegister() async {
    for (var device in remainingDevicesToRegister) {
      await tryRegisterConnectedDevice(device);
    }
  }

  /// Start collecting data for this [StudyRuntime].
  @mustCallSuper
  void start() => _status = StudyStatus.Running;

  /// Called when this [StudyRuntime] is disposed.
  /// This entails stopping and disposing all data sampling and storage.
  @mustCallSuper
  void dispose() {}

  /// Called when this [StudyRuntime] is removed from a [ClientManager].
  @mustCallSuper
  Future<void> remove() async {}

  /// Stop collecting data for this [StudyRuntime].
  @mustCallSuper
  Future<void> stop() async => _status = StudyStatus.Stopped;
}
