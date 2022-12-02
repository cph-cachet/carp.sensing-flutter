/*
 * Copyright 2021 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of carp_core_client;

/// Allows managing [StudyRuntime]s on a client device.
class ClientManager {
  /// Repository within which the state of this client is stored.
  Map<Study, StudyRuntime> repository = {};

  /// The registration of this client device.
  DeviceRegistration? registration;

  /// The application service through which study deployments, to be run on
  /// this client, can be managed and retrieved.
  DeploymentService? deploymentService;

  /// The controller of connected devices used to collect data locally on
  /// this primary device. Also works as a factory which is used to create
  /// [DeviceDataCollector] instances for connected devices.
  DeviceDataCollectorFactory? deviceController;

  /// Determines whether a [DeviceRegistration] has been configured for this client,
  /// which is necessary to start adding [StudyRuntime]s.
  bool get isConfigured =>
      (deploymentService != null) &&
      (deviceController != null) &&
      (registration != null);

  ClientManager();

  /// Configure this [ClientManager] by specifying:
  ///  * [deploymentService] - where to get study deployments
  ///  * [deviceController] that handles devices connected to this client
  ///  * [registration] - a unique device registration for this client device
  @mustCallSuper
  Future<void> configure({
    required DeploymentService deploymentService,
    required DeviceDataCollectorFactory deviceController,
    DeviceRegistration? registration,
  }) async {
    this.deploymentService = deploymentService;
    this.deviceController = deviceController;
    this.registration = registration;
  }

  /// Get the status for the studies which run on this client device.
  List<StudyStatus> getStudyStatusList() =>
      repository.values.map((study) => study.status) as List<StudyStatus>;

  /// Add a study which needs to be executed on this client.
  /// This involves registering this device for the specified study deployment.
  ///
  ///  * [studyDeploymentId] - The ID of a study which has been deployed already
  ///    and for which to collect data.
  ///  * [deviceRoleName] - The role which the client device this runtime is
  ///    intended for plays as part of the deployment identified by [studyDeploymentId].
  ///
  /// Returns the [StudyStatus] of the newly added study.
  @mustCallSuper
  Future<StudyStatus> addStudy(Study study) async {
    assert(isConfigured,
        'The client manager has not been configured yet. Call configure() first.');
    assert(!repository.containsKey(study),
        'A study with the same study deployment ID and device role name has already been added.');
    return StudyStatus.DeploymentNotStarted;
  }

  /// Verifies whether the device is ready for deployment of the study runtime
  /// identified by [study], and in case it is, deploys.
  /// In case already deployed, nothing happens.
  @mustCallSuper
  Future<StudyStatus> tryDeployment(Study study) async {
    StudyRuntime runtime = repository[study]!;

    // Early out in case this runtime has already received and validated deployment information.
    if (runtime.status.index >= StudyStatus.Deployed.index) {
      return runtime.status;
    }

    return await runtime.tryDeployment();
  }

  /// Get the [StudyRuntime] for a [study].
  StudyRuntime? getStudyRuntime(Study study) => repository[study];

  /// Lookup the [StudyRuntime] based on the [studyDeploymentId] and [deviceRoleName].
  StudyRuntime? lookupStudyRuntime(
    String studyDeploymentId,
    String deviceRoleName,
  ) =>
      repository[Study(studyDeploymentId, deviceRoleName)];

  /// Permanently stop collecting data for the study runtime identified by [studyRuntimeId].
  @mustCallSuper
  void stopStudy(Study studyRuntimeId) async =>
      repository[studyRuntimeId]?.stop();

  // /// Once a connected device has been registered, this returns a manager
  // /// which provides access to the status of the [registeredDevice].
  // ConnectedDeviceManager getConnectedDeviceManager( DeviceRegistrationStatus registeredDevice )
  // {

  //   var dataCollector = deviceCollectorFactory.createConnectedDataCollector();

  //     val dataCollector = dataListener.tryGetConnectedDataCollector(
  //         registeredDevice.device::class,
  //         registeredDevice.registration )

  //     // `tryDeployment`, through which registeredDevice is obtained, would have failed if data collector could not be created.
  //     checkNotNull( dataCollector )

  //     return ConnectedDeviceManager( registeredDevice.registration, dataCollector )
  // }
}
