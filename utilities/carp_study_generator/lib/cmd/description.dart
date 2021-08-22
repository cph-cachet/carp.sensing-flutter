part of carp_study_generator;

/// A [Command] that take the study description provided in a jsono file
/// and uploads it to the CARP server.
class StudyDescriptionCommand extends AbstractCommand {
  String? _descriptionJson;
  StudyDescription? _description;

  StudyDescriptionCommand() : super();

  String get descriptionJson {
    if (_descriptionJson == null) {
      print('Reading the informed consent from file: $descriptionPath');
      _descriptionJson = File(descriptionPath).readAsStringSync();
    }
    return _descriptionJson!;
  }

  StudyDescription get description {
    if (_description == null) {
      print('Checking that this is a valid RP Ordered Task');
      _description = StudyDescription.fromJson(
          json.decode(descriptionJson) as Map<String, dynamic>);
    }
    return _description!;
  }

  @override
  Future execute() async {
    await authenticate();
    descriptionJson;
    description;
    print('Uploading informed consent to CARP\n study_id: ${app.studyId}');
    await CarpResourceManager().setStudyDescription(description);
    print('Upload successful!');
  }
}
