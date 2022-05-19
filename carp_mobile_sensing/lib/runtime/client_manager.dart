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
  NotificationController? _notificationController;

  SmartPhoneClientManager._() {
    WidgetsFlutterBinding.ensureInitialized();
    WidgetsBinding.instance?.addObserver(this);
    DomainJsonFactory();
  }

  /// Get the singleton [SmartPhoneClientManager].
  ///
  /// In CARP Mobile Sensing the [SmartPhoneClientManager] is a singleton,
  /// which implies that only one client manager is used in an app.
  factory SmartPhoneClientManager(
          [NotificationController? notificationController]) =>
      _instance;

  @override
  DeviceController get deviceController =>
      super.deviceController as DeviceController;

  /// The [NotificationController] responsible for sending notification on [AppTask]s.
  NotificationController? get notificationController => _notificationController;

  @override
  SmartphoneDeploymentController? lookupStudyRuntime(
    String studyDeploymentId,
    String deviceRoleName,
  ) =>
      super.lookupStudyRuntime(studyDeploymentId, deviceRoleName)
          as SmartphoneDeploymentController;

  @override
  Future<DeviceRegistration> configure({
    NotificationController? notificationController,
    DeploymentService? deploymentService,
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
    this._notificationController =
        notificationController ?? FlutterLocalNotificationController();
    this.deploymentService = deploymentService ?? SmartphoneDeploymentService();
    this.deviceController = deviceController ?? DeviceController();

    this.deviceController.registerAllAvailableDevices();

    print('===========================================================');
    print('  CARP Mobile Sensing (CAMS) - $runtimeType');
    print('===========================================================');
    print('  deployment service : $deploymentService');
    print('   device controller : ${this.deviceController}');
    print('           device ID : $deviceId');
    print('   available devices : ${this.deviceController.devicesToString()}');
    print('===========================================================');

    return super.configure(
      deploymentService: this.deploymentService!,
      deviceController: this.deviceController,
      deviceId: deviceId,
    );
  }

  @override
  Future<StudyStatus> addStudy(Study study) async {
    StudyStatus status = await super.addStudy(study);
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

  /// Called when this client mananger is being (re-)activated by the OS
  ///
  /// Implementations of this method should start with a call to the inherited
  /// method, as in `super.activate()`.
  @protected
  @mustCallSuper
  void activate() {}

  /// Called when this client mananger is being deactivated and potentially
  /// stopped by the OS
  ///
  /// Implementations of this method should start with a call to the inherited
  /// method, as in `super.deactivate()`.
  @protected
  @mustCallSuper
  Future<void> deactivate() async {
    // make sure to save all studies
    repository.keys.forEach(
        (study) async => await getStudyRuntime(study)?.saveDeployment());
  }

  /// Called when the system puts the app in the background or returns
  /// the app to the foreground.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    debug('$runtimeType - App lifecycle state changed: $state');
    switch (state) {
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        deactivate();
        break;
      case AppLifecycleState.resumed:
        activate();
        break;
    }
  }
}
