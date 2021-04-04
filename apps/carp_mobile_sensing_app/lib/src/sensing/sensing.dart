/*
 * Copyright 2021 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of mobile_sensing_app;

/// This class implements the sensing layer incl. setting up a [StudyProtocol]
/// with [Task]s and [Measure]s.
class Sensing {
  static final Sensing _instance = Sensing._();
  CAMSMasterDeviceDeployment _deployment;
  StudyDeploymentStatus _status;
  StudyProtocol _protocol;
  StudyDeploymentController _controller;

  CAMSMasterDeviceDeployment get deployment => _deployment;

  /// Get the latest status of the study deployment.
  StudyDeploymentStatus get status => _status;
  StudyProtocol get protocol => _protocol;
  StudyDeploymentController get controller => _controller;

  /// the list of running - i.e. used - probes in this study.
  List<Probe> get runningProbes =>
      (_controller != null) ? _controller.executor.probes : List();

  /// the list of connected devices.
  List<DeviceManager> get runningDevices =>
      DeviceController().devices.values.toList();

  /// Get the singleton sensing instance
  factory Sensing() => _instance;

  Sensing._() {
    // create and register external sampling packages
    SamplingPackageRegistry().register(ConnectivitySamplingPackage());
    SamplingPackageRegistry().register(ContextSamplingPackage());
    SamplingPackageRegistry().register(AudioSamplingPackage());
    //SamplingPackageRegistry().register(CommunicationSamplingPackage());
    //SamplingPackageRegistry().register(AppsSamplingPackage());
    SamplingPackageRegistry().register(ESenseSamplingPackage());
  }

  /// Initialize and setup sensing.
  Future<void> initialize() async {
    // get the protocol from the local protocol manager (defined below)
    _protocol = await LocalStudyProtocolManager().getStudyProtocol('1234');

    // deploy this protocol using the on-phone deployment service
    _status = await CAMSDeploymentService().createStudyDeployment(_protocol);

    // initialize the local device controller with the deployment status,
    // which contains the list of needed devices
    await DeviceController().initialize(_status, CAMSDeploymentService());

    // now we're ready to get the device deployment configuration for this phone
    _deployment = await CAMSDeploymentService()
        .getDeviceDeployment(status.studyDeploymentId);

    // create a study deployment controller that can manage this deployment
    _controller = StudyDeploymentController(
      deployment,
      debugLevel: DebugLevel.DEBUG,
      privacySchemaName: PrivacySchema.DEFAULT,
    );

    // initialize the controller
    await _controller.initialize();

    // listening on the data stream and print them as json to the debug console
    _controller.data.listen((data) => print(toJsonString(data)));
  }
}
