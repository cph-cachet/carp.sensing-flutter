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

  CAMSMasterDeviceDeployment get masterDeployment =>
      deployment as CAMSMasterDeviceDeployment;
  StudyDeploymentExecutor executor;
  DataManager dataManager;
  SamplingSchema samplingSchema;
  String privacySchemaName;
  DatumTransformer transformer;

  /// The permissions granted to this study from the OS.
  Map<Permission, PermissionStatus> permissions;

  /// The stream of all sampled data points.
  ///
  /// Data points in the [data] stream are transformed in the following order:
  ///   1. privacy schema as specified in the [privacySchemaName]
  ///   2. preferred data format as specified by [dataFormat] in the [deployment]
  ///   3. any custom [transformer] provided
  ///
  /// This is a broadcast stream and supports multiple subscribers.
  @override
  Stream<DataPoint> get data => executor.data.map((dataPoint) => dataPoint
    ..data = transformer(TransformerSchemaRegistry()
        .lookup(masterDeployment.dataFormat)
        .transform(TransformerSchemaRegistry()
            .lookup(privacySchemaName)
            .transform(dataPoint.data))));

  PowerAwarenessState powerAwarenessState = NormalSamplingState.instance;

  /// The sampling size of this [deployment] in terms of number of [Datum] object
  /// that has been collected.
  int get samplingSize => _samplingSize;

  /// Create a new [StudyDeploymentController] to control the runtime behavior
  /// of this study [deployment].
  StudyDeploymentController() : super() {
    // initialize settings
    settings.init();

    // create and register the two built-in data managers
    DataManagerRegistry().register(ConsoleDataManager());
    DataManagerRegistry().register(FileDataManager());
  }

  /// Configure this controller.
  /// Must be called only once, and before [resume] is called.
  ///
  /// A number of optional parameters can be specified:
  ///    * A specific [samplingSchema] can be used.
  ///      If null, [SamplingSchema.normal] with power-awareness is used.
  ///    * A specific [dataManager] can be provided.
  ///      If null, a [DataManager] will be looked up in the
  ///      [DataManagerRegistry] based on the type of the study's [DataEndPoint].
  ///      If no data manager is found in the registry, then no data management
  ///      is done, but sensing can still be started. This is useful for apps
  ///      which wants to use the framework for in-app consumption of sensing
  ///      events without saving the data.
  ///    * The name of a [PrivacySchema] can be provided in [privacySchemaName].
  ///      Use [PrivacySchema.DEFAULT] for the default, built-in schema.
  ///      If null, no privacy schema is used.
  ///    * A generic [transformer] can be provided which transform each collected data.
  ///      If null, a 1:1 mapping is done, i.e. no transformation.
  ///
  Future configure({
    SamplingSchema samplingSchema,
    DataManager dataManager,
    String privacySchemaName,
    DatumTransformer transformer,
  }) async {
    assert(deployment != null,
        'Cannot configure a Study Controller without a deployment.');
    assert(deployment is CAMSMasterDeviceDeployment,
        'A CAMS study controller can only work with a CAMS Master Device Deployment');
    info('Configuring $runtimeType');

    executor = StudyDeploymentExecutor(deployment);

    // if a data manager is provided, register and use this
    if (dataManager != null) {
      DataManagerRegistry().register(dataManager);
      this.dataManager = dataManager;
    } else {
      this.dataManager = (masterDeployment.dataEndPoint != null)
          ? DataManagerRegistry().lookup(masterDeployment.dataEndPoint.type)
          : null;
    }
    if (dataManager == null)
      warning(
          "No data manager for the specified data endpoint found: '${masterDeployment.dataEndPoint}'.");

    // initialize optional parameters
    this.samplingSchema =
        samplingSchema ?? SamplingSchema.normal(powerAware: true);
    this.privacySchemaName = privacySchemaName ?? NameSpace.CARP;
    this.transformer = transformer ?? ((datum) => datum);

    // if no user is specified for this study, look up the local user id
    masterDeployment.userId ??= await settings.userId;

    // setting up permissions
    permissions = await PermissionHandlerPlatform.instance
        .requestPermissions(SamplingPackageRegistry().permissions);
    SamplingPackageRegistry().permissions.forEach((permission) {
      PermissionStatus status = permissions[permission];
      if (status != PermissionStatus.granted) {
        warning(
            'Permissions not granted for $permission, permission is $status');
      }
    });

    info(
        'CARP Mobile Sensing (CAMS) - Initializing Study Deployment Controller:');
    info('      study id : ${masterDeployment.studyId}');
    info(' deployment id : ${masterDeployment.studyDeploymentId}');
    info('    study name : ${masterDeployment.name}');
    info('          user : ${masterDeployment.userId}');
    info('      endpoint : ${masterDeployment.dataEndPoint}');
    info('   data format : ${masterDeployment.dataFormat}');
    info('      platform : ${DeviceInfo().platform.toString()}');
    info('     device ID : ${DeviceInfo().deviceID.toString()}');
    info('  data manager : ${dataManager?.toString()}');
    info('       devices : ${DeviceController().devicesToString()}');

    if (samplingSchema != null) {
      // doing two adaptation is a bit of a hack; used to ensure that
      // restoration values are set to the specified sampling schema
      masterDeployment.adapt(samplingSchema, restore: false);
      masterDeployment.adapt(samplingSchema, restore: false);
    }

    // initialize the data manager, device registry, and study executor
    await dataManager?.initialize(deployment, data);
    // await DeviceRegistry().initialize(deployment, data);
    executor.initialize(Measure(type: CAMSDataType.EXECUTOR));
    await enablePowerAwareness();
    data.listen((dataPoint) => _samplingSize++);

    status = StudyRuntimeStatus.Configured;
  }

  final BatteryProbe _battery = BatteryProbe();

  /// Enable power-aware sensing in this study. See [PowerAwarenessState].
  Future enablePowerAwareness() async {
    if (samplingSchema.powerAware) {
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
  /// specified [deployment] and [samplingSchema].
  void resume() {
    info('Resuming data sampling ...');
    super.resume();
    executor.resume();
  }

  /// Pause this controller, which will pause data collection and close the
  /// data manager.
  void pause() {
    info('Pausing data sampling ...');
    super.pause();
    executor.pause();
    dataManager?.close();
  }

  /// Stop the sampling.
  ///
  /// Once a controller is stopped it **cannot** be (re)started.
  /// If a controller should be restarted, use the [pause] and [resume] methods.
  void stop() {
    info('Stopping data sampling ...');
    disablePowerAwareness();
    dataManager?.close();
    executor.stop();
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
