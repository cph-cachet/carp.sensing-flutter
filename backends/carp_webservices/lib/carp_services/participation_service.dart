/*
 * Copyright 2021 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of carp_services;

/// A [ParticipationService] that talks to the CARP backend server(s).
class CarpParticipationService extends CarpBaseService
    implements ParticipationService {
  static CarpParticipationService _instance = CarpParticipationService._();

  CarpParticipationService._();

  /// Returns the singleton default instance of the [CarpParticipationService].
  /// Before this instance can be used, it must be configured using the [configure] method.
  factory CarpParticipationService() => _instance;

  @override
  String get rpcEndpointName => "participation-service";

  /// Gets a [ParticipationReference] for a [studyDeploymentId].
  /// If the [studyDeploymentId] is not provided, the study deployment id
  /// specified in the [CarpApp] is used.
  ParticipationReference participation([String? studyDeploymentId]) =>
      ParticipationReference._(this, studyDeploymentId);

  @override
  Future<Participation> addParticipation(
      String studyDeploymentId,
      Set<String> assignedMasterDeviceRoleNames,
      AccountIdentity identity,
      StudyInvitation invitation) {
    // TODO: implement addParticipation
    throw UnimplementedError();
  }

  /// Get the list of active participation invitations for an [accountId].
  /// This will return all deployments that this account (user) is invited to.
  ///
  /// Note that the [accountId] is the unique CARP account id (and not the
  /// username).
  /// If [accountId] is not specified, then the account id of the currently
  /// authenticated [CarpUser] is used.  @override
  @override
  Future<List<ActiveParticipationInvitation>> getActiveParticipationInvitations(
      [String? accountId]) async {
    accountId ??= currentUser!.accountId;

    Map<String, dynamic> responseJson =
        await _rpc(GetActiveParticipationInvitations(accountId!));

    // we expect a list of 'items' which maps to the invitations
    List<dynamic> items = responseJson['items'];
    return items
        .map((item) => ActiveParticipationInvitation.fromJson(item))
        .toList();
  }

  /// Get a study invitation from CARP by allowing the user to select from
  /// multiple invitations (if more than one is available).
  ///
  /// Returns the selected invitation. Returns `null` if the user has no invitation(s)
  /// or if the user closes the dialog (if [allowClose] is true).
  ///
  /// If the user is invited to more than one study and [showInvitations] is `true`,
  /// a user-interface dialog for selecting amongs the invitations is shown.
  /// If not, the study id of the first invitation is returned.
  ///
  /// [allowClose] specifies whether the user can close the window.
  ///
  /// Throws a [CarpServiceException] if not successful.
  Future<ActiveParticipationInvitation?> getStudyInvitation(
    BuildContext context, {
    bool showInvitations = true,
    bool allowClose = false,
  }) async {
    if (!this.isConfigured)
      throw CarpServiceException(
          message:
              "CARP Service not initialized. Call 'CarpService().configure()' first.");

    if (!CarpService().authenticated)
      throw CarpServiceException(
          message:
              "The current user is not authenticated to CARP. Call 'CarpService().authenticate...()' first.");

    List<ActiveParticipationInvitation> invitations =
        await getActiveParticipationInvitations();

    ActiveParticipationInvitation? _invitation;

    if (invitations.isEmpty) return null;

    if (invitations.length == 1 || !showInvitations) {
      _invitation = invitations[0];
    } else {
      _invitation = await showDialog<ActiveParticipationInvitation>(
          context: context,
          barrierDismissible: allowClose,
          builder: (BuildContext context) =>
              ActiveParticipationInvitationDialog()
                  .build(context, invitations));
    }

    // make sure that the correct study and deployment ids are saved in the app
    CarpService().app!.studyId = _invitation?.studyId;
    CarpService().app!.studyDeploymentId = _invitation?.studyDeploymentId;

    return _invitation;
  }

  @override
  Future<ParticipantData> getParticipantData(String studyDeploymentId) async =>
      await participation(studyDeploymentId).getParticipantData();

  @override
  Future<List<ParticipantData>> getParticipantDataList(
      List<String> studyDeploymentIds) async {
    // early out if empty list
    if (studyDeploymentIds.isEmpty) return [];

    Map<String, dynamic> responseJson =
        await _rpc(GetParticipantDataList(studyDeploymentIds));

    // we expect a list of 'items'
    List<dynamic> items = responseJson['items'];
    List<ParticipantData> data = [];
    items.forEach((item) => data.add(ParticipantData.fromJson(item)));

    return data;
  }

  @override
  Future<ParticipantData> setParticipantData(String studyDeploymentId,
          String inputDataType, ParticipantData data) async =>
      await participation(studyDeploymentId)
          .setParticipantData(inputDataType, data);
}
