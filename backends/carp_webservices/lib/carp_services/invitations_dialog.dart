/*
 * Copyright 2021 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */
part of carp_services;

/// A modal dialog shown a list of [ActiveParticipationInvitation] for the
/// user to select one from.
class ActiveParticipationInvitationDialog {
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
            title: Text(invitation.invitation.name),
            subtitle: (invitation.invitation.description.isEmpty)
                ? Text('No description provided...')
                : Text(
                    shortStudyDescription(invitation.invitation.description)),
          ));
}
