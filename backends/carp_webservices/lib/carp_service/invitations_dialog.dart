/*
 * Copyright 2021 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */
part of carp_services;

/// A modal dialog shown a list of [ActiveParticipationInvitation] for the
/// user to select one from.
class InvitationsDialog {
  // String _studyDeploymentId;

  // /// The selected study id.
  // /// Returns `null` if no selection is made.
  // String get studyDeploymentId => _studyDeploymentId;

  ActiveParticipationInvitation _selectedInvitation;

  /// The selected invitation.
  /// Returns `null` if no selection is made.
  ActiveParticipationInvitation get invitation => _selectedInvitation;

  Alert build(context, List<ActiveParticipationInvitation> invitations) {
    Iterable<Widget> _invitationWidgets = ListTile.divideTiles(
        context: context,
        tiles: invitations.map<Widget>(
            (invitation) => _buildInvitationTile(context, invitation)));

    return Alert(
      context: context,
      image: Padding(
          padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
          child: Image.asset('asset/images/cachet_logo_new.png',
              package: 'carp_webservices')),
      title: "INVITATIONS",
      content: ListView(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        children: _invitationWidgets.toList(),
      ),
    );
  }

  Widget _buildInvitationTile(
          BuildContext context, ActiveParticipationInvitation invitation) =>
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
          //_studyDeploymentId = invitation.studyDeploymentId;
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
