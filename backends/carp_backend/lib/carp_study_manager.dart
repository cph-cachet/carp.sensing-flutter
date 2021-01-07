/*
 * Copyright 2021 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of carp_backend;

/// Retrieve and store [Study] json definitions from the CARP backend.
///
/// Retrieving a study from the CARP backend is basically made up of a number
/// of steps, as specified in the [carp.core](https://github.com/cph-cachet/carp.core-kotlin)
/// [deployment](https://github.com/cph-cachet/carp.core-kotlin/blob/develop/docs/carp-deployment.md)
/// sub-system:
///
///  1. Get a study invitation for the user (note that a user might be invited to multiple studies).
///  2. Get the deployment status of the specific deployment.
///  3. Register this device as part of this deployment.
///  4. Get the study deployment configuration.
class CarpStudyManager implements StudyManager {
  Future initialize() {}

  /// Get a CAMS [Study] from the CARP backend.
  ///
  /// Note that in the CARP backend, a CAMS study is empbedded as a
  /// [CustomProtocolTask] and deployed as part of a so-called
  /// [Participation] for a user, with a specific [studyDeploymentId].
  ///
  /// Throws a [CarpServiceException] if not successful.
  Future<Study> getStudy(String studyDeploymentId) async {
    DeploymentReference reference = CarpService().deployment(studyDeploymentId);
    // get status
    StudyDeploymentStatus status = await reference.getStatus();

    if (status.masterDeviceStatus.device != null) {
      if (status.status == 'DeployingDevices') {
        // register this master device, if not already done
        status = await reference.registerDevice(
            deviceRoleName: status.masterDeviceStatus.device.roleName);
      }
      // get the deployment
      MasterDeviceDeployment deployment = await reference.get();
      if (deployment.tasks.isNotEmpty) {
        // asume that this deployment only contains one custom task
        TaskDescriptor task = deployment.tasks[0];
        if (task is CustomProtocolTask) {
          Study study = Study.fromJson(
              json.decode(task.studyProtocol) as Map<String, dynamic>);
          // make sure that the study has the correct id as defined by the server
          study.id = CarpService().app.studyId ?? study.id;
          // mark this deployment as successful
          await reference.success();
          return study;
        } else {
          await reference.unRegisterDevice(
              deviceRoleName: status.masterDeviceStatus.device.roleName);
          throw CarpServiceException(
              message:
                  'The deployment does not contain a CustomProtocolTask - task: $task');
        }
      } else {
        await reference.unRegisterDevice(
            deviceRoleName: status.masterDeviceStatus.device.roleName);
        throw CarpServiceException(
            message:
                'The deployment does not contain any tasks - deployment: $deployment');
      }
    } else {
      throw CarpServiceException(
          message:
              'There is not Master Device defined in this Deployment: $status');
    }
  }

  /// This method is not implemented as there is no support for saving
  /// studies in CARP from the phone.
  Future<bool> saveStudy(Study study) async {
    throw CarpServiceException(
        message:
            'There is no support for saving studies in CARP from the phone.');
  }
}
