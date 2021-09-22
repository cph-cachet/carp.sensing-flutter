/*
 * Copyright 2018-2021 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */
part of runtime;

/// A [StudyDeploymentController] controls the execution of a [SmartphoneDeployment].
class StudyDeploymentController extends StudyRuntime {
  int _samplingSize = 0;
  DataManager? _dataManager;
  DataEndPoint? _dataEndPoint;
  StudyDeploymentExecutor? _executor;
  late SamplingSchema _samplingSchema;
  String _privacySchemaName = NameSpace.CARP;
  late DatumTransformer _transformer;

  /// The master device deployment running in this controller.
  SmartphoneDeployment? get masterDeployment =>
      deployment as SmartphoneDeployment?;

  /// The executor executing this [masterDeployment].
  StudyDeploymentExecutor? get executor => _executor;

  /// The configuration of the data endpoint, i.e. how data is saved or uploaded.
  DataEndPoint? get dataEndPoint => _dataEndPoint;

  /// The data manager responsible for handling the data collected by this controller.
  DataManager? get dataManager => _dataManager;

  /// The privacy schema used to encrypt data before upload.
  String? get privacySchemaName => _privacySchemaName;

  /// The datum transformed used to transform data before upload.
  DatumTransformer get transformer => _transformer;

  /// The permissions granted to this study from the OS.
  Map<Permission, PermissionStatus>? permissions;

  /// The stream of all sampled data points.
  ///
  /// Data points in the [data] stream are transformed in the following order:
  ///   1. privacy schema as specified in the [privacySchemaName]
  ///   2. preferred data format as specified by [dataFormat] in the [deployment]
  ///   3. any custom [transformer] provided
  ///
  /// This is a broadcast stream and supports multiple subscribers.
  Stream<DataPoint> get data => _executor!.data.map((dataPoint) => dataPoint
    ..data = _transformer(TransformerSchemaRegistry()
        .lookup(masterDeployment!.dataEndPoint!.dataFormat)!
        .transform(TransformerSchemaRegistry()
            .lookup(_privacySchemaName)!
            .transform(dataPoint.data as Datum))));

  PowerAwarenessState powerAwarenessState = NormalSamplingState.instance;

  /// The sampling size of this [deployment] in terms of number of [DataPoint]
  /// objects that has been collected.
  int get samplingSize => _samplingSize;

  DateTime? _studyDeploymentStartTime;
  DateTime? get studyDeploymentStartTime => _studyDeploymentStartTime;

  // DateTime? _studyDeploymentStartTime;
  // String get _studyDeploymentStartTimesKey =>
  //     '$studyDeploymentId.${Settings.STUDY_START_KEY}'.toLowerCase();

  // /// The timestamp (in UTC) when the current study deployment
  // /// (the [masterDeployment]) was started on this phone.
  // /// This timestamp is save on the phone the first time a study is deployed
  // /// and persistently saved across app restarts.
  // Future<DateTime> get studyDeploymentStartTime async {
  //   assert(Settings().preferences != null,
  //       "Setting is not initialized. Call 'Setting().init()' first.");
  //   if (_studyDeploymentStartTime == null) {
  //     String? str =
  //         Settings().preferences!.get(_studyDeploymentStartTimesKey) as String?;
  //     _studyDeploymentStartTime = (str != null) ? DateTime.parse(str) : null;
  //     if (_studyDeploymentStartTime == null) {
  //       _studyDeploymentStartTime = DateTime.now().toUtc();
  //       await Settings().preferences!.setString(_studyDeploymentStartTimesKey,
  //           _studyDeploymentStartTime.toString());
  //       info(
  //           '$runtimeType - Study deployment start time set to $_studyDeploymentStartTime');
  //     }
  //   }
  //   return _studyDeploymentStartTime!;
  // }

  /// Create a new [StudyDeploymentController] to control the runtime behavior
  /// of a study deployment.
  StudyDeploymentController() : super() {
    // initialize settings
    Settings().init();

    // create and register the two built-in data managers
    DataManagerRegistry().register(ConsoleDataManager());
    DataManagerRegistry().register(FileDataManager());
  }

