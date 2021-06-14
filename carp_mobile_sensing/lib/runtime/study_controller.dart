/*
 * Copyright 2018-2021 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */
part of runtime;

/// A [StudyDeploymentController] controls the execution of a [CAMSMasterDeviceDeployment].
class StudyDeploymentController extends StudyRuntime {
  int _samplingSize = 0;
  DataManager _dataManager;
  // DataEndPoint _dataEndPoint;
  StudyDeploymentExecutor _executor;
  SamplingSchema _samplingSchema;
  String _privacySchemaName;
  DatumTransformer _transformer;

  /// The master device deployment running in this controller.
  CAMSMasterDeviceDeployment get masterDeployment =>
      deployment as CAMSMasterDeviceDeployment;

  /// The executor executing this [masterDeployment].
  StudyDeploymentExecutor get executor => _executor;

  /// The configuration of the data endpoint, i.e. how data is saved or uploaded.
  DataEndPoint get dataEndPoint => masterDeployment.dataEndPoint;

  /// The data manager responsible for handling the data collected by this controller.
  DataManager get dataManager => _dataManager;

  /// The privacy schema used to encrypt data before upload.
  String get privacySchemaName => _privacySchemaName;

  /// The permissions granted to this study from the OS.
  Map<Permission, PermissionStatus> permissions;

  /// The stream of all sampled data points.
  ///
  /// Data points in the [data] stream are transformed in the following order:
  ///   1. privacy schema as specified in the [_privacySchemaName]
  ///   2. preferred data format as specified by [dataFormat] in the [deployment]
  ///   3. any custom [_transformer] provided
  ///
  /// This is a broadcast stream and supports multiple subscribers.
  Stream<DataPoint> get data => _executor.data.map((dataPoint) => dataPoint
    ..data = _transformer(TransformerSchemaRegistry()
        .lookup(masterDeployment.dataEndPoint.dataFormat)
        .transform(TransformerSchemaRegistry()
            .lookup(_privacySchemaName)
            .transform(dataPoint.data))));

  PowerAwarenessState powerAwarenessState = NormalSamplingState.instance;

  /// The sampling size of this [deployment] in terms of number of [Datum] object
  /// that has been collected.
  int get samplingSize => _samplingSize;

  /// Create a new [StudyDeploymentController] to control the runtime behavior
  /// of this study [deployment].
  StudyDeploymentController() : super() {
    // initialize settings
    Settings().init();

    // create and register the two built-in data managers
    DataManagerRegistry().register(ConsoleDataManager());
    DataManagerRegistry().register(FileDataManager());
  }

