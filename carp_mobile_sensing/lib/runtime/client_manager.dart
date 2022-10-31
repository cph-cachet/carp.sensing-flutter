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
    WidgetsBinding.instance.addObserver(this);
    CarpMobileSensing();
  }

  /// Get the singleton [SmartPhoneClientManager].
  ///
  /// In CARP Mobile Sensing the [SmartPhoneClientManager] is a singleton,
  /// which implies that only one client manager is used in an app.
  factory SmartPhoneClientManager() => _instance;

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

  /// Configure this [SmartPhoneClientManager] by specifying:
  ///  * [deviceId] - this device's id in study deployments.
  ///      If not specified, the OS's device id is used.
  ///  * [deploymentService] - where to get study deployments.
  ///      If not specified, the [SmartphoneDeploymentService] will be used.
  ///  * [deviceController] that handles devices connected to this client.
  ///      If not specified, the default [DeviceController] is used.
  ///  * [notificationController] - what [NotificationController] to use for notifications.
  ///     Two alternatives exists; [FlutterLocalNotificationController] or [AwesomeNotificationController].
  ///     If not specified, the [AwesomeNotificationController] is used.
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

    // create and register the built-in data managers
    DataManagerRegistry().register(ConsoleDataManager());
    DataManagerRegistry().register(FileDataManager());
    DataManagerRegistry().register(SQLiteDataManager());

    // set default values, if not specified
    deviceId ??= DeviceInfo().deviceID;
    // _notificationController =
    //     notificationController ?? FlutterLocalNotificationController();
    _notificationController =
        notificationController ?? AwesomeNotificationController();
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

  /// Create and add a study based on the [protocol] which needs to be executed on
  /// this client. This is similar to the [addStudy] method, but deploying the
  /// [protocol] immediately.
  ///
  /// Returns the newly added study.
  Future<Study> addStudyProtocol(StudyProtocol protocol) async {
    assert(deploymentService != null,
        'Deployment Service has not been configured. Call configure() first.');

    StudyDeploymentStatus status =
        await deploymentService!.createStudyDeployment(protocol);
    Study study = Study(
      status.studyDeploymentId,
      status.masterDeviceStatus!.device.roleName,
    );

    await addStudy(study);
    return study;
  }

  @override
  SmartphoneDeploymentController? getStudyRuntime(Study study) =>
      repository[study] as SmartphoneDeploymentController;

  /// Called when this client manager is being (re-)activated by the OS
  ///
  /// Implementations of this method should start with a call to the inherited
  /// method, as in `super.activate()`.
  @protected
  @mustCallSuper
  void activate() {}

  /// Called when this client manager is being deactivated and potentially
  /// stopped by the OS
  ///
  /// Implementations of this method should start with a call to the inherited
  /// method, as in `super.deactivate()`.
  @protected
  @mustCallSuper
  Future<void> deactivate() async {
    // first save the task queue
    AppTaskController().saveQueue();
    // then save all studies
    for (var study in repository.keys) {
      await getStudyRuntime(study)?.saveDeployment();
    }
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
