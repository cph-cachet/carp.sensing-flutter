/*
 * Copyright 2021 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */
part of carp_services;

/// A modal dialog shown a list of [ActiveParticipationInvitation] for the
/// user to select one from.
class SimpleInvitationsDialog {
  SimpleDialog build(
    context,
    List<ActiveParticipationInvitation> invitations,
  ) =>
      SimpleDialog(
        title: const Text('Select invitation'),
        children: invitations
            .map<Widget>((invitation) =>
                _buildInvitationDialogOption(context, invitation))
            .toList(),
      );

  String shortDeploymentStudyId(String studyDeploymentId) => studyDeploymentId
      .substring(studyDeploymentId.length - 5, studyDeploymentId.length);

  String shortStudyDescription(String studyDescription) =>
      (studyDescription.length < 80)
          ? studyDescription
          : '${studyDescription.substring(0, 60)}...';

  SimpleDialogOption _buildInvitationDialogOption(
          BuildContext context, ActiveParticipationInvitation invitation) =>
      SimpleDialogOption(
          onPressed: () {
            Navigator.pop(context, invitation);
          },
          child: ListTile(
            isThreeLine: true,
            leading: Icon(
              Icons.mail,
              color: Color.fromRGBO(234, 91, 12, 1.0),
            ),
            title: Text('${invitation.invitation.name} '
                '[...${shortDeploymentStudyId(invitation.studyDeploymentId)}]'),
            subtitle: (invitation.invitation.description.isEmpty)
                ? Text('No description provided...')
                : Text(
                    shortStudyDescription(invitation.invitation.description)),
          ));
}

// This is the old version using the Alert package -- BUT doesn't work on iOS....
/// A modal dialog shown a list of [ActiveParticipationInvitation] for the
/// user to select one from.
class InvitationsDialog {
  ActiveParticipationInvitation _selectedInvitation;

  /// The selected invitation.
  /// Returns `null` if no selection is made.
  ActiveParticipationInvitation get invitation => _selectedInvitation;

  Alert build(context, List<ActiveParticipationInvitation> invitations) {
    return Alert(
        context: context,
        image: Padding(
            padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
            child: Image.asset('asset/images/cachet_logo_new.png',
                package: 'carp_webservices')),
        title: "INVITATIONS",
        content: Container(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              itemCount: invitations.length,
              itemBuilder: (BuildContext context, int index) =>
                  _buildInvitationTile(context, invitations[index]),
            )));
  }

  Widget _buildInvitationTile(
    BuildContext context,
    ActiveParticipationInvitation invitation,
  ) =>
      ListTile(
        isThreeLine: true,
        leading: Icon(
          Icons.mail,
          color: Color.fromRGBO(234, 91, 12, 1.0),
        ),
        title: Text('${invitation.invitation.name} '
            '[...${shortDeploymentStudyId(invitation.studyDeploymentId)}]'),
        subtitle: (invitation.invitation.description.isEmpty)
            ? Text('No description provided...')
            : Text(shortStudyDescription(invitation.invitation.description)),
        onTap: () {
          _selectedInvitation = invitation;
          Navigator.pop(context);
        },
      );

  String shortDeploymentStudyId(String studyDeploymentId) => studyDeploymentId
      .substring(studyDeploymentId.length - 5, studyDeploymentId.length);

  String shortStudyDescription(String studyDescription) =>
      (studyDescription.length < 80)
          ? studyDescription
          : '${studyDescription.substring(0, 60)}...';
}
