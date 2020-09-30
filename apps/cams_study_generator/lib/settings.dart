part of cams_study_generator;

class Settings {
  final String username = "user";
  final String password = "...";
  final String userId = "user@cachet.dk";
  final String uri = "https://cans.cachet.dk:443";
  final String studyId = "2";

  final GeneratorStudyManager manager = GeneratorStudyManager();

  Study _study;
  Study get study => _study;
}

final settings = Settings();