  /// Configure this [StudyDeploymentController].
  /// Must be called only once, and before [resume] is called.
  /// This will/can also request permissions for all [SamplingPackage]s' permissions.
  ///
  /// A number of optional parameters can be specified:
  ///
  ///    * [samplingSchema] - custom [SamplingSchema], i.e. configuration of [Measure]s.
  ///      If not specified, [SamplingSchema.normal] with power-awareness is used.
  ///    * [dataEndPoint] - A specific [DataEndPoint] specifying where to save or upload data.
  ///      If not specified, the [MasterDeviceDeployment.dataEndPoint] is used.
  ///      If no data endpoint is found, then no data management
  ///      is done, but sensing can still be started. This is useful for apps
  ///      which wants to use the framework for in-app consumption of sensing
  ///      events without saving the data.
  ///    * [privacySchemaName] - the name of a [PrivacySchema].
  ///      Use [PrivacySchema.DEFAULT] for the default, built-in schema.
  ///      If  not specified, no privacy schema is used and data is saved as sensed.
  ///    * [transformer] - a generic [DatumTransformer] function which transform
  ///      each collected [Datum].
  ///      If not specified, a 1:1 mapping is done, i.e. no transformation.
  ///    * [askForPermissions] - automatically ask for permissions for all sampling
  ///      packages at once. Default to `true`. If you want the app to handle
  ///      permissions, set this to `false`.
  ///
  Future configure({
    SamplingSchema samplingSchema,
    DataEndPoint dataEndPoint,
    String privacySchemaName,
    DatumTransformer transformer,
    bool askForPermissions = true,
  }) async {
    assert(deployment != null,
        'Cannot configure a Study Controller without a deployment.');
    assert(deployment is CAMSMasterDeviceDeployment,
        'A CAMS study controller can only work with a CAMS Master Device Deployment');
    info('Configuring $runtimeType');

    _executor = StudyDeploymentExecutor(deployment);

    // initialize optional parameters
    _samplingSchema = samplingSchema ?? SamplingSchema.normal(powerAware: true);
    masterDeployment.dataEndPoint =
        dataEndPoint ?? masterDeployment.dataEndPoint;
    _privacySchemaName = privacySchemaName ?? NameSpace.CARP;
    _transformer = transformer ?? ((datum) => datum);

    if (masterDeployment.dataEndPoint != null) {
      _dataManager =
          DataManagerRegistry().lookup(masterDeployment.dataEndPoint.type);
    }

    if (_dataManager == null) {
      warning(
          "No data manager for the specified data endpoint found: '${masterDeployment.dataEndPoint}'.");
    }

    // if no user is specified for this study, look up the local user id
    masterDeployment.userId ??= await Settings().userId;

    // setting up permissions
    if (askForPermissions) {
      info('Asking for permission for all measure types.');
      permissions = await PermissionHandlerPlatform.instance
          .requestPermissions(SamplingPackageRegistry().permissions);
    }

    // check if needed permission are set
    SamplingPackageRegistry().permissions.forEach((permission) async {
      PermissionStatus status = await PermissionHandlerPlatform.instance
          .checkPermissionStatus(permission);
      if (status != PermissionStatus.granted) {
        warning(
            'Permissions not granted for $permission -  permission is $status');
      }
    });

    info(
        'CARP Mobile Sensing (CAMS) - Initializing Study Deployment Controller:');
    info('      study id : ${masterDeployment.studyId}');
    info(' deployment id : ${masterDeployment.studyDeploymentId}');
    info('    study name : ${masterDeployment.name}');
    info('          user : ${masterDeployment.userId}');
    info(' data endpoint : ${masterDeployment.dataEndPoint}');
    info('      platform : ${DeviceInfo().platform.toString()}');
    info('     device ID : ${DeviceInfo().deviceID.toString()}');
    info('  data manager : $_dataManager');
    info('       devices : ${DeviceController().devicesToString()}');

    if (samplingSchema != null) {
      // doing two adaptation is a bit of a hack; used to ensure that
      // restoration values are set to the specified sampling schema
      masterDeployment.adapt(samplingSchema, restore: false);
      masterDeployment.adapt(samplingSchema, restore: false);
    }

    // initialize the data manager, device registry, and study executor
    await _dataManager?.initialize(
      masterDeployment.studyDeploymentId,
      masterDeployment.dataEndPoint,
      data,
    );
    // await DeviceRegistry().initialize(deployment, data);
    _executor.initialize(Measure(type: CAMSDataType.EXECUTOR));
    await enablePowerAwareness();
    data.listen((dataPoint) => _samplingSize++);

    status = StudyRuntimeStatus.Configured;
  }

  final BatteryProbe _battery = BatteryProbe();

  /// Enable power-aware sensing in this study. See [PowerAwarenessState].
  Future enablePowerAwareness() async {
    if (_samplingSchema.powerAware) {
      info('Enabling power awareness ...');
      _battery.data.listen((dataPoint) {
        BatteryDatum batteryState = (dataPoint.data as BatteryDatum);
        if (batteryState.batteryStatus == BatteryDatum.STATE_DISCHARGING) {
          // only apply power-awareness if not charging.
          PowerAwarenessState newState =
              powerAwarenessState.adapt(batteryState.batteryLevel);
          if (newState != powerAwarenessState) {
            powerAwarenessState = newState;
            info(
                'PowerAware: Going to $powerAwarenessState, level ${batteryState.batteryLevel}%');
            masterDeployment.adapt(powerAwarenessState.schema);
          }
        }
      });
      _battery.initialize(Measure(
          type: DataType(NameSpace.CARP, DeviceSamplingPackage.BATTERY)
              .toString()));
      _battery.resume();
    }
  }

