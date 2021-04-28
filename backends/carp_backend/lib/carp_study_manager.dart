/*
 * Copyright 2021 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of carp_backend;

/// Retrieve and store [StudyProtocol] json definitions at the CARP backend.
///
/// In the CARP web service, a CAMS study protocol is modelled as a custom
/// protcol, which has only one taks, namely a [CustomProtocolTask]. This
/// custom task hold the raw json desription of a [CAMSStudyProtocol].
class CARPStudyProtocolManager implements StudyProtocolManager {
  Future initialize() async {
    CAMSStudyProtocol(); // to initialize json serialization for CAMS classes
  }

  /// Get a CAMS [StudyProtocol] from the CARP backend.
  ///
  /// Note that in the CARP backend, a CAMS study is empbedded as a
  /// [CustomProtocolTask] and deployed as part of a so-called
  /// [Participation] for a user, with a specific [studyDeploymentId].
  ///
  /// Throws a [CarpServiceException] if not successful.
  Future<StudyProtocol> getStudyProtocol(String studyDeploymentId) async {
    assert(CarpService().isConfigured,
        "CARP Service has not been configured - call 'CarpService().configure()' first.");
    assert(CarpService().currentUser != null,
        "No user is authenticated - call 'CarpService().authenticate()' first.");
    info(
        'Retrieving study protocol from CARP web service - studyDeploymentId: $studyDeploymentId');
    DeploymentReference reference = CarpService().deployment(studyDeploymentId);

    // get status
    StudyDeploymentStatus deploymentStatus = await reference.getStatus();

    if (deploymentStatus?.masterDeviceStatus?.device != null) {
      // register the remaining devices needed for deployment
      if (deploymentStatus.masterDeviceStatus
              ?.remainingDevicesToRegisterToObtainDeployment !=
          null) {
        for (String deviceRolename in deploymentStatus
            .masterDeviceStatus.remainingDevicesToRegisterToObtainDeployment) {
          info("Registring device: '$deviceRolename'");
          deploymentStatus =
              await reference.registerDevice(deviceRoleName: deviceRolename);
        }
      }

      // get the deployment
      MasterDeviceDeployment deployment = await reference.get();

      if (deployment.tasks.isNotEmpty) {
        // asume that this deployment only contains one custom task
        TaskDescriptor task = deployment.tasks[0];
        if (task is CustomProtocolTask) {
          StudyProtocol protocol = StudyProtocol.fromJson(
              json.decode(task.studyProtocol) as Map<String, dynamic>);

          // set the protocol's study id - in the following order:
          //  1. the study id from the server specified in an invitation and save in the CarpService().app
          //  2. the study id provided in the downloaded (custom) protocol
          //  3. the study deployment id
          if (protocol is CAMSStudyProtocol)
            protocol.studyId =
                (CarpService().app.studyId ?? protocol.studyId) ??
                    studyDeploymentId;

          // mark this deployment as successful
          await reference.success();
          info(
              "Study deployment '$studyDeploymentId' successfully deployed on this phone.");
          return protocol;
        } else {
          await reference.unRegisterDevice(
              deviceRoleName:
                  deploymentStatus.masterDeviceStatus.device.roleName);
          throw CarpServiceException(
              message:
                  'The deployment does not contain a CustomProtocolTask - task: $task');
        }
      } else {
        await reference.unRegisterDevice(
            deviceRoleName:
                deploymentStatus.masterDeviceStatus.device.roleName);
        throw CarpServiceException(
            message:
                'The deployment does not contain any tasks - deployment: $deployment');
      }
    } else {
      throw CarpServiceException(
          message:
              'There is not Master Device defined in this deployment: $deploymentStatus');
    }
  }

  /// This method is not implemented as there is no support for saving
  /// studies in CARP from the phone.
  Future<bool> saveStudyProtocol(String studyId, StudyProtocol study) async {
    throw CarpServiceException(
        message:
            'There is no support for saving studies in the CARP web service from the phone.');
  }
}
