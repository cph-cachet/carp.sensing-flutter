part of mobile_sensing_app;

class SensingBLoC {
  CAMSMasterDeviceDeployment get deployment => Sensing().deployment;
  StudyDeploymentModel _model;

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
    DeviceController().devices[device.type].connect();
  }

  Future init() async {
    globalDebugLevel = DebugLevel.DEBUG;
    await settings.init();
    await Sensing().initialize();
    info('$runtimeType initialized');
  }

  void resume() async => Sensing().controller.resume();
  void pause() => Sensing().controller.pause();
  void stop() async => Sensing().controller.stop();
  void dispose() async => Sensing().controller.stop();
}

final bloc = SensingBLoC();