  /// Disable power-aware sensing.
  void disablePowerAwareness() => _battery.stop();

  /// Resume this controller, i.e. resume data collection according to the
  /// specified [deployment] and [_samplingSchema].
  void resume() {
    info('Resuming data sampling ...');
    super.resume();
    _executor.resume();
  }

  /// Pause this controller, which will pause data collection and close the
  /// data manager.
  void pause() {
    info('Pausing data sampling ...');
    super.pause();
    _executor.pause();
    _dataManager?.close();
  }

  /// Stop the sampling.
  ///
  /// Once a controller is stopped it **cannot** be (re)started.
  /// If a controller should be restarted, use the [pause] and [resume] methods.
  void stop() {
    info('Stopping data sampling ...');
    disablePowerAwareness();
    _dataManager?.close();
    _executor.stop();
    super.stop();
  }
}

// /// Enumerates the stat a [StudyDeploymentController] can be in.
// enum StudyDeploymentControllerState {
//   unknown,
//   created,
//   initialized,
//   resumed,
//   paused,
//   stopped,
// }

/// This default power-awareness schema operates with four power states:
///
///
///       0%   10%        30%        50%                         100%
///       +-----+----------+----------+----------------------------+
///        none   minimum     light              normal
///
abstract class PowerAwarenessState {
  static const int LIGHT_SAMPLING_LEVEL = 50;
  static const int MINIMUM_SAMPLING_LEVEL = 30;
  static const int NO_SAMPLING_LEVEL = 10;

  static PowerAwarenessState instance;

  PowerAwarenessState adapt(int level);
  SamplingSchema get schema;
}

class NoSamplingState implements PowerAwarenessState {
  static NoSamplingState instance = NoSamplingState();

  PowerAwarenessState adapt(int level) {
    if (level > PowerAwarenessState.NO_SAMPLING_LEVEL) {
      return MinimumSamplingState.instance;
    } else {
      return NoSamplingState.instance;
    }
  }

  SamplingSchema get schema => SamplingPackageRegistry().none();

  String toString() => 'Disabled Sampling Mode';
}

class MinimumSamplingState implements PowerAwarenessState {
  static MinimumSamplingState instance = MinimumSamplingState();

  PowerAwarenessState adapt(int level) {
    if (level < PowerAwarenessState.NO_SAMPLING_LEVEL) {
      return NoSamplingState.instance;
    } else if (level > PowerAwarenessState.MINIMUM_SAMPLING_LEVEL) {
      return LightSamplingState.instance;
    } else {
      return MinimumSamplingState.instance;
    }
  }

  SamplingSchema get schema => SamplingPackageRegistry().minimum();

  String toString() => 'Minimun Sampling Mode';
}

class LightSamplingState implements PowerAwarenessState {
  static LightSamplingState instance = LightSamplingState();

  PowerAwarenessState adapt(int level) {
    if (level < PowerAwarenessState.MINIMUM_SAMPLING_LEVEL) {
      return MinimumSamplingState.instance;
    } else if (level > PowerAwarenessState.LIGHT_SAMPLING_LEVEL) {
      return NormalSamplingState.instance;
    } else {
      return LightSamplingState.instance;
    }
  }

  SamplingSchema get schema => SamplingPackageRegistry().light();

  String toString() => 'Light Sampling Mode';
}

class NormalSamplingState implements PowerAwarenessState {
  static NormalSamplingState instance = NormalSamplingState();

  PowerAwarenessState adapt(int level) {
    if (level < PowerAwarenessState.LIGHT_SAMPLING_LEVEL) {
      return LightSamplingState.instance;
    } else {
      return NormalSamplingState.instance;
    }
  }

  SamplingSchema get schema => SamplingSchema.normal();

  String toString() => 'Normal Sampling Mode';
}
