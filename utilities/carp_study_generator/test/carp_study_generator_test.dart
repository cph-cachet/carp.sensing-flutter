import 'package:test/test.dart';
import 'package:carp_study_generator/carp_study_generator.dart';

void main() {
  setUp(() {});

  test('help', () async {});
  test('help', () async => HelpCommand().execute());
  test('description', () async => StudyDescriptionCommand().execute());
  test('consent', () async => ConsentCommand().execute());
  test('protocol', () async => CreateStudyProtocolCommand().execute());
}
