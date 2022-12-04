/*
 * Copyright 2018-2022 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */
part of runtime;

/// A [SmartphoneDeploymentController] controls the execution of a [SmartphoneDeployment].
class SmartphoneDeploymentController extends StudyRuntime {
  int _samplingSize = 0;
  DataManager? _dataManager;
  DataEndPoint? _dataEndPoint;
  SmartphoneDeploymentExecutor? _executor;
  String _privacySchemaName = NameSpace.CARP;
  late DataTransformer _transformer;

  @override
  SmartphoneDeployment? get deployment =>
      super.deployment as SmartphoneDeployment?;

  @override
  DeviceController get deviceRegistry =>
      super.deviceRegistry as DeviceController;

  /// The executor executing the [deployment].
  SmartphoneDeploymentExecutor? get executor => _executor;

  /// The configuration of the data endpoint, i.e. how data is saved or uploaded.
  DataEndPoint? get dataEndPoint => _dataEndPoint;

  /// The data manager responsible for handling the data collected by this controller.
  DataManager? get dataManager => _dataManager;

  /// The privacy schema used to encrypt data before upload.
  String get privacySchemaName => _privacySchemaName;

  /// The transformer used to transform data before upload.
  DataTransformer get transformer => _transformer;

  /// The permissions granted to this study from the OS.
  Map<Permission, PermissionStatus>? permissions;

  /// The stream of all sampled measurements.
  ///
  /// Measures in the [measurements] stream are transformed in the following order:
  ///   1. privacy schema as specified in the [privacySchemaName]
  ///   2. preferred data format as specified by [dataFormat] in the [SmartphoneDeployment.dataEndPoint]
  ///   3. any custom [transformer] provided
  ///
  /// This is a broadcast stream and supports multiple subscribers.
  Stream<Measurement> get measurements =>
      _executor!.measurements.map((measurement) => measurement
        ..data = _transformer(TransformerSchemaRegistry()
            .lookup(deployment?.dataEndPoint?.dataFormat ?? NameSpace.CARP)!
            .transform(TransformerSchemaRegistry()
                .lookup(privacySchemaName)!
                .transform(measurement.data))));

  /// A stream of all [measurements] of a specific data [type].
  Stream<Measurement> measurementsByType(String type) => measurements
      .where((measurement) => measurement.data.format.toString() == type);

  // PowerAwarenessState powerAwarenessState = NormalSamplingState.instance;

  /// The sampling size of this [deployment] in terms of number of [Measurement]
  /// that has been collected.
  int get samplingSize => _samplingSize;

  /// Create a new [SmartphoneDeploymentController] to control the runtime behavior
  /// of a study deployment.
  SmartphoneDeploymentController(super.deploymentService, super.deviceRegistry);

  /// Verifies whether the master device is ready for deployment and in case
  /// it is, deploy the [study] previously added.
  ///
  /// If [useCached] is true (default), a previously cached [deployment] will be
  /// retrieved from the phone locally.
  /// If [useCached] is false, the [deployment] will be retrieved from the
  /// [deploymentService], based on the [study].
  ///
  /// In case already deployed, nothing happens.
  @override
  Future<StudyStatus> tryDeployment({bool useCached = true}) async {
    assert(
        study != null,
        'Cannot deploy without a valid study deployment id and device role name. '
        "Call 'initialize()' first.");

    // check cache
    if (useCached) {
      bool success = await restoreDeployment();
      if (success) {
        status = StudyStatus.Deployed;
        return status;
      }
    }

    // if no cache, get the deployment from the deployment service
    // and save a local cache
    status = await super.tryDeployment();
    if (status == StudyStatus.Deployed) deployment!.deployed = DateTime.now();
    // if no user is specified for this study, look up the local user id
    deployment!.userId ??= await Settings().userId;
    await saveDeployment();

    return status;
  }

  /// Save the [deployment] persistently to a cache.
  /// Returns `true` if successful.
  Future<bool> saveDeployment() async => (deployment != null)
      ? await Persistence().saveDeployment(deployment!)
      : false;

  /// Restore the [deployment] from a local file cache.
  /// Returns `true` if successful.
  Future<bool> restoreDeployment() async => (studyDeploymentId != null)
      ? (deployment =
              await Persistence().restoreDeployment(studyDeploymentId!)) !=
          null
      : false;

