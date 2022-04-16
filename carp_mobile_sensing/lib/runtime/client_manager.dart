/*
 * Copyright 2021 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of runtime;

class SmartPhoneClientManager extends ClientManager {
  static final SmartPhoneClientManager _instance = SmartPhoneClientManager._();
  SmartPhoneClientManager._();

  /// Get the singleton [SmartPhoneClientManager].
  ///
  /// In CARP Mobile Sensing the [SmartPhoneClientManager] is a singleton,
  /// which implies that only one client manager is used in an app.
  factory SmartPhoneClientManager() => _instance;

  @override
  DeviceController get deviceController =>
      super.deviceController as DeviceController;

  NotificationController get notificationController => NotificationController();

  @override
  Future<DeviceRegistration> configure({
    required DeploymentService deploymentService,
    DeviceDataCollectorFactory? deviceController,
    String? deviceId,
  }) async {
    await DeviceInfo().init();
    // set default values, if not specified
    deviceId ??= DeviceInfo().deviceID;
    this.deviceController = deviceController ?? DeviceController();

    this.deviceController.registerAllAvailableDevices();

    print('===========================================================');
    print('  CARP Mobile Sensing (CAMS) - $runtimeType');
    print('===========================================================');
    print('  deployment service : $deploymentService');
    print('   device controller : $deviceController');
    print('           device ID : $deviceId');
    print('   connected devices : ${this.deviceController.devicesToString()}}');
    print('===========================================================');

    return super.configure(
      deploymentService: deploymentService,
      deviceController: this.deviceController,
      deviceId: deviceId,
    );
  }

  @override
  Future<SmartphoneDeploymentController> addStudy(
    String studyDeploymentId,
    String deviceRoleName,
  ) async {
    info(
        'Adding study to $runtimeType - studyDeploymentId: $studyDeploymentId, deviceRoleName: $deviceRoleName');
    await super.addStudy(studyDeploymentId, deviceRoleName);

    // create the study runtime
    SmartphoneDeploymentController controller =
        SmartphoneDeploymentController();

    await controller.initialize(
      deploymentService!,
      deviceController,
      studyDeploymentId,
      deviceRoleName,
      registration!,
    );

    repository[StudyRuntimeId(studyDeploymentId, deviceRoleName)] = controller;
    return controller;
  }

  @override
  SmartphoneDeploymentController? getStudyRuntime(
          StudyRuntimeId studyRuntimeId) =>
      repository[studyRuntimeId] as SmartphoneDeploymentController;
}
