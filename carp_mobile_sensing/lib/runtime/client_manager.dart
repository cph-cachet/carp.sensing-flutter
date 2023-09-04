/*
 * Copyright 2021-2023 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of runtime;

enum ClientManagerState {
  created,
  configured,
  started,
  stopped,
  disposed,
}

class SmartPhoneClientManager extends SmartphoneClient
    with WidgetsBindingObserver {
  static final SmartPhoneClientManager _instance = SmartPhoneClientManager._();
  NotificationController? _notificationController;
  bool _heartbeat = true;
  final StreamGroup<Measurement> _group = StreamGroup.broadcast();
  ClientManagerState _state = ClientManagerState.created;

  /// The runtime state of this client manager.
  ClientManagerState get state => _state;

  /// The stream of all [Measurement]s collected by this client manager.
  Stream<Measurement> get measurements => _group.stream;

  /// The permissions granted to this client from the OS.
  Map<Permission, PermissionStatus>? permissions;

  SmartPhoneClientManager._() {
    WidgetsFlutterBinding.ensureInitialized();
    WidgetsBinding.instance.addObserver(this);
    CarpMobileSensing.ensureInitialized();
  }

  /// Get the singleton [SmartPhoneClientManager].
  ///
  /// In CARP Mobile Sensing the [SmartPhoneClientManager] is a singleton,
  /// which implies that only one client manager is used in an app.
  factory SmartPhoneClientManager() => _instance;

  /// Is this client sending [Heartbeat] measurements for its studies?
  bool get heartbeat => _heartbeat;

  /// The number of studies running on this client.
  int get studyCount => repository.length;

  /// The list of studies deployed on this client manager.
  List<Study> get studies => repository.keys.toList();

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

  /// Configure this [SmartPhoneClientManager].
  ///
  /// If the [deploymentService] is not specified, the local
  /// [SmartphoneDeploymentService] will be used.
  /// If the [deviceController] is not specified, the default [DeviceController]
  /// is used.
  /// The [registration] is a unique device registration for this client device.
  /// If not specified, a [SmartphoneDeviceRegistration] is created and used.
  ///
  /// If [enableNotifications] is true (default), notifications is created an [AppTask]
  /// is triggered? The [notificationController] specifies what [NotificationController] to
  /// use for notifications. Two alternatives exists:
  /// [FlutterLocalNotificationController] or [AwesomeNotificationController] (default).
  ///
  /// If [askForPermissions] is true (default), this client manager will
  /// automatically ask for permissions for all sampling packages at once.
  /// If you want the app to handle permissions itself, set this to false.
  ///
  /// If [heartbeat] is true, a [Heartbeat] data point will be uploaded for all
  /// devices (including the phone) in all studies running on this client
  /// (every 5 minutes).
  @override
  Future<void> configure({
    DeploymentService? deploymentService,
    DeviceDataCollectorFactory? deviceController,
    DeviceRegistration? registration,
    bool enableNotifications = true,
    NotificationController? notificationController,
    bool askForPermissions = true,
    bool heartbeat = true,
  }) async {
    // initialize misc device settings
    await DeviceInfo().init();
    await Settings().init();
    await Persistence().init();

    // create and register the built-in data managers
    DataManagerRegistry().register(ConsoleDataManagerFactory());
    DataManagerRegistry().register(FileDataManagerFactory());
    DataManagerRegistry().register(SQLiteDataManagerFactory());

    // create the device registration using the [DeviceInfo] singleton
    registration ??= DefaultDeviceRegistration(
      deviceId: DeviceInfo().deviceID,
      deviceDisplayName: DeviceInfo().toString(),
    );

    // initialize default services, if not specified
    deploymentService ??= SmartphoneDeploymentService();
    deviceController ??= DeviceController();
    if (enableNotifications) {
      _notificationController =
          notificationController ?? AwesomeNotificationController();
    }
    _heartbeat = heartbeat;

    // initialize the app task controller singleton
    await AppTaskController()
        .initialize(enableNotifications: enableNotifications);

    // setting up permissions
    if (askForPermissions) await askForAllPermissions();

    super.configure(
      deploymentService: deploymentService,
      deviceController: deviceController,
      registration: registration,
    );

    // look up and register all connected devices and services on this client
    this.deviceController.registerAllAvailableDevices();

    print('===========================================================');
    print('  CARP Mobile Sensing (CAMS) - $runtimeType');
    print('===========================================================');
    print('             device : ${registration.deviceDisplayName}');
    print(' deployment service : ${this.deploymentService}');
    print('  device controller : ${this.deviceController}');
    print('  available devices : ${this.deviceController.devicesToString()}');
    print(
        '        persistence : ${Persistence().databaseName.split('/').last}');
    print('===========================================================');

    _state = ClientManagerState.configured;
  }

  @override
  Future<Study> addStudy(
    String studyDeploymentId,
    String deviceRoleName,
  ) async {
    Study study = await super.addStudy(
      studyDeploymentId,
      deviceRoleName,
    );

    // always create a new controller
    final controller =
        SmartphoneDeploymentController(deploymentService!, deviceController);
    repository[study] = controller;
    _group.add(controller.measurements);

    await controller.addStudy(
      study,
      registration!,
    );
    info('$runtimeType - Added study: $study');

    return study;
  }

  /// Create and add a study based on the [protocol] which needs to be executed on
  /// this client.
  ///
  /// This is similar to the [addStudy] method, but the [protocol] is deployed
  /// immediately.
  ///
  /// Returns the newly added study.
  Future<Study> addStudyProtocol(StudyProtocol protocol) async {
    assert(deploymentService != null,
        'Deployment Service has not been configured. Call configure() first.');

    final status = await deploymentService!.createStudyDeployment(protocol);
    return await addStudy(
      status.studyDeploymentId,
      status.primaryDeviceStatus!.device.roleName,
    );
  }

  @override
  SmartphoneDeploymentController? getStudyRuntime(Study study) =>
      repository[study] as SmartphoneDeploymentController;

  @override
  Future<void> removeStudy(Study study) async {
    info('Removing study from $runtimeType - $study');
    AppTaskController().removeStudyDeployment(study.studyDeploymentId);
    await deviceController.disconnectAllConnectedDevices();
    await super.removeStudy(study);
  }

  /// Asking for all permissions needed for the included sampling packages.
  ///
  /// Should be called before sensing is started, if not already done as part of
  /// [configure].
  Future<void> askForAllPermissions() async {
    if (SamplingPackageRegistry().permissions.isNotEmpty) {
      info('Asking for permission for all measure types.');
      permissions = await SamplingPackageRegistry().permissions.request();

      for (var permission in SamplingPackageRegistry().permissions) {
        PermissionStatus status = await permission.status;
        info('Permissions for $permission : $status');
      }
    }
  }

  /// Called when this client manager is being (re-)activated by the OS.
  ///
  /// Implementations of this method should start with a call to the inherited
  /// method, as in `super.activate()`.
  @protected
  @mustCallSuper
  void activate() {}

  /// Called when this client manager is being deactivated and potentially
  /// stopped by the OS.
  ///
  /// Implementations of this method should start with a call to the inherited
  /// method, as in `super.deactivate()`.
  @protected
  @mustCallSuper
  Future<void> deactivate() async {
    for (var study in studies) {
      await getStudyRuntime(study)?.saveDeployment();
    }
  }

  /// Start all studies in this client manager.
  void start() {
    for (var study in studies) {
      getStudyRuntime(study)?.start();
    }
    _state = ClientManagerState.started;
  }

  /// Stop all studies in this client manager.
  Future<void> stop() async {
    for (var study in studies) {
      await getStudyRuntime(study)?.stop();
    }
    _state = ClientManagerState.stopped;
  }

  /// Restore and resume all study deployments which were running on this
  /// client manager when the app was killed / stopped (e.g., by the OS).
  ///
  /// This method is useful on app restart, since it will restore and
  /// resume all sampling on this client.
  /// Data sampling will be resumed for studies which were running
  /// (i.e., having [StudyStatus.Running]) when the app was closed.
  ///
  /// Returns the number of restored studies, if any (may be zero).
  /// To access a list of resumed studies, use [studies] after this
  /// resume method has ended.
  Future<int> resume() async {
    info('$runtimeType - restoring all study deployments');
    var persistentStudies = await Persistence().getAllStudyDeployments();

    debug('$runtimeType - studies: $persistentStudies');

    for (var study in persistentStudies) {
      debug('$runtimeType - study status: ${study.status}');

      // only add deployed, running or stopped studies
      if (study.status == StudyStatus.Deployed ||
          study.status == StudyStatus.Running ||
          study.status == StudyStatus.Stopped) {
        var newStudy =
            await addStudy(study.studyDeploymentId, study.deviceRoleName);
        newStudy.status = study.status;
        final controller = getStudyRuntime(study);

        // deploy the study using the cached deployment
        await controller?.tryDeployment(useCached: true);
        await controller?.configure();

        // if this study was running when the app was closed, restart sampling
        if (study.status == StudyStatus.Running) controller?.start();
      }
    }
    _state = ClientManagerState.started;
    return studyCount;
  }

  /// Called when this client is disposed permanently.
  ///
  /// When this method is called, the client is never used again. It is an error
  /// to call any of the [start] or [stop] methods at this point.
  ///
  /// Subclasses should override this method to release any resources retained
  /// by this client.
  /// Implementations of this method should end with a call to the inherited
  /// method, as in `super.dispose()`.
  ///
  /// See also:
  ///
  ///  * [deactivate], which is called prior to [dispose].
  @mustCallSuper
  void dispose() {
    deactivate();
    for (var study in studies) {
      getStudyRuntime(study)?.dispose();
    }
    _group.close();
    Persistence().close();
    _state = ClientManagerState.disposed;
  }

  /// Called when the system puts the app in the background or returns
  /// the app to the foreground.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    debug('$runtimeType - App lifecycle state changed: $state');
    switch (state) {
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.hidden:
      case AppLifecycleState.detached:
        deactivate();
        break;
      case AppLifecycleState.resumed:
        activate();
        break;
    }
  }
}
