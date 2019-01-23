part of mobile_sensing_app;

class StudyModel {
  Study study;

  String get name => study.name;
  String get description => study.description ?? 'No description available.';
  Image get image => Image.asset('images/study.png');
  String get userID => study.userId;
  String get samplingStrategy => study.samplingStrategy.toString();
  String get dataEndpoint => study.dataEndPoint.toString();

  StudyModel(this.study)
      : assert(study != null, 'A StudyModel must be initialized with a real Study.'),
        super();
}
