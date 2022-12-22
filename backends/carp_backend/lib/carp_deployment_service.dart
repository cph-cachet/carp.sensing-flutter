/*
 * Copyright 2021 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of carp_backend;

// /// A [DeploymentService] that works with the [CarpStudyProtocolManager]
// /// to handle a [MasterDeviceDeployment] based on a [SmartphoneStudyProtocol],
// /// which is stored as a custom protocol on the CARP server.
// ///
// /// This deployment service basically reads a [SmartphoneStudyProtocol] as a
// /// custom protocol from the CARP web server, and translate this into a
// /// [SmartphoneDeployment], which can be used on this phone.
// ///
// /// The [SmartphoneDeployment.userId] will be set to the [CarpUser.accountId]
// /// of the user logged in and downloading the protocol. This id will be used
// /// as the [DataPointHeader.userId] when uploading data back to CARP.
// class CustomProtocolDeploymentService implements DeploymentService {
//   static final CustomProtocolDeploymentService _instance =
//       CustomProtocolDeploymentService._();
//   final StreamController<CarpBackendEvents> _eventController =
//       StreamController.broadcast();

//   CustomProtocolDeploymentService._() {
//     manager.initialize();
//   }

//   factory CustomProtocolDeploymentService() => _instance;

//   CarpStudyProtocolManager manager = CarpStudyProtocolManager();
//   late SmartphoneStudyProtocol protocol;

//   // /// Should the [getDeviceDeploymentFor] method cache the downloaded
//   // /// [MasterDeviceDeployment] locally?
//   // bool useCache = true;

//   /// The stream of [CarpBackendEvents] reflecting the state of this service.
//   Stream get carpBackendEvents => _eventController.stream;

//   void addCarpBackendEvent(CarpBackendEvents event) =>
//       _eventController.add(event);

//   /// Is this service configured and authenticated to CARP?
//   bool isConfigured() {
//     if (!CarpService().isConfigured)
//       throw CarpBackendException(
//           "CARP Service has not been configured - call 'CarpService().configure()' first.");
//     if (!CarpService().authenticated)
//       throw CarpBackendException(
//           "No user is authenticated - call 'CarpService().authenticate()' first.");

//     if (!CarpDeploymentService().isConfigured) {
//       CarpDeploymentService().configureFrom(CarpService());
//       _eventController.add(CarpBackendEvents.Initialized);
//     }
//     return CarpDeploymentService().isConfigured;
//   }

//   @override
//   Future<StudyDeploymentStatus> createStudyDeployment(
//     StudyProtocol protocol, [
//     String? studyDeploymentId,
//   ]) {
//     throw CarpBackendException(
//         'Study protocols cannot be created using this $runtimeType.');
//   }

//   @override
//   Future<StudyDeploymentStatus> getStudyDeploymentStatus(
//     String studyDeploymentId,
//   ) async {
//     StudyDeploymentStatus? status;
//     if (isConfigured()) {
//       status = await CarpDeploymentService()
//           .getStudyDeploymentStatus(studyDeploymentId);
//       _eventController.add(CarpBackendEvents.DeploymentStatusRetrieved);
//     }

//     if (status != null)
//       return status;
//     else
//       throw CarpBackendException(
//           'Could not get deployment status in $runtimeType');
//   }

//   // Future<String> get _cacheFilename async =>
//   //     '${await Settings().deploymentBasePath}/deployment.json';

//   @override
//   Future<MasterDeviceDeployment> getDeviceDeploymentFor(
//     String studyDeploymentId,
//     String masterDeviceRoleName,
//   ) async {
//     SmartphoneDeployment? deployment;

//     // // first try to get local cache
//     // if (useCache) {
//     //   try {
//     //     String jsonString = File(await _cacheFilename).readAsStringSync();
//     //     deployment = SmartphoneDeployment.fromJson(
//     //         json.decode(jsonString) as Map<String, dynamic>);
//     //     info(
//     //         "Study deployment was read from local cache - id: $studyDeploymentId");
//     //   } catch (exception) {
//     //     warning(
//     //         "Failed to read cache of study deployment - id: '$studyDeploymentId' - $exception");
//     //   }
//     // }

//     // if (deployment == null) {
//     if (isConfigured()) {
//       // get the protocol from the study protocol manager
//       protocol = await manager.getStudyProtocol(studyDeploymentId);
//       _eventController.add(CarpBackendEvents.ProtocolRetrieved);

//       // create the smartphone deployment
//       deployment = SmartphoneDeployment.fromSmartphoneStudyProtocol(
//         studyDeploymentId: studyDeploymentId,
//         masterDeviceRoleName: masterDeviceRoleName,
//         protocol: protocol,
//       );

//       // set the user id of the deployment to the account id of the logged in user
//       deployment.userId ??= CarpService().currentUser?.accountId;

//       info("Study deployment was read from CARP - id: $studyDeploymentId");

//       _eventController.add(CarpBackendEvents.DeploymentRetrieved);
//     }
//     // }

//     // register a CARP data manager which can upload data back to CARP
//     DataManagerRegistry().register(CarpDataManager());

//     if (deployment != null) {
//       //   // saving to the local cache
//       //   if (useCache) {
//       //     info("Saving study deployment to local cache - id: $studyDeploymentId");
//       //     try {
//       //       final json = jsonEncode(deployment);
//       //       File(await _cacheFilename).writeAsStringSync(json);
//       //     } catch (exception) {
//       //       warning(
//       //           "Failed to save local cache for study deployment - id: '$studyDeploymentId' - $exception");
//       //     }
//       //   }

//       // in all cases, return the deployment
//       return deployment;
//     } else
//       throw CarpBackendException(
//           "Could not get deployment in $runtimeType - id: '$studyDeploymentId'");
//   }

//   @override
//   Future<StudyDeploymentStatus> registerDevice(
//     String studyDeploymentId,
//     String deviceRoleName,
//     DeviceRegistration registration,
//   ) async {
//     StudyDeploymentStatus? status;
//     if (isConfigured()) {
//       try {
//         status = await CarpDeploymentService()
//             .registerDevice(studyDeploymentId, deviceRoleName, registration);
//       } on CarpServiceException catch (cse) {
//         // a CarpServiceException is typically because the device is already registred
//         warning('$runtimeType - $cse');
//         status = await getStudyDeploymentStatus(studyDeploymentId);
//       } catch (error) {
//         // other errors can be rethrown
//         rethrow;
//       }
//     }
//     if (status != null)
//       return status;
//     else
//       throw CarpBackendException(
//           "Could not register device in $runtimeType - id: '$studyDeploymentId'");
//   }

//   @override
//   Future<List<StudyDeploymentStatus>> getStudyDeploymentStatusList(
//       List<String> studyDeploymentIds) {
//     throw CarpBackendException(
//         'getStudyDeploymentStatusList() is not supported using this CustomProtocolDeploymentService.');
//   }

//   @override
//   Future<Set<String>> removeStudyDeployments(Set<String> studyDeploymentIds) {
//     throw CarpBackendException('removeStudyDeployments() is not supported.');
//   }

//   @override
//   Future<StudyDeploymentStatus> deploymentSuccessfulFor(
//       String studyDeploymentId,
//       String masterDeviceRoleName,
//       DateTime deviceDeploymentLastUpdateDate) {
//     throw CarpBackendException(
//         'deploymentSuccessfulFor() is not supported. This happens automatically.');
//   }

//   @override
//   Future<StudyDeploymentStatus> stop(String studyDeploymentId) async {
//     StudyDeploymentStatus? status;
//     if (isConfigured()) {
//       try {
//         status = await CarpDeploymentService().stop(studyDeploymentId);
//       } on CarpServiceException catch (cse) {
//         // a CarpServiceException is typically because the deployment is already stopped
//         warning('$runtimeType - $cse');
//         status = await getStudyDeploymentStatus(studyDeploymentId);
//       } catch (error) {
//         // other errors can be rethrown
//         rethrow;
//       }
//     }
//     if (status != null)
//       return status;
//     else
//       throw CarpBackendException(
//           "Could not stop study deployment in $runtimeType - id: '$studyDeploymentId'");
//   }

//   @override
//   Future<StudyDeploymentStatus> unregisterDevice(
//       String studyDeploymentId, String deviceRoleName) {
//     throw CarpBackendException('unregisterDevice() is not supported.');
//   }

//   @override
//   String toString() => runtimeType.toString();
// }
