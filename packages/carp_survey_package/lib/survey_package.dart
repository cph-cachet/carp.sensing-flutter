part of 'survey.dart';

/// A [SamplingPackage] that knows how to collect data from user surveys based
/// on the [research_package](https://pub.dev/packages/research_package)
/// package.
///
/// In contrast to other sampling packages, this package does not support any
/// [dataTypes]. Collection of [RPTask] data from a user is supported by the
/// [SurveyUserTask] user task.
class SurveySamplingPackage extends SmartphoneSamplingPackage {
  static const String SURVEY = "${NameSpace.CARP}.survey";

  @override
  void onRegister() {
    ResearchPackage.ensureInitialized();
    CognitionPackage.ensureInitialized();

    FromJsonFactory().registerAll([
      RPAppTask(type: '', rpTask: RPTask(identifier: 'ignored')),
      RPTaskResultData()
    ]);
    AppTaskController().registerUserTaskFactory(SurveyUserTaskFactory());
  }

  // no data types supported in this package and hence no probes
  // or sampling schema are needed.

  @override
  DataTypeSamplingSchemeMap get samplingSchemes => DataTypeSamplingSchemeMap();

  @override
  Probe? create(String type) => null;
}
