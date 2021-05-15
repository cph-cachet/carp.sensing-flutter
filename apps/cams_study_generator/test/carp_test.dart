import 'dart:convert';
import 'package:test/test.dart';
import 'dart:io';

void main() {
  setUp(() {});

  test('CLI', () async {
    stdout.writeln('Type something');
    final input = stdin.readLineSync();
    stdout.writeln('You typed: $input');
  });
}
