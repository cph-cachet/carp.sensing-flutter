/*
 * Copyright 2021 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of carp_core_client;

/// Manage data collection for a specific master device [deployment] on a client device.
class StudyRuntime {
  final List<DeviceDescriptor> _remainingDevicesToRegister = [];
  StudyRuntimeId? _id;
  StudyRuntimeStatus _status = StudyRuntimeStatus.NotReadyForDeployment;
  final StreamController<StudyRuntimeStatus> _statusEventsController =
      StreamController();

  /// The [MasterDeviceDeployment] for this study runtime.
  ///
  /// Is null if the deployment is not ready.
  /// Use the [tryDeployment] method to retrieve the [deployment] from
  /// the [deploymentService].
  MasterDeviceDeployment? deployment;

  /// The device factory / registry that handles the devices used in this runtime.
  late DeviceDataCollectorFactory deviceRegistry;

  /// The deployment service to use to retrieve and manage the study deployment.
  /// Use the [initialize] method to initialize this service.
  DeploymentService? deploymentService;

  /// The ID of the study [deploymnet].
  String? studyDeploymentId;

  /// The latest known deployment status.
  late StudyDeploymentStatus deploymentStatus;

  /// The description of the device this runtime is intended for within the
  /// deployment identified by [studyDeploymentId].
  MasterDeviceDescriptor? device;

  /// The device role name.
  String? get deviceRoleName => device?.roleName;

  /// Composite ID for this study runtime, comprised of the [studyDeploymentId]
  /// and [device] role name.
  StudyRuntimeId? get id => _id;

  /// The stream of [StudyRuntimeStatus] events for this controller.
  Stream<StudyRuntimeStatus> get statusEvents => _statusEventsController.stream;

  /// The status of this [StudyRuntime].
  StudyRuntimeStatus get status => _status;

  /// Set the state of this study runtime.
  set status(StudyRuntimeStatus newStatus) {
    _status = newStatus;
    _statusEventsController.add(newStatus);
  }

  /// Has this [StudyRuntime] been initialized?
  bool get isInitialized => (deploymentService != null);

  /// Has the device deployment been completed successfully?
  bool get isDeployed => (_status == StudyRuntimeStatus.Deployed);

  /// Has the study and data collection been stopped?
  bool get isStopped => (_status == StudyRuntimeStatus.Stopped);

  /// The list of devices that still remain to be registrered before all devices
  /// in this study runtime is registrered.
  List<DeviceDescriptor> get remainingDevicesToRegister =>
      _remainingDevicesToRegister;

  StudyRuntime();

  /// Instantiate a [StudyRuntime] by registering the client device in a [DeploymentService].
  ///
  ///  * [deploymentService] - the deployment service to use to retrieve and manage
  ///    the study deployment with [studyDeploymentId].
  ///  * [deviceRegistry] - the device factory to handle the devices used in this study deployment.
  ///  * [studyDeploymentId] - the ID of the deployed study for which to collect data.
  ///  * [deviceRoleName] – the role which the client device this runtime is intended
  ///    for plays inthe deployment identified by [studyDeploymentId].
  ///  * [deviceRegistration] - the device configuration for the device this study
  ///    runtime runs on, identified by [deviceRoleName] in the study deployment
  ///    with [studyDeploymentId].
  ///
  /// Call [tryDeployment] to subsequently deploy the study.
  Future initialize(
    DeploymentService deploymentService,
    DeviceDataCollectorFactory deviceRegistry,
    String studyDeploymentId,
    String deviceRoleName,
    DeviceRegistration deviceRegistration,
  ) async {
    this.deploymentService = deploymentService;
    this.deviceRegistry = deviceRegistry;

    _id = StudyRuntimeId(studyDeploymentId, deviceRoleName);
    _status = StudyRuntimeStatus.DeploymentReceived;

    // Register the master device this study runs on for the given study deployment.
    deploymentStatus = await deploymentService.registerDevice(
      studyDeploymentId,
      deviceRoleName,
      deviceRegistration,
    );

    // Initialize runtime.
    this.studyDeploymentId = studyDeploymentId;
    device =
        deploymentStatus.masterDeviceStatus!.device as MasterDeviceDescriptor?;
  }

  /// Verifies whether the master device is ready for deployment and in case
  /// it is, deploy the study previously added.
  /// Deployment entails trying to retrieve the [deployment] from the [deploymentService],
  /// based on the [studyDeploymentId].
  ///
  /// In case already deployed, nothing happens.
  Future<StudyRuntimeStatus> tryDeployment() async {
    assert(
        studyDeploymentId != null && device != null,
        'Cannot deploy without a valid study deployment id and device role name. '
        "Call 'initialize()' first.");

    // early out if already deployed.
    if (status.index >= StudyRuntimeStatus.Deployed.index) return status;

    deploymentStatus =
        await deploymentService!.getStudyDeploymentStatus(studyDeploymentId!);

    // get the deployment
    deployment = await deploymentService!
        .getDeviceDeploymentFor(studyDeploymentId!, device!.roleName);
    _status = StudyRuntimeStatus.DeploymentReceived;

    // TODO - set _remainingDevicesToRegister

    // mark this deployment as successful
    try {
      await deploymentService!.deploymentSuccessfulFor(
        studyDeploymentId!,
        device!.roleName,
        deployment!.lastUpdateDate,
      );
    } catch (error) {
      // we only print a warning
      // see issue #50 - there is a bug in CARP
      print(
          "$runtimeType - Error marking deployment '$studyDeploymentId' as successful.\n$error");
    }
    print(
        "$runtimeType - Study deployment '$studyDeploymentId' successfully deployed.");

    _status = StudyRuntimeStatus.Deployed;

    return _status;
  }

  /// Tries to register a connected device which are available
  /// in this device's [deviceRegistry] as well as in the [deploymentService].
  Future tryRegisterConnectedDevice(DeviceDescriptor device) async {
    assert(studyDeploymentId != null,
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
      DeviceRegistration registration = DeviceRegistration(deviceManager.id);
      deviceManager.deviceRegistration = registration;
      deploymentStatus = (await deploymentService?.registerDevice(
          studyDeploymentId!, deviceRoleName, registration))!;
    }
  }

  /// Tries to register all connected devices which are available
  /// in this device's [deviceRegistry] as well as in the [deploymentService].
  ///
  /// The [deploymentStatus] lists the devices needed to be deployed on this device.
  ///
  /// This is a convinient method for synchronizing the devices neeeded for a
  /// deployment and the available devices on this phone.
  Future tryRegisterConnectedDevices() async {
    for (var deviceStatus in deploymentStatus.devicesStatus) {
      await tryRegisterConnectedDevice(deviceStatus.device);
    }
  }

  /// Resume collecting data for this [StudyRuntime].
  void resume() {
    _status = StudyRuntimeStatus.Resumed;
  }

  /// Temporary pause collecting data for this [StudyRuntime].
  void pause() {
    _status = StudyRuntimeStatus.Paused;
  }

  /// Permanently stop collecting data for this [StudyRuntime].
  void stop() {
    // Early out in case study has already been stopped.
    if (status == StudyRuntimeStatus.Stopped) return;

    // Stop study deployment.
    deploymentService!.stop(studyDeploymentId!);
    _status = StudyRuntimeStatus.Stopped;
  }
}

/// Uniquely identifies a [StudyRuntime] running on a [ClientManager].
class StudyRuntimeId {
  /// The ID of the deployed study for which to collect data.
  String studyDeploymentId;

  /// The role name of the device in the deployment this study runtime participates in.
  String deviceRoleName;

  StudyRuntimeId(this.studyDeploymentId, this.deviceRoleName);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StudyRuntimeId &&
          runtimeType == other.runtimeType &&
          studyDeploymentId == other.studyDeploymentId &&
          deviceRoleName == other.deviceRoleName;

  @override
  int get hashCode => (studyDeploymentId + deviceRoleName).hashCode;
}

/// Describes the possible status' of a [StudyRuntime].
enum StudyRuntimeStatus {
  /// Deployment information has been received.
  DeploymentReceived,

  /// Deployment cannot succeed yet because other master devices have not been registered yet.
  NotReadyForDeployment,

  /// Deployment can complete after [remainingDevicesToRegister] have been registered.
  RegisteringDevices,

  /// Study runtime status when deployment has been successfully completed.
  /// The [MasterDeviceDeployment] has been retrieved and all necessary plugins
  /// to execute the study have been loaded.
  Deployed,

  /// The study runtime is configured and ready to execute.
  Configured,

  /// The study is resumed and is sampling data.
  Resumed,

  /// The study is paused and is not sampling data.
  Paused,

  /// The deployment has been stopped, either by this client or researcher.
  Stopped,
}
