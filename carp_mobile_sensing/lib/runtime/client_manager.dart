/*
 * Copyright 2021 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of runtime;

class SmartPhoneClientManager extends ClientManager {
  SmartPhoneClientManager({
    DeploymentService? deploymentService,
    DeviceController? deviceRegistry,
  }) : super(
          // if not specified, use default services
          deploymentService: deploymentService ?? SmartphoneDeploymentService(),
          deviceRegistry: deviceRegistry ?? DeviceController(),
        );

  @override
  DeviceController get deviceRegistry =>
      super.deviceRegistry as DeviceController;

  @override
  Future<DeviceRegistration> configure({String? deviceId}) async {
    await DeviceInfo().init();
    deviceId ??= DeviceInfo().deviceID;
    info('Configuring $runtimeType:');
    info('  deployment service : $deploymentService');
    info('     device registry : $deviceRegistry');
    info('           device ID : $deviceId');

    return super.configure(deviceId: deviceId);
  }

  @override
  Future<StudyDeploymentController> addStudy(
    String studyDeploymentId,
    String deviceRoleName,
  ) async {
    info(
        'Adding study to $runtimeType - studyDeploymentId: $studyDeploymentId, deviceRoleName: $deviceRoleName');
    await super.addStudy(studyDeploymentId, deviceRoleName);

    // Create the study runtime.
    // val deviceRegistration = repository.getDeviceRegistration()!!

    StudyDeploymentController controller = StudyDeploymentController();

    await controller.initialize(
      deploymentService,
      deviceRegistry,
      studyDeploymentId,
      deviceRoleName,
      registration!,
    );

    repository[StudyRuntimeId(studyDeploymentId, deviceRoleName)] = controller;
    return controller;
  }
}
