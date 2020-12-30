/*
 * Copyright 2020 Copenhagen Center for Health Technology (CACHET) at the
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
  Future initialize() {
    // TODO: implement initialize
    throw UnimplementedError();
  }

  /// Get the study id for the current user based on an invitation from CARP.
  ///
  /// Returns `null` if the user has no invitations.
  ///
  /// If the user is invited to more than one study and [showInvitations] is `true`,
  /// a user-interface for selecting amongs the invitations is shown.
  /// If not, the study id of the first invitation is returned.
  ///
  /// Throws a [CarpServiceException] if not successful.
  Future<String> getStudyIdByInvitation(
    BuildContext context, {
    bool showInvitations,
  }) async {
    if (!CarpService().isConfigured)
      throw CarpServiceException(
          message:
              "CARP Service not initialized. Call 'CarpService().configure()' first.");

    if (!CarpService().authenticated)
      throw CarpServiceException(
          message:
              "The current user is not authenticated to CARP. Call 'CarpService().authenticate...()' first.");

    List<ActiveParticipationInvitation> invitations =
        await CarpService().invitations();

    if (invitations.isEmpty) return '123';
  }

  Future<Study> getStudy(String studyId) {
    // TODO: implement getStudy
    throw UnimplementedError();
  }

  @override
  Future<bool> saveStudy(Study study) {
    // TODO: implement saveStudy
    throw UnimplementedError();
  }

  @override
  Future dispose() {
    // TODO: implement dispose
    throw UnimplementedError();
  }
}
