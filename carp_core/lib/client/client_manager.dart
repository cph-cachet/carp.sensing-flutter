/*
 * Copyright 2021-2022 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of carp_core_client;

/// Allows managing [StudyRuntime]s on a client device.
abstract class ClientManager<
    TPrimaryDevice extends PrimaryDeviceConfiguration<TRegistration>,
    TRegistration extends DeviceRegistration> {
  DeploymentService? _deploymentService;
  DeviceDataCollectorFactory? _deviceController;

  /// Repository of [StudyRuntime] mapped to a [Study].
  Map<Study, StudyRuntime> repository = {};

  /// The registration of this client.
  TRegistration? registration;

  /// The application service through which study deployments, to be run on
  /// this client, can be managed and retrieved.
  DeploymentService? get deploymentService => _deploymentService;

  /// The controller of connected devices used to collect data locally on
  /// this primary device. Also works as a factory which is used to create
  /// [DeviceDataCollector] instances for connected devices.
  DeviceDataCollectorFactory? get deviceController => _deviceController;

  /// Determines whether a [DeviceRegistration] has been configured for this client,
  /// which is necessary to start adding [StudyRuntime]s.
  bool get isConfigured =>
      (deploymentService != null) &&
      (deviceController != null) &&
      (registration != null);

  /// Configure this [ClientManager] by specifying:
  ///  * [deploymentService] - where to get study deployments
  ///  * [deviceController] that handles devices connected to this client
  ///  * [registration] - a unique device registration for this client device
  @mustCallSuper
  Future<void> configure({
    required DeploymentService deploymentService,
    required DeviceDataCollectorFactory deviceController,
    TRegistration? registration,
  }) async {
    this._deploymentService = deploymentService;
    this._deviceController = deviceController;
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
  /// Returns the added study.
  @mustCallSuper
  Future<Study> addStudy(
    String studyDeploymentId,
    String deviceRoleName,
  ) async {
    assert(isConfigured,
        'The client manager has not been configured yet. Call configure() first.');
    Study study = Study(studyDeploymentId, deviceRoleName);
    assert(!repository.containsKey(study),
        'A study with the same study deployment ID and device role name has already been added.');
    return study;
  }

  /// Verifies whether the device is ready for deployment of the study runtime
  /// identified by [study], and in case it is, deploys.
  /// In case already deployed, nothing happens.
  @mustCallSuper
  Future<StudyStatus> tryDeployment(Study study) async {
    StudyRuntime? runtime = repository[study];
    assert(runtime != null && runtime.study != null,
        'No runtime for this study found. Has this study been added using the addStudy method?');

    // Early out in case this runtime has already received and validated deployment information.
    if (runtime!.status.index >= StudyStatus.Deployed.index) {
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

  /// Remove [study] from this client manager.
  ///
  /// Note that by removing a study, it isn't stopped. Hence, the study can later
  /// be added again using the [addStudy] method.
  /// If a study is to be permanently stopped, use the [stopStudy] method.
  @mustCallSuper
  Future<void> removeStudy(Study study) async {
    await repository[study]?.remove();
    var runtime = repository[study];
    repository.remove(study);
    if (runtime != null) runtime.remove();
  }

  /// Permanently stop collecting data for [study] and then remove it.
  ///
  /// Once a study is stopped it cannot be deployed anymore since it will
  /// be marked as permanently stopped in the [DeploymentService] via the [stop]
  /// method.
  ///
  /// If you only want to remove the study from this client, use the
  /// [removeStudy] method instead.
  @mustCallSuper
  Future<void> stopStudy(Study study) async {
    var runtime = repository[study];

    if (runtime != null) {
      await runtime.stop();
      await removeStudy(study);

      // Permanently stop this study deployment on the deployment service.
      await deploymentService?.stop(study.studyDeploymentId);
    }
  }
}

/// Allows managing studies on a smartphone.
class SmartphoneClient extends ClientManager<Smartphone, DeviceRegistration> {
  SmartphoneClient();
}
