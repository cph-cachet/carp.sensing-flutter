import 'package:test/test.dart';
import 'package:carp_mobile_sensing/core/core.dart';
import 'dart:convert';
import 'dart:io';

String _encode(Object object) => const JsonEncoder.withIndent(' ').convert(object);

void main() {
  /// Test if we can load a raw JSON from a file and convert it into a [Study] object with all its [Task]s and [Measure]s.
  /// Note that this test, tests if a [Study] object can be create 'from scratch', i.e. without having been created before.
  test('Raw JSON string -> Study object', () async {
    String plain_study_json = File("test/study_1234.json").readAsStringSync();

    Study plain_study = Study.fromJson(json.decode(plain_study_json) as Map<String, dynamic>);
    expect(plain_study.id, "1234");

    print(_encode(plain_study));
  });

  /// Test template.
  test('...', () {
    // test template
  });
}
