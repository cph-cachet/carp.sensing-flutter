import 'package:test/test.dart';
import 'package:carp_study_generator/carp_study_generator.dart';

void main() {
  test('help', () async {});
  test('help', () async => HelpCommand().execute());
  test('consent', () async => ConsentCommand().execute());
  test('protocol', () async => CreateStudyProtocolCommand().execute());
}
