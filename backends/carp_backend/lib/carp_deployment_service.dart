/*
 * Copyright 2021 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of carp_backend;

/// A [DeploymentService] that works with the [CarpStudyProtocolManager]
/// to handle a [MasterDeviceDeployment] based on a [StudyProtocol], which is
/// store as a custom protocol on the CARP server.
///
/// This deployment service basically reads a [StudyProtocol] as a custom protocol
/// from the CARP web server, and translate this into a [SmartphoneDeployment]
/// which can be used on this phone.
///
/// It also gets the [StudyDescription] for the study and adds this to the device
/// deployment.
///
/// It adds a [CarpDataEndPoint] to the device deployment, which makes sure
/// that data is stored back on the CARP server.
///
/// Its main responsibility is to:
///  - retrieve the custom protocol from the CARP server
///  - retrieve the study description from the CARP server
///  - transform it into a smartphone study deployment
///  - add a [CarpDataEndPoint] to the deployment
///
/// The [CarpDataEndPoint] is the following:
///
/// ´´´dart
///    CarpDataEndPoint(
///       uploadMethod: CarpUploadMethod.BATCH_DATA_POINT,
///       name: CarpService().app.name,
///       uri: CarpService().app.uri.toString(),
///       bufferSize: 500 * 1000,
///       deleteWhenUploaded: true,
///    );
/// ````
///
/// Hence, data is uploaded in batches using a local file (500 KB) as a buffer,
/// which is deleted once uploaded.
/// If another data enpoint is needed, this can be changed in the deployment
/// before it is deployed and started on the local phone.
///
/// This deployment service also allow for local caching of a [SmartphoneDeployment]
/// once it has been downloaded and created. This is configured using the [useCache]
/// attribute.
class CustomProtocolDeploymentService implements DeploymentService {
  static final CustomProtocolDeploymentService _instance =
      CustomProtocolDeploymentService._();
  final StreamController<CarpBackendEvents> _eventController =
      StreamController.broadcast();

  CustomProtocolDeploymentService._() {
    // make sure that the json functions are loaded
    DomainJsonFactory();

    manager.initialize();
  }

  factory CustomProtocolDeploymentService() => _instance;

  CarpStudyProtocolManager manager = CarpStudyProtocolManager();
  late StudyProtocol protocol;

  /// Should the [getDeviceDeploymentFor] method cache the downloaded
  /// [MasterDeviceDeployment] locally?
  bool useCache = true;

  /// The stream of [CarpBackendEvents] reflecting the state of this service.
  Stream get carpBackendEvents => _eventController.stream;

  void addCarpBackendEvent(CarpBackendEvents event) =>
      _eventController.add(event);

  /// Is this service configured and authenticated to CARP?
  bool isConfigured() {
    if (!CarpService().isConfigured)
      throw CarpBackendException(
          "CARP Service has not been configured - call 'CarpService().configure()' first.");
    if (!CarpService().authenticated)
      throw CarpBackendException(
          "No user is authenticated - call 'CarpService().authenticate()' first.");

    if (!CarpDeploymentService().isConfigured) {
      CarpDeploymentService().configureFrom(CarpService());
      _eventController.add(CarpBackendEvents.Initialized);
    }
    return CarpDeploymentService().isConfigured;
  }

  @override
  Future<StudyDeploymentStatus> createStudyDeployment(
    StudyProtocol protocol, [
    String? studyDeploymentId,
  ]) {
    throw CarpBackendException(
        'Study protocols cannot be created using this $runtimeType.');
  }

  @override
  Future<StudyDeploymentStatus> getStudyDeploymentStatus(
    String studyDeploymentId,
  ) async {
    StudyDeploymentStatus? status;
    if (isConfigured()) {
      status = await CarpDeploymentService()
          .getStudyDeploymentStatus(studyDeploymentId);
      _eventController.add(CarpBackendEvents.DeploymentStatusRetrieved);
    }

    if (status != null)
      return status;
    else
      throw CarpBackendException(
          'Could not get deployment status in $runtimeType');
  }

  Future<String> get _cacheFilename async =>
      '${await Settings().deploymentBasePath}/deployment.json';

  @override
  Future<MasterDeviceDeployment> getDeviceDeploymentFor(
    String studyDeploymentId,
    String masterDeviceRoleName,
  ) async {
    SmartphoneDeployment? deployment;

    // first try to get local cache
    if (useCache) {
      try {
        String jsonString = File(await _cacheFilename).readAsStringSync();
        deployment = SmartphoneDeployment.fromJson(
            json.decode(jsonString) as Map<String, dynamic>);
      } catch (exception) {
        warning(
            "Failed to read cache of study deployment - id: '$studyDeploymentId' - $exception");
      }
    }

    if (deployment == null) {
      if (isConfigured()) {
        // get the protocol from the study protocol manager
        protocol = await manager.getStudyProtocol(studyDeploymentId);
        _eventController.add(CarpBackendEvents.ProtocolRetrieved);

        // get the study description from CARP
        StudyDescription? description =
            await CarpResourceManager().getStudyDescription();

        // configure a data endpoint which can send data back to CARP
        // note that files must not be zipped
        // files are deleted locally once uploaded
        DataEndPoint dataEndPoint = CarpDataEndPoint.fromCarpApp(
          uploadMethod: CarpUploadMethod.BATCH_DATA_POINT,
          app: CarpService().app!,
          bufferSize: 50 * 1000,
          zip: false,
          deleteWhenUploaded: true,
        );

        // create the smartphone deployment with the
        // - protocol
        // - description
        // - data endpoint
        deployment = SmartphoneDeployment.fromStudyProtocol(
          studyDeploymentId: studyDeploymentId,
          protocolDescription: description,
          masterDeviceRoleName: masterDeviceRoleName,
          dataEndPoint: dataEndPoint,
          protocol: protocol,
        );

        _eventController.add(CarpBackendEvents.DeploymentRetrieved);
      }
    }

    // register a CARP data manager which can upload data back to CARP
    DataManagerRegistry().register(CarpDataManager());

    if (deployment != null) {
      // saving to the local cache
      if (useCache) {
        info("Saving study deployment to local cache - id: $studyDeploymentId");
        try {
          final json = jsonEncode(deployment);
          File(await _cacheFilename).writeAsStringSync(json);
        } catch (exception) {
          warning(
              "Failed to save local cache for study deployment - id: '$studyDeploymentId' - $exception");
        }
      }

      // in all cases, return the deployment
      return deployment;
    } else
      throw CarpBackendException(
          "Could not get deployment in $runtimeType - id: '$studyDeploymentId'");
  }

  @override
  Future<StudyDeploymentStatus> registerDevice(
    String studyDeploymentId,
    String deviceRoleName,
    DeviceRegistration registration,
  ) async {
    StudyDeploymentStatus? status;
    if (isConfigured()) {
      try {
        status = await CarpDeploymentService()
            .registerDevice(studyDeploymentId, deviceRoleName, registration);
      } on CarpServiceException catch (cse) {
        // a CarpServiceException is typically because the device is already registred
        warning(cse.toString());
        status = await getStudyDeploymentStatus(studyDeploymentId);
      } catch (error) {
        // other errors can be rethrown
        rethrow;
      }
    }
    if (status != null)
      return status;
    else
      throw CarpBackendException(
          "Could not register device in $runtimeType - id: '$studyDeploymentId'");
  }

  @override
  Future<List<StudyDeploymentStatus>> getStudyDeploymentStatusList(
      List<String> studyDeploymentIds) {
    throw CarpBackendException(
        'getStudyDeploymentStatusList() is not supported using this CustomProtocolDeploymentService.');
  }

  @override
  Future<Set<String>> removeStudyDeployments(Set<String> studyDeploymentIds) {
    throw CarpBackendException('removeStudyDeployments() is not supported.');
  }

  @override
  Future<StudyDeploymentStatus> deploymentSuccessfulFor(
      String studyDeploymentId,
      String masterDeviceRoleName,
      DateTime deviceDeploymentLastUpdateDate) {
    throw CarpBackendException(
        'deploymentSuccessfulFor() is not supported. This happens automatically.');
  }

  @override
  Future<StudyDeploymentStatus> stop(String studyDeploymentId) {
    throw CarpBackendException('stop() is not supported.');
  }

  @override
  Future<StudyDeploymentStatus> unregisterDevice(
      String studyDeploymentId, String deviceRoleName) {
    throw CarpBackendException('unregisterDevice() is not supported.');
  }

  @override
  String toString() => runtimeType.toString();
}
