part of mobile_sensing_app;

class SensingBLoC {
  static const String PROD_URI = "https://cans.cachet.dk:443";

  CAMSMasterDeviceDeployment get deployment => Sensing().deployment;
  StudyDeploymentModel _model;
  CarpApp _app;

  CarpApp get app => _app;

  /// Is sensing running, i.e. has the study executor been resumed?
  bool get isRunning =>
      (Sensing().controller != null) &&
      Sensing().controller.executor.state == ProbeState.resumed;

  /// Get the study for this app.
  StudyDeploymentModel get studyDeploymentModel =>
      _model ??= StudyDeploymentModel(deployment);

  /// Get a list of running probes
  Iterable<ProbeModel> get runningProbes =>
      Sensing().runningProbes.map((probe) => ProbeModel(probe));

  /// Get a list of running devices
  Iterable<DeviceModel> get runningDevices =>
      Sensing().runningDevices.map((device) => DeviceModel(device));

  void connectToDevice(DeviceModel device) {
    Sensing().client?.deviceRegistry?.devices[device.type].connect();
  }

  Future init() async {
    await Settings().init();
    Settings().debugLevel = DebugLevel.DEBUG;
    _app = CarpApp(
      name: "CANS Production @ DTU",
      uri: Uri.parse(uri),
      oauth: OAuthEndPoint(clientID: clientID, clientSecret: clientSecret),
    );

    // configure and authenticate
    CarpService().configure(app);
    await CarpService().authenticate(username: username, password: password);

    await Sensing().initialize();
    info('$runtimeType initialized');
  }

  void resume() async => Sensing().controller.resume();
  void pause() => Sensing().controller.pause();
  void stop() async => Sensing().controller.stop();
  void dispose() async => Sensing().controller.stop();
}

final bloc = SensingBLoC();
