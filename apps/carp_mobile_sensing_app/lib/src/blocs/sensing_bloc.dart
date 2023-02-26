part of mobile_sensing_app;

class SensingBLoC {
  static const String STUDY_DEPLOYMENT_ID_KEY = 'study_deployment_id';

  String? _studyDeploymentId;
  bool _useCached = true;
  bool _resumeSensingOnStartup = false;

  /// The study deployment id for the currently running deployment.
  /// Returns the deployment id cached locally on the phone (if available).
  /// Returns `null` if no study is deployed (yet).
  String? get studyDeploymentId => (_studyDeploymentId ??=
      Settings().preferences?.getString(STUDY_DEPLOYMENT_ID_KEY));

  /// Set the study deployment id for the currently running deployment.
  /// This study deployment id will be cached locally on the phone.
  set studyDeploymentId(String? id) {
    assert(
        id != null,
        'Cannot set the study deployment id to null in Settings. '
        "Use the 'eraseStudyDeployment()' method to erase study deployment information.");
    _studyDeploymentId = id;
    Settings().preferences?.setString(STUDY_DEPLOYMENT_ID_KEY, id!);
  }

  /// Use the cached study deployment?
  bool get useCachedStudyDeployment => _useCached;

  /// Should sensing be automatically resumed on app startup?
  bool get resumeSensingOnStartup => _resumeSensingOnStartup;

  /// Erase all study deployment information cached locally on this phone.
  Future<void> eraseStudyDeployment() async {
    _studyDeploymentId = null;
    await Settings().preferences!.remove(STUDY_DEPLOYMENT_ID_KEY);
  }

  /// The [SmartphoneDeployment] deployed on this phone.
  SmartphoneDeployment? get deployment => Sensing().controller?.deployment;

  /// What kind of deployment are we running - local or CARP?
  DeploymentMode deploymentMode = DeploymentMode.local;

  /// The preferred format of the data to be uploaded according to
  /// [NameSpace]. Default using the [NameSpace.CARP].
  String dataFormat = NameSpace.CARP;

  StudyDeploymentModel? _model;

  /// Get the study deployment model for this app.
  StudyDeploymentModel get studyDeploymentModel =>
      _model ??= StudyDeploymentModel(deployment!);

  /// Get a list of running probes
  Iterable<ProbeModel> get runningProbes =>
      Sensing().runningProbes.map((probe) => ProbeModel(probe));

  /// Get a list of running devices
  Iterable<DeviceModel> get availableDevices =>
      Sensing().availableDevices!.map((device) => DeviceModel(device));

  /// Initialize the BLoC.
  Future<void> initialize({
    DeploymentMode deploymentMode = DeploymentMode.local,
    String dataFormat = NameSpace.CARP,
    bool useCachedStudyDeployment = true,
    bool resumeSensingOnStartup = false,
  }) async {
    await Settings().init();
    Settings().debugLevel = DebugLevel.debug;
    this.deploymentMode = deploymentMode;
    this.dataFormat = dataFormat;
    _resumeSensingOnStartup = resumeSensingOnStartup;
    _useCached = useCachedStudyDeployment;

    info('$runtimeType initialized');
  }

  /// Connect to a [device] which is part of the [deployment].
  void connectToDevice(DeviceModel device) =>
      Sensing().client?.deviceController.devices[device.type!]!.connect();

  void start() async => Sensing().controller?.executor?.start();
  void stop() async => Sensing().controller?.executor?.stop();

  /// Is sensing running, i.e. has the study executor been started?
  bool get isRunning =>
      (Sensing().controller != null) &&
      Sensing().controller!.executor!.state == ExecutorState.started;
}

final bloc = SensingBLoC();

/// How to deploy a study.
enum DeploymentMode {
  /// Use a local study protocol & deployment and store data locally on the phone.
  local,

  /// Use the CAWS PROD server to get the study deployment and store data.
  production,

  /// Use the CAWS staging server to get the study deployment and store data.
  staging,

  /// Use the CAWS DEV server to get the study deployment and store data.
  development,
}
