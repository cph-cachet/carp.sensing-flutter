import 'dart:convert';
import 'dart:io';
import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';
import 'package:carp_study_generator/carp_study_generator.dart';

import 'package:test/test.dart';

void main() {
  test('help', () async {
    HelpCommand().execute();
  });
}
