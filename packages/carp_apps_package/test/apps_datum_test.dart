import 'dart:convert';

import 'package:carp_apps_package/apps.dart';
import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';
import 'package:test/test.dart';

String _encode(Object object) =>
    const JsonEncoder.withIndent(' ').convert(object);

void main() {
  setUp(() {
    // This is a hack. Need to create some serialization object in order to intialize searialization.
    Study(id: '1234');
  });

  group('Apps Datum Tests', () {
    test(' - installed apps', () {
      AppsDatum d = AppsDatum()
        ..installedApps = [
          'MUBS',
          'mCardia',
          'Safari',
        ];
      print(d);
      print(_encode(d));
    });

    test(' - apps usage', () {
      AppUsageDatum d2 = AppUsageDatum()
        ..usage = {
          'carp_mobile_sensing_test_app': 1405,
          'systemui': 4,
          'MtpApplication': 5,
          'launcher': 1999,
          'settings': 19,
        };
      print(d2);
      print(_encode(d2));
    });

    /// Test template.
    test('...', () {
      // test template
    });
  });
}