  /// Configure this [SmartphoneDeploymentController].
  ///
  /// Must be called after a deployment is ready using [tryDeployment] and
  /// before [start] is called.
  ///
  /// Can request permissions for all [SamplingPackage]s' permissions.
  ///
  /// A number of optional parameters can be specified:
  ///
  ///    * [dataEndPoint] - A specific [DataEndPoint] specifying where to save or upload data.
  ///      If not specified, the [MasterDeviceDeployment.dataEndPoint] is used.
  ///      If no data endpoint is found, then no data management
  ///      is done, but sensing can still be started. This is useful for apps
  ///      which wants to use the framework for in-app consumption of sensing
  ///      events without saving the data.
  ///    * [privacySchemaName] - the name of a [PrivacySchema].
  ///      Use [PrivacySchema.DEFAULT] for the default, built-in schema.
  ///      If  not specified, no privacy schema is used and data is saved as collected.
  ///    * [transformer] - a generic [DataTransformer] function which transform
  ///      each collected data item. If not specified, a 1:1 mapping is done,
  ///      i.e. no transformation.
  ///    * [askForPermissions] - automatically ask for permissions for all sampling
  ///      packages at once. Default to `true`. If you want the app to handle
  ///      permissions, set this to `false`.
  ///    * [enableNotifications] - should notification be enabled and send to the user
  ///      when an app task is triggered?
  ///
  Future<void> configure({
    DataEndPoint? dataEndPoint,
    String privacySchemaName = NameSpace.CARP,
    DataTransformer? transformer,
    bool askForPermissions = true,
    bool enableNotifications = true,
  }) async {
    assert(deployment != null,
        'Cannot configure a StudyDeploymentController without a deployment.');
    assert(deployment is SmartphoneDeployment,
        'A StudyDeploymentController can only work with a SmartphoneDeployment master device deployment');
    info('Configuring $runtimeType');

    // initialize all devices from the master deployment, incl. this master device
    deviceRegistry.initializeDevices(deployment!);

    // initialize the app task controller singleton
    await AppTaskController()
        .initialize(deployment!, enableNotifications: enableNotifications);

    _executor = SmartphoneDeploymentExecutor();

    // initialize optional parameters
    _dataEndPoint = dataEndPoint ?? deployment!.dataEndPoint;
    _privacySchemaName = privacySchemaName;
    _transformer = transformer ?? ((data) => data);

    if (_dataEndPoint != null) {
      _dataManager = DataManagerRegistry().lookup(_dataEndPoint!.type);
    }

    if (_dataManager == null) {
      warning(
          "No data manager for the specified data endpoint found: '${deployment?.dataEndPoint}'.");
    }

    // setting up permissions
    if (askForPermissions) await askForAllPermissions();

    // initialize the data manager, device registry, and study executor
    await _dataManager?.initialize(
      deployment!,
      deployment!.dataEndPoint!,
      measurements,
    );

    // connect to all connectable devices, incl. this phone
    await deviceRegistry.connectAllConnectableDevices();

    _executor!.initialize(deployment!, deployment!);
    // await enablePowerAwareness();
    measurements.listen((dataPoint) => _samplingSize++);

    status = StudyStatus.Deployed;

    print('===============================================================');
    print('  CARP Mobile Sensing (CAMS) - $runtimeType');
    print('===============================================================');
    print(' deployment id : ${deployment!.studyDeploymentId}');
    print(' deployed time : ${deployment!.deployed}');
    print('       user id : ${deployment!.userId}');
    print('      platform : ${DeviceInfo().platform.toString()}');
    print('     device ID : ${DeviceInfo().deviceID.toString()}');
    print('  data manager : $_dataManager');
    print(' data endpoint : $_dataEndPoint');
    print('        status : ${status.toString().split('.').last}');
    print('===============================================================');
  }

  // final BatteryProbe _battery = BatteryProbe();

  // /// Enable power-aware sensing in this study. See [PowerAwarenessState].
  // Future<void> enablePowerAwareness() async {
  //   if (_samplingSchema.powerAware) {
  //     info('Enabling power awareness ...');
  //     _battery.data.listen((dataPoint) {
  //       BatteryDatum batteryState = (dataPoint.data as BatteryDatum);
  //       if (batteryState.batteryStatus == BatteryDatum.STATE_DISCHARGING) {
  //         // only apply power-awareness if not charging.
  //         PowerAwarenessState newState =
  //             powerAwarenessState.adapt(batteryState.batteryLevel);
  //         if (newState != powerAwarenessState) {
  //           powerAwarenessState = newState;
  //           info(
  //               'PowerAware: Going to $powerAwarenessState, level ${batteryState.batteryLevel}%');
  //           deployment!.adapt(powerAwarenessState.schema);
  //         }
  //       }
  //     });
  //     _battery.initialize(Measure(
  //         type: DataType(NameSpace.CARP, DeviceSamplingPackage.BATTERY)
  //             .toString()));
  //     _battery.resume();
  //   }
  // }

