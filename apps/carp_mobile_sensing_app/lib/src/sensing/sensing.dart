/*
 * Copyright 2021 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of mobile_sensing_app;

/// This class implements the sensing layer.
///
/// Call [initialize] to setup a deployment, either locally or using a CARP
/// deployment. Once initialized, the runtime [controller] can be used to
/// control the study execution (e.g., resume, pause, stop).
class Sensing {
  static final Sensing _instance = Sensing._();
  StudyDeploymentStatus _status;
  StudyDeploymentController _controller;

  DeploymentService deploymentService;
  SmartPhoneClientManager client;

  /// The deployment running on this phone.
  CAMSMasterDeviceDeployment get deployment => _controller?.deployment;

  /// Get the latest status of the study deployment.
  StudyDeploymentStatus get status => _status;

  /// The role name of this device in the deployed study
  String get deviceRolename => _status?.masterDeviceStatus?.device?.roleName;

  /// The study deployment id of the deployment running on this phone.
  String get studyDeploymentId => _status?.studyDeploymentId;

  /// The study runtime controller for this deployment
  StudyDeploymentController get controller => _controller;

  /// the list of running - i.e. used - probes in this study.
  List<Probe> get runningProbes =>
      (_controller != null) ? _controller.executor.probes : [];

  /// The list of connected devices.
  List<DeviceManager> get runningDevices =>
      client?.deviceRegistry?.devices?.values?.toList();

  /// The singleton sensing instance
  factory Sensing() => _instance;

  Sensing._() {
    // create and register external sampling packages
    // SamplingPackageRegistry().register(ConnectivitySamplingPackage());
    SamplingPackageRegistry().register(ContextSamplingPackage());
    SamplingPackageRegistry().register(AudioSamplingPackage());
    //SamplingPackageRegistry().register(CommunicationSamplingPackage());
    //SamplingPackageRegistry().register(AppsSamplingPackage());
    SamplingPackageRegistry().register(ESenseSamplingPackage());
  }

  /// Initialize and set up sensing.
  Future<void> initialize() async {
    info('Initializing $runtimeType - mode: ${bloc.deploymentMode}');

    // set up the devices available on this phone
    DeviceController().registerAllAvailableDevices();

    switch (bloc.deploymentMode) {
      case DeploymentMode.LOCAL:
        // use the local, phone-based deployment service
        deploymentService = SmartphoneDeploymentService();

        // get the protocol from the local study protocol manager
        // note that the study id is not used
        StudyProtocol protocol =
            await LocalStudyProtocolManager().getStudyProtocol('');

        // deploy this protocol using the on-phone deployment service
        _status = await SmartphoneDeploymentService().createStudyDeployment(
          protocol,
        );

        break;
      case DeploymentMode.CARP:
        // use the CARP deployment service that knows how to download a
        // custom protocol
        deploymentService = CustomProtocolDeploymentService();

        // authenticate the user
        // this would normally trigger a dialogue, but for demo/testing we're using
        // the username/password in the 'credentials.dart' file
        if (!CarpService().authenticated)
          await CarpService()
              .authenticate(username: username, password: password);

        // get the study deployment id
        // this would normally be done by getting the invitations for this user,
        // but for demo/testing we're using the deployment id in the 'credentials.dart' file
        _status = await CustomProtocolDeploymentService()
            .getStudyDeploymentStatus(testStudyDeploymentId);

        // now register the CARP data manager for uploading data back to CARP
        DataManagerRegistry().register(CarpDataManager());

        break;
    }

    // create and configure a client manager for this phone
    client = SmartPhoneClientManager(
      deploymentService: deploymentService,
      deviceRegistry: DeviceController(),
    );
    await client.configure();

    // add and deploy this deployment
    _controller = await client.addStudy(studyDeploymentId, deviceRolename);

    // configure the controller with the default privacy schema
    await _controller.configure(
      privacySchemaName: PrivacySchema.DEFAULT,
    );
    // controller.resume();

    // listening on the data stream and print them as json to the debug console
    _controller.data.listen((data) => print(toJsonString(data)));

    info('$runtimeType initialized');
  }
}