  /// Configure this [StudyDeploymentController].
  /// Must be called only once, and before [resume] is called.
  ///
  /// Can request permissions for all [SamplingPackage]s' permissions.
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
  Future<void> configure({
    SamplingSchema? samplingSchema,
    DataEndPoint? dataEndPoint,
    String privacySchemaName = NameSpace.CARP,
    DatumTransformer? transformer,
    bool askForPermissions = true,
  }) async {
    assert(deployment != null,
        'Cannot configure a StudyDeploymentController without a deployment.');
    assert(deployment is SmartphoneDeployment,
        'A StudyDeploymentController can only work with a SmartphoneDeployment master device deployment');
    info('Configuring $runtimeType');

    // save the study deployment id in settings
    // this is actually a little hack since we should be able to run
    // several studies in the same app....
    Settings().studyDeploymentId = studyDeploymentId;

    // initialize the app task controller singleton
    await AppTaskController().initialize();

    _executor = StudyDeploymentExecutor(deployment as SmartphoneDeployment);

    // initialize optional parameters
    _samplingSchema = samplingSchema ?? SamplingSchema.normal(powerAware: true);
    _dataEndPoint = dataEndPoint ?? masterDeployment!.dataEndPoint;
    _privacySchemaName = privacySchemaName;
    _transformer = transformer ?? ((datum) => datum);

    if (_dataEndPoint != null) {
      _dataManager = DataManagerRegistry().lookup(_dataEndPoint!.type);
    }

    if (_dataManager == null) {
      warning(
          "No data manager for the specified data endpoint found: '${masterDeployment?.dataEndPoint}'.");
    }

    // if no user is specified for this study, look up the local user id
    masterDeployment!.userId ??= await Settings().userId;

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

    // check the start time for this deployment on this phone
    // and save it, the first time the deployment is done
    _studyDeploymentStartTime = await Settings().studyDeploymentStartTime;
    if (_studyDeploymentStartTime == null) {
      await Settings().markStudyDeploymentAsStarted();
      _studyDeploymentStartTime = await Settings().studyDeploymentStartTime;
    }

    info('CARP Mobile Sensing (CAMS) - Study Deployment Controller');
    info('========================================================');
    info(' deployment id : ${masterDeployment!.studyDeploymentId}');
    info('    start time : $studyDeploymentStartTime');
    info('       user id : ${masterDeployment!.userId}');
    info(' data endpoint : $_dataEndPoint');
    info('      platform : ${DeviceInfo().platform.toString()}');
    info('     device ID : ${DeviceInfo().deviceID.toString()}');
    info('  data manager : $_dataManager');
    info('       devices : ${DeviceController().devicesToString()}');
    info('========================================================');

    if (samplingSchema != null) {
      // doing two adaptation is a bit of a hack; used to ensure that
      // restoration values are set to the specified sampling schema
      masterDeployment!.adapt(samplingSchema, restore: false);
      masterDeployment!.adapt(samplingSchema, restore: false);
    }

    // initialize the data manager, device registry, and study executor
    await _dataManager?.initialize(
      masterDeployment!.studyDeploymentId,
      masterDeployment!.dataEndPoint!,
      data,
    );
    // await DeviceRegistry().initialize(deployment, data);
    _executor!.initialize(Measure(type: CAMSDataType.EXECUTOR));
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
            masterDeployment!.adapt(powerAwarenessState.schema);
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
  /// parameters specified in [configure].
  ///
  /// [configure] must be called before resuming sampling.
  void resume() {
    info('Resuming data sampling ...');
    super.resume();
    _executor!.resume();
  }

  /// Pause this controller, which will pause data collection and close the
  /// data manager.
  void pause() {
    info('Pausing data sampling ...');
    super.pause();
    _executor!.pause();
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
    _executor!.stop();
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

  static PowerAwarenessState? instance;

  PowerAwarenessState adapt(int? level);
  SamplingSchema get schema;
}

class NoSamplingState implements PowerAwarenessState {
  static NoSamplingState instance = NoSamplingState();

  PowerAwarenessState adapt(int? level) {
    if (level! > PowerAwarenessState.NO_SAMPLING_LEVEL) {
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

  PowerAwarenessState adapt(int? level) {
    if (level! < PowerAwarenessState.NO_SAMPLING_LEVEL) {
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

  PowerAwarenessState adapt(int? level) {
    if (level! < PowerAwarenessState.MINIMUM_SAMPLING_LEVEL) {
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

  PowerAwarenessState adapt(int? level) {
    if (level! < PowerAwarenessState.LIGHT_SAMPLING_LEVEL) {
      return LightSamplingState.instance;
    } else {
      return NormalSamplingState.instance;
    }
  }

  SamplingSchema get schema => SamplingSchema.normal();

  String toString() => 'Normal Sampling Mode';
}
