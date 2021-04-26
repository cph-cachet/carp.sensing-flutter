/*
 * Copyright 2021 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of runtime;

class SmartPhoneClientManager extends ClientManager {
  SmartPhoneClientManager({
    DeploymentService deploymentService,
    DeviceController deviceRegistry,
  }) {
    // if not specified, use default services
    this.deploymentService ??= SmartphoneDeploymentService();
    this.deviceRegistry ??= DeviceController();
  }

  @override
  DeviceController get deviceRegistry => super.deviceRegistry;

  @override
  Future<DeviceRegistration> configure({String deviceId}) async {
    await DeviceInfo().init();
    deviceId ??= DeviceInfo().deviceID;
    return super.configure(deviceId: deviceId);
  }

  @override
  Future<StudyDeploymentController> addStudy(
    String studyDeploymentId,
    String deviceRoleName,
  ) async {
    assert(isConfigured, 'The client manager has not been configured yet.');
    assert(
        !repository
            .containsKey(StudyRuntimeId(studyDeploymentId, deviceRoleName)),
        'A study with the same study deployment ID and device role name has already been added.');

    // Create the study runtime.
    // val deviceRegistration = repository.getDeviceRegistration()!!

    StudyDeploymentController controller = StudyDeploymentController();

    await controller.initialize(
      deploymentService,
      deviceRegistry,
      studyDeploymentId,
      deviceRoleName,
      registration,
    );

    repository[StudyRuntimeId(studyDeploymentId, deviceRoleName)] = controller;
    return controller;
  }
}
