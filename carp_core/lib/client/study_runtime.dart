/*
 * Copyright 2022 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of carp_core_client;

/// Manage data collection for a specific master device [deployment] on a client device.
class StudyRuntime {
  final List<DeviceConfiguration> _remainingDevicesToRegister = [];
  Study? _study;
  StudyStatus _status = StudyStatus.DeploymentNotStarted;
  final StreamController<StudyStatus> _statusEventsController =
      StreamController();

  /// The study for this study runtime.
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
  /// Use the [initialize] method to initialize this service.
  DeploymentService deploymentService;

  /// The latest known deployment status.
  late StudyDeploymentStatus deploymentStatus;

  /// The description of the device this runtime is intended for within the
  /// deployment identified by [studyDeploymentId].
  PrimaryDeviceConfiguration? device;

  /// The device role name.
  String? get deviceRoleName => device?.roleName;

  /// The stream of [StudyStatus] events for this controller.
  Stream<StudyStatus> get statusEvents => _statusEventsController.stream;

  /// The status of this [StudyRuntime].
  StudyStatus get status => _status;

  /// Set the state of this study runtime.
  set status(StudyStatus newStatus) {
    _status = newStatus;
    _statusEventsController.add(newStatus);
  }

  /// Has this [StudyRuntime] been initialized?
  bool get isInitialized => (study != null);

  /// Has the device deployment been completed successfully?
  bool get isDeployed => (_status == StudyStatus.Deployed);

  /// Has the study and data collection been stopped?
  bool get isStopped => (_status == StudyStatus.Stopped);

  /// The list of devices that still remain to be registrered before all devices
  /// in this study runtime is registrered.
  List<DeviceConfiguration> get remainingDevicesToRegister =>
      _remainingDevicesToRegister;

  /// Create a new study runtime, specifying the [deploymentService] to use to
  /// retrieve and manage the study deployment with [studyDeploymentId] and the
  /// [deviceRegistry] to handle the devices used in this study deployment.
  StudyRuntime(this.deploymentService, this.deviceRegistry);

  /// Intialize this study runtime by specifying its [study] and [deviceRegistration].
  ///
  /// [deviceRegistration] is the device configuration for the device this study
  /// runtime runs on, identified by [deviceRoleName] in the study deployment
  /// with [studyDeploymentId].
  ///
  /// Call [tryDeployment] to subsequently deploy the study.
  Future<void> initialize(
    Study study,
    DeviceRegistration deviceRegistration,
  ) async {
    _study = study;
    _status = StudyStatus.DeploymentReceived;

    // Register the master device this study runs on for the given study deployment.
    deploymentStatus = await deploymentService.registerDevice(
      study.studyDeploymentId,
      study.deviceRoleName,
      deviceRegistration,
    );

    // Initialize runtime.
    // this.studyDeploymentId = studyDeploymentId;
    device = deploymentStatus.masterDeviceStatus!.device
        as PrimaryDeviceConfiguration?;
  }

  /// Verifies whether the master device is ready for deployment and in case
  /// it is, deploy the study previously added.
  /// Deployment entails trying to retrieve the [deployment] from the [deploymentService],
  /// based on the [studyDeploymentId].
  ///
  /// In case already deployed, nothing happens.
  Future<StudyStatus> tryDeployment() async {
    assert(
        study != null && device != null,
        'Cannot deploy without a valid study deployment id and device role name. '
        "Call 'initialize()' first.");

    // early out if already deployed.
    if (status.index >= StudyStatus.Deployed.index) return status;

    _status = StudyStatus.Deploying;
    deploymentStatus = await deploymentService
        .getStudyDeploymentStatus(study!.studyDeploymentId);

    // get the deployment from the deployment service
    deployment = await deploymentService.getDeviceDeploymentFor(
      study!.studyDeploymentId,
      device!.roleName,
    );
    _status = StudyStatus.DeploymentReceived;

    // TODO - set _remainingDevicesToRegister

    // mark this deployment as successful
    try {
      await deploymentService.deploymentSuccessfulFor(
        study!.studyDeploymentId,
        device!.roleName,
        deployment?.lastUpdateDate ?? DateTime.now(),
      );
    } catch (error) {
      // we only print a warning
      // see issue #50 - there is a bug in CARP
      print(
          "$runtimeType - Error marking deployment '${study!.studyDeploymentId}' as successful.\n$error");
    }
    print(
        "$runtimeType - Study deployment '${study!.studyDeploymentId}' successfully deployed.");

    _status = StudyStatus.Deployed;

    return _status;
  }

  /// Tries to register a connected device which are available
  /// in this device's [deviceRegistry] as well as in the [deploymentService].
  Future<void> tryRegisterConnectedDevice(DeviceConfiguration device) async {
    assert(study != null,
        "Cannot register a device without a valid study deployment. Call 'initialize()' first.");

    String deviceType = device.type;
    String? deviceRoleName = device.roleName;

    // if this phone supports the device, register it locally
    if (deviceRegistry.supportsDevice(deviceType)) {
      await deviceRegistry.createDevice(deviceType);
    }

    // if successful, register at the deployment service
    if (deviceRegistry.hasDevice(deviceType)) {
      DeviceDataCollector deviceManager = deviceRegistry.getDevice(deviceType)!;
      // ask the device manager for a unique id of the device
      DeviceRegistration registration = DeviceRegistration(
        deviceId: deviceManager.id,
      );
      deviceManager.deviceRegistration = registration;
      deploymentStatus = (await deploymentService.registerDevice(
        study!.studyDeploymentId,
        deviceRoleName,
        registration,
      ));
    }
  }

  /// Tries to register all connected devices which are available
  /// in this device's [deviceRegistry] as well as in the [deploymentService].
  ///
  /// The [deploymentStatus] lists the devices needed to be deployed on this device.
  ///
  /// This is a convinient method for synchronizing the devices neeeded for a
  /// deployment and the available devices on this phone.
  Future<void> tryRegisterConnectedDevices() async {
    for (var deviceStatus in deploymentStatus.devicesStatus) {
      await tryRegisterConnectedDevice(deviceStatus.device);
    }
  }

  /// Start collecting data for this [StudyRuntime].
  void start() {
    _status = StudyStatus.Running;
  }

  /// Permanently stop collecting data for this [StudyRuntime].
  /// Once a runtime is stopped it **cannot** be (re)started.
  void stop() {
    // Early out in case study has already been stopped.
    if (status == StudyStatus.Stopped) return;

    // Stop study deployment.
    deploymentService.stop(study!.studyDeploymentId);
    _status = StudyStatus.Stopped;
  }
}