  // /// Disable power-aware sensing.
  // void disablePowerAwareness() => _battery.stop();

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

  /// Start this controller and if [start] is true, start data collection
  /// according to the parameters specified in [configure].
  ///
  /// [configure] must be called before starting sampling.
  @override
  void start([bool start = true]) {
    assert(
        _executor != null,
        '$runtimeType - Cannot start this controller, since the the runtime is not initialized. '
        'Call the configure() method first.');

    info('$runtimeType - Starting data sampling ...');
    super.start();
    if (start) _executor!.start();
  }

  /// Stop the sampling.
  @override
  void stop() {
    info('$runtimeType - Stopping data sampling ...');
    _executor!.stop();
    super.stop();
  }

  /// Called when this controller is disposed permanently.
  ///
  /// When this method is called, the controller is never used again. It is an error
  /// to call any of the [start] or [stop] methods at this point.
  @protected
  @mustCallSuper
  void dispose() {
    info('$runtimeType - Disposing ...');
    saveDeployment();
    stop();
    dataManager?.close();
  }
}

// /// This default power-awareness schema operates with four power states:
// ///
// ///
// ///       0%   10%        30%        50%                         100%
// ///       +-----+----------+----------+----------------------------+
// ///        none   minimum     light              normal
// ///
// abstract class PowerAwarenessState {
//   static const int LIGHT_SAMPLING_LEVEL = 50;
//   static const int MINIMUM_SAMPLING_LEVEL = 30;
//   static const int NO_SAMPLING_LEVEL = 10;

//   static PowerAwarenessState? instance;

//   PowerAwarenessState adapt(int? level);
//   SamplingSchema get schema;
// }

// class NoSamplingState implements PowerAwarenessState {
//   static NoSamplingState instance = NoSamplingState();

//   PowerAwarenessState adapt(int? level) {
//     if (level! > PowerAwarenessState.NO_SAMPLING_LEVEL) {
//       return MinimumSamplingState.instance;
//     } else {
//       return NoSamplingState.instance;
//     }
//   }

//   SamplingSchema get schema => SamplingPackageRegistry().none;

//   String toString() => 'Disabled Sampling Mode';
// }

// class MinimumSamplingState implements PowerAwarenessState {
//   static MinimumSamplingState instance = MinimumSamplingState();

//   PowerAwarenessState adapt(int? level) {
//     if (level! < PowerAwarenessState.NO_SAMPLING_LEVEL) {
//       return NoSamplingState.instance;
//     } else if (level > PowerAwarenessState.MINIMUM_SAMPLING_LEVEL) {
//       return LightSamplingState.instance;
//     } else {
//       return MinimumSamplingState.instance;
//     }
//   }

//   SamplingSchema get schema => SamplingPackageRegistry().minimum;

//   String toString() => 'Minimun Sampling Mode';
// }

// class LightSamplingState implements PowerAwarenessState {
//   static LightSamplingState instance = LightSamplingState();

//   PowerAwarenessState adapt(int? level) {
//     if (level! < PowerAwarenessState.MINIMUM_SAMPLING_LEVEL) {
//       return MinimumSamplingState.instance;
//     } else if (level > PowerAwarenessState.LIGHT_SAMPLING_LEVEL) {
//       return NormalSamplingState.instance;
//     } else {
//       return LightSamplingState.instance;
//     }
//   }

//   SamplingSchema get schema => SamplingPackageRegistry().light;

//   String toString() => 'Light Sampling Mode';
// }

// class NormalSamplingState implements PowerAwarenessState {
//   static NormalSamplingState instance = NormalSamplingState();

//   PowerAwarenessState adapt(int? level) {
//     if (level! < PowerAwarenessState.LIGHT_SAMPLING_LEVEL) {
//       return LightSamplingState.instance;
//     } else {
//       return NormalSamplingState.instance;
//     }
//   }

//   SamplingSchema get schema => SamplingSchema.normal();

//   String toString() => 'Normal Sampling Mode';
// }
