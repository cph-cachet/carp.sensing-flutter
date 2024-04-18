/*
 * Copyright 2018-2023 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of 'runtime.dart';

/// A [SmartphoneDeploymentController] controls the execution of a [SmartphoneDeployment].
class SmartphoneDeploymentController extends StudyRuntime<DeviceRegistration> {
  int _samplingSize = 0;
  DataManager? _dataManager;
  DataEndPoint? _dataEndPoint;
  final SmartphoneDeploymentExecutor _executor = SmartphoneDeploymentExecutor();
  late DataTransformer _transformer;

  @override
  SmartphoneDeployment? get deployment =>
      super.deployment as SmartphoneDeployment?;

  @override
  DeviceController get deviceRegistry =>
      super.deviceRegistry as DeviceController;

  /// The executor executing the [deployment].
  SmartphoneDeploymentExecutor get executor => _executor;

  /// The configuration of the data endpoint, i.e. how data is saved or uploaded.
  DataEndPoint? get dataEndPoint => _dataEndPoint;

  /// The data manager responsible for handling the data collected by this controller.
  DataManager? get dataManager => _dataManager;

  /// The privacy schema used to encrypt data before upload.
  String get privacySchemaName =>
      deployment?.privacySchemaName ?? NameSpace.CARP;

  /// The transformer used to transform data before upload.
  DataTransformer get transformer => _transformer;

  /// The stream of all sampled measurements.
  ///
  /// Data in the [measurements] stream are transformed in the following order:
  ///   1. privacy schema as specified in the [privacySchemaName]
  ///   2. preferred data format as specified by [dataFormat] in the
  ///      [SmartphoneDeployment.dataEndPoint]
  ///   3. any custom [transformer] provided in the [configure] method when
  ///      configuring this controller
  ///
  /// This is a broadcast stream and supports multiple subscribers.
  Stream<Measurement> get measurements =>
      _executor.measurements.map((measurement) => measurement
        ..data = _transformer(DataTransformerSchemaRegistry()
            .lookup(deployment?.dataEndPoint?.dataFormat ?? NameSpace.CARP)!
            .transform(DataTransformerSchemaRegistry()
                .lookup(privacySchemaName)!
                .transform(measurement.data))));

  /// A stream of all [measurements] of a specific data [type].
  Stream<Measurement> measurementsByType(String type) => measurements
      .where((measurement) => measurement.data.format.toString() == type);

  /// The sampling size of this [deployment] in terms of number of [Measurement]
  /// that has been collected since sampling was started.
  /// Note that this number is not persistent, and the counter hence resets
  /// across app restart.
  int get samplingSize => _samplingSize;

  /// Create a new [SmartphoneDeploymentController] to control the runtime behavior
  /// of a study deployment.
  SmartphoneDeploymentController(super.deploymentService, super.deviceRegistry);

  /// Verifies whether the primary device is ready for deployment and in case
  /// it is, deploy the [study] previously added.
  ///
  /// If [useCached] is true (default), a previously cached [deployment] will be
  /// retrieved from the phone locally.
  /// If [useCached] is false, the [deployment] will be retrieved from the
  /// [deploymentService], based on the [study].
  ///
  /// In case already deployed, nothing happens and the current [status] is returned.
  @override
  Future<StudyStatus> tryDeployment({bool useCached = true}) async {
    assert(
        study != null,
        'Cannot deploy without a valid study deployment id and device role name. '
        "Call 'addStudy()' or 'addStudyProtocol()' first.");

    info('$runtimeType - trying to deploy study: $study');
    if (useCached) {
      // restore the deployment and app task queue
      bool success = await restoreDeployment();
      if (success) {
        await AppTaskController().restoreQueue();
        return status = deployment?.status ?? StudyStatus.Deployed;
      }
    }

    // if no cache, get the deployment from the deployment service
    // and save a local cache
    status = await super.tryDeployment();
    debug('$runtimeType - got deployment: $deployment');
    if (status == StudyStatus.Deployed && deployment != null) {
      deployment!.deployed = DateTime.now().toUtc();
      // if no user is specified for this study, look up the local user id
      deployment!.userId ??= await Settings().userId;
      deployment?.status = status;
      await saveDeployment();
    }

    return status;
  }

  /// Save the [deployment] persistently to a cache.
  /// Returns `true` if successful.
  Future<bool> saveDeployment() async => (deployment != null)
      ? await Persistence().saveDeployment(deployment!)
      : false;

  /// Restore the [deployment] from a local cache.
  /// Returns `true` if successful.
  Future<bool> restoreDeployment() async => (studyDeploymentId != null)
      ? (deployment =
              await Persistence().restoreDeployment(studyDeploymentId!)) !=
          null
      : false;

  /// Erase study deployment information cached locally on this phone.
  Future<void> eraseDeployment() async {
    if (studyDeploymentId == null) return;

    try {
      info("Erasing deployment cache for deployment '$studyDeploymentId'.");
      await Persistence().eraseDeployment(studyDeploymentId!);

      final name = await Settings().getCacheBasePath(studyDeploymentId!);
      await File(name).delete(recursive: true);
    } catch (exception) {
      warning('Failed to delete deployment - $exception');
    }
  }

  /// Configure this [SmartphoneDeploymentController].
  ///
  /// Must be called after a deployment is ready using [tryDeployment] and
  /// before [start] is called.
  ///
  /// The [dataEndPoint] parameter is a custom [DataEndPoint] specifying where to save
  /// or upload data. If not specified, the endpoint specified in the study deployment
  /// ([deployment.dataEndPoint]) which originates from the study protocol is used.
  /// If no data endpoint is specified in the study protocol either, then no data
  /// management is done, but sensing  can still be started. This is useful for
  /// apps that wants to use the framework for in-app consumption of sensing
  /// events without saving the data.
  ///
  /// The [transformer] is a generic [DataTransformer] function which transform
  /// each collected measurement. If not specified, a 1:1 mapping is done,
  /// i.e. no transformation.
  Future<void> configure({
    DataEndPoint? dataEndPoint,
    DataTransformer? transformer,
  }) async {
    assert(deployment != null,
        'Cannot configure a StudyDeploymentController without a deployment.');
    assert(deployment is SmartphoneDeployment,
        'A StudyDeploymentController can only work with a SmartphoneDeployment device deployment');
    info('Configuring $runtimeType');

    // initialize all devices from the primary deployment, incl. this smartphone.
    initializeDevices();

    // try to register relevant connected devices
    super.tryRegisterRemainingDevicesToRegister();

    // initialize optional parameters
    _dataEndPoint = dataEndPoint ?? deployment!.dataEndPoint;
    _transformer = transformer ?? ((data) => data);

    if (_dataEndPoint != null) {
      _dataManager = DataManagerRegistry().create(_dataEndPoint!.type);
    }

    if (_dataManager == null) {
      warning(
          "No data manager for the specified data endpoint found: '${deployment?.dataEndPoint}'.");
    }

    // initialize the data manager, device registry, and study executor
    await _dataManager?.initialize(
      deployment!.dataEndPoint!,
      deployment!,
      measurements,
    );

    // initialize the executor, which recursively initializes all executors and probes
    _executor.initialize(deployment!, deployment!);

    // Connect to all connectable devices, incl. this phone.
    // (Re-)connecting a device will trigger that sampling is (re)started
    await connectAllConnectableDevices();

    // start heartbeat monitoring
    if (SmartPhoneClientManager().heartbeat) startHeartbeatMonitoring();

    measurements.listen((_) => _samplingSize++);
    status = StudyStatus.Deployed;

    print('===============================================================');
    print('  CARP Mobile Sensing (CAMS) - $runtimeType');
    print('===============================================================');
    print(' deployment id : ${deployment!.studyDeploymentId}');
    print(' deployed time : ${deployment!.deployed}');
    print('     role name : ${deployment!.deviceConfiguration.roleName}');
    print('       user id : ${deployment!.userId}');
    print('      platform : ${DeviceInfo().platform.toString()}');
    print('     device ID : ${DeviceInfo().deviceID.toString()}');
    print(' data endpoint : $_dataEndPoint');
    print('  data manager : $_dataManager');
    print('        status : ${status.toString().split('.').last}');
    print('===============================================================');
  }

  /// Initialize all devices in this [deployment].
  void initializeDevices() {
    assert(deployment != null, 'Deployment is null.');

    for (var configuration in deployment!.devices) {
      initializeDevice(configuration);
    }
  }

  /// Initialize the device specified in the [configuration].
  void initializeDevice(DeviceConfiguration configuration) {
    if (deviceRegistry.hasDevice(configuration.type)) {
      deviceRegistry.devices[configuration.type]?.initialize(configuration);
    } else {
      warning(
          "A device of type '${configuration.type}' is not available on this device. "
          "This may be because this device is not available on this operating system. "
          "Or it may be because the sampling package containing this device has not been "
          "registered in the SamplingPackageRegistry.");
    }
  }

  /// Start heartbeat monitoring for all devices, incl. the phone, for the
  /// [deployment] controlled by this controller.
  void startHeartbeatMonitoring() {
    for (var configuration in deployment!.devices) {
      deviceRegistry
          .getDevice(configuration.type)
          ?.startHeartbeatMonitoring(this);
    }
  }

  /// Connect all connectable devices to be used in the [deployment]
  /// and which are available on this phone.
  Future<void> connectAllConnectableDevices() async {
    assert(deployment != null, 'Deployment is null.');

    debug('$runtimeType - Trying to connect to all connectable devices.');

    // connect all the connected devices and the primary device (i.e. this phone)
    for (var configuration in deployment!.devices) {
      var device = deviceRegistry.getDevice(configuration.type);
      if (device != null && await device.canConnect()) await device.connect();
    }
  }

  /// Start this controller.
  ///
  /// If [start] is true, immediately start data collection
  /// according to the parameters specified in [configure].
  ///
  /// [configure] must be called before starting sampling.
  @override
  void start([bool start = true]) {
    // if this study has not yet been deployed, do this first.
    if (status.index < StudyStatus.Deployed.index) {
      tryDeployment().then((value) {
        configure().then((value) {
          super.start();
          if (start) _executor.start();
        });
      });
    } else {
      super.start();
      if (start) _executor.start();
    }
    info(
        '$runtimeType - Starting data sampling for study deployment: ${deployment?.studyDeploymentId}');
  }

  /// Stop this controller and data sampling.
  @override
  Future<void> stop() async {
    info('$runtimeType - Stopping data sampling...');
    _executor.stop();
    super.stop();
  }

  /// Remove a study from this [SmartphoneDeploymentController].
  ///
  /// This entails:
  ///   * stopping data sampling
  ///   * closing the data manager (e.g., flushing data to a file)
  ///   * erasing any locally cached deployment information
  ///
  /// Note that only cached deployment information is deleted. Any data sampled
  /// from this deployment will remain on the phone.
  ///
  /// If the same deployment is deployed again, it will start on a fresh start
  /// and not use old deployment information. This means, for example,
  /// that any [OneTimeTrigger] will trigger again, since it is considered to
  /// be a new deployment.
  @override
  Future<void> remove() async {
    info('$runtimeType - Removing deployment from this smartphone...');
    executor.stop();
    await dataManager?.close();

    await eraseDeployment();
    await super.remove();
  }

  /// Called when this controller is disposed permanently.
  ///
  /// When this method is called, the controller is never used again. It is an error
  /// to call any of the [start] or [stop] methods at this point.
  @mustCallSuper
  @override
  void dispose() {
    info('$runtimeType - Disposing ...');
    saveDeployment();
    executor.stop();
    dataManager?.close().then((_) => super.dispose());
  }
}
