/*
 * Copyright 2021-2022 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of runtime;

class SmartPhoneClientManager extends ClientManager
    with WidgetsBindingObserver {
  static final SmartPhoneClientManager _instance = SmartPhoneClientManager._();
  SmartPhoneClientManager._() {
    WidgetsFlutterBinding.ensureInitialized();
    WidgetsBinding.instance?.addObserver(this);
  }

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
  SmartphoneDeploymentController? lookupStudyRuntime(
    String studyDeploymentId,
    String deviceRoleName,
  ) =>
      super.lookupStudyRuntime(studyDeploymentId, deviceRoleName)
          as SmartphoneDeploymentController;

  @override
  Future<DeviceRegistration> configure({
    required DeploymentService deploymentService,
    DeviceDataCollectorFactory? deviceController,
    String? deviceId,
  }) async {
    // initialize device settings
    await DeviceInfo().init();
    await Settings().init();

    // create and register the two built-in data managers
    DataManagerRegistry().register(ConsoleDataManager());
    DataManagerRegistry().register(FileDataManager());

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
  Future<StudyStatus> addStudy(
    String studyDeploymentId,
    String deviceRoleName,
  ) async {
    StudyStatus status = await super.addStudy(
      studyDeploymentId,
      deviceRoleName,
    );
    Study study = Study(studyDeploymentId, deviceRoleName);
    info('Adding study to $runtimeType - $study');

    SmartphoneDeploymentController controller =
        SmartphoneDeploymentController(deploymentService!, deviceController);
    repository[study] = controller;

    await controller.initialize(
      study,
      registration!,
    );

    return status;
  }

  @override
  SmartphoneDeploymentController? getStudyRuntime(Study study) =>
      repository[study] as SmartphoneDeploymentController;

  /// Called when the system puts the app in the background or returns
  /// the app to the foreground.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print(state);
    switch (state) {
      case AppLifecycleState.inactive:
        print('appLifeCycleState inactive');
        break;
      case AppLifecycleState.resumed:
        print('appLifeCycleState resumed');
        break;
      case AppLifecycleState.paused:
        print('appLifeCycleState paused');
        break;
      case AppLifecycleState.detached:
        print('appLifeCycleState detached');
        break;
    }
  }
}
