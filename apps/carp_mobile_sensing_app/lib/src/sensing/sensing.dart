/*
 * Copyright 2021 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of mobile_sensing_app;

/// This class implements the sensing layer.
///
/// Call [initialize] to setup a deployment, either locally or using a CAWS
/// deployment. Once initialized, the runtime [controller] can be used to
/// control the study execution (e.g., start and stop).
/// Collected data is available in the [measurements] stream.
class Sensing {
  static final Sensing _instance = Sensing._();
  StudyDeploymentStatus? _status;
  SmartphoneDeploymentController? _controller;

  DeploymentService? deploymentService;
  SmartPhoneClientManager? client;
  Study? study;

  /// The deployment running on this phone.
  // SmartphoneDeployment? get deployment => _controller?.deployment;

  /// Get the latest status of the study deployment.
  StudyDeploymentStatus? get status => _status;

  /// The role name of this device in the deployed study
  String? get deviceRolename => _status?.primaryDeviceStatus?.device.roleName;

  /// The study runtime controller for this deployment
  SmartphoneDeploymentController? get controller => _controller;

  /// The stream of all sampled measurements.
  Stream<Measurement>? get measurements => _controller?.measurements;

  /// the list of running - i.e. used - probes in this study.
  List<Probe> get runningProbes =>
      (_controller != null) ? _controller!.executor.probes : [];

  /// The list of available devices.
  List<DeviceManager>? get availableDevices =>
      (client != null) ? client!.deviceController.devices.values.toList() : [];

  /// The singleton sensing instance
  factory Sensing() => _instance;

  Sensing._() {
    CarpMobileSensing.ensureInitialized();

    // Create and register external sampling packages
    SamplingPackageRegistry().register(ConnectivitySamplingPackage());
    SamplingPackageRegistry().register(ContextSamplingPackage());
    SamplingPackageRegistry().register(MediaSamplingPackage());
    // SamplingPackageRegistry().register(CommunicationSamplingPackage());
    SamplingPackageRegistry().register(AppsSamplingPackage());
    SamplingPackageRegistry().register(PolarSamplingPackage());
    SamplingPackageRegistry().register(ESenseSamplingPackage());
  }

  /// Initialize and set up sensing.
  Future<void> initialize() async {
    info('Initializing $runtimeType - mode: ${bloc.deploymentMode}');

    switch (bloc.deploymentMode) {
      case DeploymentMode.local:
        // Use the local, phone-based deployment service.
        deploymentService = SmartphoneDeploymentService();

        // Get the protocol from the local study protocol manager.
        // Note that the study id is not used.
        StudyProtocol protocol =
            await LocalStudyProtocolManager().getStudyProtocol('');

        // Deploy this protocol using the on-phone deployment service.
        // Reuse the study deployment id, if this is stored on the phone.
        _status = await SmartphoneDeploymentService().createStudyDeployment(
          protocol,
          [],
          bloc.studyDeploymentId,
        );

        // Save the correct deployment id on the phone for later use.
        bloc.studyDeploymentId = _status?.studyDeploymentId;
        bloc.deviceRolename = _status?.primaryDeviceStatus?.device.roleName;

        break;
      case DeploymentMode.production:
      case DeploymentMode.staging:
      case DeploymentMode.development:
        // Use the CARP deployment service which can download a protocol from CAWS
        CarpDeploymentService().configureFrom(CarpService());
        deploymentService = CarpDeploymentService();

        break;
    }

    // Register the CARP data manager for uploading data back to CARP.
    // This is needed in both LOCAL and CARP deployments, since a local study
    // protocol may still upload to CARP
    DataManagerRegistry().register(CarpDataManagerFactory());

    // Create and configure a client manager for this phone
    client = SmartPhoneClientManager();
    await client?.configure(
      deploymentService: deploymentService,
      deviceController: DeviceController(),
    );

    // Define the study and add it to the client.
    study = await client?.addStudy(
      bloc.studyDeploymentId!,
      bloc.deviceRolename!,
    );

    // Get the study controller and try to deploy the study.
    //
    // Note that if the study has already been deployed on this phone
    // it has been cached locally in a file and the local cache will
    // be used pr. default.
    // If not deployed before (i.e., cached) the study deployment will be
    // fetched from the deployment service.
    _controller = client?.getStudyRuntime(study!);
    await controller?.tryDeployment(useCached: bloc.useCachedStudyDeployment);

    // Configure the controller
    await controller?.configure();

    // Start sampling
    controller?.start(bloc.resumeSensingOnStartup);

    // Listening on the data stream and print them as json to the debug console
    controller?.measurements
        .listen((measurement) => print(toJsonString(measurement)));

    info('$runtimeType initialized');
  }
}
