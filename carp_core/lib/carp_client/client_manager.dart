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
  Map<StudyRuntimeId, StudyRuntime> repository = {};

  /// The registration of this client device.
  DeviceRegistration registration;

  /// The application service through which study deployments, to be run on
  /// this client, can be managed and retrieved.
  DeploymentService deploymentService;

  /// Determines which [DeviceRegistry] to use to collect data locally on
  /// this master device and this factory is used to create [ConnectedDeviceDataCollector]
  /// instances for connected devices.
  DeviceRegistry deviceRegistry;

  // private val dataListener: DataListener = DataListener( dataCollectorFactory )

  /// Determines whether a [DeviceRegistration] has been configured for this client,
  /// which is necessary to start adding [StudyRuntime]s.
  bool get isConfigured => registration != null;

  ClientManager({this.deploymentService, this.deviceRegistry});

  /// Configure the [DeviceRegistration] used to register this client device
  /// in study deployments managed by the [deploymentService].
  Future<DeviceRegistration> configure({String deviceId}) async =>
      registration = DeviceRegistration(deviceId);

  /// Get the status for the studies which run on this client device.
  List<StudyRuntimeStatus> getStudiesStatus() =>
      repository.values.map((study) => study.status);

  /// Add a study which needs to be executed on this client.
  /// This involves registering this device for the specified study deployment.
  ///
  ///  * [studyDeploymentId] - The ID of a study which has been deployed already
  ///    and for which to collect data.
  ///  * [deviceRoleName] - The role which the client device this runtime is
  ///    intended for plays as part of the deployment identified by [studyDeploymentId].
  ///
  /// Returns the [StudyRuntime] through which data collection for the newly
  /// added study can be managed.
  Future<StudyRuntime> addStudy(
    String studyDeploymentId,
    String deviceRoleName,
  ) async {
    assert(isConfigured, 'The client manager has not been configured yet.');
    assert(
        !repository
            .containsKey(StudyRuntimeId(studyDeploymentId, deviceRoleName)),
        'A study with the same study deployment ID and device role name has already been added.');
    return StudyRuntime();
  }

  /// Verifies whether the device is ready for deployment of the study runtime identified by [studyRuntimeId],
  /// and in case it is, deploys. In case already deployed, nothing happens.
  Future<StudyRuntimeStatus> tryDeployment(
      StudyRuntimeId studyRuntimeId) async {
    StudyRuntime runtime = repository[studyRuntimeId];

    // Early out in case this runtime has already received and validated deployment information.
    var status = runtime.status;
    if (status == StudyRuntimeStatus.Deployed) return status;

    return runtime.tryDeployment();
  }

  /// Permanently stop collecting data for the study runtime identified by [studyRuntimeId].
  void stopStudy(StudyRuntimeId studyRuntimeId) async =>
      repository[studyRuntimeId].stop();

  /// Get the [StudyRuntime] with the unique [studyRuntimeid].
  StudyRuntime getStudyRuntime(StudyRuntimeId studyRuntimeId) =>
      repository[studyRuntimeId];

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
