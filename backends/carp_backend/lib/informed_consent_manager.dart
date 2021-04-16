/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of carp_backend;

/// Retrieve and store informed consent definitions as [RPOrderedTask] json
/// definitions at the CARP backend.
///
/// In the CARP web service, informed consent for a study is stored as a json file
/// with the name [INFORMED_CONSENT_FILE_NAME].
class InformedConsentManager {
  static const String INFORMED_CONSENT_FILE_NAME = 'informed_consent.json';

  Future initialize() async {}

  /// Get the informed consent to be shown for this study.
  ///
  /// This method return a [RPOrderedTask] which is an ordered list of [RPStep]
  /// which are shown to the user as the informed consent flow.
  /// See [research_package](https://pub.dev/packages/research_package) for a
  /// description on how to create an informed consent in the research package
  /// domain model.
  ///
  /// If there is no informed consent json file on the CARP server, `null` is
  /// returned.
  Future<RPOrderedTask> getInformedConsent() async {
    assert(CarpService().isConfigured,
        "CARP Service has not been configured - call 'CarpService().configure()' first.");
    assert(CarpService().currentUser != null,
        "No user is authenticated - call 'CarpService().authenticate()' first.");

    info('Downloading informed consent as file : $INFORMED_CONSENT_FILE_NAME');
    FileStorageReference informedConsentReference = await CarpService()
        .getFileStorageReferenceByName(INFORMED_CONSENT_FILE_NAME);
    final File file = File("$localFilePath/$INFORMED_CONSENT_FILE_NAME");

    final FileDownloadTask downloadTask =
        informedConsentReference.download(file);

    int response = await downloadTask.onComplete;

    RPOrderedTask informedConsent;
    if (response == 200) {
      info('Informed consent downloaded : $INFORMED_CONSENT_FILE_NAME');
      String jsonString = file.readAsStringSync();
      // TODO - implement when json is implemented....
      // informedConsent = RPOrderedTask.fromJson(json.decode(jsonString) as Map<String, dynamic>);
    }
    return informedConsent;
  }

  /// Set the informed consent to be used for this study.
  ///
  /// This method will upload the informed consent as a file to CARP using the
  /// [INFORMED_CONSENT_FILE_NAME] file name.
  ///
  /// Returns `true` if upload is successful, `false` otherwise.
  Future<bool> setInformedConsent(RPOrderedTask informedConsent) async {
    assert(CarpService().isConfigured,
        "CARP Service has not been configured - call 'CarpService().configure()' first.");
    assert(CarpService().currentUser != null,
        "No user is authenticated - call 'CarpService().authenticate()' first.");

    info('Uploading informed consent as file : $INFORMED_CONSENT_FILE_NAME');

    final File file = File("$localFilePath/$INFORMED_CONSENT_FILE_NAME");
    // TODO - implement when json is implemented....
    // file.writeAsStringSync(toJsonString(informedConsent.toJson()));
    final FileUploadTask uploadTask =
        CarpService().getFileStorageReference().upload(file);

    CarpFileResponse response = await uploadTask.onComplete;
    return (response.id > 0);
  }

  String _path;

  ///Returns the local path on the device where files can be written.
  Future<String> get localFilePath async {
    if (_path == null) {
      final localApplicationDir = await getApplicationDocumentsDirectory();
      final directory = await Directory('${localApplicationDir.path}/downloads')
          .create(recursive: true);
      _path = directory.path;
    }
    return _path;
  }
}
